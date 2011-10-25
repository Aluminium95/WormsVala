using GLib;
using Gee;
using SDL;

namespace Jeu
{
	/**
	 * Classe gérant qui va mettre en scène tous les acteurs 
	 * du jeu ( Terrains; IA; Joueurs; Décor etc … )
	 */
	public class Gerant : Object
	{
		private ArrayList<Terrain> listeTerrains; // Terrains
		private HashSet<Objet> objets; // Set des objets du jeu
		private ArrayList<Player> players; // Joueurs
		
		/*
		 * Variables environnement 
		 */
		public World w;
		
		// Identifiant unique maximum pour un objet
		private int idmax;

		// Taille de tous les terrains réunis
		private int tailleTotaleTerrain = 0;

		/** 
		 * Délégates pour connecter aux signaux 
		 * Liés au personnages
		 */
		delegate void delegateJoueurFrappe (Personnage p);
		delegate void delegateAssignerTerrain (Terrain t, bool d, Objet o);
		delegate void delegateJoueurTire (Personnage p, TuplePos t);
		
		/**
		 * Signaux pour demander l'affichage
		 */
		public signal void needDrawLine (int x1, int y1, int x2, int y2);
		public signal void needDrawObjet (Objet o);
		public signal void needDrawTerrain (Terrain t);
		
		/**
		 * Signaux pour demander le son
		 */
		public signal void need_play_hit (); // frapper/collision
		public signal void need_play_bam (); // sort de l'écran ( bam contre le mur :D )
		
		/**
		 * Delegate pour qu'un joueur frappe !
		 * Regarde dans tous les terrains autour de celui du
		 * personnage
		 */
		private void joueur_frappe (Personnage p)
		{
			int t = ( p.t.i != 0 ) ? p.t.i - 1 : p.t.i; // On regarde dans les terrains alentours
			t = ( t == listeTerrains.size -1 ) ? t - 2 : t;
			
			for (int i = 0; i < 3; i++) // On fait trois fois 
			{
				foreach ( var pers in listeTerrains[t].objets ) // pour chaque objet du terrain
				{
					// Calcul de la distance de frappe
					double d = pow(pers.pos.x - p.pos.x,2) + pow(pers.pos.y - p.pos.y, 2);
					if ( d <= p.armeActuelle.r ) // Si c'est dedans
					{
						pers.modifier_vie (10); // On enlève 10 pv
					}
				}
				t++; // Indice du prochain terrain
			}
		}
		
		/**
		 * Assigne l'objet à un terrain
		 * en fonction des positions de l'objet
		 * Il faut qu'il y ai un terrain après ou avant !
		 * Si c'est pas possible renvoie false
		 */
		private bool change_terrain (bool d, Objet o)
		{
			if (  d & o.t.i < listeTerrains.size - 1  ) // Si c'est pas le dernier terrain
			{
				o.t.rm_objet (o); // Supression de l'objet dans le premier terrain
				listeTerrains[o.t.i+1].add_objet (o);
				return true;
			} else if ( !d && o.t.i > 0 )  {
				o.t.rm_objet (o); // Supression de l'objet dans le premier terrain
				listeTerrains[o.t.i-1].add_objet (o);
				return true;
			} else { // Si on peut pas changer de terrain
				return false; 
			} 
		}
		
		/**
		 * Retourne le terrain auquel appartien cette position
		 */
		private Terrain get_terrain_pos (float x)
		{
			Terrain ret = listeTerrains[0]; // Terrain par défaut
			foreach ( var t in listeTerrains ) // Pour chaque terrain
			{
				/*
				 * Si l'objet rentre dans le terrain !
				 */
				if ( x >= t.start && x <= t.start + t.largeur )
				{
					ret = t; // On modifie la référence
				}
			}
			return ret; // On retourne le terrain 
		}
		
		/**
		 * Crée le gérant 
		 */
		public Gerant ()
		{
			#if DEBUG 
				print ("\t\t Gerant : Création !\n", CouleurConsole.VERT);
			#endif
			
			/*
			 * Initialisation des tableaux contenants les terrains
			 * et les objets du jeu
			 */
			listeTerrains = new ArrayList<Terrain> ();
			objets = new HashSet<Objet> ();
			players = new ArrayList<Player> ();
			
			this.idmax = 0;
			
			this.w.gravity = 9.81f;
			this.w.air_res = 0.06f;
			
			// this.wind = 0.2f;
			// this.friction = 0.03f;
			
			/*
			 * Appel des fonctions créatrices 
			 */
			creer_terrain (10);
			creerIA (2);
			creer_joueur (2);
		}
		
		/**
		 * Recommence le jeu 
		 */
		public void restart ()
		{
			this.listeTerrains.clear ();
			this.objets.clear ();
			this.players.clear ();
			
			creer_terrain (10);
			creer_IA (2);
			creer_joueur (2);
			creer_decors (1);
		}
		
		/**
		 * Créer les IAs du jeu
		 */
		private void creer_IA (int nbr)
		{
			#if DEBUG
				print ("\t\t Gerant : Création des IAs \n", CouleurConsole.VERT);
			#endif
			
			for(int i = 0; i < nbr; i++)
			{
				/*
				 * Créer les positions, valeurs de l'ia, 
				 * calculer le terrain
				 * Créer l'ia et l'ajouter au terrain
				 * Connecter les signaux de l'ia
				 */
				int x = GLib.Random.int_range (0, tailleTotaleTerrain); // Création d'un point de départ

				var ia = new IA (x, get_terrain_pos (x), 10, "Une IA");
				
				add_objet (ia); // Ajoute l'objet au gérant
				
				ia.i = idmax;
				
				ia.w = this.w;
				
				#if DEBUG 
					print ("\t\t Gerant : New IA : " + x.to_string () + " => " + ia.pos.x.to_string () + ";" + ia.pos.y.to_string () + "\n", CouleurConsole.VERT);
				#endif 
				
				if ( i % 2 == 0 )
				{
					ia.rebondirx ();
				}
				
				/*
				 * Connection des signaux 
				 */
				ia.dead.connect ( (o) =>
				{
					rm_objet (o); // Supprime l'objet du gérant
				});
				ia.moved.connect ( (o) => 
				{
					// stdout.printf (o.name + " à bougé : (" + o.pos.x.to_string () +";"+o.pos.y.to_string () +"); :: " + o.t.i.to_string () + "\n");
				});
				ia.frapper.connect(joueurFrappe);
				
				idmax++;
			}
		}
		
		/**
		 * Crée les terrains du jeu
		 */
		private void creer_terrain (int nbr)
		{
			#if DEBUG 
				print ("\t\t Gerant : Création des Terrains \n", CouleurConsole.VERT);
			#endif
			int pos = 0;
			int prevHeight = (int) Jeu.Aff.SCREEN_HEIGHT / 4;
			int width = (int) Jeu.Aff.SCREEN_WIDTH / nbr;
			
			for (int i = 0; i < nbr; i++)
			{
				int largeurTerrain;
				if ( i == nbr - 1 ) // Si c'est le dernier terrain
				{
					largeurTerrain = Jeu.Aff.SCREEN_WIDTH - pos; // Il prend la place restante
				} else { // Sinon il prend une place aléatoire dans celle qui reste
					largeurTerrain = width;
				}
				
				int h = GLib.Random.int_range (prevHeight - 150, prevHeight + 150);
				h = ( h < 0 ) ? 0 : h;
				h = ( h > Jeu.Aff.SCREEN_HEIGHT ) ? Jeu.Aff.SCREEN_HEIGHT : h;
				
				var t = new Terrain (largeurTerrain, prevHeight, h);
				t.start = pos; // Définition du début du terrain
				t.i = i; // Définition de l'indice du terrain dans le tableau
				listeTerrains.add (t); // Ajout du terrain
				
				/*
				 * Ajout de la largeur du terrain à pos pour trouver
				 * le début du prochain terrain
				 */
				pos += largeurTerrain;
				prevHeight = h;
			}
			tailleTotaleTerrain = pos; // Définiton de la taille totale du jeu
		}
		
		public void ajouter_terrain (int l, int hg, int hd)
		{
			var t = new Terrain (l,hg,hd);
			t.start = tailleTotaleTerrain;
			t.i = listeTerrains.size; // Définition de l'indice du terrain dans le tableau
			listeTerrains.add (t); // Ajout du terrain
			tailleTotaleTerrain += l;
		}
		
		/**
		 * Crée les jouers du jeu
		 */
		private void creer_joueur (int nbr)
		{
			nbr = (nbr > 2) ? 2 : nbr;
			#if DEBUG
				print ("\t\t Gerant : Création des Players \n", CouleurConsole.VERT);
			#endif
			
			
			for ( int i = 0; i < nbr; i++ )
			{
				int x = i * 20;
				var p = new Player (x, get_terrain_pos(x), 50, "Joueur "+(i+1).to_string ());
				p.i = idmax;
				
				add_player (p);
				add_objet (p);
				
				p.w = this.w;
				
				if (i==1)
				{
					p.left = KeySymbol.l;
					p.right = KeySymbol.z;
					p.up = KeySymbol.j;
				}
				
				p.frapper.connect (joueurFrappe);
				p.dead.connect (rm_objet);
				
				idmax++;
			}
		}
		
		/**
		 * Crée les décors du jeu
		 */
		private void creer_decors (int nbr)
		{
			for (int i = 0; i < nbr; i++)
			{
				int x = 50;
				
				var d = new Decor (x, get_terrain_pos(x));
				add_objet (d);
				get_terrain_pos (x) .add_objet (d);
			}
		}
		
		/**
		 * Fait éxecuter un cycle aux IA :
		 * 		- Les fait choisir une action 
		 * 		- Les fait bouger :
		 * 			+ S'il ne sortent pas de l'écran
		 * 			+ Les fait changer de terrain | zone si nécessaire
		 */
		public void execute ()
		{			
			foreach ( Terrain t in listeTerrains )
			{
				needDrawTerrain (t);
				needDrawLine (t.start, t.hg, t.start + t.largeur, t.hd);
			}
			
			foreach ( var o in objets ) // Très mauvaise gestion, mais c'est pour la démo
			{
				needDrawObjet (o); // Affiche l'objet
				
				o.calc_vel (); // Calcule la vélocité de l'objet
				
				bool sortDuJeu;
				
				gerer_collisions (o); // Gère les collisions
				
				/*
				 * Conditions de sortie du terrain
				 */
				if ( o.pos.x + o.velx < o.t.start ) {
					bool v = changeTerrain (false, o);
					sortDuJeu = !v;
				} else if ( o.pos.x + o.velx > o.t.start + o.t.largeur ) {
					bool v = changeTerrain (true, o);
					sortDuJeu = !v;
				} else {
					sortDuJeu = false;
				}
				
				if ( sortDuJeu ) // Si on sort du jeu
				{
					int B = 1;
					
					if ( o.velx > 0 ) // on va vers la droite
					{
						B = Jeu.Aff.SCREEN_WIDTH - 5;
					}
					o.move (B - o.pos.x);
					
					//Jeu.Aff.done = true;
					o.rebondirx ();
					o.velx = o.velx/4;
					
					need_play_bam ();
				} else {
					o.move (o.velx); // Pas de y !!!
				}

			}
		}
		
		/**
		 * Tue tous les objets du jeu
		 */
		public void kill ()
		{
			foreach ( var o in objets )
			{
				o.mourrir ();
			}
		}
		
		/**
		 * Ajoute un objet !
		 * Et l'ajoute à un terrain du jeu
		 */
		public void add_objet (Objet o)
		{
			get_terrain_pos (o.pos.x).add_objet (o);
			objets.add (o);
		}
		
		/**
		 * Ajoute le joueur et l'ajoute à un terrain
		 */
		public void add_player (Player p)
		{
			get_terrain_pos (p.pos.x).add_objet (p);
			players.add (p);
		}
		
		/**
		 * Supprime un objet !
		 * Et le supprime du terrain où il est
		 */
		public void rm_objet (Objet o)
		{
			// o.t.objets.remove (o);
			objets.remove (o);
		}
		
		/**
		 * Get les collisions de l'objet o 
		 */
		public void gerer_collisions (Objet o)
		{
			int t;
			if ( o.t.i == 0 ) // Si c'est le premier terrain
			{
				t = o.t.i;
			} else if ( o.t.i == listeTerrains.size -1 ) {
				// Si c'est le dernier terrain 
				t = o.t.i - 2;
			} else {
				t = o.t.i - 1; // si c'est un terrain normal
			}
			collision (this, o,ref this.listeTerrains,t);
		}
		
		/**
		 * Brute force pour faire bouger un joueur avec la touche enfoncée @k
		 */
		public void move_player (KeySymbol k)
		{
			#if DEBUG
				print ("\t\t Gérant : bouge Player \n", CouleurConsole.VERT);
			#endif
			foreach (var p in players)
			{
				bool b = p.compute_key (k);
				if (b) { break; }
			}
		}
	}
}

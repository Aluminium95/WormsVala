using GLib;
using Gee;

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
		// public float gravity; // Gravité : Inutilisé !
		public float air_res; // Résistance de l'air
		// public float wind; // Vent : Inutilisé !
		// public float friction; // Friction : inutilisé !
		
		private int idmax; // Identifiant unique maximum

		private int tailleTotaleTerrain = 0; // Taille de tous les terrains réunis

		/**
		 * Délégates pour connecter aux signaux 
		 */
		delegate void delegateJoueurFrappe (Personnage p);
		delegate void delegateAssignerTerrain (Terrain t, bool d, Objet o);
		delegate void delegateJoueurTire (Personnage p, TuplePos t);
		
		/**
		 * Delegate pour qu'un joueur frappe !
		 * Regarde dans tous les terrains autour de celui du
		 * personnage
		 */
		private void joueurFrappe (Personnage p)
		{
			int t = ( p.t.i != 0 ) ? p.t.i - 1 : p.t.i; // On regarde dans les terrains alentours
			t = ( t == listeTerrains.size -1 ) ? t - 1 : t;
			
			for (int i = 0; i < 3; i++) // On fait trois fois 
			{
				foreach ( var pers in listeTerrains[t].objets ) // pour chaque objet du terrain
				{
					// Calcul de la distance de frappe
					double d = GLib.Math.pow(pers.pos.x - pers.r - p.pos.x,2) + GLib.Math.pow(pers.pos.y - pers.r - p.pos.y, 2);
					if ( d <= p.armeActuelle.r ) // Si c'est dedans
					{
						pers.modifierVie (10); // On enlève 10 pv
						stdout.printf ("AIE ! - 10 pv\n");
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
		private bool changeTerrain (bool d, Objet o)
		{
			if (  d & o.t.i < listeTerrains.size - 1  ) // Si c'est pas le dernier terrain
			{
				o.t.rmObjet (o); // Supression de l'objet dans le premier terrain
				listeTerrains[o.t.i+1].addObjet (o);
				Jeu.Aff.son.play (2,2);
				return true;
			} else if ( !d && o.t.i > 0 )  {
				o.t.rmObjet (o); // Supression de l'objet dans le premier terrain
				listeTerrains[o.t.i-1].addObjet (o);
				Jeu.Aff.son.play (2,2);
				return true;
			} else { // Si on peut pas changer de terrain
				return false; 
			} 
		}
		
		/**
		 * Retourne le terrain auquel appartien cette position
		 */
		private Terrain getTerrainPos (float x)
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
			
			// this.gravity = 9.8f;
			this.air_res = 0.06f;
			// this.wind = 0.2f;
			// this.friction = 0.03f;
			
			
			creerCannaux (3);
			creerSons ();
			
			/*
			 * Appel des fonctions créatrices 
			 */
			creerTerrain (10);
			creerIA (2);
			creerJoueur (1);
		}
		
		/**
		 * Créer les IAs du jeu
		 */
		private void creerIA (int nbr)
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

				var ia = new IA (x, getTerrainPos (x), 10, "Une IA");
				
				addObjet (ia); // Ajoute l'objet au gérant
				
				ia.i = idmax;
				
				if ( i % 2 == 0)
				{
					ia.col = 0x000FFFF * (i + 60) * 5;
				} else {
					ia.col = 0xFFF0000 * (i + 60) * 5;
				}
				
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
					rmObjet (o); // Supprime l'objet du gérant
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
		private void creerTerrain (int nbr)
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
		
		/**
		 * Crée les jouers du jeu
		 */
		private void creerJoueur (int nbr)
		{
			#if DEBUG
				print ("\t\t Gerant : Création des Players \n", CouleurConsole.VERT);
			#endif
			for ( int i = 0; i < nbr; i++ )
			{
				int x = i * 20;
				var p = new Player (x, getTerrainPos(x), 50, "Joueur "+(i+1).to_string ());
				p.i = idmax;
				
				p.col = 0xCCCCCCC * (i + 60) * 5;
				
				addPlayer (p);
				
				idmax++;
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
			Jeu.Aff.draw ();
			
			foreach ( Terrain t in listeTerrains )
			{
				Jeu.Aff.draw_terrain (t);
				Jeu.Aff.draw_line (t.start, t.hg, t.start + t.largeur, t.hd);
			}
			
			foreach ( var o in objets ) // Très mauvaise gestion, mais c'est pour la démo
			{
				Jeu.Aff.draw_objet (o); // Affiche l'objet
				
				o.calcVel (this.air_res); // Calcule la vélocité de l'objet
				
				bool sortDuJeu;
				
				gererCollisions (o); // Gère les collisions
				
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
					o.move ((int) (B - o.pos.x));
					//Jeu.Aff.done = true;
					o.rebondirx ();
					o.velx = o.velx/2;
					Jeu.Aff.son.play (1,1);
				} else {
					o.move ((int)o.velx); // Pas de y !!!
				}

			}
			
			foreach ( var p in players )
			{
				Jeu.Aff.draw_objet (p); // Affiche l'objet
				
				p.calcVel (this.air_res);
				
				bool sortDuJeu;
				
				/*
				 * Conditions de sortie du terrain
				 */
				if ( p.pos.x + p.velx < p.t.start ) {
					bool v = changeTerrain (false, p);
					sortDuJeu = !v;
				} else if ( p.pos.x + p.velx > p.t.start + p.t.largeur ) {
					bool v = changeTerrain (true, p);
					sortDuJeu = !v;
				} else {
					sortDuJeu = false;
				}
				
				if ( sortDuJeu ) // Si on sort du jeu
				{
					int B = 1;
					
					if ( p.velx > 0 ) // on va vers la droite
					{
						B = Jeu.Aff.SCREEN_WIDTH - 5;
					}
					p.move ((int) (B - p.pos.x - p.r));
					Jeu.Aff.son.play (1,1);
				} else {
					p.move ((int)p.velx); // Pas de y !!!
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
		public void addObjet (Objet o)
		{
			getTerrainPos (o.pos.x).addObjet (o);
			objets.add (o);
		}
		
		/**
		 * Ajoute le joueur et l'ajoute à un terrain
		 */
		public void addPlayer (Player p)
		{
			getTerrainPos (p.pos.x).addObjet (p);
			players.add (p);
		}
		
		/**
		 * Supprime un objet !
		 * Et le supprime du terrain où il est
		 */
		public void rmObjet (Objet o)
		{
			o.t.rmObjet (o);
			objets.remove (o);
		}
		
		/**
		 * Get les collisions de l'objet o 
		 */
		public void gererCollisions (Objet o)
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
			collision (o,ref listeTerrains,t);
		}
		
		/**
		 * Crée les sons : 
		 * 		@hit : 0
		 * 		@terrain : 1
		 * 		@bordure : 2
		 */
		private void creerSons ()
		{
			Jeu.Aff.son.addSon (Config.MUSIQUE + "/hit.ogg");
			Jeu.Aff.son.addSon (Config.MUSIQUE + "/terrain.ogg");
			Jeu.Aff.son.addSon (Config.MUSIQUE + "/bordure.ogg");
		}
		
		/**
		 * Crée les cannaux et met les volumes des 
		 * trois premiers cannaux comme ceci :
		 * 		@0 = 25
		 * 		@1 = 25
		 * 		@2 = 120
		 */
		private void creerCannaux (int nbr)
		{
			for ( int i = 0; i < nbr; i++ )
			{
				Jeu.Aff.son.addChannel ();
			}
			Jeu.Aff.son.setChannelVolume (0, 25);
			Jeu.Aff.son.setChannelVolume (2, 50);
			Jeu.Aff.son.setChannelVolume (3, 120);
		}
		
		/**
		 * Fait bouger le joueur numéro @p avec une force de @x
		 */
		public void movePlayer (int p, int x)
		{
			#if DEBUG
				print ("\t\t Gérant : bouge Player \n", CouleurConsole.VERT);
			#endif
			players[p-1].velx += 2 * x;
		}
	}
}

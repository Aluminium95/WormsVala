using GLib;
using Gee;

namespace Jeu
{
	/**
	 * Pour l'instant je crée 2 ia … et je les nomme !
	 * Il faut utiliser des tableaux et créer des tableaux de terrain 
	 * Il faut gérer les déplacements et les changements de terrain ! ( et donc attribution à une zone ).
	 */
	public class Gerant : Object
	{
		private ArrayList<Terrain> listeTerrains; // Terrains
		private HashSet<Objet> objets; // Set des objets du jeu
		
		/*
		 * Variables environnement 
		 */
		public float gravity;
		public float air_res;
		public float wind;
		public float friction;

		private int tailleTotaleTerrain = 0;

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
			Jeu.Son.play (Jeu.note.B);
			
			int t = ( p.t.i != 0 ) ? p.t.i - 1 : p.t.i; // On regarde dans les terrains alentours
			t = ( t == listeTerrains.size -1 ) ? t - 1 : t;
			
			for (int i = 0; i < 3; i++) // On fait trois fois 
			{
				foreach ( var pers in listeTerrains[t].objets ) // pour chaque objet du terrain
				{
					// Calcul de la distance de frappe
					int d = (int)  (pers.pos.x - pers.dim.x - p.pos.x)^2 + (pers.pos.y - pers.dim.y - p.pos.y)^2 ;
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
				listeTerrains[o.t.i+1].addObjet (o);
				o.t.rmObjet (o); // Supression de l'objet dans le premier terrain
				return true;
			} else if ( !d && o.t.i > 0 )  {
				listeTerrains[o.t.i-1].addObjet (o);
				o.t.rmObjet (o);
				return true;
			} else { return false; } // Si on peut pas changer de terrain
		}
		
		/**
		 * Retourne le terrain auquel appartien cette position
		 */
		private Terrain getTerrainPos (int x)
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
			/*
			 * Initialisation des tableaux contenants les terrains
			 * et les objets du jeu
			 */
			listeTerrains = new ArrayList<Terrain> ();
			objets = new HashSet<Objet> ();
			
			this.gravity = 9.8f;
			this.air_res = 0.05f;
			this.wind = 0.2f;
			this.friction = 0.03f;
			
			/*
			 * Appel des fonctions créatrices 
			 */
			creerTerrain (10);
			creerIA (1);
		}
		
		/**
		 * Créer les IAs du jeu
		 */
		private void creerIA (int nbr)
		{
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
				
				stdout.printf ("New IA : " + x.to_string () + " => " + ia.pos.x.to_string () + ";" + ia.pos.y.to_string () + "\n");
				
				/*
				 * Connection des signaux 
				 */
				ia.dead.connect ( (o) =>
				{
					rmObjet (o); // Supprime l'objet du gérant
				});
				ia.moved.connect ( (o) => 
				{
					stdout.printf (o.name + " à bougé : (" + o.pos.x.to_string () +";"+o.pos.y.to_string () +"); \n");
				});
				ia.frapper.connect(joueurFrappe);
			}
		}
		
		/**
		 * Crée les terrains du jeu
		 */
		private void creerTerrain (int nbr)
		{
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
		private void creerJoueur ()
		{
			
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
			
			
			foreach ( var o in objets ) // Très mauvaise gestion, mais c'est pour la démo
			{
				Jeu.Aff.draw_objet (o); // Affiche l'objet
				
				o.calcVel (this.air_res);
				
				bool sortDuJeu;
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
				
				/*
				 * Gestion des collisions 
				 */
				int t = ( o.t.i != 0 ) ? o.t.i - 1 : o.t.i;
				t = ( t == listeTerrains.size -1 ) ? t - 1 : t;
				
				for (int i = 0; i <  3; i++)
				{
					foreach ( var ia in listeTerrains[i].objets )
					{
						/*
						 * Gestion des collisions de cercles 
						 * if ( … )
						 * 		faire rebondir + break !
						 */
					}
					t++;
				}
				
				if ( sortDuJeu ) // Si on sort du jeu
				{
					// Jeu.Aff.done = true;
					o.rebondirx ();
				} else {
					o.move ((int)o.velx); // Pas de y !!!
				}
				
				if ( o.velx < 1 && o.velx > -1)
				{
					Jeu.Aff.done = true;
				}
			}
			
			foreach ( Terrain t in listeTerrains )
			{
				Jeu.Aff.draw_terrain (t);
				Jeu.Aff.draw_line (t.start, t.hg, t.start + t.largeur, t.hd);
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
		 * Supprime un objet !
		 * Et le supprime du terrain où il est
		 */
		public void rmObjet (Objet o)
		{
			o.t.rmObjet (o);
			objets.remove (o);
		}
	}
}

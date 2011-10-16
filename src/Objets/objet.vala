using GLib;

namespace Jeu
{
	/**
	 * Classe abstraite pour tous les objets 
	 * du jeu qui sont dessinés
	 * C'est sûrement la classe la plus importante et la plus grosse !
	 */
	public abstract class Objet : Object
	{
		public int l; // Largeur
		public int h; // Hauteur
		
		public int r; // Rayon ( temporaire … avant d'utiliser des rectangles ! )
		
		/* Il faudrait passer à un TuplePos vel { x; y; } */
		public float velx; // Vélocité X
		public float vely; // Vélocité Y
		
		public float masse { get; protected set; } // Masse de l'objet
		
		public int32 col; // Couleur
		
		public int i; // Id ( très moche !!! )

		public TuplePos pos; // Point en bas à gauche ( départ )
		
		/* Ceci sera utile quand ils seront rectangulaires ! 
		public TuplePos pos_gh; // Point en haut à gauche
		public TuplePos pos_db; // Point en bas à droite
		public TuplePos pos_dh; // Point en haut à droite 

		public TuplePos dim; // Dimensions de l'objet */
		
		// Contient une référence faible vers le terrain 
		public unowned Terrain t {get;set;} 
		public unowned World w {get;set;}
		
		public string name {get; protected set; } // Oh pourquoi pas !!
		
		public Mouvement m; // Mouvement entrain d'être effectué
		
		/*public Type type; Peut servir, mais pour l'instant inutile ! */
		
		public signal void dead (); // Signal quand on meurt
		public signal void moved (); // Signal quand on bouge
		
		protected int vie; // Vie de l'objet
		
		public Objet (int x, Terrain t, int vie = 10, int l = 10, int h = 10)
		{
			this.t = t;
			
			this.pos.x = x;
			this.pos.y = t.getSol (this.pos.x);
			
			this.velx = 0;
			this.vely = 0;
			
			this.vie = vie;
			
			/*this.dim.x = l;
			this.dim.y = h;*/
			
			// this.calc_rect ();
			
			this.r = 10;
			this.masse = 1;
			
			this.m = Mouvement.MARCHE;
		}

		/**
		 * Effectue un mouvement
		 */
		public void move ( float x )
		{
			this.pos.x += x;
			
			if ( this.m == Mouvement.SAUT)
			{
				if ( this.pos.x + (int) this.vely > this.t.getSol (this.pos.x) )
				{
					this.pos.y += (int) this.vely;
				} else {
					this.pos.y = this.t.getSol (this.pos.x);
					this.m = Mouvement.MARCHE;
				}
			} else if ( this.m == Mouvement.MARCHE ){
				this.pos.y = this.t.getSol (this.pos.x);
			}
			
			// this.calc_rect (); Inutile ça marche pas !
			
			moved (); // Envoie le signal de déplacement
		}

		/**
		 * Modifie la vie
		 */
		public void modifierVie (int v)
		{
			if ( this.vie == 0)
			{
				mourrir ();
			} else if ( vie != -1 )
			{
				this.vie -= v;
			}
		}

		/**
		 * Meurt
		 */
		public void mourrir ()
		{
			dead (); // Envoie le signal de mort
		}

		/**
		 * Calcule les points qui ne sont pas définis: 
		 * 	- db ; gh; dh 
		 */
		/*protected void calc_rect ()
		{
			calc_db ();
			calc_gh ();
			calc_dh ();
		}*/

		/**
		 * Calcule la position du point en bas à droite 
		 * Très très moche et pas fonctionnel !
		 * Méthode à revoir !!!!!
		 */
		/*protected void calc_db ()
		{

			pos_db.x = (int) ( t.largeur * dim.x ) / (int) t.largeur * t.largeur + t.getH (this.pos.x) * t.getH (this.pos.x);
		}*/

		/**
		 * Calcule la position du point en haut à gauche
		 */
		/*protected void calc_gh ()
		{
			
		}*/
		
		/**
		 * Calucle la position du point en haut à droite
		 */
		/*protected void calc_dh ()
		{
			
		}*/
		
		/**
		 * Rebondit en Y
		 */
		public void rebondiry ()
		{
			this.vely *= -1;
		}
		
		/**
		 * Rebondit en X
		 */
		public void rebondirx ()
		{
			/* Si on a pas de vitesse, on en ajoute un peu */
			/*if ( this.velx < 0 )
			{
				this.velx += ( this.velx > -1 ) ? -1 : 0;
			} else {
				this.velx += ( this.velx < 1 ) ? 1 : 0;
			}*/
			this.velx *= -1; // on multiplie par -1
		}
		
		/**
		 * Calcule de la vélocité 
		 */
		public void calcVel ()
		{
			this.velx += (this.m == Mouvement.MARCHE ) ? this.t.accelx : 0;
			
			if ( velx > 0 )
			{
				velx -= this.w.air_res;
				/* Si on change de signe, on met à 0 */
				velx = (velx - t.collage < 0 && this.m == Mouvement.MARCHE) ? 0 : velx - t.collage;
			} else if ( velx < 0 ) {
				velx += this.w.air_res;
				/* Si on change de signe, on met à 0 */
				velx = (velx + t.collage > 0 && this.m == Mouvement.MARCHE) ? 0 : velx + t.collage;
			}
			
			if ( this.m == Mouvement.SAUT )
			{
				this.vely -= this.masse * this.w.gravity / 10;
				this.vely += ( this.vely < 0 ) ? this.w.air_res : -this.w.air_res;
			}
		}
	}
}

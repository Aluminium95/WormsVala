using GLib;
using SDL;
using SDLImage;

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
		
		// public float elastic; // Élasticité 
		
		public float masse { get; protected set; } // Masse de l'objet
		
		public int32 col; // Couleur
		
		public int i; // Id ( très moche !!! )

		public TuplePos pos; // Point en bas à gauche ( départ )
		
		// Contient une référence faible vers le terrain 
		public unowned Terrain t {get;set;}
		public unowned World w {get;set;}
		
		// public Orientation orientation {get; protected set;}
		
		public string name {get; protected set; } // Oh pourquoi pas !!
		
		public Mouvement m; // Mouvement entrain d'être effectué
		
		/*public Type type; Peut servir, mais pour l'instant inutile ! */
		
		public signal void dead (); // Signal quand on meurt
		public signal void moved (); // Signal quand on bouge
		
		protected int vie; // Vie de l'objet
		
		public Surface s; // Image de l'objet
		
		protected string baseURI; // Chemin de base pour les images !
		
		public Objet (int x, Terrain t, int vie = 10, int l = 10, int h = 10)
		{
			this.t = t;
			
			this.pos.x = x;
			this.pos.y = t.getSol (this.pos.x);
			
			this.velx = 0;
			this.vely = 0;
			
			this.vie = vie;
			
			this.r = 20;
			this.masse = 10;
			
			this.m = Mouvement.MARCHE;
		}

		/**
		 * Effectue un mouvement
		 */
		public virtual void move ( float x )
		{
			this.pos.x += x;
			
			if ( this.m == Mouvement.SAUT)
			{
				if ( this.pos.y + (int) this.vely > this.t.getSol (this.pos.x) )
				{
					this.pos.y += (int) this.vely;
				} else {
					this.pos.y = this.t.getSol (this.pos.x);
					/*
					 * Gérér Ici l'élasticité et le rebon en fonction
					 * de la vélocité + gravité !
					 */
					this.m = Mouvement.MARCHE; // En attendant
				}
			} else if ( this.m == Mouvement.MARCHE ){
				this.pos.y = this.t.getSol (this.pos.x);
			}
			
			moved (); // Envoie le signal de déplacement
		}

		/**
		 * Modifie la vie
		 */
		public virtual void modifierVie (int v)
		{
			if ( this.vie == 0)
			{
				mourrir ();
			} else if ( vie != -1 ) {
				this.vie -= v;
			}
		}

		/**
		 * Meurt
		 */
		public virtual void mourrir ()
		{
			dead (); // Envoie le signal de mort
		}
	
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
			this.velx *= -1; // on multiplie par -1
		}
		
		/**
		 * Calcule de la vélocité 
		 */
		public virtual void calcVel ()
		{
			this.velx += (this.m == Mouvement.MARCHE ) ? this.t.accelx : 0;
			
			velx += (velx < 0 ) ? this.w.air_res : -this.w.air_res;
			
			if ( this.m == Mouvement.SAUT )
			{
				this.vely -= this.masse * this.w.gravity / 100;
				this.vely += ( this.vely < 0 ) ? this.w.air_res : -this.w.air_res;
			} else if ( this.m == Mouvement.MARCHE ){
				if ( velx > 0 )
				{
					velx = (velx - t.collage < 0 && this.m == Mouvement.MARCHE) ? 0 : velx - t.collage;
				} else {
					velx = (velx + t.collage > 0 && this.m == Mouvement.MARCHE) ? 0 : velx + t.collage;
				}
			}
		}
		
		/**
		 * Change le sprite en fonction de l'uri
		 * donnée en param
		 */
		public void setSprite (string uri)
		{
			this.s = SDLImage.load (uri);
		}
	}
}

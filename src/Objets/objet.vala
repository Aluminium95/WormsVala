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
		/**
		 * Largeur et hauteur 
		 */
		public int l;
		public int h;
		
		// Rayon du personnage
		public int r;
		
		/**
		 * Vélocité x et y 
		 */
		public float velx; // Vélocité X
		public float vely; // Vélocité Y
		
		// public float elastic; // Élasticité 
		
		/**
		 * Masse de l'objet, utilisée pour les calculs
		 * physiques 
		 */
		public float masse { get; protected set; }
		
		public int i; // Id ( très moche !!! )

		public TuplePos pos; // Point en bas à gauche ( départ )
		
		/**
		 * Références faibles ( unowned ) vers le terrain 
		 * auquel il appartient et le monde auquel il appartient
		 * ( va sûrement changer vu que world sera dans terrain bientôt ! )
		 */
		public unowned Terrain t {get;set;}
		public unowned World w {get;set;}
		
		/**
		 * Orientation du personnage ( gauche, droite, haut, bas )
		 */
		// public Orientation orientation {get; protected set;}
		
		/**
		 * Nom de l'objet :
		 * 	sera sûrement supprimée ou mis en virtual
		 * 	et définit dans des classe filles
		 * 	ex: caisse, mur, etc …
		 */
		public string name {get; protected set; }
		
		/**
		 * Mouvement en train d'être effectué
		 * sachant que saut peut aussi être une chute !
		 */
		public Mouvement m;
		
		/*public Type type; Peut servir, mais pour l'instant inutile ! */
		
		// Vie restante à l'objet
		protected int vie;
		
		// Surface ( image ) de l'objet
		public Surface s;
		
		// Chemin de base pour les images à charger
		protected string baseURI;
		
		/** 
		 * Définit si le personnage à déjà 
		 * « donné un coup de reins » en l'air
		 */
		protected bool virementEnAir;
		
		/**
		 * Signaux envoyés pour utilisation
		 * ultérieure 
		 */
		public signal void dead ();
		public signal void moved ();
		
		/**
		 * Constructeur
		 */
		public Objet (int x, Terrain t, int vie = 10, int l = 10, int h = 10)
		{
			this.t = t;
			
			this.pos.x = x;
			this.pos.y = t.getSol (this.pos.x);
			
			this.velx = 0;
			this.vely = 0;
			
			this.vie = vie;
			
			this.r = 20;
			this.masse = 50;
			
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
					this.pos.y += this.vely;
				} else {
					this.pos.y = this.t.getSol (this.pos.x);
					/*
					 * Gérér Ici l'élasticité et le rebon en fonction
					 * de la vélocité + gravité !
					 */
					this.m = Mouvement.MARCHE; // En attendant
					this.virementEnAir = false; // Reset de la possiblitité de s'orienter
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
			if ( this.vie - v < 0 && this.vie != -1)
			{
				stderr.printf ("Mourrir !\n");
				mourrir ();
			} else {
				stderr.printf ("Moins de vie !\n");
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
			// Si on est sur le sol, on subit la pente
			this.velx += (this.m == Mouvement.MARCHE ) ? this.t.accelx : 0;
			
			// Résistance de l'air
			velx += (velx < 0 ) ? this.w.air_res : -this.w.air_res;
			
			if ( this.m == Mouvement.SAUT )
			{
				double calc = this.masse * this.w.gravity;
				calc /= 1000;
				this.vely -= (float) calc;
				this.vely += ( this.vely < 0 ) ? this.w.air_res : -this.w.air_res;
			} else if ( this.m == Mouvement.MARCHE ){ // Gestion de l'adhérence
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

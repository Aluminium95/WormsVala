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

		public TuplePos pos { get; private set; } // Point en bas à gauche ( départ )
		public TuplePos pos_gh { get; private set; } // Point en haut à gauche
		public TuplePos pos_db { get; private set; } // Point en bas à droite
		public TuplePos pos_dh { get; private set; } // Point en haut à droite

		public TuplePos dim; // Dimensions de l'objet
		
		public Terrain t; // Mmmh, on pourrait pas plutôt faire que le terrain fasse ça lui même !?
		
		public string name; // Oh pourquoi pas !!
		
		public int i; // Position dans le tableau des Objets
		
		public Type type; // Visiblement … sert à rien … ( déjà implémenté dans une classe par défaut )
		
		public signal void dead (); // Quand on meurt
		public signal void moved (); // Quand on frappe
		
		protected int vie;
		
		public Objet ( int x, Terrain t, int vie = 10, int l = 10, int h = 10)
		{
			this.t = t;
			
			this.pos.x = x;
			this.pos.y = t.getSol (x);
			
			this.vie = vie;
			
			this.dim.x = l;
			this.dim.y = h;
			
			this.calc_rect ();
		}

		/**
		 * Effectue un mouvement
		 */
		public void move ( int x )
		{
			this.pos.x = x;
			this.pos.y = this.t.getSol (x);
			
			this.calc_rect ();
			
			moved ();
		}

		/**
		 * Modifie la vie
		 */
		public void modifierVie (int v)
		{
			if ( this.vie == 0)
			{
				mourrir ();
			} else if ( vie != 1 )
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
		protected void calc_rect ()
		{
			calc_db ();
			calc_gh ();
			calc_dh ();
		}

		/**
		 * Calcule la position du point en bas à droite 
		 * Très très moche et pas fonctionnel !
		 * Méthode à revoir !!!!!
		 */
		protected void calc_db ()
		{
			if ( t.pencheDroite )
			{
				pos_db.x = (int) ( t.largeur * dim.x ) / (int) GLib.Math.sqrt (t.largeur * t.largeur + t.getH (this.pos.x) * t.getH (this.pos.x) );
			} else {
				pos_db.x = (int) ( t.largeur * dim.x ) / (int) GLib.Math.sqrt (t.largeur * t.largeur + t.getH (this.pos.x) * t.getH (this.pos.x) );
			}
			
			pos_db.y = t.getSol (pos_db.x);
		}

		/**
		 * Calcule la position du point en haut à gauche
		 */
		protected void calc_gh ()
		{
			
		}

		/**
		 * Calucle la position du point en haut à droite
		 */
		protected void calc_dh ()
		{
			
		}
	}
}

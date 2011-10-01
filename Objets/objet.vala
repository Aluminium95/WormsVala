using GLib;

namespace Jeu
{
	/*
	 * Un objet du jeu ( decor, ia, joueur … )
	 */
	public abstract class Objet : Object
	{
		/*
		 * Modifier les propriétés de la Position pos 
		 * en même temps !
		 */
		public int l { 
			get { }
			set { }
		}
		public int h {
			get { }
			set { }
		}
		
		public Position pos;
		
		public Terrain t;
		
		public string name; // Oh pourquoi pas !!
		
		public int i; // Position dans le tableau des Objets
		
		public Type type; // Visiblement … sert à rien … ( déjà implémenté dans une classe par défaut )
		
		public signal void dead (); // Quand on meurt
		public signal void moved (); // Quand on frappe
		
		protected int vie;
		
		public Objet ( int x, Terrain t, int vie )
		{
			this.x = x;
			this.y = t.getSol (x);
			this.t = t;
		}
		
		public void move ( int x )
		{
			this.pos.move (x, this.t.getSol (x));
			moved ();
		}
		
		public void aie (int v)
		{
			if ( this.vie == 0)
			{
				mourrir ();
			} else if ( vie != 1 )
			{
				this.vie -= v;
			}
		}
		
		public void mourrir ()
		{
			dead ();
		}
	}
}

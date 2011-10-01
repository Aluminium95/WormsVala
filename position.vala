using GLib;

namespace Jeu
{
	/*
	 * Classe pour gérer les positions des objets
	 */
	public class Position : Objet
	{
		public TuplePos gb { get; private set; } // Point en bas à gauche
		public TuplePos gh { get; private set; } // Point en haut à gauche
		public TuplePos db { get; private set; } // Point en bas à droite
		public TuplePos dh { get; private set; } // Point en haut à droite
		
		public TuplePos dim; // Dimensions de l'objet
		
		public Terrain t;
		
		public Position (int x, int y, int l, int h, Terrain t ) // Position gb + terrain + dimensions
		{
			
		}
		
		/*
		 * Déplacement du point de départ ( gb )
		 */
		public void move (int x, int y)
		{
			
		}
		
		private void calc_db ()
		{
			if ( t.pencheDroite )
			{
				db.x = (int) ( t.largeur * dim.x ) / GLib.Math.sqrt (t.largeur * t.largeur + t.getH * t.getH );
			} else {
				db.x = (int) ( t.largeur * dim.x ) / GLib.Math.sqrt (t.largeur * t.largeur + t.getH * t.getH );
			}
			
			db.y = t.getSol (db.x);
		}
		
		private void calc_gh ()
		{
			
		}
		
		private void calc_dh ()
		{
			
		}
	}
}

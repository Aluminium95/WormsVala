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
		
		public Terrain t;
		
		public Position (int x, int y, Terrain t ) // Position gb + terrain
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
			
		}
		
		private void calc_gh ()
		{
		
		}
		
		private void calc_dh ()
		{
		
		}
	}
}

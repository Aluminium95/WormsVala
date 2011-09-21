using GLib;

namespace Jeu
{
	/*
	 * Terrain du jeu
	 */
	public class Terrain : Object
	{
		private bool pencheDroite;
		
		public int i; // Peut être pas … 
		
		public int largeur { get; protected set; default = 0; }
		
		public int hg { get; protected set; default = 0; }
		
		public int hd { get; protected set; default = 0; }
		
		public Terrain (int l, int d, int g)
		{
			this.largeur = l;
			this.hd = d;
			this.hg = g;
			
			this.pencheDroite = ( hg > hd ) ? true : false;
		}
		
		public int getSol ( int x )
		{
			if ( pencheDroite )
			{
				return (int) x * ( hg - hd ) / largeur + hd;
			} else {
				return (int) x * ( hd - hg ) / largeur + hg;
			}
		}
	}
}

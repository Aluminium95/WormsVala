using GLib;

namespace Jeu
{
	public class Player : Personnage
	{
		public Player (int x, Terrain t, int vie, string name)
		{
			base ( x, t, vie);
			
			this.name = name;
		}
	}
}

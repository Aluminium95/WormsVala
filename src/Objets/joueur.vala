using GLib;

namespace Jeu
{
	/**
	 * Représente un joueur 
	 */
	public class Player : Personnage
	{
		public Player (int x, Terrain t, int vie, string name)
		{
			base ( x, t, vie); // Chaine vers Personnage
			
			this.name = name; // Définit le nom
		}
	}
}

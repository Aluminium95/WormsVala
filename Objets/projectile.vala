using GLib;

namespace Jeu
{
	/*
	 * Projectile d'une arme à distance
	 * il faut implémenter une gravité pour le projectile en fonction
	 * de sa puissance !
	 */
	public class Projectile : Objet
	{
		public Projectile (Terrain t)
		{
			base ( 10, t, 10);
		}
	}
}

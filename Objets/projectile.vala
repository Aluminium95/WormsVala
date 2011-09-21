using GLib;

namespace Jeu
{
	/*
	 * Projectile d'une arme à distance
	 */
	public class Projectile : Objet
	{
		public Projectile (Terrain t)
		{
			base ( 10, t, 10);
		}
	}
}

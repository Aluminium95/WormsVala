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
		public int degats { get; protected set; } // Dégats de contact
		
		public Projectile (Terrain t, int deg)
		{
			base ( 10, t, 10);
			
			this.degats = deg;
		}

		public int execute ()
		{
			stdout.printf ("Éxécute !\n");
			return 0;
		}
	}
}

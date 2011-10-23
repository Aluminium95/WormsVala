using GLib;

namespace Jeu
{
	/**
	 * Arme à distance
	 */
	public class ArmeDist : Arme
	{
		// Munitions dans le chargeur !
		public int chargeur {get; protected set;}
		
		public ArmeDist (int deg)
		{
			base (deg);
		}
		
		public override bool utiliser ()
		{
			/*
			 * Code d'utilisation d'une arme 
			 * distance
			 */
			return false;
		}
	}
}

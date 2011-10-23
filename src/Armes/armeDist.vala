using GLib;

namespace Jeu
{
	/**
	 * Arme à distance
	 */
	public class ArmeDist : Arme
	{
		public override new const bool distance = true;
		
		// Munitions dans le chargeur !
		public int chargeur {get; protected set;}
		
		/**
		 * Constructeur 
		 */
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

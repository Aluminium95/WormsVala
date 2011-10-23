using GLib;

namespace Jeu
{
	/*
	 * Arme de corps à corps
	 */
	public class ArmeCac : Arme
	{
		public ArmeCac (int deg)
		{
			base (deg);
		}
		public override bool utiliser ()
		{
			/*
			 * Code d'utilisation d'une arme Cac
			 */
			return true;
		}
	}
}

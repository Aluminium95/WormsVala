using GLib;

namespace Jeu
{
	/*
	 * Représente une arme du jeu
	 */
	public abstract class Arme : Object
	{
		public int degats { get; protected set; default = 0; }
		public int munitions { get; protected set; default = -1; } // Pour les armes Cac c'est l'usure
		
		public bool distance; // Distance ou Cac
		
		public Arme (int deg)
		{
			this.degats = deg;
		}
		
		public bool utiliser ()
		{
			if ( this.munitions > 0 )
			{
				this.munitions --;
				return true;
			} else if ( this.munitions == -1 ) {
				return true;
			} else {
				return false;
			}
		}

	}
}

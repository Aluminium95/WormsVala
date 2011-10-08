using GLib;

namespace Jeu
{
	/*
	 * Représente une arme du jeu
	 */
	public class Arme : Object
	{
		public int degats { get; protected set; default = 0; }
		public int munitions { get; protected set; default = -1; } // Pour les armes Cac c'est l'usure
		
		public bool distance; // Distance ou Cac

		public int gravite { get; protected set; default = 0; } // Force de la courbe … A(x-a)²+b

		public int r {get; protected set; default = 10; }
		
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

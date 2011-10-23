using GLib;
using SDL;

namespace Jeu
{
	/**
	 * Représente une arme du jeu
	 */
	public class Arme : Object
	{
		// Dégats infligés par l'arme
		public int degats { get; protected set; default = 0; }
		
		// Munitions de l'arme ( -1 = infini )
		public int munitions { get; protected set; default = -1; }
		
		// Arme de distance ou de CAC ?
		public bool distance;
		
		// Rayon de l'arme
		public int r {get; protected set; default = 50; }
		
		// Image de l'arme
		public Surface s;
		
		/**
		 * Constructeur 
		 */
		public Arme (int deg)
		{
			this.degats = deg;
		}
		
		/**
		 * Utiliser l'arme !
		 */
		public virtual bool utiliser ()
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

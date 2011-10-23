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
		
		// Rayon de l'arme
		public int r {get; protected set; default = 50; }
		
		// Image de l'arme
		public Surface s;
		
		// Est une arme de distance 
		public virtual const bool distance = false;
		
		/**
		 * Signal envoyé lors de l'utilisation 
		 * de l'arme, on va se démerder avec pour 
		 * ne plus passer par joueurFrappe et autres
		 *
		 * public abstract signal void utilise (bool d);
		 */
		
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

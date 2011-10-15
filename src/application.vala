using GLib;

namespace Jeu
{
	public class Application : Object
	{
		private Gerant g; // Moteur du jeu
		private Aff a; // Gestionnaire d'affichage
		private Son s; // Moteur de son
		
		public Application ()
		{
			a = new Aff ();
			g = new Gerant ();
			s = new Son ();
		}
		
		/**
		 * Fait tourner l'application 
		 */
		public void run ()
		{
			
		}
	}
}

using GLib;
using SDL;

namespace Jeu
{
	public class Application : Object
	{
		private Gerant g; // Moteur du jeu
		private Aff a; // Gestionnaire d'affichage
		private Son s; // Moteur de son
		
		private bool done;
		
		public Application ()
		{
			a = new Aff ();
			g = new Gerant ();
			s = new Son ();
			done = false;
		}
		
		/**
		 * Fait tourner l'application 
		 */
		public void run ()
		{
			while (!done)
			{
				g.execute ();
				process_events ();
				
				/*
				 * Quitte sans attendre le delai ni rafaichir l'écran
				 * si durant l'éxécution done = true
				 */
				if (done) { break; }
				
				SDL.Timer.delay (DELAY);
			}
		}
	}
}

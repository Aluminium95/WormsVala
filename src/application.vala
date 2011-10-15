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
			s = new Son ();
			
			g = new Gerant ();
			
			connectSignals();
			
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
		
		/**
		 * Connection des signaux de l'application
		 */
		public void connectSignals ()
		{
			g.needDrawLine.connect (a.draw_line);
			g.needDrawObjet.connect (a.draw_objet);
			g.needDrawTerrain.connect (a.draw_terrain);
			g.needPlayHit.connect (
			
			Jeu.Aff.son.addSon (Config.MUSIQUE + "/hit.ogg");
			Jeu.Aff.son.addSon (Config.MUSIQUE + "/terrain.ogg");
			Jeu.Aff.son.addSon (Config.MUSIQUE + "/bordure.ogg");
		}
	}
}

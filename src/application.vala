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
		
		/**
		 * Fait la boucle événementielle
		 */
		private void process_events () {
			
			Event event = Event ();
			while (Event.poll (event) == 1) {
		        switch (event.type) {
		        	case EventType.QUIT:
						Jeu.Aff.done = true;
              	 		break;
					case EventType.KEYDOWN:
						Jeu.Aff.on_keyboard_event (event.key);
						break;
		        }
        	}
        	
		}
		
		/**
		 * Récupère la touche appuyée et fait les actions 
		 * nécessaires en fonction
		 */
		private void on_keyboard_event (KeyboardEvent event) {
			#if DEBUG
				print ("\tAff : entrée clavier !\n", CouleurConsole.BLEU);
			#endif
			switch (event.keysym.sym)
			{
				case KeySymbol.q:
					Jeu.Aff.done = true;
					break;
				case KeySymbol.m:
					/* affiche le menu */
					break;
				default:
					g.movePlayer (event.keysym.sym);
					break;
			}
		}
	}
}

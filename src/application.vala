using GLib;
using SDL;

namespace Jeu
{
	public class Application : Object
	{
		private Gerant g; // Moteur du jeu
		private Aff a; // Gestionnaire d'affichage
		private Son s; // Moteur de son
		
		public const int DELAY = 20; // Délai entre chaque tour de boucle
		
		private bool done;
		
		public Application ()
		{
			a = new Aff ();
			
			s = new Son ();
			s.hit = Config.MUSIQUE + "/hit.ogg";
			s.bam = Config.MUSIQUE + "/terrain.ogg";
			s.createSons ();
			
			g = new Gerant ();
			
			connectSignals();
			
			done = false;
		}
		
		/**
		 * Fait tourner l'application 
		 */
		public void run ()
		{
			s.music.play (-1); // Joue la musique de fond en boucle
			
			while (!done)
			{
				a.clearscr (); // Efface l'écran
				
				a.draw (); // Dessine le fond animé 
				
				g.execute (); // Execute un tour de boucle du jeu
				
				process_events (); // Process les évent
				
				a.affiche (); // Rafraichit l'écran
				
				/*
				 * Quitte sans attendre le delai ni rafaichir l'écran
				 * si durant l'éxécution done = true
				 */
				if (done) { break; }
				
				SDL.Timer.delay (DELAY); // Wait le délai
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
			g.needPlayHit.connect (s.playHit);
			g.needPlayBam.connect (s.playBam);
		}
		
		/**
		 * Fait la boucle événementielle
		 */
		private void process_events () {
			
			Event event = Event ();
			while (Event.poll (event) == 1) {
		        switch (event.type) {
		        	case EventType.QUIT:
						this.done = true;
              	 		break;
					case EventType.KEYDOWN:
						this.on_keyboard_event (event.key);
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
					this.done = true;
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

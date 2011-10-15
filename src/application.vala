using GLib;
using SDL;

namespace Jeu
{
	public class Application : Object
	{
		private Gerant g; // Moteur du jeu
		private Menu.Menu m; // Menu du jeu
		private Aff a; // Gestionnaire d'affichage
		private Son s; // Moteur de son
		
		public const int DELAY = 20; // Délai entre chaque tour de boucle
		
		private bool done;
		private bool menu;
		
		private delegate void dActionMenu (Menu.ActionMenu a);
		
		public Application ()
		{
			a = new Aff ();
			
			s = new Son ();
			s.hit = Config.MUSIQUE + "/hit.ogg";
			s.bam = Config.MUSIQUE + "/terrain.ogg";
			s.createSons ();
			
			g = new Gerant ();
			m = new Menu.Menu ();
			
			connectSignals();
			
			done = false;
			menu = true; // On affiche le menu au début
		}
		
		/**
		 * Fait tourner l'application 
		 */
		public void run ()
		{
			s.music.play (-1);
			s.music.pause ();
			
			while (!done)
			{
				a.clearscr (); // Efface l'écran
				
				if (!menu)
				{
					a.draw (); // Dessine le fond animé 
					g.execute (); // Execute un tour de boucle du jeu
					process_events_gerant (); // Process les évent du gérant
				} else { 
					m.execute ();
					process_events_menu (); // Process les évent du menu
				}
				
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
			// Signaux de gérant 
			g.needDrawLine.connect (a.draw_line);
			g.needDrawObjet.connect (a.draw_objet);
			g.needDrawTerrain.connect (a.draw_terrain);
			g.needPlayHit.connect (s.playHit);
			g.needPlayBam.connect (s.playBam);
			
			// Signaux de menu 
			m.needDrawBouton.connect (a.draw_bouton);
			m.actionMenu.connect (this.gererActionMenu);
		}
		
		/**
		 * Fait la boucle événementielle
		 */
		private void process_events_gerant () {
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
		
		private void process_events_menu () {
			Event event = Event ();
			while (Event.poll (event) == 1) {
				switch (event.type) {
					case EventType.QUIT:
						this.done = true;
						break;
					case EventType.MOUSEBUTTONDOWN:
						this.m.clic (event.button.x,event.button.y);
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
					this.menu = true;
					s.music.pause ();
					break;
				default:
					g.movePlayer (event.keysym.sym);
					break;
			}
		}
		
		private void gererActionMenu (Menu.ActionMenu a)
		{
			switch (a)
			{
				case Menu.ActionMenu.QUITTER:
					this.done = true;
					break;
				case Menu.ActionMenu.COMMENCER:
					this.menu = false;
					g.restart ();
					s.music.rewind ();
					break;
				case Menu.ActionMenu.RECOMMENCER:
					this.menu = false;
					s.music.resume ();
					break;
			}
		}
	}
}

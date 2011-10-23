using GLib;
using SDL;

namespace Jeu
{
	/**
	 * L'application en elle-même du jeu
	 */
	public class Application : Object
	{
		private Gerant g; // Moteur du jeu
		private Menu.Menu m; // Menu du jeu
		private Aff a; // Gestionnaire d'affichage
		private Son s; // Moteur de son
		
		/**
		 * Contient si les touches sont enfoncées
		 */
		private bool keyHeld[256];
		
		/**
		 * Contient les symboles correspondants 
		 * utilisé en lien avec le tableau précédent
		 */
		private KeySymbol keySym[256];
		
		// Délai entre chaque tour de boucle
		public const int DELAY = 10;
		
		// Tant que ce n'est pas fini
		private bool done;
		
		// Affiche le menu ?
		private bool menu;
		
		/**
		 * Délégate pour récupérér une action du menu
		 */
		private delegate void dActionMenu (Menu.ActionMenu a);
		
		/** 
		 * Constructeur
		 */
		public Application ()
		{		
			a = new Aff ();
			
			s = new Son ();
			s.hit = Config.MUSIQUE + "/hit.ogg";
			s.bam = Config.MUSIQUE + "/test.ogg";
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
			
			m.execute ();
			
			while (!done)
			{
				if (!menu)
				{
					a.clearscr (); // Efface l'écran
					a.draw (); // Dessine le fond animé 
					g.execute (); // Execute un tour de boucle du jeu
					process_events_gerant (); // Process les évent du gérant
				} else { 
					// m.execute ();
					process_events_menu (); // Process les évent du menu
				}
				touchesEnfoncees ();
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
							this.on_keyboard_event (event.key, true);
							break;
						case EventType.KEYUP:
							this.on_keyboard_event (event.key, false);
							break;
				}
        		}
		}
		
		/**
		 * Fait la boucle événementielle pour le menu uniquement
		 */
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
		private void on_keyboard_event (KeyboardEvent event, bool down) {
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
					m.execute ();
					s.music.pause ();
					break;
				default:
					keyHeld[event.keysym.sym] = down;
					keySym[event.keysym.sym] = event.keysym.sym;
					break;
			}
		}
		
		/**
		 * Gère les actionns retournées par le menu
		 */
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
					if ( s.music.is_paused () == 1 )
					{
						s.music.resume ();
					}
					s.music.rewind ();
					break;
				case Menu.ActionMenu.CONTINUER:
					this.menu = false;
					s.music.resume ();
					break;
			}
		}
		
		/**
		 * Gère les touches appuyées
		 */
		private void touchesEnfoncees ()
		{
			for (int i = 0; i < 256; i++ )
			{
				if ( keyHeld[i] == true )
				{
					g.movePlayer (keySym[i]);
				}
			}
		}
	}
}

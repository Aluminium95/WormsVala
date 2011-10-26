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
		private Scripts scripts; // Moteur des scripts lua
		private GestionInfo inf; // Moteur des infos textuelles
		
		// Délai entre chaque tour de boucle
		public const int DELAY = 10;
		
		// Tant que ce n'est pas fini
		private bool done;
		
		// Affiche le menu ?
		private bool menu;
		
		/**
		 * Délégate pour récupérér une action du menu
		 */
		private delegate void d_action_menu (Menu.ActionMenu a);
		
		/** 
		 * Constructeur
		 */
		public Application ()
		{		
			a = new Aff ();
			
			s = new Son ();
			s.hit = Config.MUSIQUE + "/hit.ogg";
			s.bam = Config.MUSIQUE + "/test.ogg";
			s.create_sons ();
			
			g = new Gerant ();
			
			m = new Menu.Menu ();
			
			scripts = new Scripts (ref g, ref m);
			scripts.load_level (1);
			// scripts.load_menu ();
			
			connect_signaux();
			
			done = false;
			menu = true; // On affiche le menu au début
			
			// Répétition des touches !
			SDL.Key.set_repeat (10,10);
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
		public void connect_signaux ()
		{
			// Signaux de gérant 
			g.need_draw_line.connect (a.draw_line);
			g.need_draw_objet.connect (a.draw_objet);
			g.need_draw_terrain.connect (a.draw_terrain);
			g.need_play_hit.connect (s.play_hit);
			g.need_play_bam.connect (s.play_bam);
			
			// Signaux de menu 
			m.needDrawBouton.connect (a.draw_bouton);
			m.actionMenu.connect (gerer_action_menu);
			stdout.printf ("Connecte les signaux !\n");
			m.need_load_menu.connect ( () => {
				stdout.printf ("tente de loader un menu !\n");
			});
			stdout.printf ("A conneté le signal\n");
			// Signaux infos
			//g.need_add_info.connect (inf.add_info);
			//m.need_add_info.connect (inf.add_info);
			//inf.need_draw_info.connect (a.draw_info);
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
					m.execute ();
					s.music.pause ();
					break;
				default:
					g.move_player (event.keysym.sym);
					break;
			}
		}
		
		/**
		 * Gère les actionns retournées par le menu
		 */
		private void gerer_action_menu (Menu.ActionMenu a)
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
	}
}

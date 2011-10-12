using GLib;
using SDL; // Écran
using SDLGraphics; // Géométrie

namespace Jeu
{
	/**
	 * Gestion de l'affichage du jeu
	 * Classe statique !
	 */
	public class Aff : Object {

		public static const int SCREEN_WIDTH = 800; // Largeur de l'écran
		public static const int SCREEN_HEIGHT = 400; // Hauteur de l'écran
		
		private static const int SCREEN_BPP = 32;
		public static const int DELAY = 20; // Délai entre chaque tour de boucle

		private static unowned SDL.Screen screen; // L'écran 
		
		private static SDL.Surface surf; // La surface de fond
		
		private static GLib.Rand rand; // Le générateur de nombre aléatoires
		
		public static Son son; // Le gestionnaire de son
		
		public static bool done; // 
		
		public static Gerant g; // Le gestionnaire du jeu !
		
		/**
		 * Initialise les objets 
		 */
		public static void init () {
			#if DEBUG
				print ("\tAff : Initialisation \n", CouleurConsole.BLEU);
			#endif
			son = new Son ();
			rand = new GLib.Rand ();			
			g = new Gerant ();
		}
		
		/**
		 * Fait tourner la boucle principale
		 */
		public static void run () {
			init_video ();
			
			son.music.volume (25);
			son.music.play (-1);
			
			while (!done) {
				screen.fill (null,5468);
				g.execute ();
				process_events ();
				/*
				 * Quitte sans attendre le delai ni rafaichir l'écran
				 * si durant l'éxécution done = true
				 */
				if (done) { break; }
				
				screen.flip ();
				SDL.Timer.delay (DELAY);
			}
			#if DEBUG
				print ("\tAff : Boucle principale finie\n", CouleurConsole.BLEU);
			#endif
			son.quit ();
			#if DEBUG 
				print ("\tAff : Son quitté\n", CouleurConsole.BLEU);
			#endif
		}
		
		/**
		 * Initialise la vidéo
		 */
		private static void init_video () {
			#if DEBUG
				print ("\tAff : Initialisation de la vidéo\n", CouleurConsole.BLEU);
			#endif 
			uint32 video_flags = SurfaceFlag.DOUBLEBUF
								| SurfaceFlag.HWACCEL
								| SurfaceFlag.HWSURFACE;

			screen = Screen.set_video_mode (SCREEN_WIDTH, SCREEN_HEIGHT,
							SCREEN_BPP, video_flags);
			if (screen == null) {
				stderr.printf ("Could not set video mode.\n");
			}

			SDL.WindowManager.set_caption ("MégaWorm", "");
		
			surf = new SDL.Surface.RGB (video_flags, SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, 0,0,0,0);
		}
		
		/**
		 * Dessine le fond 
		 */
		public static void draw () {
			int16 x = (int16) rand.int_range (0, screen.w);
			int16 y = (int16) rand.int_range (0, screen.h);
			int16 radius = (int16) rand.int_range (0, 100);
			uint32 color = rand.next_int ();

			Circle.fill_color (surf, x, y, radius, color);
			Circle.outline_color_aa (surf, x, y, radius, color);
			
			surf.blit (null, screen, null);
		}
		
		/**
		 * Dessine un objet
		 */
		public static void draw_objet (Objet o)
		{
			Circle.fill_color (screen, (int16) o.pos.x, (int16) (SCREEN_HEIGHT - o.pos.y), (int16) o.r, o.col);
			Circle.outline_color (screen, (int16) o.pos.x, (int16) (SCREEN_HEIGHT - o.pos.y), (int16) o.r, 0xFFFFFFF);
		}
		
		/**
		 * Dessine un terrain
		 */
		public static void draw_terrain (Terrain t)
		{
			
			int16[] vx = {
					(int16) t.start , (int16) t.start, (int16) (t.start + t.largeur), (int16) (t.start + t.largeur)
				};
			int16[] vy = {
					(int16) SCREEN_HEIGHT, (int16) (SCREEN_HEIGHT - t.hg) , (int16) (SCREEN_HEIGHT - t.hd), (int16) SCREEN_HEIGHT
				};
			
			if ( t.objets.size == 0)
			{
				Polygon.fill_rgba (screen, vx, vy, 4, '1', '1', '1', 255);
			} else {
				Polygon.fill_rgba (screen, vx, vy, 4, 'F', 'F', 'F', 255);
			}
			Line.color (screen, (int16) (t.start + t.largeur), 0, (int16) (t.start + t.largeur), (int16) SCREEN_HEIGHT, 0xFFFFFFF);
		}
		
		/**
		 * Dessine une ligne 
		 */
		public static void draw_line (int x1, int y1, int x2, int y2)
		{
			Line.color (screen, (int16) x1, (int16) (SCREEN_HEIGHT - y1), (int16) x2, (int16) (SCREEN_HEIGHT - y2) , 0xFFFFFFF);
		}

		/**
		 * Fait la boucle événementielle
		 */
		private static void process_events () {
			
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
		private static void on_keyboard_event (KeyboardEvent event) {
			#if DEBUG
				print ("\tAff : entrée clavier !\n", CouleurConsole.BLEU);
			#endif
			if(event.keysym.sym==KeySymbol.q)
			{
				Jeu.Aff.done = true;
			} else if ( event.keysym.sym == KeySymbol.m )  {
				/* Afficher menu */
			} else {
				clavier_joueur (event.keysym.sym);
			}
		}
		
		/**
		 * Gère les mouvements des joueurs en fonction 
		 * des touches utilisées
		 */
		private static void clavier_joueur (KeySymbol k)
		{
			#if DEBUG
				print ("\tAff : entrée clavier joueur !\n", CouleurConsole.BLEU);
			#endif
			switch (k)
			{
				case KeySymbol.t:
					/* demande le déplacement du personnage 1 de 1 */
					g.movePlayer (1,1);
					break;
				case KeySymbol.e:
					/* demande le déplacement du personnage -1 de 1 */
					g.movePlayer (1,-1);
					break;
			}
		}
	}
}

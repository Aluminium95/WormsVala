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

		public const int SCREEN_WIDTH = 800; // Largeur de l'écran
		public const int SCREEN_HEIGHT = 400; // Hauteur de l'écran
		
		private const int SCREEN_BPP = 32;
		public const int DELAY = 20; // Délai entre chaque tour de boucle

		private unowned SDL.Screen screen; // L'écran 
		
		private SDL.Surface surf; // La surface de fond
		
		private GLib.Rand rand; // Le générateur de nombre aléatoires
		
		public bool done; // Tant que l'affichage n'est pas fini
		
		public delegate void draw_line (int x1, int y1, int x2, int y2);
		public delegate void draw_objet (Objet o);
		public delegate void draw_terrain (Terrain t);
		
		/**
		 * Constructeur 
		 */
		public Aff ()
		{
			#if DEBUG
				print ("\tAff : Initialisation \n", CouleurConsole.BLEU);
			#endif
			rand = new GLib.Rand ();
			
			init_video ();
		}
		
		/**
		 * Fait tourner la boucle principale
		 */
		public void run () {
			
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
		private void init_video () {
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
		public void draw () {
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
		public void draw_objet (Objet o)
		{
			Circle.fill_color (screen, (int16) o.pos.x, (int16) (SCREEN_HEIGHT - o.pos.y), (int16) o.r, o.col);
			Circle.outline_color (screen, (int16) o.pos.x, (int16) (SCREEN_HEIGHT - o.pos.y), (int16) o.r, 0xFFFFFFF);
		}
		
		/**
		 * Dessine un terrain
		 */
		public void draw_terrain (Terrain t)
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
		public void draw_line (int x1, int y1, int x2, int y2)
		{
			Line.color (screen, (int16) x1, (int16) (SCREEN_HEIGHT - y1), (int16) x2, (int16) (SCREEN_HEIGHT - y2) , 0xFFFFFFF);
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

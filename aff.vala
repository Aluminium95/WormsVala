using GLib;
using SDL;
using SDLGraphics;

namespace Jeu
{
	/**
	 * Gestion de l'affichage du jeu
	 * Classe statique !
	 */
	public class Aff : Object {

		public static const int SCREEN_WIDTH = 600;
		public static const int SCREEN_HEIGHT = 400;
		private static const int SCREEN_BPP = 32;
		public static const int DELAY = 30;
		
		private static bool[] keysHeld = new bool[323]; // Entrées clavier

		private static unowned SDL.Screen screen;
		private static GLib.Rand rand;
		public static bool done;
		
		public static Gerant g;

		public static void init () {
			rand = new GLib.Rand ();
			g = new Gerant ();
		}

		public static void run () {
			init_video ();

			while (!done) {
				screen.fill (null,5468);
				g.execute ();
				process_events ();
				screen.flip ();
				SDL.Timer.delay (DELAY);
			}
		}

		private static void init_video () {
			uint32 video_flags = SurfaceFlag.DOUBLEBUF
								| SurfaceFlag.HWACCEL
								| SurfaceFlag.HWSURFACE;

			screen = Screen.set_video_mode (SCREEN_WIDTH, SCREEN_HEIGHT,
							SCREEN_BPP, video_flags);
			if (screen == null) {
				stderr.printf ("Could not set video mode.\n");
			}

			SDL.WindowManager.set_caption ("Un super jeu en SDL", "");
		}

		private static void draw () {
			int16 x = (int16) rand.int_range (0, screen.w);
			int16 y = (int16) rand.int_range (0, screen.h);
			int16 radius = (int16) rand.int_range (0, 100);
			uint32 color = rand.next_int ();

			Circle.fill_color (screen, x, y, radius, color);
			Circle.outline_color_aa (screen, x, y, radius, color);
		}
		
		public static void draw_objet (Objet o)
		{
			Circle.fill_color (screen, (int16) o.pos.x, (int16) (SCREEN_HEIGHT - o.pos.y), 10, 0x004AFF);
			Circle.outline_color (screen, (int16) o.pos.x, (int16) (SCREEN_HEIGHT - o.pos.y), 10, 0xFFFFFFF);
		}
		
		public static void draw_terrain (Terrain t)
		{
			int16[] vx = {
					(int16) t.start , (int16) t.start, (int16) (t.start + t.largeur), (int16) (t.start + t.largeur)
				};
			int16[] vy = {
					(int16) SCREEN_HEIGHT, (int16) (SCREEN_HEIGHT - t.hg) , (int16) (SCREEN_HEIGHT - t.hd), (int16) SCREEN_HEIGHT
				};
			Polygon.fill_rgba (screen, vx, vy, 4, 'C', 'C', 'C', 255);
		}
		
		public static void draw_line (int x1, int y1, int x2, int y2)
		{
			Line.color (screen, (int16) x1, (int16) (SCREEN_HEIGHT - y1), (int16) x2, (int16) (SCREEN_HEIGHT - y2) , 0xFFFFFFF);
		}

		private static void process_events () {
			Event event = Event ();
			while (Event.poll (event) == 1) {
		        switch (event.type) {
		        case EventType.QUIT:
		            Aff.done = true;
		            break;
		        case EventType.KEYDOWN:
					keysHeld[event.key.keysym.sym] = true;
		            break;
		        case EventType.KEYUP:
					keysHeld[event.key.keysym.sym] = false;
		            break;
		        }
        	}
        	
		}

		private static void gerer_clavier () {
			if ( keysHeld[113] ) { // Q
				Aff.done = true;
			}
		}
	}
}

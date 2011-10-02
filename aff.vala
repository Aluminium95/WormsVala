using GLib;
using SDL;
using SDLGraphics;

namespace Jeu
{
	public class Aff : Object {

		private static const int SCREEN_WIDTH = 400;
		private static const int SCREEN_HEIGHT = 500;
		private static const int SCREEN_BPP = 32;
		private static const int DELAY = 10;

		private static unowned SDL.Screen screen;
		private static GLib.Rand rand;
		private static bool done;
		
		public static Gerant g;

		public static void init () {
			rand = new GLib.Rand ();
			g = new Gerant ();
		}

		public static void run () {
			init_video ();

			while (!done) {
				// draw ();
				g.execute ();
				process_events ();
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

			screen.flip ();
		}
		
		public static void draw_objet (Objet o)
		{
			Circle.fill_color (screen, (int16) o.pos.x, (int16) (SCREEN_HEIGHT - o.pos.y), 500, 65432);
			stdout.printf ("Draw Rectangle !");
			screen.flip (); 
		}
		
		public static void draw_terrain (Terrain t)
		{
			int16[] vx = {
					0, 0, (int16) t.largeur, (int16) t.largeur
				};
			int16[] vy = {
					0, (int16) t.hg, 0, (int16) t.hd
				};
			Polygon.fill_color (screen, vx, vy, 0, 65432);
			screen.flip (); 
		}
		
		public static void draw_line (int x1, int y1, int x2, int y2)
		{
			Line.color (screen, (int16) x1, (int16) (SCREEN_HEIGHT - y1), (int16) x2, (int16) (SCREEN_HEIGHT - y2) , 65432);
			screen.flip ();
		}

		private static void process_events () {
			Event event = Event ();
			while (Event.poll (event) == 1) {
				switch (event.type) {
					case EventType.QUIT:
						done = true;
						break;
					case EventType.KEYDOWN:
						on_keyboard_event (event.key);
						break;
				}
			}
		}

		private static void on_keyboard_event (KeyboardEvent event) {
			done = true;
		}

		private static bool is_alt_enter (Key key) {
			return ((key.mod & KeyModifier.LALT)!=0)
					&& (key.sym == KeySymbol.RETURN
					|| key.sym == KeySymbol.KP_ENTER);
		}
	}
}

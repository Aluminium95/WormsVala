using GLib;
using SDL; // Écran
using SDLGraphics; // Géométrie
using SDLImage; // Images

namespace Jeu
{
	/**
	 * Gestion de l'affichage de tous les objets possibles du jeu
	 * menu y compris ! Fonctionne par délégate !
	 */
	public class Aff : Object {
	
		/**
		 * Largeur et Hauteur de l'écran
		 */
		public const int SCREEN_WIDTH = 800;
		public const int SCREEN_HEIGHT = 400;
		
		private const int SCREEN_BPP = 32;

		// L'écran lui-même
		private unowned SDL.Screen screen; 
		
		// La surface de fond d'écran
		private SDL.Surface surf;
		
		// Le générateur de nombre aléatoires
		private GLib.Rand rand;
		
		/**
		 * Délégates pour connection aux signaux
		 */
		public delegate void drawLine (int x1, int y1, int x2, int y2);
		public delegate void drawObjet (Objet o);
		public delegate void drawTerrain (Terrain t);
		public delegate void drawBouton (Menu.Bouton b);
		
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
		 * Efface l'écran
		 */
		public void clearscr ()
		{
			screen.fill (null,5468);
		}
		
		/**
		 * Raffraichit l'écran
		 */
		public void affiche () 
		{
				screen.flip ();
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
			o.s.blit (null, screen, SDL.Rect () { x = (int16) (o.pos.x - o.r), y = (int16)(SCREEN_HEIGHT - o.pos.y - 2 * o.r), w = (int16) (2 * o.r), h = (int16) (2 * o.r) });
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
			// Line.color (screen, (int16) (t.start + t.largeur), 0, (int16) (t.start + t.largeur), (int16) SCREEN_HEIGHT, 0xFFFFFFF);
		}
		
		/**
		 * Dessine une ligne 
		 */
		public void draw_line (int x1, int y1, int x2, int y2)
		{
			Line.color (screen, (int16) x1, (int16) (SCREEN_HEIGHT - y1), (int16) x2, (int16) (SCREEN_HEIGHT - y2) , 0xFFFFFFF);
		}
		
		/**
		 * Dessine un bouton
		 */
		public void draw_bouton (Menu.Bouton b)
		{
			b.s.blit (null, screen, SDL.Rect () { x = b.x, y = b.y, w = 150, h = 80});
		}
	}
}

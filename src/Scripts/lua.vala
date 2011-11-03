using Lua;
using GLib;

namespace Jeu 
{
	/**
	 * Classe qui gère les scripts
	 */
	public class Scripts : Object
	{
		
		public static LuaVM vm;
		
		public static unowned Gerant g;
		public static unowned Menu.Menu m;
		
		private const string scripts_levels = Config.DATA + "/Levels";
		
		private const string scripts_terrains = Config.DATA + "/Terrains";
		
		private const string scripts_IA = Config.DATA + "/IA";
		
		private const string scripts_menu = Config.DATA + "/Menu";
		
		public delegate void d_load (string uri);
		
		public Scripts (ref Gerant ger, ref Menu.Menu men)
		{
			this.g = ger;
			this.m = men;
			
			this.vm = new LuaVM ();
			vm.open_libs ();
			
			// Gère le scan des dossiers !
			vm.do_file (Config.DATA + "/LuaLibs/scan.lua");
			
			
			/** 
		 	 * Crée un terrain
		 	 */
			vm.register ("terrain", ajoute_terrain);
			
			/**
			 * Crée une IA
			 */
			vm.register ("ia", ajoute_ia);
			
			/**
			 * Crée un joueur
			 */
			vm.register ("joueur", ajoute_joueur);
			
			/**
			 * Crée un bouton
			 */
			vm.register ("bouton", ajoute_bouton);
			
			vm.push_number (Jeu.Aff.SCREEN_WIDTH);
			vm.set_global ("screen_w");
			
			vm.push_number (Jeu.Aff.SCREEN_HEIGHT);
			vm.set_global ("screen_h");
			
			vm.push_string (Config.DATA);
			vm.set_global ("data");
		}
		
		/**
		 * Charge le niveau numéro @lvl
		 */
		public void load_level (int lvl)
		{
			vm.do_file (scripts_levels + "/" + lvl.to_string () + ".lua");
		}
		
		/**
		 * Charge le menu avec le chemin @menu
		 */
		public void load (string uri)
		{
			vm.do_file (uri);
		}
		
		/**
		 * Éxécute le code passé en string 
		 */
		public void exec (string code)
		{
			vm.do_string (code);
		}
		
		public static int ajoute_terrain (LuaVM vmi)
		{
			var t = new Terrain (
				(int) vmi.to_number (1),
				(int) vmi.to_number (2),
				(int) vmi.to_number (3));
			
			g.ajouter_terrain (t);
			#if DEBUG
				stdout.printf ("Ajoute un terrain ! (%f,%f,%f)\n", 
					vmi.to_number (1),
					vmi.to_number (2),
					vmi.to_number (3));
			#endif
			return 1;
		}
		
		public static int ajoute_joueur (LuaVM vmi)
		{
			int x = (int) vmi.to_number (1);
			int vie = (int) vmi.to_number (2);
			string nom = vmi.to_string (3);
			var j = new Player (x, g.get_terrain_pos (x), vie, nom);
			g.ajouter_joueur (j);
			#if DEBUG
				stdout.printf ("Ajoute un joueur !(%d,%d,%s)\n",x,vie,nom);
			#endif
			return 1;
		}
		
		public static int ajoute_bouton (LuaVM vmi)
		{
			Menu.ActionMenu a = Menu.ActionMenu.COMMENCER;
			switch (vmi.to_string (4))
			{
				case "QUITTER":
					a = Menu.ActionMenu.QUITTER;
					break;
				case "CONTINUER":
					a = Menu.ActionMenu.CONTINUER;
					break;							
			}
			var b = new Menu.Bouton (
				(int16) vmi.to_number (1), 
				(int16) vmi.to_number (2), 
				vmi.to_string (3), a);
			
			m.add_bouton (b);
			#if DEBUG
				stdout.printf ("Ajoute un bouton ! (%f,%f,%s,%s)\n", 
					vmi.to_number (1),
					vmi.to_number (2),
					vmi.to_string (3),
					vmi.to_string (4));
			#endif
			return 1;
		}
		
		public static int ajoute_ia (LuaVM vmi)
		{
			int x = (int) vmi.to_number (1);
			int vie = (int) vmi.to_number (2);
			string nom = vmi.to_string (3);
			var ia = new IA (x, g.get_terrain_pos (x), vie, nom);
			g.ajouter_IA (ia);
			#if DEBUG
				stdout.printf ("Ajoute une IA ! (%d, %d, %s)\n", x, vie, nom);
			#endif
			return 1;
		}
	}
}

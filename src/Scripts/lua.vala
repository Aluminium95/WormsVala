using Lua;
using GLib;
// using Gio;

namespace Jeu 
{
	/**
	 * Classe qui gère les scripts
	 */
	public class Scripts : Object
	{
		public static unowned Gerant g;
		
		public LuaVM vm;
		
		private const string scripts_levels = Config.DATA + "/Levels";
		
		private const string scripts_terrains = Config.DATA + "/Terrains";
		
		private const string scripts_IA = Config.DATA + "/IA";
		
		public Scripts (ref Gerant ger)
		{
			this.g = ger;
			this.vm = new LuaVM ();
			vm.open_libs ();
			vm.register ("addTerrain", ajoute_terrain);
			vm.register ("addIA", ajoute_IA);
			vm.register ("addJoueur", ajoute_joueur);
		}
		
		/**
		 * Charge le niveau numéro @lvl
		 */
		public void load_level (int lvl)
		{
			vm.do_file (scripts_levels + "/" + lvl.to_string () + ".lua");
		}
		
		/**
		 * Éxécute le code passé en string 
		 */
		public void exec (string code)
		{
			vm.do_string (code);
		}
		
		/**
		 * Callback pour la fonction lua `addTerrain`
		 */
		[CCode (instance_pos = -1)]
		public static int ajoute_terrain (LuaVM vmi)
		{
			var t = new Terrain ((int)vmi.to_number (1), (int)vmi.to_number (2), (int)vmi.to_number (3));
			g.ajouter_terrain (t);
			#if DEBUG
				stdout.printf ("Ajoute un terrain ! (%f,%f,%f)\n", vmi.to_number (1), vmi.to_number (2), vmi.to_number (3));
			#endif
			return 1;
		}
		
		/**
		 * Callback pour la fonction lua `addIA`
		 */
		[CCode (instance_pos = -1)]
		public static int ajoute_IA (LuaVM vmi)
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
		
		/**
		 * Callback pour la fonction lua `addJoueur`
		 */
		[CCode (instance_pos = -1)]
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
	}
}

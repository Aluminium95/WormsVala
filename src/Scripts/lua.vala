using Lua;

namespace Jeu 
{
	/**
	 * Classe qui gère les scripts
	 */
	public class Scripts : Object
	{
		public static unowned Gerant g;
		
		public static LuaVM vm;
		
		public Scripts (Gerant g)
		{
			this.g = g;
			this.vm = new LuaVM ();
			vm.open_libs ();
			vm.register ("addTerrain", ajoute_terrain);
		}
		
		public static void read_directory ()
		{
		
		}
		
		public static void init (Gerant ger)
		{
			g = ger;
			vm = new LuaVM ();
			vm.open_libs ();
			vm.register ("addTerrain", ajoute_terrain);
		}
		
		public static void exec (string code)
		{
			vm.do_string (code);
		}
		
		public static int ajoute_terrain ()
		{
			g.ajouter_terrain ((int)vm.to_number (1), (int)vm.to_number (2), (int)vm.to_number (3));
			return 1;
		}
	}
}

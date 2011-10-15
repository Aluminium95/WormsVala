using GLib;
using SDL;

namespace Jeu
{
	namespace Menu
	{
		/**
		 * Menu du jeu 
		 * 		- Début de partie ( commencer/reprendre )
		 * 		- Milieu de partie ( quitter/commencer/reprendre )
		 * 		- Fin de partie ( quitter/recommencer )
		 */
		public class Menu : Object 
		{
			public MenuAffiche menu;
			
			/**
			 * Constructeur
			 */
			public Menu ()
			{
				menu = MenuAffiche.START; // Premier menu !
			}
		}
		
		/**
		 * Énnumération des différents menus possibles 
		 */
		public enum MenuAffiche 
		{
			START, RUNNING, LEVEL, END
		}
	}
}

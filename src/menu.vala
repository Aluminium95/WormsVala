using GLib;
using SDL;
using Gee;

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
			public MenuAffiche menu {get;private set;}
			private HashSet<Bouton> boutons; // Boutons du menu
			
			/**
			 * Constructeur
			 */
			public Menu ()
			{
				menu = MenuAffiche.START; // Premier menu !
				boutouns = new HashSet<Bouton> ();
			}
			
			/**
			 * Un clic sur la position (@x,@y)
			 */
			public void clic (int x, int y)
			{
				
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

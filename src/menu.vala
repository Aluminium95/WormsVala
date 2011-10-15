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
		public class Menu : Object 
		{
			public MenuAffiche menu {get;private set;}
			private HashSet<Bouton> boutons; // Boutons du menu
			
			public signal void needDrawBouton (Bouton b);
			
			public signal void actionMenu (ActionMenu a); 
			
			/**
			 * Constructeur
			 */
			public Menu ()
			{
				menu = MenuAffiche.START; // Premier menu !
				boutons = new HashSet<Bouton> ();
				creer_menu_start ();
			}
			
			/**
			 * Execute un cycle ( affiche les boutons )
			 */
			public void execute ()
			{
				foreach (var b in boutons)
				{
					needDrawBouton (b);
				}
			}
			
			/**
			 * Un clic sur la position (@x,@y)
			 */
			public void clic (int x, int y)
			{
				foreach (var b in boutons)
				{
					if ( (b.x < x < b.x2 ) && (b.y < y < b.y2 ) )
					{
						actionMenu (b.action);
						break;
					}
				}
			}
			
			/**
			 * Crée les boutons du menu `Start` 
			 */
			public void creer_menu_start ()
			{
				this.boutons.clear ();
				this.boutons.add (new Bouton (20, 20, 150, 60, "Quitter ?", ActionMenu.QUITTER));
				this.boutons.add (new Bouton (150, 60, 300, 120, "(Re)Commencer", ActionMenu.COMMENCER));
				this.boutons.add (new Bouton (300, 200, 350, 400, "Reprendre", ActionMenu.CONTINUER));
			}
			
			/**
			 * Crée les boutons du menu `Running`
			 */
			public void creer_menu_running ()
			{
				this.boutons.clear ();
			}
		}
		
		/**
		 * Énnumération des différents menus possibles 
		 */
		public enum MenuAffiche 
		{
			START, RUNNING, LEVEL, END
		}
		
		public enum ActionMenu 
		{
			COMMENCER, CONTINUER, QUITTER
		}
	}
}

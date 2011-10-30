using GLib;
using SDL;
using Gee;
using Lua;

namespace Jeu
{
	// Tous les objets relatifs au menu sont dans ce namespace
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
			protected MenuAffiche _menu;
			
			/**
			 * Menu à afficher
			 */
			public MenuAffiche menu {
				get {
					return _menu;
				}
				set {
					_menu = value;
					update_menu ();
				}
			}
			
			/**
			 * Uri du menu à afficher
			 */
			public string uri {get;protected set;}
			
			protected HashSet<Bouton> boutons; // Boutons du menu actuel
			
			/**
			 * Signaux importants du menu
			 */
			public signal void needDrawBouton (Bouton b);
			// public signal void need_add_info (ref Info i);
			public signal void actionMenu (ActionMenu a);
			// public signal void need_play_clic (); // Pas encore connecté
			public signal void need_load_menu (string uri);
			
			/**
			 * Constructeur
			 */
			public Menu ()
			{
				boutons = new HashSet<Bouton> ();
			}
			
			/**
			 * Execute Affiche les boutons
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
			
			protected void update_menu ()
			{
				this.boutons.clear ();
				switch (menu) {
					case MenuAffiche.START:
						this.uri = Config.DATA + "/Menu/start.lua";
						break;
					case MenuAffiche.RUNNING:
						this.uri = Config.DATA + "/Menu/run.lua";
						break;
					case MenuAffiche.LEVEL:
						this.uri = Config.DATA + "/Menu/level.lua";
						break;
					case MenuAffiche.END:
						this.uri = Config.DATA + "/Menu/end.lua";
						break;
				}
				need_load_menu (this.uri);
			}
			
			public void add_bouton (Bouton b)
			{
				this.boutons.add (b);
			}
		}
		
		/**
		 * Énnumération des différents menus possibles 
		 */
		public enum MenuAffiche 
		{
			START, RUNNING, LEVEL, END
		}
		
		/**
		 * Actions du menu 
		 */
		public enum ActionMenu 
		{
			COMMENCER, CONTINUER, QUITTER
		}
	}
}

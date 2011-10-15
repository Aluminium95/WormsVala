using GLib;
using SDL;

namespace Jeu
{
	namespace Menu 
	{
		/**
		 * Classe qui gère un bouton dans le menu
		 * On pourrait juste faire une structure !!!!
		 */
		public class Bouton : Object
		{
			// Point Haut Gauche
			public int16 x { get; private set; }
			public int16 y { get; private set; }
			// Point Bas Droite
			public int16 x2 { get; private set; }
			public int16 y2 { get; private set; }
			
			// Texte du bouton
			public string text { get; private set; }
			
			public ActionMenu action { get; private set; }
			
			/**
			 * Constructeur
			 */
			public Bouton (int16 x, int16 y, int16 x2, int16 y2, string text, ActionMenu a)
			{
				this.x = x;
				this.y = y;
				this.x2 = x2;
				this.y2 = y2;
				this.text = text;
				this.action = a;
			}
		}
	}
}

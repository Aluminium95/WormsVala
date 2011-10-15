using GLib;
using SDL;

namespace Jeu
{
	namespace Menu 
	{
		/**
		 * Classe qui gère un bouton dans le menu
		 */
		public class Bouton : Object
		{
			// Point Haut Gauche
			public int x { get; private set; }
			public int y { get; private set; }
			// Point Bas Droite
			public int x2 { get; private set; }
			public int y2 { get; private set; }
			
			// Texte du bouton
			public string text { get; private set; }
			
			/**
			 * Constructeur
			 */
			public Bouton (int x, int y, int x1, int y1, string text)
			{
				this.x = x;
				this.y = y;
				this.x1 = x1;
				this.y1 = y1;
				this.text = text;
			}
		}
	}
}

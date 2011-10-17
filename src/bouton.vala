using GLib;
using SDL;
using SDLImage;

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
			
			public Surface s;
			
			/**
			 * Constructeur
			 */
			public Bouton (int16 x, int16 y, string file, ActionMenu a)
			{
				this.x = x;
				this.y = y;
				this.x2 = x + 150;
				this.y2 = y + 80;
				this.text = text;
				this.action = a;
				
				this.s = SDLImage.load (file);
				if (this.s == null)
				{
					stderr.printf ("Erreur chargement img !!! "+file+"\n");
				}
			}
		}
	}
}

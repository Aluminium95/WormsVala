using GLib;
using SDL;

namespace Jeu
{
	/**
	 * Représente un joueur 
	 */
	public class Player : Personnage
	{
		/**
		 * Pour l'instant les attributs sont en public
		 */
		public KeySymbol left;
		public KeySymbol right;
		public KeySymbol up;
		
		/**
		 * Construit un player 
		 */
		public Player (int x, Terrain t, int vie, string name)
		{
			base ( x, t, vie); // Chaine vers Personnage
			
			this.name = name; // Définit le nom
			
			this.baseURI = Config.SPRITES + "/Personnages/Joueur/default/SDegats/";
			
			this.s = SDLImage.load (baseURI + "droite.png");
			
			/**
			 * Définition des touches par défaut 
			 */
			left = KeySymbol.e;
			right = KeySymbol.t;
			up = KeySymbol.k;
		}
		
		/**
		 * Fait réagir le personnage à l'appui de la 
		 * touche @k 
		 * @return false si la touche ne fait rien au personnage
		 */
		public bool computeKey (KeySymbol k)
		{
			if ( k == this.left)
			{
				this.velx -= 0.7f;
			} else if ( k == this.right ) {
				this.velx += 0.7f;
			} else if ( k == this.up ) {
				if ( this.m == Mouvement.MARCHE )
				{
					this.vely = 500;
					this.m = Mouvement.SAUT;
				}
			} else {
				return false;
			}
			
			return true;
		}
	}
}

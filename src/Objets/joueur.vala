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
		 * ce sont les touches utilisées pour se déplacer
		 */
		public KeySymbol left;
		public KeySymbol right;
		public KeySymbol up;
		public KeySymbol hit;
		
		/**
		 * Construit un player 
		 */
		public Player (int x, Terrain t, int vie, string name)
		{
			base ( x, t, vie); // Chaine vers Personnage
			
			this.name = name; // Définit le nom
			
			this.baseURI += "/Joueur/default/";
			
			this.s = SDLImage.load (baseURI + "SDegats.png");
			this.surface = SDLImage.load (baseURI + "SDegats.png");
			
			/**
			 * Définition des touches par défaut 
			 */
			left = KeySymbol.e;
			right = KeySymbol.t;
			up = KeySymbol.k;
			hit = KeySymbol.h;
		}
		
		/**
		 * Fait réagir le personnage à l'appui de la 
		 * touche @k 
		 * @return false si la touche ne fait rien au personnage
		 */
		public bool compute_key (KeySymbol k)
		{
			if ( this.m == Mouvement.MARCHE )
			{
				if ( k == this.left )
				{
					this.velx -= 0.7f;
				} else if ( k == this.right ) {
					this.velx += 0.7f;
				} else if ( k == this.up ) {
					if ( this.m == Mouvement.MARCHE )
					{
						this.vely = 10;
						this.m = Mouvement.SAUT;
					}
				} else if ( k == this.hit ) {
					this.frapper ();
				} else {
					return false;
				}
			} else if ( this.m == Mouvement.SAUT ) {
				if ( k == this.left && this.virementEnAir == false) 
				{
					this.velx -= 5;
					virementEnAir = true;
				} else if ( k == this.right && this.virementEnAir == false) {
					this.velx += 5;
					virementEnAir = true;
				}
			}
			
			return true;
		}
	}
}

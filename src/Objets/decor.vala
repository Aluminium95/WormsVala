using GLib;
using SDL;
using SDLImage;

namespace Jeu
{
	/**
	 * Classe qui gère un décor du jeu
	 */
	public class Decor : Objet
	{
		public Decor (int x, Terrain t)
		{
			base (x,t);
			this.baseURI = Config.SPRITES + "/Decor/default/";
		}
		
		/**
		 * Surcharge de la fonction modifier vie
		 * pour gérer la modification du sprite du décor 
		 * en fonction de ses dégats !
		 */
		public override void modifierVie (int v)
		{
			base.modifierVie (v);
			if (this.sens == true )
			{
				if ( 0 < vie < 2 )
				{
					setSprite (baseURI + "sdegats.png");
				} else if ( 0 < vie < 6 ) {
					setSprite (baseURI + "mdegats.png");
				} else {
					setSprite (baseURI + "ndegats.png");
				}
			} else {
				/**
				 * Gérer le changement de dossier
				 */
			}
		}
	}
}

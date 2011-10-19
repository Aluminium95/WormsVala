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
			this.baseURI = Config.SPRITES + "/Decor/";
		}
		
		/**
		 * Surcharge de la fonction modifier vie
		 * pour gérer la modification du sprite du décor 
		 * en fonction de ses dégats !
		 */
		public override void modifierVie (int v)
		{
			base.modifierVie (v);
			
			if ( 0 < vie < 2 )
			{
				setSprite (baseURI + "Sdammage.png");
			} else if ( 0 < vie < 6 ) {
				setSprite (baseURI + "Mdammage.png");
			} else {
				setSprite (baseURI + "Ndammage.png");
			}
		}
	}
}

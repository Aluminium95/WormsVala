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
		// L'objet a un sens ( droite/gauche )
		private bool sens;
		
		/**
		 * Constructeur
		 */
		public Decor (int x, Terrain t)
		{
			base (x,t);
			this.baseURI = Config.SPRITES + "/Decor/default/";
			sens = false;
		}
		
		/**
		 * Surcharge de la fonction modifier vie
		 * pour gérer la modification du sprite du décor 
		 * en fonction de ses dégats !
		 */
		public override void modifierVie (int v)
		{
			base.modifierVie (v);
			if (this.sens == false )
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

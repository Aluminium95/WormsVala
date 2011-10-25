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
		public override void modifier_vie (int v)
		{
			base.modifier_vie (v);
			if (this.sens == false )
			{
				if ( 0 < vie < 2 )
				{
					set_sprite (baseURI + "sdegats.png");
				} else if ( 0 < vie < 6 ) {
					set_sprite (baseURI + "mdegats.png");
				} else {
					set_sprite (baseURI + "ndegats.png");
				}
			} else {
				/**
				 * Gérer le changement de dossier
				 */
			}
		}
		
		/**
		 * Quand une collision se produit
		 */
		public override void on_collision (ref Objet o)
		{
			// Code en fonction du type d'objet
		}
		
		/**
		 * Quand on utilise la touche action sur cet objet
		 */
		public override void on_action (ref Objet o)
		{
			// Code en fonction du type d'objet
		}
	}
}

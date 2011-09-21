using GLib;

namespace Jeu
{
	/*
	 * Un personnage !
	 */
	public abstract class Personnage : Objet
	{
		
		protected Mouvement m; // Mouvement effectué
		protected Strategie s; // Stratégie
		
		public Arme armeActuelle { get; protected set; } // Arme en main
		
		protected Arme armePrincipale; // Arme principale de l'IA
		protected Arme armeSecondaire; // Arme secondaire de l'IA
		
		public Personnage (int x, Terrain t, int vie = 50)
		{
			base (x,t,vie);
		}
		
		/*
		 * Change l'arme
		 */
		protected void changerArme ()
		{
			this.armeActuelle = ( this.armeActuelle == this.armePrincipale ) ? this.armeSecondaire : this.armePrincipale;
		}
		
		/*
		 * Échange l'arme actuelle avec une autre proposée 
		 */
		public void echangerArme (Arme a)
		{
			if ( this.armeActuelle == this.armePrincipale )
			{
				this.armePrincipale = a;
			} else {
				this.armeSecondaire = a;
			}
		}
		
		/*
		 * Frappe !
		 */
		public signal void frapper ();
		
		public signal void tirer (); // Tire un PROJECTILE !!
		
		/*
		 * Utilise l'arme pour envoyer un projectile 
		 * dans la direction de l'objet
		 */
		protected void attaquerDistance (Objet o)
		{
			
		}
	}
}

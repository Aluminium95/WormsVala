using GLib;

namespace Jeu
{
	/**
	 * Un personnage ! ( Abstrait )
	 */
	public abstract class Personnage : Objet
	{
		public Arme armeActuelle { get; protected set; } // Arme en main
		
		protected Arme armePrincipale; // Arme principale de l'IA
		protected Arme armeSecondaire; // Arme secondaire de l'IA

		protected TuplePos vecteurRegard; // Vecteur du regard

		/**
		 * Très mauvais … mais bon c'est pour tester !
		 */
		public Personnage (int x, Terrain t, int vie = 50)
		{
			base (x,t,vie);

			this.armePrincipale = new Arme (20);
			this.armeSecondaire = new Arme (10);

			this.armeActuelle = armePrincipale;
			
			this.masse = 50;
			
			this.baseURI = Config.SPRITES + "/Personnages";
		}
		
		/**
		 * Change l'arme
		 */
		protected virtual void changerArme ()
		{
			this.armeActuelle = ( this.armeActuelle == this.armePrincipale ) ? this.armeSecondaire : this.armePrincipale;
		}
		
		/**
		 * Échange l'arme actuelle avec une autre proposée 
		 */
		public virtual void echangerArme (Arme a)
		{
			if ( this.armeActuelle == this.armePrincipale )
			{
				this.armePrincipale = a;
			} else {
				this.armeSecondaire = a;
			}
		}
		
		/**
		 * Frappe !
		 */
		public signal void frapper ();
		
		public signal void tirer (TuplePos vecteurInitial); // Tire un PROJECTILE avec le vecteur initial
		
		/**
		 * Utilise l'arme pour envoyer un projectile 
		 * dans la direction de l'objet
		 */
		protected virtual void attaquerDistance ()
		{
			if ( armeActuelle.utiliser () == true )
			{
				/*
				 * Calcul du vecteur initial en fonction du tuplePos regard 
				 */
				tirer (vecteurRegard);
			}
		}
		
		/**
		 * Surcharge de la fonction calcVel
		 */
		public override void calcVel ()
		{
			definirSprite ();
			base.calcVel ();
		}
		
		/**
		 * Recalcule le sprite
		 */
		protected virtual void definirSprite () {
			if ( this.velx < -1 ) {
				setSprite (baseURI + "gauche.png");
			} else if ( this.velx > 1 ) {
				setSprite (baseURI + "droite.png");
			}
		}
	}
}

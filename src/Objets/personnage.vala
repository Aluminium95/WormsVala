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
		protected virtual void changer_arme ()
		{
			this.armeActuelle = ( this.armeActuelle == this.armePrincipale ) ? this.armeSecondaire : this.armePrincipale;
		}
		
		/**
		 * Échange l'arme actuelle avec une autre proposée 
		 */
		public virtual void echanger_arme (Arme a)
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
		
		// Tire un PROJECTILE avec le vecteur initial
		public signal void tirer (TuplePos vecteurInitial);
		
		/**
		 * Utilise l'arme pour envoyer un projectile 
		 * dans la direction de l'objet
		 */
		protected virtual void attaquer_distance ()
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
		 * Surcharge de la fonction calc_vel
		 */
		public override void calc_vel ()
		{
			definir_sprite ();
			base.calc_vel ();
		}
		
		/**
		 * Recalcule le sprite
		 */
		protected virtual void definir_sprite () {
			if ( this.velx < -1 ) {
				this.angle = -180 ;
			} else if ( this.velx > 1 ) {
				this.angle = 180;
			}
		}
	}
}

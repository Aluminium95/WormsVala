using GLib;

namespace Jeu
{
	/**
	 * IA Simple
	 */
	public class IA : Personnage
	{
		public IA (int x, Terrain t, int vie, string name)
		{
			base ( x, t, vie);
			this.s = Strategie.CAC;
			this.name = name;
		}
		
		/**
		 * Execute un cycle : fait une action longue
		 * Le problème est que l'on devrait plutôt faire un truc
		 * différent !
		 */
		public int execute (Objet o) // Joueurs ou autre IA
		{
			int depl = 0;
			int d = (int)  (o.pos.x - this.pos.x)^2 + (o.pos.y - this.pos.y)^2 ;
			switch (this.s)
			{
				case Strategie.CAC: // Corps à Corps
					if ( d > 10)
					{
						depl = (o.pos.x - this.pos.x > 0 ) ? 1 : -1;
					} else {
						frapper ();
					}
					break;
				case Strategie.DISTANCE: // Distance
					ajusteVisee (o);
					if ( d < 10 )
					{
						depl = -1;
					} else {
						attaquerDistance ();
					}
					break;
				default:
					break;
			}
			return depl;
		}
		
		/**
		 * Échange l'arme actuelle avec une autre proposée 
		 */
		public new void echangerArme (Arme a)
		{
			if ( this.armeActuelle == this.armePrincipale )
			{
				this.armePrincipale = a;
			} else {
				this.armeSecondaire = a;
			}
			
			checkStrategie (); // Vérifie que la stratégie correspond à l'arme
		}
		
		/**
		 * Change l'arme
		 */
		protected new void changerArme ()
		{
			this.armeActuelle = ( this.armeActuelle == this.armePrincipale ) ? this.armeSecondaire : this.armePrincipale;
			checkStrategie (); // Vérifie que la stratégie correspond à l'arme
		}
		
		/**
		 * Change de strategie
		 */
		public void reviseStrategie ()
		{
			this.s = (this.s == Strategie.DISTANCE) ? Strategie.CAC : Strategie.DISTANCE;
		}
		
		/**
		 * Vérifie si la strategie correspond bien
		 * au style de l'arme
		 */
		protected void checkStrategie ()
		{
			if ( this.armeActuelle.distance == true )
			{
				this.s = Strategie.DISTANCE;
			} else {
				this.s = Strategie.CAC;
			}
		}

		/**
		 * Ajuste le tir / la vision en fonction de l'objet !
		 */
		protected void ajusteVisee (Objet o)
		{
			/**
			 * Code d'ajustement de la visée
			 * en fonction de :
			 * 		- la force de l'arme
			 * 		- la gravité de l'arme // Arrgh courbe !
			 * 		- la position du personnage
			 */
		}
	}
}

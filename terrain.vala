using GLib;

namespace Jeu
{
	/*
	 * Terrain du jeu
	 */
	public class Terrain : Object
	{
		private bool pencheDroite; // penche à droite ? ( pour simplifier les calculs )
		
		public Objet[] objets; // Tableau des Objets
		
		public int i; // Position dans le tableau des terrains
		
		public int largeur { get; protected set; default = 0; } // Largeur du terrain
		
		public int hg { get; protected set; default = 0; } // Hauteur gauche du terrain
		
		public int hd { get; protected set; default = 0; } // Hauteur droite du terrain
		
		/*
		 * Crée le terrain
		 */
		public Terrain (int l, int d, int g)
		{
			this.largeur = l;
			this.hd = d;
			this.hg = g;
			
			this.pencheDroite = ( hg > hd ) ? true : false;
		}
		
		/*
		 * Retourne la hauteur du sol
		 */
		public int getSol ( int x )
		{
			if ( pencheDroite )
			{
				return (int) x * ( hg - hd ) / largeur + hd;
			} else {
				return (int) x * ( hd - hg ) / largeur + hg;
			}
		}
		
		/*
		 * Envoie un signal de changement de terrain
		 */
		public signal void changeTerrain (bool droite, Objet o);
		
		/*
		 * Signal de changement d'inclinaison ( terrains mouvants, on sait jamais )
		 */
		public signal void changeInclinaison ();
		
		/*
		 * Retire un objet du terrain
		 * !!! FAIRE UN THROW D'ERREUR !!!
		 */
		public void rmObjet (int positionTableau)
		{
			/*
			 * Code de retirage sécurisé
			 */
		}
		
		/*
		 * Ajoute un objet au terrain
		 */
		public void addObjet (Objet o)
		{
			/*
			 * Code d'ajout sécurisé 
			 */
		}
	}
}

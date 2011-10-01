using GLib;
using Gee;

namespace Jeu
{
	/*
	 * Terrain du jeu
	 */
	public class Terrain : Object
	{
		private bool pencheDroite; // penche à droite ? ( pour simplifier les calculs )
	
		public ArrayList<Objet> objets; // Tableau des Objets | on va peut-être passer à un Set 
		
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
		 * Ceci n'est normalement pas nécessaire !
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
			objets.remove_at (positionTableau);
		}
		
		/*
		 * Ajoute un objet au terrain
		 */
		public void addObjet (Objet o)
		{
			/*
			 * Code d'ajout sécurisé 
			 */
			objets.add (o);
			o.i = objets.index_of (o);
		}
		
		/*
		 * Execute les IA & Objets dans le terrain
		 */
		public void execute ()
		{
			foreach ( var i in objets )
			{
				if (IA ia = (IA) i) // Cast en IA
				{
					ia.execute ();
				}
			}
		}
	}
}

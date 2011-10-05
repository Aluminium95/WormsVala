using GLib;
using Gee;

namespace Jeu
{
	/*
	 * Terrain du jeu 
	 * 		Implémente la gestion des collisions !!!!!!!!!
	 */
	public class Terrain : Object
	{
		public bool pencheDroite { get; protected set; } // penche à droite ? ( pour simplifier les calculs )
	
		public HashSet<Objet> objets; // Tableau des Objets | on va peut-être passer à un Set 
		
		public int i; // Position dans le tableau des terrains
		
		public int start; // Position de départ du terrain 
		
		public int largeur { get; protected set; default = 0; } // Largeur du terrain
		
		public int hg { get; protected set; default = 0; } // Hauteur gauche du terrain
		
		public int hd { get; protected set; default = 0; } // Hauteur droite du terrain
		
		/*
		 * Crée le terrain
		 */
		public Terrain (int l, int g, int d)
		{
			this.largeur = l;
			this.hd = d;
			this.hg = g;
			
			this.pencheDroite = ( hg > hd ) ? true : false;
			stdout.printf (pencheDroite.to_string ());

			this.objets = new HashSet<Objet> (); // initialisation du tableau
		}
		
		/*
		 * Retourne la hauteur du sol
		 * 		Prendre en compte la « superposition d'objets » !!!!
		 * 		Faire une gestion des collisions !
		 */
		public int getSol ( int x )
		{
			if ( pencheDroite )
			{
				// return (int) x * ( hg - hd ) / largeur + hd;
				return (int) (x * ( hg - hd ) / largeur + hg);
			} else {
				return (int) (x * ( hd - hg ) / largeur + hg);
			}
		}
		
		public int getH ( int x )
		{
			if ( pencheDroite )
			{
				return (int) ( hg - hd ) * x / largeur; 
			} else {
				return (int) ( hd - hg ) * x / largeur; 
			}
		}
		
		/*
		 * Signal de changement d'inclinaison ( terrains mouvants, on sait jamais )
		 * Ceci n'est normalement pas nécessaire !
		 */
		public signal void changeInclinaison ();
		
		/*
		 * Retire un objet du terrain
		 * !!! FAIRE UN THROW D'ERREUR !!!
		 */
		public void rmObjet (Objet o)
		{
			/*
			 * Code de retirage sécurisé
			 */
			objets.remove (o);
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
			o.t = this;
		}
	}
}

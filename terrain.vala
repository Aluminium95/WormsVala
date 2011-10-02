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
		public bool pencheDroite { get; private set; } // penche à droite ? ( pour simplifier les calculs )
	
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

			this.objets = new ArrayList<Objet> (); // initialisation du tableau
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
				return (int) x * ( hg - hd ) / largeur + hd;
			} else {
				return (int) x * ( hd - hg ) / largeur + hg;
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
			stdout.printf ("exec !\n");
			foreach ( var o in objets )
			{
				Jeu.Aff.draw_objet (o);
			}
		}
	}
}

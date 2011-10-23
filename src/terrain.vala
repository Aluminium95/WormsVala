using GLib;
using Gee;

namespace Jeu
{
	/**
	 * Terrain du jeu 
	 * 		Implémente la gestion des collisions !!!!!!!!!
	 */
	public class Terrain : Object
	{
		// Tableau des Objets | on va peut-être passer à un Set 
		public HashSet<Objet> objets;
		
		// Position dans le tableau des terrains
		public int i;
		
		/**
		 * Position de départ du terrain par rapport au 
		 * début de l'écran
		 */
		public int start;
		
		// Largeur du terrain
		public int largeur { get; protected set;}
		
		// Hauteur gauche du terrain
		public int hg { get; protected set;}
		
		// Hauteur droite du terrain
		public int hd { get; protected set;}
		
		// Acceleration X du terrain
		public float accelx { get; protected set; }
		
		// Adhérence du terrain
		public float collage { get; protected set; } 
		
		/**
		 * Crée le terrain
		 */
		public Terrain (int l, int g, int d)
		{
			this.largeur = l;
			this.hd = d;
			this.hg = g;
			
			this.accelx = ( hg - hd ) / largeur;
			
			this.collage = 0.5f;
			
			this.objets = new HashSet<Objet> (); // initialisation du tableau
		}
		
		/**
		 * Retourne la hauteur du sol
		 * 		Prendre en compte la « superposition d'objets » !!!!
		 * 		Faire une gestion des collisions !
		 */
		public float getSol ( float x )
		{
			return (x - this.start) * ( hd - hg ) / largeur + hg;
		}
		
		/**
		 * Retourne la hauteur dans le triangle du terrain
		 */
		public int getH ( int x )
		{
			return (int) ( hd - hg ) * x / largeur; 
		}
		
		/**
		 * Signal de changement d'inclinaison ( terrains mouvants, on sait jamais )
		 * Ceci n'est normalement pas nécessaire !
		 */
		public signal void changeInclinaison ();
		
		/**
		 * Retire un objet du terrain
		 * !!! FAIRE UN THROW D'ERREUR !!!
		 */
		public void rmObjet (Objet o)
		{
			/**
			 * Code de retirage sécurisé
			 */
			objets.remove (o);
		}
		
		/**
		 * Ajoute un objet au terrain
		 */
		public void addObjet (Objet o)
		{
			/**
			 * Code d'ajout sécurisé 
			 */
			objets.add (o);
			o.t = this; // On change la référence du terrain dans l'objet
		}
	}
}

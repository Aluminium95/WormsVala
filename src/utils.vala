using GLib;
using SDL;

namespace Jeu
{
	/**
	 * Orientation d'un objet
	 */
	public enum Orientation
	{
		DROITE, GAUCHE, HAUT, BAS
	}
	
	/**
	 * Mouvement en train d'être effectué
	 * par un objet
	 */
	public enum Mouvement
	{
		SAUT, MARCHE, VOLE
	}
	
	/**
	 * Stratégie utilisée par l'ia
	 */
	public enum Strategie
	{
		DISTANCE, CAC // CAC = Corps À Corps
	}
	
	/**
	 * Gestion des positions ( tuples )
	 * Mais aussi de tous les trucs qui ont 2 coordonnées !
	 */
	public struct TuplePos 
	{
		float x;
		float y;
	}
	
	/**
	 * Pour définir les couleurs de la console 
	 * et que ce soit bien User-Friendly :D
	 */
	public enum CouleurConsole
	{
		NOIR = 30, ROUGE = 31, VERT = 32, JAUNE = 33,
		BLEU = 34, MAGENTA = 35, CYAN = 36, BLANC = 37
	}
	
	/**
	 * Affiche en couleur le texte passé
	 */
	public void print (string text, CouleurConsole color)
	{
		#if DEBUG 
			/* Définit la couleur ( commande spéciale console *nix ) */
			stderr.printf ("\033[%dm",color);
			stderr.printf (text);
			/* Reset la couleur à défault ( commande spéciale *nix ) */
			stderr.printf ("\033[0m"); 
		#else
			stdout.printf ("\033[%dm",color);
			stdout.printf (text);
			stdout.printf ("\033[0m");
		#endif
	}
	
	/**
	 * Gestion des puissances !
	 */
	public float pow (float x, int pow)
	{
		for (int i = 0; i < pow; i++)
		{
			x *= x;
		}
		return x;
	}
}

using GLib;

namespace Jeu
{
	/**
	 * Mouvement en train d'être effectué
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
		DISTANCE, CAC
	}
	
	/**
	 * Type d'objet ( utile pour les tableaux confondant tout ! ) 
	 * Euh, vu qu'on a une fonction « typeof » ça devrait être bon
	 */
	public enum Type
	{
		DECOR, ENNEMI, JOUEUR
	}
	
	/**
	 * Gestion des positions ( tuples )
	 */
	public struct TuplePos
	{
		int x;
		int y;
	}
	
	/**
	 * Pour définir les couleurs de la console 
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
			stderr.printf ("\033[%dm",color);
			stderr.printf (text);
			stderr.printf ("\033[0m");
		#else
			stdout.printf ("\033[%dm",color);
			stdout.printf (text);
			stdout.printf ("\033[0m");
		#endif
	}
}

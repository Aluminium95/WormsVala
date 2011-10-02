using GLib;

namespace Jeu
{
	/*
	 * Mouvement en train d'être effectué
	 */
	public enum Mouvement
	{
		SAUT, CHUTE, MARCHE, VOLE
	}
	
	/*
	 * Stratégie utilisée par l'ia
	 */
	public enum Strategie
	{
		DISTANCE, CAC
	}
	
	/*
	 * Type d'objet ( utile pour les tableaux confondant tout ! ) 
	 * Euh, vu qu'on a une fonction « typeof » ça devrait être bon
	 */
	public enum Type
	{
		DECOR, ENNEMI, JOUEUR
	}
	
	/*
	 * Gestion des positions ( tuples )
	 */
	public struct TuplePos
	{
		int x;
		int y;
	}
	
	namespace note
	{
		public const double E =  369.23;
		public const double A = 440;
		public const double D = 587.33;
		public const double G = 783.99;
		public const double B = 987.77;
	}
}

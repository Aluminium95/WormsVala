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
}

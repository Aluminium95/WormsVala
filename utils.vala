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
	 * Stratégie utilisée
	 */
	public enum Strategie
	{
		DISTANCE, CAC
	}
	
	/*
	 * Type d'objet ( utile pour les tableaux confondant tout ! )
	 */
	public enum Type
	{
		DECOR, ENNEMI, JOUEUR
	}
}

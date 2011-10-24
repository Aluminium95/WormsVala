using GLib;
using SDL;
using Gee;

namespace Jeu 
{
	/**
	 * Classe qui gère les infos 
	 * affichées à l'écran !
	 */
	public class GestionInfo : Object
	{	
		/**
		 * Tableau avec toutes les infos
		 */
		public ArrayList<Info?> infos;
		
		public delegate void dAddInfo (int x, int y, string text);
		
		/**
		 * Constructeur
		 */
		public Info (int x, int y)
		{
			infos = new ArrayList<Info?> ();
		}
		
		/**
		 * Ajoute une info à afficher 
		 */
		public void addInfo (int x, int y, string text)
		{
			infos.add(Info () {x = x, y = y, text = text});
		}
		
		/**
		 * Supprime une info à afficher
		 */
		public void delInfo (int x, int y, string text)
		{
			int i = 0;
			
			foreach (var i in infos)
			{
				if (i.x == x && i.y == y && i.text == text)
				{
					break;
				}
				i++;
			}
			infos.remove (i);
		}
	}
	
	/**
	 * Une info affichée à l'écran 
	 */
	public struct Info 
	{
		public int x;
		public int y;
		public string text;
	}
}

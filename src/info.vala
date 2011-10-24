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
		public ArrayList<Info> infos;
		
		public delegate void dAddInfo (Info i);
		
		/**
		 * Constructeur
		 */
		public GestionInfo (int x, int y)
		{
			infos = new ArrayList<Info?> ();
		}
		
		/**
		 * Ajoute une info à afficher 
		 */
		public void addInfo (ref Info i)
		{
			infos.add(i);
		}
		
		/**
		 * Supprime une info à afficher
		 */
		public void delInfo (ref Info i)
		{
			infos.remove (i);
		}
	}
	
	/**
	 * Une info affichée à l'écran 
	 */
	public class Info 
	{
		public int x {get; set;}
		public int y {get; set;}
		public string text {get; set;}

		public Info (int x, int y, string text, int time = 0)
		{
			this.x = x;
			this.y = y;
			this.text = text;
		}
	}
}

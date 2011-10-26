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
		
		public signal void need_draw_info (ref Info i);
		
		public delegate void d_add_info (Info i);
		
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
		public void add_info (ref Info i)
		{
			infos.add(i);
		}
		
		/**
		 * Supprime une info à afficher
		 */
		public void del_info (ref Info i)
		{
			infos.remove (i);
		}
		
		/**
		 * Demande l'affichage des infos
		 */
		public void aff_infos ()
		{
			foreach (var i in infos)
			{
				need_draw_info (ref i);
			}	
		}
	}
	
	/**
	 * Une info affichée à l'écran 
	 */
	public class Info 
	{
		public int16 x {get; set;}
		public int16 y {get; set;}
		public string text {get; set;}
		public int32 color {get; set;}

		public Info (int16 x, int16 y, string text, int32 color = 0xF2C46ECD3)
		{
			this.x = x;
			this.y = y;
			this.text = text;
			this.color = color;
		}
	}
}

using GLib;
using Gee;

namespace Jeu
{
	/**
	 * Fonction qui gère les collisions : c'est très moche !
	 */
	public void collision (Gerant g, Objet o, ref ArrayList<Terrain> t, int start)
	{
		/*
		 * Gestion des collisions 
		 */
		for (int i = 0; i < 3; i++)
		{
			foreach ( var ia in t[start].objets )
			{
				if ( o.i != ia.i ) // Pas lui même !
				{
					float x = o.pos.x - ia.pos.x;
					float y = o.pos.y - ia.pos.y;
					float d = x*x + y*y;
					
					if ( d < (o.r+ia.r)*(o.r+ia.r) )
					{
						// Play le son
						g.needPlayHit ();
						
						#if DEBUG 
							print ("\t\t\t Physique : Collision !\n", CouleurConsole.CYAN);
						#endif
						
						/** 
						 * Arf ça ne marche pas !
						 * Ou du moins ça fait n'importe quoi !
						 */
						if (ia.pos.x < o.pos.x)
						{
							o.move ((o.pos.x + o.r) - (ia.pos.x));
						} else {
							o.move ((o.pos.x - o.r) - (ia.pos.x));
						}
						
						// o.rebondiry (); // collisions en l'air …
					}
				}
			}
			start++;
		}
	}
}

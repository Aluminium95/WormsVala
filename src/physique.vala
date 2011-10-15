using GLib;
using Gee;

namespace Jeu
{
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
					
					if ( d <= (o.r+ia.r)*(o.r+ia.r) )
					{
						
						g.needPlayHit ();
						#if DEBUG 
							print ("\t\t\t Physique : Collision !\n", CouleurConsole.CYAN);
						#endif
						
						o.move (o.pos.x - ia.pos.x - o.r);
						o.rebondirx (); // Mauvais Manque des conditions
						ia.velx += o.velx;
						o.velx /= 2;
						// o.rebondiry (); // pour gérer les différentes réacs
					}
				}
			}
			start++;
		}
	}
}

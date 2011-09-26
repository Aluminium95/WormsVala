using GLib;

namespace Jeu
{
	/*
	 * Pour l'instant je crée 2 ia … et je les nomme !
	 * Il faut utiliser des tableaux et créer des tableaux de terrain 
	 * Il faut gérer les déplacements et les changements de terrain ! ( et donc attribution à une zone ).
	 */
	public class Gerant : Object
	{
		private IA[] e; // Tous les ennemis
		private Terrain t; // Terrain
		
		delegate void delegateJoueurFrappe (Personnage p);
		
		private void joueurFrappe (Personnage p)
		{
			foreach ( var pers in e )
			{
				int d = (int)  (pers.x - p.x)^2 + (pers.y - p.y)^2 ;
				if ( d <= 10)
				{
					pers.aie (10);
					stdout.printf ("AIE ! - 10 pv\n");
				}
			}
		}
		
		public Gerant ()
		{
			e = {};
			
			creerTerrain ();
			creerIA ();
		}
		
		private void creerIA ()
		{
			for(int i = 0; i < 2;i++)
			{
				e += new IA (20+10*i, t, 50,  i.to_string());
				
				e[i].dead.connect ( (e) =>
				{
					stdout.printf ("L'IA est morte !\n");
				});
				stdout.printf ("Instance d'ennemi ! "+ e[i].x.to_string () + "x : " + e[i].y.to_string () + "y\n" );
				e[i].moved.connect ( (e) =>
				{
					stdout.printf ("Ennemi "+e.name+"! "+ e.x.to_string () + "x : " + e.y.to_string () + "y\n" );
				});
				
				e[i].frapper.connect (joueurFrappe);
			}
		}
		
		private void creerTerrain ()
		{
			t = new Terrain (100, 10, 50);
		}
		
		private void creerJoueur ()
		{
			
		}
		
		/*
		 * Fait éxecuter un cycle aux IA :
		 * 		- Les fait choisir une action 
		 * 		- Les fait bouger :
		 * 			+ S'il ne sortent pas de l'écran
		 * 			+ Les fait changer de terrain | zone si nécessaire
		 */
		public void execute ()
		{
			int d;
			d = e[0].execute (e[1]);
			e[0].move (d);
			d = e[1].execute (e[0]);
			e[1].move (d);
		}
		
		/*
		 * Tue toutes les IA 
		 */
		public void kill ()
		{
			foreach ( var i in e )
			{
				i.mourrir ();
			}
		}
	}
}

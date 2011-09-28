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
		private Terrain[] listeTerrains; // Terrains
		
		delegate void delegateJoueurFrappe (Personnage p);
		delegate void delegateAssignerTerrain (Terrain t, bool d, Objet o);
		
		/*
		 * Delegate pour qu'un joueur frappe !
		 */
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
		
		/*
		 * Assigne l'objet à un terrain
		 * en fonction des positions de l'objet
		 */
		private void assignerTerrain (Terrain t, bool d, Objet o)
		{
			if ( d ) // Il faut rajoutter la limite de droite !
			{
				listeTerrains[t.i+1].addObjet (o);
			} else if ( t.i != 0 ) { // On ne va pas plus loin que 0 !
				listeTerrains[t.i-1].addObjet (o);
			}
			t.rmObjet (o.i); // Supression de l'objet dans le premier terrain
		}
		
		/*
		 * Assigne l'objet au terarin en fonction de la postion 
		 * de l'objet
		 */
		private void assignerTerrainPos (Objet o)
		{
			/*
			 * Teste tous les terrains pour savoir si l'objet rentre 
			 * dedans !
			 */
		}
		
		/*
		 * Crée le gérant 
		 */
		public Gerant ()
		{
			e = {};
			
			creerTerrain ();
			creerIA ();
		}
		
		/*
		 * Créer les IAs du jeu
		 */
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
		
		/*
		 * Crée les terrains du jeu
		 */
		private void creerTerrain ()
		{
			t = new Terrain (100, 10, 50);
		}
		
		/*
		 * Crée les jouers du jeu
		 */
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
			foreach ( var t in listeTerrains )
			{
				foreach ( var o in t.objets )
				{
					/* 
					 * Execute 
					 */
					 try 
					 {
						 IA ia = (IA) o;
						 ia.execute();
					 } catch ( Error e) {
						 
					 }
				}
			}
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

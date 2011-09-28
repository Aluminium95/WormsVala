using GLib;
using Gee;

namespace Jeu
{
	/*
	 * Pour l'instant je crée 2 ia … et je les nomme !
	 * Il faut utiliser des tableaux et créer des tableaux de terrain 
	 * Il faut gérer les déplacements et les changements de terrain ! ( et donc attribution à une zone ).
	 */
	public class Gerant : Object
	{
		private ArrayList<Terrain> listeTerrains; // Terrains
		
		delegate void delegateJoueurFrappe (Personnage p);
		delegate void delegateAssignerTerrain (Terrain t, bool d, Objet o);
		
		/*
		 * Delegate pour qu'un joueur frappe !
		 * Regarde dans tous les terrains autour de celui du
		 * personnage
		 */
		private void joueurFrappe (Personnage p)
		{
			int t = p.t.i - 1;
			
			for (int i = 0; i < 3; i++)
			{
				foreach ( var pers in listeTerrains[t].objets )
				{
					int d = (int)  (pers.x - p.x)^2 + (pers.y - p.y)^2 ;
					if ( d <= 10)
					{
						pers.aie (10);
						stdout.printf ("AIE ! - 10 pv\n");
					}
				}
				t++;
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
			listeTerrains = new ArrayList<Terrain> ();
			
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
				/*
				 * Créer les positions, valeurs de l'ia, 
				 * calculer le terrain
				 * Créer l'ia et l'ajouter au terrain
				 * Connecter les signaux de l'ia
				 */
			}
		}
		
		/*
		 * Crée les terrains du jeu
		 */
		private void creerTerrain ()
		{
			for (int i = 0; i < 10; i++)
			{
				listeTerrains.add(new Terrain (50, 20, 20));
			}
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
				t.execute (); // Demande au terrain d'executer 
			}
		}
		
		/*
		 * Tue toutes les IA 
		 */
		public void kill ()
		{
			foreach ( var t in listeTerrains )
			{
				foreach ( var i in t.objets )
				{
					i.mourrir ();
				}
			}
		}
	}
}

using GLib;
using SDL;
using SDLMixer;

namespace Jeu
{
	/**
	 * Classe pour gérer la musique de fond
	 * et les effets sonores supplémentaires 
	 * de façon simple et transparente
	 * Elle est très simple … et absolument pas OO,
	 * mais c'est à cause des bugs de SDLMixer … 
	 */
	public class Son : Object
	{
		public Music music; // Musique de fond
		
		/*
		private Channel[] chans; // Liste des cannaux 
		
		private Chunk[] sons; // Liste des sons
		*/
		
		public delegate void playSon ();
		
		public string hit; // Chemin vers hit
		public string bam; // Chemin vers bam
		
		public Chunk hitc;
		public Chunk bamc;
		
		public Channel chit;
		public Channel cbam;
		
		public Son ()
		{
			#if DEBUG 
				print ("\t\t Son : Création !\n", CouleurConsole.ROUGE);
			#endif 
			
			// chans = {};
			// sons = {};
			
			music = new Music (Config.MUSIQUE + "/mus.ogg");
			music.volume (50);
		}
		
		public void createSons ()
		{
			var src = new SDL.RWops.from_file (hit, "r");
			this.hitc = new Chunk.WAV (src);
			var src2 = new SDL.RWops.from_file (bam, "r");
			this.bamc = new Chunk.WAV (src2);
			bamc.volume (25);
		}
		
		public void playHit ()
		{
			this.chit.play (hitc, 0);
		}
		
		public void playBam ()
		{
			this.cbam.play (bamc, 0);
		}
	}
}

using GLib;
using SDL;
using SDLMixer;

namespace Jeu
{
	/**
	 * Classe pour gérer la musique de fond
	 * et les effets sonores supplémentaires 
	 * de façon simple et transparente
	 */
	public class Son : Object
	{
		public Music music; // Musique de fond
		
		private Channel[] chans; // Liste des cannaux 
		
		private Chunk[] sons; // Liste des sons
		
		public delegate void playSon ();
		
		public string hit; // Chemin vers hit
		public string bam; // Chemin vers bam
		
		public Son ()
		{
			#if DEBUG 
				print ("\t\t Son : Création !\n", CouleurConsole.ROUGE);
			#endif 
			
			chans = {};
			sons = {};
			
			music = new Music (Config.MUSIQUE + "/mus.ogg");
			music.volume (50);
		}
		
		public void createSons ()
		{
			this.addChannel ();
			this.addSon (hit);
			this.addChannel ();
			this.addSon (bam);
		}
		
		public void playHit ()
		{
			play (0,0);
		}
		
		public void playBam ()
		{
			play (1,1);
		}
		
		/**
		 * Joue sur le cannal @chan le son numero @son @repeat fois
		 */
		public void play (int chan, int son, int repeat = 1)
		{
			#if DEBUG == 3
				print ("\t\t Son : Joue un son \n", CouleurConsole.ROUGE);
			#endif
			chans[chan].play (sons[son], repeat - 1);
		}
		
		/**
		 * Ajoute un cannal avec pour volume @vol = 100
		 */
		public int addChannel (int vol = 100)
		{
			#if DEBUG
				print ("\t\t Son : Ajout d'un canal !\n", CouleurConsole.ROUGE);
			#endif
			
			Channel c = 0;
			c.volume (vol);
			chans += c;
			
			return chans.length - 1;
		}
		
		/**
		 * Ajoute un son depuis un fichier avec le volume @vol 
		 */
		public int addSon (string file, int vol = 100)
		{
			#if DEBUG
				print ("\t\t Son : Ajout d'un son ! \n", CouleurConsole.ROUGE);
			#endif
			var src = new SDL.RWops.from_file (file, "r");
			sons += new Chunk.WAV (src);
			// sons[-1].volume (vol); FAIT BUGGER L'ÉXÉCUTION 
			return sons.length - 1;
		}
		
		/**
		 * Définit le volume du cannal @chan à @vol
		 */
		public void setChannelVolume (int chan, int vol)
		{
			#if DEBUG
				print ("\t\t Son : Modification du volume d'un cannal \n", CouleurConsole.ROUGE);
			#endif
			chans[chan].volume (vol);
		}
		
		/**
		 * Définit le volume de l'effet sonore @son à @vol
		 */
		public void setSonVolume (int son, int vol)
		{
			#if DEBUG
				print ("\t\t Son : Modification du volume d'un son \n", CouleurConsole.ROUGE);
			#endif
			sons[son].volume (vol);
		}
	}
}

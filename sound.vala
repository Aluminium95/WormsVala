using GLib;
using SDL;
using SDLMixer;

namespace Jeu
{
	public class Son : Object
	{
		public Music music; // Musique de fond
		
		private Channel[] chans; // Liste des cannaux 
		
		private Chunk[] sons; // Liste des sons 
		
		public Son ()
		{
			chans = {};
			sons = {};
			
			music = new Music ("/home/aluminium95/Code/Vala/jeu/mus.ogg");
			music.volume (50);
		}
		
		public void play (int chan, int son, int repeat = 1)
		{
			chans[chan].play (sons[son], repeat - 1);
		}
		
		public int addChannel (int vol = 100)
		{
			Channel c = 0;
			c.volume (vol);
			chans += c;
			return chans.length - 1;
		}
		
		public int addSon (string file, int vol = 100)
		{
			var src = new SDL.RWops.from_file (file, "r");
			sons += new Chunk.WAV (src);
			// sons[-1].volume (vol); FAIT BUGGER L'ÉXÉCUTION 
			return sons.length - 1;
		}
		
		public void setChannelVolume (int chan, int vol)
		{
			chans[chan].volume (vol);
		}
		
		public void setSonVolume (int son, int vol)
		{
			sons[son].volume (vol);
		}
	}
}

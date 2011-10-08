using GLib;
using SDL;
using SDLGraphics;
using SDLMixer;

void main (string[] args)
{
	SDL.init (InitFlag.VIDEO);
	SDLMixer.open (44100, 0, 2, 1024);
	SDLMixer.Channel.allocate (1);
	
	Jeu.Aff.init ();
	Jeu.Aff.run ();

	SDLMixer.close ();
	SDL.quit ();
}

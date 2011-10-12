using GLib;
using SDL;
using SDLGraphics;
using SDLMixer;

void main (string[] args)
{
	#if DEBUG 
		Jeu.print ("WORMSVALA !\n", Jeu.CouleurConsole.JAUNE);
	#endif
	
	SDL.init (InitFlag.VIDEO | InitFlag.AUDIO);
	SDLMixer.open (44100, 0, 2, 1024);
	SDLMixer.Channel.allocate (2);
	
	Jeu.Aff.init ();
	#if DEBUG 
		Jeu.print ("Jeu initialisé !\n", Jeu.CouleurConsole.JAUNE);
	#endif
	
	Jeu.Aff.run ();
	#if DEBUG 
		Jeu.print ("Jeu terminé !\n", Jeu.CouleurConsole.JAUNE);
	#endif
	
	SDLMixer.close (); // Visiblement c'est ça qui rame 
	#if DEBUG 
		Jeu.print ("SDL_mixer fermé!\n", Jeu.CouleurConsole.JAUNE);
	#endif
	
	SDL.quit ();
	#if DEBUG 
		Jeu.print ("SDL fermé !\n", Jeu.CouleurConsole.JAUNE);
	#endif
}

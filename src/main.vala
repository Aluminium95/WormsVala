using GLib;
using SDL;
using SDLGraphics;
using SDLMixer;

/**
 * Point d'entrée du programme
 */
void main (string[] args)
{
	#if DEBUG 
		Jeu.print ("WORMSVALA !\n", Jeu.CouleurConsole.JAUNE);
	#endif
	/**
	 * Init des librairies 
	 */
	SDL.init (InitFlag.VIDEO | InitFlag.AUDIO);
	SDLImage.init (InitFlag.VIDEO | InitFlag.AUDIO);
	SDLMixer.open (44100, 0, 2, 1024);
	SDLMixer.Channel.allocate (2);
	
	/**
	 * Création du jeu
	 */
	var jeu = new Jeu.Application ();
	#if DEBUG 
		Jeu.print ("Jeu initialisé !\n", Jeu.CouleurConsole.JAUNE);
	#endif
	
	/**
	 * Éxécution du jeu
	 */
	jeu.run ();
	#if DEBUG 
		Jeu.print ("Jeu terminé !\n", Jeu.CouleurConsole.JAUNE);
	#endif
	
	/**
	 * Fermeture des librairies 
	 */
	SDLMixer.close (); // Visiblement c'est ça qui rame 
	#if DEBUG 
		Jeu.print ("SDL_mixer fermé!\n", Jeu.CouleurConsole.JAUNE);
	#endif
	SDLImage.quit ();
	SDL.quit ();
	#if DEBUG 
		Jeu.print ("SDL fermé !\n", Jeu.CouleurConsole.JAUNE);
	#endif
}

using GLib;
using SDL;
using SDLGraphics;

void main (string[] args)
{
	Gst.init (ref args);
	SDL.init (InitFlag.VIDEO);
	
	Jeu.Aff.init ();
	Jeu.Aff.run ();

	SDL.quit ();
}

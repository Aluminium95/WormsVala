using GLib;

void main (string[] args)
{
	Gst.init (ref args);
	
	var g = new Jeu.Gerant ();
	
	for ( int i = 0; i < 20;i++)
	{
		g.execute ();
	}
	
	g.kill ();
	
	Jeu.Son.play (Jeu.note.A);
	
	new MainLoop ().run ();
}

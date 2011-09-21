using GLib;

void main (string[] args)
{
	var g = new Jeu.Gerant ();
	
	for ( int i = 0; i < 20;i++)
	{
		g.execute ();
	}
	g.kill ();
}

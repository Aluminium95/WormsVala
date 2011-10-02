using GLib;
using Gst;

/**
 * Gestion des sont avec GStreamer !!
 */
namespace Jeu
{
	public class Son : GLib.Object
	{
		public static void play (double freq)
		{
			stdout.printf ("test je joue un son !!\n");
			var pipeline = new Gst.Pipeline ("note");
			var source = Gst.ElementFactory.make ("audiotestsrc",
												"source");
			var sink = Gst.ElementFactory.make ("autoaudiosink",
											"output");
											
			source.set ("freq", freq);
			pipeline.add (source);
			pipeline.add (sink);
			source.link (sink);
			
			pipeline.set_state (Gst.State.PLAYING);
			
			var time = new TimeoutSource(200);

			time.set_callback(() => {
				pipeline.set_state (Gst.State.PAUSED);
				return false;
			});
			
			time.attach(null);
		}
	}
}
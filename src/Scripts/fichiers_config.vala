using GLib;

namespace Jeu
{
	/**
	 * Représente un fichier de configuration
	 * Peut-être que je ne l'utiliserais pas … 
	 */
	public class ConfigFile : Object
	{
		protected File file;
		protected DataInputStream input;
		protected DataOutputStream output;
		 
		/**
		 * Constructeur
		 */
		public ConfigFile (string uri)
		{
			try 
			{
				file = File.new_for_path (uri);
				input = new DataInputStream (file.read());
				output = new DataOutputStream (file.create (FileCreateFlags.NONE));
			} catch (Error e) {
				stderr.printf ("Impossible de loader le fichier de configuration\n");
			}
		}
		
		/**
		 * Change de fichier de config
		 */
		public void change_config_file (string uri)
		{
			try 
			{
				file = File.new_for_path (uri);
				input = new DataInputStream (file.read());
				output = new DataOutputStream (file.create (FileCreateFlags.NONE));
			} catch (Error e) {
				stderr.printf ("Impossible de loader le fichier de configuration\n");
			}
		}
		
		/**
		 * Ajoute une ligne d'information au fichier
		 */
		public void add_info (string[] infos)
		{
			try 
			{
				foreach (var s in infos)
				{
					output.put_string (s);
				}
				output.put_string ("\n");
			} catch (Error e) {
				stderr.printf ("Impossible d'écrire la configuration\n");
			}
		}
		
		/**
		 * Récupère une ligne d'information
		 */
		public string[]? get_info (int ligne)
		{
			try
			{
				int read_line = 0;
				string? line;
				while ((line = input.read_line (null)) != null) {
				   	if ( ligne == read_line )
				   	{
				   		return line.split(" ::: ");
				   	}
				    read_line++;
				}
			} catch (Error e){
				stderr.printf ("Impossible de récupérer la ligne de config \n");
			}
			return null;
		}
	}
}

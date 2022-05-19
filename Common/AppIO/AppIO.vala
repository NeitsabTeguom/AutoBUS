namespace AppIO
{
    public class FileWatcher
    {
        // SINGLETON
        // https://csharpindepth.com/Articles/Singleton

        private static FileWatcher instance = null;
        private static Object padlock = new Object();

        FileWatcher()
        {
            this.Init();
        }

        public static FileWatcher Instance
        {
            get
            {
                lock (padlock)
                {
                    if (instance == null)
                    {
                        instance = new FileWatcher();
                    }
                    return instance;
                }
            }
        }

        private FileMonitor monitor;

        private void Init()
        {
                File file = File.new_for_path (Environment.get_home_dir ());
                this.monitor = file.monitor_directory (FileMonitorFlags.NONE, null);
                print ("Monitoring: %s\n", file.get_path ());
        
                this.monitor.changed.connect (this.on_changed);
        }

        private void on_changed (FileMonitor fm, File src, File? dest, FileMonitorEvent event)
        {
            if (dest != null) {
                print ("%s: %s, %s\n", event.to_string (), src.get_path (), dest.get_path ());
            } else {
                print ("%s: %s\n", event.to_string (), src.get_path ());
            }
        }
    }
}
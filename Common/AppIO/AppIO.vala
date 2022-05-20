namespace AutoBUS.AppIO
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

    public class TmpFs
    {
        public TmpFs()
        {
        }

        /**
        * Mounting TmpFs
        * 
        * Mounting TmpFs volume for application exchange messages
        *
        * @param MemorySize Size memory of the monting volume (after the maximum -> swap)
        */
        public void Mount(uint MemorySize, string? MountPoint = null)
        {
            #if WINDOWS
                message ("Running on Windows");
            #elif OSX
                message ("Running on OS X");
            #elif LINUX
                //message ("Running on GNU/Linux");
                MountPoint = MountPoint == null ? "/var/tmp/AutoBUS" : MountPoint;
                this.ExecuteCommand("mkdir -p "+MountPoint);
                this.ExecuteCommand("mount -t tmpfs tmpfs "+MountPoint+" -o size="+MemorySize.to_string()+"o");
            #elif POSIX
                message ("Running on other POSIX system");
            #else
                message ("Running on unknown OS");
            #endif
        }

        private bool ExecuteCommand(string cmd)
        {
            bool result = false;

            string ls_stdout;
            string ls_stderr;
            int ls_status;
        
            try {
                Process.spawn_command_line_sync (cmd,
                                            out ls_stdout,
                                            out ls_stderr,
                                            out ls_status);
        
                // Output: <File list>
                print ("stdout:\n");
                // Output: ````
                print (ls_stdout);
                print ("stderr:\n");
                print (ls_stderr);
                // Output: ``0``
                print ("Status: %d\n", ls_status);
                result = true;
            } catch (SpawnError e) {
                print ("Error: %s\n", e.message);
            }

            return result;
        }
    }
}
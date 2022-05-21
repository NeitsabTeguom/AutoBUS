namespace AutoBUS
{
    public class AppIO
    {

        // SINGLETON
        // https://csharpindepth.com/Articles/Singleton

        private static AppIO instance = null;
        private static Object padlock = new Object();

        AppIO()
        {
            this.Init();
        }

        ~AppIO()
        {
            this.Dispose();
        }

        public static AppIO Instance
        {
            get
            {
                lock (padlock)
                {
                    if (instance == null)
                    {
                        instance = new AppIO();
                    }
                    return instance;
                }
            }
        }

        private TmpFs tfs;
        private FSWatcher fsw;

        private void Init()
        {
            string MountingPoint = "/var/tmp/AutoBUS/";

            this.tfs = new TmpFs(MountingPoint);
            this.tfs.Mount(100 * 1024 * 1024);
            
            this.fsw = new FSWatcher(MountingPoint);
            this.fsw.Watch();
        }

        public void Dispose()
        {
            this.tfs.Unmount();
        }

        public class FSWatcher
        {
            private string path;

            public FSWatcher(string path = null)
            {
                this.path = (path == null ? Environment.get_home_dir () : path);
            }

            private FileMonitor monitor;

            public void Watch()
            {
                    File file = File.new_for_path (this.path);
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
            private string MountPoint;

            public TmpFs(string MountPoint = null)
            {
                #if WINDOWS
                    message ("Running on Windows");
                #elif OSX
                    message ("Running on OS X");
                #elif LINUX
                    this.MountPoint = (MountPoint == null ? "/var/tmp/AutoBUS/" : MountPoint);
                #elif POSIX
                    message ("Running on other POSIX system");
                #else
                    message ("Running on unknown OS");
                #endif
            }

            /**
            * Mounting TmpFs
            * 
            * Mounting TmpFs volume for application exchange messages
            *
            * @param MemorySize Size memory of the volume (after the maximum -> swap)
            */
            public void Mount(uint MemorySize)
            {
                print ("Mount "+this.MountPoint+"\n");
                #if WINDOWS
                    message ("Running on Windows");
                #elif OSX
                    message ("Running on OS X");
                #elif LINUX
                    //message ("Running on GNU/Linux");
                    this.ExecuteCommand("sudo mkdir -p "+this.MountPoint);
                    this.ExecuteCommand("sudo mount -t tmpfs tmpfs "+this.MountPoint+" -o size="+MemorySize.to_string());
                #elif POSIX
                    message ("Running on other POSIX system");
                #else
                    message ("Running on unknown OS");
                #endif
            }

            /**
            * Mounting TmpFs
            * 
            * Unmounting TmpFs volume for application exchange messages
            */
            public void Unmount()
            {
                print ("Unmount "+this.MountPoint+"\n");
                #if WINDOWS
                    message ("Running on Windows");
                #elif OSX
                    message ("Running on OS X");
                #elif LINUX
                    this.ExecuteCommand("sudo umount -f "+this.MountPoint);
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
}
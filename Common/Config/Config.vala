using GLib;

namespace AutoBUS {

    public class Config
    {
        private static T DeserializeConfigFile<T>()
        {
            string parentPath = typeof(Config).name();

            string file = Path.build_filename(
                Environment.get_current_dir(),
                typeof(T).name().substring(parentPath.char_count()) + ".config.json"
            );

            return Deserialize<T>(ReadFileContent(file));
        }

        private static string ReadFileContent(string file)
        {
            // open file stream:
            FileStream stream = FileStream.open(file, "r");
            assert(stream != null);
        
            // get file size:
            stream.seek (0, FileSeek.END);
            long size = stream.tell ();
            stream.rewind ();
        
            // load content:
            uint8[] buf = new uint8[size];
            size_t read = stream.read(buf, 1);
            assert(size == read);
        
            return (string)buf;	
        }

        private static T Deserialize<T>(string data)
        {
            try
            {
                T obj = Json.gobject_from_data(typeof (T), data);
                assert (obj != null);
                return obj;
        
            }
            catch (Error e)
            {
                print ("Error: %s\n", e.message);
            }
            return null;
        }

        private static router _Router;
        private static Object padlockRouter = new Object();
        public static router Router
        {
            get
            {
                lock (padlockRouter)
                {
                    if (_Router == null)
                    {
                        _Router = DeserializeConfigFile<router>();
                    }
                    return _Router;
                }
            }
        }

        public class router : Object
        {
            public server Server { get; set; }
            public class server : Object
            {
                public string Host { get; set; }
                public int Port { get; set; }
            }
        }

        private static worker _Worker;
        private static Object padlockWorker = new Object();
        public static worker Worker
        {
            get
            {
                lock (padlockRouter)
                {
                    if (_Worker == null)
                    {
                        _Worker = DeserializeConfigFile<worker>();
                    }
                    return _Worker;
                }
            }
        }

        public class worker : Object
        {            
            public client Client { get; set; }
            public class client : Object
            {
                public string URL { get; set; }
            }
        }
    }
}
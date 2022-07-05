namespace AutoBUS
{
    public class Config {

        private static RouterConfig _router;
        private static Object padlockRouter = new Object();
        public static RouterConfig router
        {
            get
            {
                lock (padlockRouter)
                {
                    if (_router == null)
                    {
                        // Loading file
                        _router = new RouterConfig();
                    }
                    return _router;
                }
            }
        }
        public class RouterConfig
        {
            public Server server { get; private set;}
            public class Server
            {
                public string Host { get{
                    return "localhost";
                }}
                public int Port { get{
                    return 8888;
                }}
            }

        }

        private static Worker _worker;
        private static Object padlockWorker = new Object();
        public static Worker worker
        {
            get
            {
                lock (padlockWorker)
                {
                    if (_worker == null)
                    {
                        // Loading file
                        _worker = new Worker();
                    }
                    return _worker;
                }
            }
        }
        public class Worker
        {
            public Client client { get; private set;}
            public class Client
            {
                public string URL { get{
                    return "http://localhost:8888/autobus/router";
                }}
            }

        }


    }
}
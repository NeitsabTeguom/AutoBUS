namespace Sockets
{
    class SocketServer
    {
        // SINGLETON
        // https://csharpindepth.com/Articles/Singleton

        private static SocketServer instance = null;
        private static Object padlock = new Object();

        SocketServer()
        {
            this.Init();
        }

        public static SocketServer Instance
        {
            get
            {
                lock (padlock)
                {
                    if (instance == null)
                    {
                        instance = new SocketServer();
                    }
                    return instance;
                }
            }
        }

        private void Init()
        {
            try {
                var srv = new SocketService ();
                srv.add_inet_port (3333, null);
                srv.incoming.connect (this.on_incoming_connection);
                srv.start ();
            } catch (Error e) {
                stderr.printf ("%s\n", e.message);
            }
        }

        private bool on_incoming_connection (SocketConnection conn) {
            stdout.printf ("Got incoming connection\n");
            // Process the request asynchronously
            this.process_request.begin (conn);
            return true;
        }
        
        private async void process_request (SocketConnection conn) {
            try {
                var dis = new DataInputStream (conn.input_stream);
                var dos = new DataOutputStream (conn.output_stream);
                string req = yield dis.read_line_async (Priority.HIGH_IDLE);
                dos.put_string ("Got: %s\n".printf (req));
            } catch (Error e) {
                stderr.printf ("%s\n", e.message);
            }
        }
    }
}
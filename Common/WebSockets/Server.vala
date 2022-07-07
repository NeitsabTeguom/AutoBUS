namespace AutoBUS
{
    public class Server : Soup.Server
    {

        // SINGLETON
        // https://csharpindepth.com/Articles/Singleton

        private static Server instance = null;
        private static Object padlock = new Object();

        Server()
        {
            assert (this != null);
            this.Init();
        }

        ~Server()
        {
            this.Dispose();
        }

        public static Server Instance
        {
            get
            {
                lock (padlock)
                {
                    if (instance == null)
                    {
                        instance = new Server();
                    }
                    return instance;
                }
            }
        }

        private Soup.Server server;

        public void Init()
        {
            this.listen_local (AutoBUS.Config.Router.Server.Port, 0);

            stdout.printf(AutoBUS.Config.Router.Server.Host);
            string[] protocols = {"autobus"};
            this.add_websocket_handler("/autobus/router",AutoBUS.Config.Router.Server.Host, protocols, ws_callback);
        }
    
        private void ws_callback(Soup.Server server, Soup.WebsocketConnection websocket, string path, Soup.ClientContext client)
        {

            websocket.message.connect(this.ws_message);
            websocket.closed.connect(this.ws_closed);
            websocket.error.connect(this.ws_error);
            
            string host = client.get_host();
            //info (@"Client connected! Host: $host");
            string msg = """test_message1""";
            //info (@"Sending to client message: $msg");
            websocket.send_text(msg);
        }

        private void ws_message(int type, Bytes message)
        {
            stdout.printf((string)message.get_data());
            // this.websocket.send_text("test_message2"); // client does not send message
        }

        private void ws_closed()
        {
            stdout.printf("WebSock closed!");
        }

        private void ws_error(Error error)
        {
            int code = error.code;
            string message = error.message;
            stdout.printf("WS Error %d: %s\n".printf(code,message));
        }

        public void Dispose()
        {
            this.disconnect();
        }
    }

}
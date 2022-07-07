namespace AutoBUS
{
    public class Client
    {

        // SINGLETON
        // https://csharpindepth.com/Articles/Singleton

        private static Client instance = null;
        private static Object padlock = new Object();

        Client()
        {
            this.Init();
        }

        ~Client()
        {
            this.Dispose();
        }

        public static Client Instance
        {
            get
            {
                lock (padlock)
                {
                    if (instance == null)
                    {
                        instance = new Client();
                    }
                    return instance;
                }
            }
        }

        private Soup.WebsocketConnection websocket;
        private Soup.Session session;
        private Soup.Message message;

        private void Init()
        {
            this.session = new Soup.Session();
            
            this.message = new Soup.Message("GET", AutoBUS.Config.Worker.Client.URL); // "http://<server_host>[:server_port]/[path]"

            string[] protocols = {"autobus"};
            this.session.websocket_connect_async.begin(this.message, "worker", protocols, null, (obj, res) => {
                //this.websocket = this.session.websocket_connect_async.end(res);
                this.websocket.message.connect(this.ws_message);
                this.websocket.closed.connect(this.ws_closed);
                this.websocket.error.connect(this.ws_error);
            });
        }

        private void ws_message(int type, Bytes message){
            stdout.printf((string)message.get_data());
            // this.websocket.send_text("test_message2"); // client does not send message
        }

        private void ws_closed(){
            stdout.printf("WebSock closed!"); // я просто вывел сообщение
        }

        private void ws_error(Error error){
            int code = error.code;
            string message = error.message;
            stdout.printf("WS Error %d: %s\n".printf(code,message));
        }

        public void Dispose()
        {
            this.websocket.close(Soup.WebsocketCloseCode.NO_STATUS, null);
            this.websocket = null;
        }

    }
}
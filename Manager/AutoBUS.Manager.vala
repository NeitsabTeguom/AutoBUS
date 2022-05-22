public class HTTPServer {

    private string staticPath;

    int port;
    Soup.Server server;

    public HTTPServer(int port = 0) {
        this.port = port;
        #if DEBUG
            staticPath="static/";
        #else
            staticPath="static/";
        #endif
        this.server = new Soup.Server(Soup.SERVER_PORT, port, null);
        server.add_handler(null, handle_static_file);
    }
    
    void handle_static_file(Soup.Server server, Soup.Message message,
            string path, HashTable? query, Soup.ClientContext context) {
        server.pause_message(message);
        handle_static_file_async.begin(server, message, path, query, context);
    }

    async void handle_static_file_async(Soup.Server server,
            Soup.Message message, string path, HashTable? query,
            Soup.ClientContext context) {
        
        if (path == "/" || path == "") {
            path = "index.html";
        }

        var file = File.new_for_path(staticPath + path);

        try {
            var info = yield file.query_info_async("*", FileQueryInfoFlags.NONE);
            var io = yield file.read_async();
            Bytes data;
            while ((data = yield io.read_bytes_async((size_t)info.get_size())).length > 0) {
                message.response_body.append(Soup.MemoryUse.COPY,
                    data.get_data());
            }
            string content_type = info.get_content_type();
            message.set_status(Soup.Status.OK);
            message.response_headers.set_content_type(content_type, null);
        } catch (IOError.NOT_FOUND e) {
            message.set_status(404);
            message.set_response("text/plain", Soup.MemoryUse.COPY,
                ("File " + file.get_path() + " does not exist.").data);
        } catch (Error e) {
            stderr.printf("Failed to read file %s: %s\n", file.get_path(),
                e.message);
            message.set_status(500);
            message.set_response("text/plain", Soup.MemoryUse.COPY,
                e.message.data);
        } finally {
            server.unpause_message(message);
        }
    }

    public void start() throws Error{
        server.run_async();
        stdout.printf("Starting HTTP server on http://localhost:%u\n",
            server.port);
    }
}

static int port = 8088;

static MainLoop loop;
static void safe_exit(int signal) {
    loop.quit();
}

static int main(string[] args) {
    try {
        #if DEBUG
            stdout.printf ("debug version \n");
        #else
            stdout.printf ("production version \n");
        #endif
        var server = new HTTPServer(port);
        server.start();

        loop = new MainLoop();
        Posix.signal(Posix.SIGINT, safe_exit);
        Posix.signal(Posix.SIGHUP, safe_exit);
        Posix.signal(Posix.SIGTERM, safe_exit);
        loop.run();
    } catch (Error e) {
        stderr.printf("Error running HttpServer: %s\n", e.message);
        return 1;
    }
    return 0;
}
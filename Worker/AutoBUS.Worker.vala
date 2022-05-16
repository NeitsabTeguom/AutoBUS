class AsyncDemo {

    private MainLoop loop;

    public AsyncDemo (MainLoop loop) {
        this.loop = loop;
    }

    public async void http_request () throws Error {
        try {
            var resolver = Resolver.get_default ();
            var addresses = yield resolver.lookup_by_name_async ("www.google.com");
            var address = addresses.nth_data (0);
            print ("(async) resolved www.google.com to %s\n", address.to_string ());

            var socket_address = new InetSocketAddress (address, 80);
            var client = new SocketClient ();
            var conn = yield client.connect_async (socket_address);
            print ("(async) connected to www.google.com\n");

            var message = "GET / HTTP/1.1\r\nHost: www.google.com\r\n\r\n";
            yield conn.output_stream.write_async (message.data, Priority.DEFAULT);
            print ("(async) wrote request\n");

            // we set the socket back to blocking here for the convenience
            // of DataInputStream
            conn.socket.set_blocking (true);

            var input = new DataInputStream (conn.input_stream);
            message = input.read_line (null).strip ();
            print ("(async) received status line: %s\n", message);
        } catch (Error e) {
            stderr.printf ("%s\n", e.message);
        }

        this.loop.quit ();
    }
}

void main () {
    var loop = new MainLoop ();
    var demo = new AsyncDemo (loop);
    demo.http_request.begin ();
    loop.run ();
}
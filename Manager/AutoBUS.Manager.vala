void default_handler (Soup.Server server, Soup.Message msg, string path,
    GLib.HashTable? query, Soup.ClientContext client)
{
    string response_text = """
<html>
<body>
<p>Current location: %s</p>
</body>
</html>""".printf (path);

    msg.set_response ("text/html", Soup.MemoryUse.COPY,
        response_text.data);
}

void main () {
    var server = new Soup.Server (Soup.SERVER_PORT, 8088);
    server.add_early_handler ("/adminlte/", default_handler);
    server.run ();
}
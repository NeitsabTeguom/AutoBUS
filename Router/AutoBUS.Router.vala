void main () {
        Sockets.SocketServer ss = Sockets.SocketServer.Instance;
        new MainLoop ().run ();
}
//https://wiki.gnome.org/Projects/Vala/ValaForCSharpProgrammers
// echo "blub" | nc localhost 3333 
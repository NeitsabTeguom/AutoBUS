public static int main () {
        Sockets.SocketServer ss = Sockets.SocketServer.Instance;
        AppIO.FileWatcher fw = AppIO.FileWatcher.Instance;
        new MainLoop ().run ();
        return 0;
}
//https://wiki.gnome.org/Projects/Vala/ValaForCSharpProgrammers
// echo "blub" | nc localhost 3333 
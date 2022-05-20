using AutoBUS.Sockets;
using AutoBUS.AppIO;

public static int main () {
        SocketServer ss = SocketServer.Instance;
        FileWatcher fw = FileWatcher.Instance;
        (new AutoBUS.AppIO.TmpFs()).Mount(100 * 1024 * 1024);
        new MainLoop ().run ();
        return 0;
}
//https://wiki.gnome.org/Projects/Vala/ValaForCSharpProgrammers
// echo "blub" | nc localhost 3333 
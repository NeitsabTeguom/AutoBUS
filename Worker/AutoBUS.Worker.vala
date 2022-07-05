using GLib;

namespace AutoBUS.Worker {

    private static MainLoop mainloop;

    private static Client client;

    private static void on_start ()
    {
        print ("Starting\n");
            
        client = Client.Instance;
    }

    private static void on_exit (int signum)
    {
        print("Exiting\n");

        stop();

        mainloop.quit ();
    }

    private static void stop()
    {

        client.Dispose();
        client = null;

    }

    public static int main (string[] args)
    {
        // set timezone to avoid that strftime stats /etc/localtime on every call
        Environment.set_variable ("TZ", "/etc/localtime", false);

        Process.signal(ProcessSignal.INT, on_exit);
        Process.signal(ProcessSignal.TERM, on_exit);

        // Creating a GLib main loop with a default context
        mainloop = new MainLoop (null, false);

        on_start();
        
        // Start GLib mainloop
        mainloop.run ();

        stop();

        return 0;        
    }
}
//https://gitlab.gnome.org/Archive/gnome-dvb-daemon/-/blob/master/src/Main.vala
//https://wiki.gnome.org/Projects/Vala/ValaForCSharpProgrammers
// echo "blub" | nc localhost 3333 
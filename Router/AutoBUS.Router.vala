using AutoBUS;

public class AutoBUSApp : Application {
        private AppIO aio;

	private AutoBUSApp () {
		Object (application_id: "org.autobus.router", flags: ApplicationFlags.FLAGS_NONE);
		//set_inactivity_timeout (10000);
	}

        protected override void activate () {
                base.activate ();
		print ("Activated\n");
                Sockets.SocketServer ss = Sockets.SocketServer.Instance;
                this.aio = AppIO.Instance;
	}

        protected override void shutdown () {
                base.shutdown ();
		print ("Shutdown \n");
                this.aio.Dispose();
	}

	static int main (string[] args) {
		AutoBUSApp app = new AutoBUSApp ();
		int status = app.run (args);
		return status;
	}
}

/*
public static int main () {
        Sockets.SocketServer ss = Sockets.SocketServer.Instance;
        AppIO aio = AppIO.Instance;
        new MainLoop ().run ();
        AppIO.Instance.Dispose();
        return 0;
}
*/
//https://wiki.gnome.org/Projects/Vala/ValaForCSharpProgrammers
// echo "blub" | nc localhost 3333 
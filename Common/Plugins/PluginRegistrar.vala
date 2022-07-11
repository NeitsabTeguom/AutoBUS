//https://wiki.gnome.org/Projects/Vala/TypeModules
namespace AutoBUS
{
    public class PluginRegistrar<T> : Object {

        public string path { get; private set; }

        private Type type;
        private Module module;

        private delegate Type RegisterPluginFunction (Module module);

        public PluginRegistrar (string name) {
            assert (Module.supported ());
            this.path = Path.build_path (Path.DIR_SEPARATOR_S, Environment.get_current_dir(), "internal");
            this.path = Module.build_path (this.path, name);
        }

        public bool load () {
            stdout.printf ("Loading plugin with path: '%s'\n", path);

            module = Module.open (path, ModuleFlags.LAZY);
            if (module == null) {
                return false;
            }

            stdout.printf ("Loaded module: '%s'\n", module.name ());

            void* function;
            module.symbol ("register_plugin", out function);
            unowned RegisterPluginFunction register_plugin = (RegisterPluginFunction) function;

            type = register_plugin (module);
            stdout.printf ("Plugin type: %s\n\n", type.name ());
            return true;
        }

        public T new_object () {
            return Object.new (type);
        }
    }
}
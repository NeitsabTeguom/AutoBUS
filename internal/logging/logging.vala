class Logging : Object, ILogging {
    public void Log (string? log_domain, LogLevelFlags log_levels, string message) {
        //write to file or all logging method that you want ...
    }
}

public Type register_plugin (Module module) {
    // types are registered automatically
    return typeof (Logging);
}

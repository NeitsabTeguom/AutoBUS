public interface ILogging : Object {
    public abstract void Log (string? log_domain, LogLevelFlags log_levels, string message);
}
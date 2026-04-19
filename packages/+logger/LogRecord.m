classdef LogRecord
    properties
        timestamp datetime
        level double
        loggerName string
        message string
    end

    methods
        function obj = LogRecord(level, loggerName, message)
            obj.timestamp = datetime("now");
            obj.level = logger.LogLevel.normalize(level);
            obj.loggerName = string(loggerName);
            obj.message = string(message);
        end
    end
end

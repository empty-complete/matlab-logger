classdef LogLevel
    properties (Constant)
        DEBUG = 10;
        INFO = 20;
        WARN = 30;
        ERROR = 40;
    end

    methods (Static)
        function level = normalize(levelValue)
            if isnumeric(levelValue)
                level = double(levelValue);
                return;
            end

            levelName = upper(string(levelValue));
            switch levelName
                case "DEBUG"
                    level = logger.LogLevel.DEBUG;
                case "INFO"
                    level = logger.LogLevel.INFO;
                case {"WARN", "WARNING"}
                    level = logger.LogLevel.WARN;
                case "ERROR"
                    level = logger.LogLevel.ERROR;
                otherwise
                    error("Logger:InvalidLevel", "Unknown log level: %s", levelName);
            end
        end

        function levelName = toString(levelValue)
            level = logger.LogLevel.normalize(levelValue);
            switch level
                case logger.LogLevel.DEBUG
                    levelName = "DEBUG";
                case logger.LogLevel.INFO
                    levelName = "INFO";
                case logger.LogLevel.WARN
                    levelName = "WARN";
                case logger.LogLevel.ERROR
                    levelName = "ERROR";
                otherwise
                    levelName = "INFO";
            end
        end
    end
end

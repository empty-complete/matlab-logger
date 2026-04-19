classdef Logger < handle
    properties
        name string
        level double = logger.LogLevel.INFO
        handlers cell = {}
        propagate logical = true
    end

    methods (Access = private)
        function this = Logger(name)
            this.name = string(name);
        end
    end

    methods (Static)
        function loggerInstance = getLogger(name)
            persistent registry;

            if isempty(registry)
                registry = containers.Map('KeyType', 'char', 'ValueType', 'any');
            end

            loggerName = char(string(name));
            if ~isKey(registry, loggerName)
                registry(loggerName) = logger.Logger(loggerName);
            end

            loggerInstance = registry(loggerName);
        end

        function configure(varargin)
            options = logger.Logger.parseConfigureOptions(varargin{:});
            handlers = {};
            formatter = logger.LogFormatter();

            if options.consoleEnabled
                handlers{end + 1} = logger.ConsoleLogHandler(options.level, formatter);
            end
            if options.fileEnabled
                logger.Logger.ensureDirectoryExists(fileparts(options.filePath));
                handlers{end + 1} = logger.FileLogHandler(options.filePath, options.level, formatter);
            end

            rootLogger = logger.Logger.getLogger("root");
            rootLogger.level = logger.LogLevel.normalize(options.level);
            rootLogger.handlers = handlers;
            rootLogger.propagate = false;
        end

        function reset()
            persistent registry;
            registry = containers.Map('KeyType', 'char', 'ValueType', 'any');
        end

        function logFilePath = defaultLogFilePath()
            timestamp = string(datetime("now"), "yyyy-MM-dd_HH-mm-ss");
            logFilePath = fullfile("logs", "session_" + timestamp + ".log");
        end
    end

    methods
        function setLevel(this, level)
            this.level = logger.LogLevel.normalize(level);
        end

        function addHandler(this, handler)
            this.handlers{end + 1} = handler;
        end

        function childLogger = child(this, suffix)
            childLogger = logger.Logger.getLogger(this.name + "." + string(suffix));
        end

        function debug(this, message, varargin)
            this.log(logger.LogLevel.DEBUG, message, varargin{:});
        end

        function info(this, message, varargin)
            this.log(logger.LogLevel.INFO, message, varargin{:});
        end

        function warn(this, message, varargin)
            this.log(logger.LogLevel.WARN, message, varargin{:});
        end

        function error(this, message, varargin)
            this.log(logger.LogLevel.ERROR, message, varargin{:});
        end

        function log(this, level, message, varargin)
            normalizedLevel = logger.LogLevel.normalize(level);
            if normalizedLevel < this.level
                return;
            end

            renderedMessage = logger.Logger.renderMessage(message, varargin{:});
            record = logger.LogRecord(normalizedLevel, this.name, renderedMessage);
            this.emit(record);

            if this.propagate
                rootLogger = logger.Logger.getLogger("root");
                if ~strcmp(this.name, "root")
                    rootLogger.emit(record);
                end
            end
        end
    end

    methods (Access = private)
        function emit(this, record)
            for handlerIndex = 1:numel(this.handlers)
                this.handlers{handlerIndex}.emit(record);
            end
        end
    end

    methods (Static, Access = private)
        function options = parseConfigureOptions(varargin)
            parser = inputParser();
            addParameter(parser, "Level", logger.LogLevel.INFO);
            addParameter(parser, "Console", true);
            addParameter(parser, "File", true);
            addParameter(parser, "FilePath", logger.Logger.defaultLogFilePath());
            parse(parser, varargin{:});

            options.level = parser.Results.Level;
            options.consoleEnabled = parser.Results.Console;
            options.fileEnabled = parser.Results.File;
            options.filePath = string(parser.Results.FilePath);
        end

        function renderedMessage = renderMessage(message, varargin)
            messageText = string(message);
            if isempty(varargin)
                renderedMessage = messageText;
                return;
            end

            formatArgs = cellfun(@logger.Logger.normalizeFormatArgument, varargin, 'UniformOutput', false);
            renderedMessage = string(sprintf(char(messageText), formatArgs{:}));
        end

        function value = normalizeFormatArgument(value)
            if isstring(value) && isscalar(value)
                value = char(value);
            elseif ischar(value)
                return;
            elseif isnumeric(value) || islogical(value)
                return;
            else
                value = char(string(value));
            end
        end

        function ensureDirectoryExists(directoryPath)
            if strlength(directoryPath) == 0
                return;
            end
            if ~isfolder(directoryPath)
                mkdir(directoryPath);
            end
        end
    end
end

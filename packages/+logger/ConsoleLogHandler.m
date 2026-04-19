classdef ConsoleLogHandler < handle
    properties
        level double = logger.LogLevel.INFO
        formatter logger.LogFormatter = logger.LogFormatter()
    end

    methods
        function this = ConsoleLogHandler(level, formatter)
            if nargin >= 1 && ~isempty(level)
                this.level = logger.LogLevel.normalize(level);
            end
            if nargin >= 2 && ~isempty(formatter)
                this.formatter = formatter;
            end
        end

        function emit(this, record)
            if record.level < this.level
                return;
            end

            fprintf('%s', this.formatter.format(record));
        end
    end
end

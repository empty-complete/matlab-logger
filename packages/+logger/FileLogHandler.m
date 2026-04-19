classdef FileLogHandler < handle
    properties
        level double = logger.LogLevel.INFO
        formatter logger.LogFormatter = logger.LogFormatter()
        filePath string
    end

    methods
        function this = FileLogHandler(filePath, level, formatter)
            this.filePath = string(filePath);

            if nargin >= 2 && ~isempty(level)
                this.level = logger.LogLevel.normalize(level);
            end
            if nargin >= 3 && ~isempty(formatter)
                this.formatter = formatter;
            end
        end

        function emit(this, record)
            if record.level < this.level
                return;
            end

            fileId = fopen(this.filePath, 'a');
            if fileId == -1
                error("Logger:FileOpenFailed", "Unable to open log file: %s", this.filePath);
            end

            cleanupObj = onCleanup(@() fclose(fileId)); %#ok<NASGU>
            fprintf(fileId, '%s', this.formatter.format(record));
        end
    end
end

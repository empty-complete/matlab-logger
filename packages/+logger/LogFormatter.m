classdef LogFormatter < handle
    properties
        timestampFormat string = "HH:mm:ss"
        pattern string = "[{level}] [{time}] [{logger}] {message}"
    end

    methods
        function formattedMessage = format(this, record)
            formattedMessage = this.pattern;
            formattedMessage = replace(formattedMessage, "{level}", logger.LogLevel.toString(record.level));
            formattedMessage = replace(formattedMessage, "{time}", string(record.timestamp, this.timestampFormat));
            formattedMessage = replace(formattedMessage, "{logger}", record.loggerName);
            formattedMessage = replace(formattedMessage, "{message}", record.message);
            formattedMessage = formattedMessage + newline;
        end
    end
end

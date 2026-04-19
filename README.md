<div align="center">
  <img src="./assets/logo_matlab_logger.png" alt="matlab-logger logo" width="120">
  <h1>MATLAB logger</h1>
  <p><i>A Python-inspired logging framework for MATLAB — named loggers, log levels, console and file handlers, session-aware output.</i></p>

  <p>
    <a href="https://github.com/empty-complete/matlab-logger/commits/main">
      <img src="https://img.shields.io/github/commit-activity/m/empty-complete/matlab-logger" alt="GitHub commit activity">
    </a>
    <a href="https://github.com/empty-complete/matlab-logger/blob/main/LICENSE">
      <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
    </a>
    <img src="https://img.shields.io/badge/MATLAB-R2021b%2B-blue?logo=mathworks" alt="MATLAB">
  </p>
  <p>
    <a href="https://t.me/kinesis_lab">
      <img src="https://img.shields.io/badge/Telegram-follow-229ED9?logo=telegram" alt="Telegram">
    </a>
  </p>
</div>

---

## Overview

**matlab-logger** brings `logging`-style ergonomics from Python to MATLAB. Drop the scattered `fprintf` calls and `diary` hacks — get named loggers, log levels, console and file handlers, and child logger hierarchies, all in a clean MATLAB package.

```matlab
addpath("path/to/matlab-logger/packages")

logger.configure("Level", "INFO", "FilePath", "logs/session.log");
log = logger.getLogger("main");

log.info("Starting calculation for M=%.2f", mach);
log.warn("Convergence slow at %i Hz", freq);
log.error("Solver failed: %s", err.message);
```

---

## Quick Start

**1. Add to path**
```matlab
addpath("path/to/matlab-logger/packages")
```

**2. Configure once at startup**
```matlab
logger.configure( ...
    "Level",    "INFO", ...
    "Console",  true, ...
    "File",     true, ...
    "FilePath", "logs/session.log" ...
);
```

**3. Get a named logger and use it**
```matlab
log = logger.getLogger("mymodule");
log.debug("x = %f", x);
log.info("Done in %.2f s", elapsed);
log.warn("Tolerance not met");
log.error("Unexpected value: %s", num2str(val));
```

**4. Use child loggers for nested context**
```matlab
sublog = log.child("solver");
sublog.info("Iteration %d complete", iter);
```

---

## API Reference

### `logger.configure(Name, Value, ...)`

Initializes the root logger. Call once at startup.

| Parameter  | Default          | Description           |
|------------|------------------|-----------------------|
| `Level`    | `"INFO"`         | Minimum log level     |
| `Console`  | `true`           | Enable console output |
| `File`     | `true`           | Enable file output    |
| `FilePath` | auto-timestamped | Path to log file      |

### `logger.getLogger(name)`

Returns a named `logger.Logger` instance. Repeated calls with the same name return the same instance (registry pattern).

### `logger.Logger` methods

| Method                | Description                                  |
|-----------------------|----------------------------------------------|
| `log.debug(msg, ...)` | Debug-level message                          |
| `log.info(msg, ...)`  | Info-level message                           |
| `log.warn(msg, ...)`  | Warning-level message                        |
| `log.error(msg, ...)` | Error-level message                          |
| `log.child(suffix)`   | Returns a child logger named `parent.suffix` |
| `log.setLevel(level)` | Override level for this logger               |
| `log.addHandler(h)`   | Attach a custom handler                      |

### Log levels

```matlab
logger.LogLevel.DEBUG   % 10
logger.LogLevel.INFO    % 20
logger.LogLevel.WARN    % 30
logger.LogLevel.ERROR   % 40
```

### Custom handlers

```matlab
formatter = logger.LogFormatter();
handler   = logger.FileLogHandler("logs/custom.log", "DEBUG", formatter);
log.addHandler(handler);
```

---

## Package structure

```
matlab-logger/
└── packages/
    └── +logger/
        ├── Logger.m             % Core logger class and registry
        ├── LogLevel.m           % Level constants and helpers
        ├── LogRecord.m          % Normalized log record
        ├── LogFormatter.m       % Message formatter
        ├── ConsoleLogHandler.m  % Console output handler
        ├── FileLogHandler.m     % File output handler
        ├── configure.m          % Package-level configure() shortcut
        └── getLogger.m          % Package-level getLogger() shortcut
```

---

## Log output format

```
[INFO] [14:32:01] [main.solver.freq_500] Rigid wall solution complete
[WARN] [14:32:03] [main.solver.freq_1250] Convergence slow
```

Format is configurable via `logger.LogFormatter`:

```matlab
fmt = logger.LogFormatter();
fmt.pattern = "[{level}] [{time}] [{logger}] {message}";
fmt.timestampFormat = "HH:mm:ss";
```

---

## Requirements

- MATLAB R2021b or later
- No additional toolboxes required

---

<div align="center">
  <h2>Contributing</h2>
  <p>Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.</p>
  <p>
    <sub>Made with ❤️</sub>
  </p>
</div>

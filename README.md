# TGDS Data Scope

**The Greco Data Scope**

A dependency-free, local-first browser application for monitoring and visualizing CSV data as it changes over time.

TGDS Data Scope opens a user-selected CSV file and repeatedly reads its latest values, turning an ordinary file into a live data scope. System time is used for the X axis, while numeric CSV columns become selectable live series.

> **Open a CSV. Watch the data live.**

## Run TGDS Data Scope

**[▶ Run TGDS Data Scope in your browser](https://mikejamesgreco.github.io/tgds-scope/)**

No installation is required. The GitHub Pages version runs directly in your browser. TGDS can also be downloaded as the standalone `tgds-data-scope.html` file and opened locally in a supported browser.

For live local-file monitoring, Chromium-based browsers such as Microsoft Edge and Google Chrome currently provide the broadest support for the browser File System Access API used by TGDS.

---

## Why TGDS Data Scope?

Many programs, scripts, instruments, integrations, and batch processes already know how to write CSV files.

TGDS provides a simple way to watch that data without requiring a database, application server, visualization service, framework, or development environment.

```text
Process / Instrument / Script
             │
             ▼
          data.csv
             │
             ▼
┌───────────────────────────────┐
│        TGDS Data Scope        │
│                               │
│  Poll      Plot      Inspect  │
│  Monitor   Compare   Analyze  │
│                               │
└───────────────────────────────┘
```

The process producing the CSV and the browser displaying it remain loosely coupled through an ordinary file.

---

## Core Principles

TGDS is designed around a few simple principles:

- **Local-first** — CSV data is processed in the browser.
- **Standalone application** — the application is distributed as one HTML file.
- **Zero third-party runtime dependencies** — no frameworks, CDNs, or runtime packages are required.
- **CSV-first** — ordinary CSV files remain the data source.
- **System-time visualization** — TGDS uses the current system time for the live X axis.
- **Continuous sampling** — every polling interval produces a time sample, even when the source file has not changed.
- **Browser-native APIs first** — native browser capabilities are preferred wherever practical.
- **Simple deployment** — download the HTML file or open the hosted GitHub Pages version.

---

## Getting Started

1. Open the **[hosted TGDS Data Scope](https://mikejamesgreco.github.io/tgds-scope/)** or open `tgds-data-scope.html` locally in a supported browser.
2. Choose **Open CSV**.
3. Select the CSV file you want to monitor.
4. Choose the series you want to display.
5. Choose a refresh interval.
6. Select **Start Monitoring**.

TGDS retains access to the selected file for the browser session and rereads it at the configured polling interval.

---

## CSV Format

TGDS intentionally keeps the source format simple.

Each plottable CSV column is treated as a possible series.

For example:

```csv
temperature [F],pressure [psi],voltage [V],rpm
72.1,31.2,13.8,1320
72.4,31.5,13.7,1344
72.8,31.7,13.9,1361
```

There is no required timestamp column.

TGDS uses **current system time** as the X-axis value whenever it samples the latest CSV row.

Recognizable numeric and date/time columns can be discovered as series. Units included in headings, such as `pressure [psi]`, can also be reflected in the visualization.

---

## Live Polling Model

TGDS separates **poll time** from **source-file change time**.

Suppose TGDS polls once per second but the source process only changes the CSV every five seconds.

TGDS continues advancing through time:

```text
12:00:01   50
12:00:02   50
12:00:03   50
12:00:04   50
12:00:05   72   ← source changed
12:00:06   72
12:00:07   72
```

If the file has not changed, TGDS holds the most recently observed value while system time continues advancing.

When new source data appears, the scope moves to the new value.

This makes the visualization reflect both the value being observed and how long that value persisted.

---

## Visualizations

TGDS currently provides three live visualization modes.

### Line Scope

Displays selected series as continuous traces across system time.

Useful for:

- Trends
- Sensor values
- Process measurements
- Performance counters
- Batch status values
- Continuously updated metrics

### Scatter

Displays selected series as live point streams.

Useful when individual observations are more important than continuous lines.

### Equalizer

Displays recent samples as a retro-style grouped bar visualization with peak behavior.

This provides a compact alternative view when several series are being monitored simultaneously.

---

## Leading Edge

The newest sample can enter from either side of the scope.

- **Right** — conventional timeline behavior, with newest data on the right.
- **Left** — newest data enters from the left.

The Y-axis rail follows the selected leading edge.

---

## Live Statistics

TGDS calculates live statistics for each selected series:

- Current
- Minimum
- Maximum
- Average
- Delta from the previous sample
- Rate of change per second

Statistics remain synchronized with the active monitoring session.

They are also available when using **Full Screen** and **Pop Out Graph**.

---

## Pause Display

**Pause Display** freezes the visualization for inspection without stopping the monitoring session.

TGDS continues polling and collecting samples in the background.

Selecting **Resume Display** returns the scope to the current live state.

This is intentionally different from **Stop**, which stops the polling process.

---

## Crosshair Inspection

Line Scope and Scatter support interactive crosshair inspection.

Move the pointer across the graph to inspect the nearest sampled system time and the corresponding values for the selected series.

This makes it possible to examine an earlier point without interrupting monitoring.

---

## Source Change Markers

TGDS distinguishes between:

- A polling sample
- An actual change to the source CSV

Subtle timeline markers indicate when TGDS detected that the underlying file changed.

This makes it possible to see periods where a value was simply being held between source updates.

---

## Full Screen and Pop Out

TGDS supports two expanded monitoring modes.

### Full Screen

Expands the live scope using the browser Fullscreen API and includes synchronized live statistics below the graph.

### Pop Out Graph

Opens a separate monitoring window containing the live graph and synchronized statistics.

The main TGDS window continues to own the file handle, polling timer, and sample history. The pop-out is a synchronized display rather than a separate monitoring process.

---

## Refresh and Display History

The polling refresh interval can be adjusted to match the expected rate of the source process.

TGDS also limits the number of samples retained for display so the scope can continue moving through time without indefinitely expanding the rendered history.

---

## File Monitoring

Where supported, TGDS uses the browser **File System Access API**.

After the user selects a file, TGDS retains the resulting file handle for the browser session and periodically obtains the current version of the file.

Conceptually:

```text
Open CSV
   │
   ▼
FileSystemFileHandle
   │
   ├──► getFile()
   │       │
   │       ▼
   │   latest CSV
   │
   ├──► wait
   │
   └──► getFile() again
```

This allows a separate process to continue updating the file while TGDS monitors it.

Browser security rules and capabilities still apply.

---

## Local Use

TGDS is designed so the standalone HTML file can be useful without installing an application stack.

```text
tgds-data-scope.html
```

In supported Chromium environments, the file can be opened directly from the local filesystem and use the browser's file picker to obtain access to the CSV being monitored.

No TGDS application server is required for the normal local workflow.

---

## Live Feed Test Harness and Data Collection

The repository can optionally include:

```text
tgds-live-feed.bat
```

The included Windows BAT file is a simple **test harness** for TGDS. It generates a four-column CSV and appends a new row once per second, making it easy to simulate a continuously changing external data source.

Example output:

```csv
signal_1,signal_2,signal_3,signal_4
54.64,67.82,77.51,39.99
59.16,67.29,80.05,44.91
63.42,66.42,82.08,49.72
```

A typical simulation looks like:

```text
tgds-live-feed.bat
        │
        ▼
 tgds-live-data.csv
        │
        ▼
 TGDS Data Scope
```

The harness demonstrates an important part of the TGDS design: **TGDS does not need to know where the data came from.** It only needs a CSV file that another process can create or update.

The included BAT file generates simulated values, but the same pattern can be adapted into a lightweight **data-collection harness**. Instead of generating test signals, a script or program could periodically gather values from external sources and write the latest observations to CSV for TGDS to monitor.

Potential sources include:

- Command-line utilities
- PowerShell scripts
- Local programs or services
- Instrument or device output
- Log-processing scripts
- Database queries
- REST APIs or other network services
- Operating-system or machine statistics
- Scheduled jobs and integration processes

Conceptually:

```text
External Data Sources
   │
   ├──► Device / Instrument
   ├──► REST API
   ├──► Database Query
   ├──► System Metrics
   └──► Other Program
             │
             ▼
      Collection Harness
             │
             ▼
          data.csv
             │
             ▼
      TGDS Data Scope
```

This keeps TGDS deliberately decoupled from data acquisition. The producer can be a BAT file, PowerShell script, Python program, compiled application, scheduled process, or anything else capable of maintaining a CSV file.

`tgds-live-feed.bat` is therefore both a ready-to-run simulation and a small reference implementation of the **producer → CSV → TGDS** pattern. TGDS itself does not depend on the BAT file.

---

## Repository Structure

The repository is intentionally simple.

```text
tgds-scope/
│
├── index.html              # GitHub Pages launcher
├── tgds-data-scope.html    # Standalone TGDS application
├── tgds-live-feed.bat      # Simulation / data-producer test harness
├── .gitignore
├── README.md
├── CHANGELOG.md
└── LICENSE
```

The exact structure may evolve as the project grows.

---

## Browser Support

TGDS is designed primarily for modern desktop browsers.

Chromium-based browsers such as **Microsoft Edge** and **Google Chrome** currently provide the broadest support for the browser-native file capabilities used for persistent local-file monitoring.

If the required persistent file-handle capability is unavailable, browser behavior may be more limited.

---

## Privacy

TGDS's normal monitoring workflow is local-first.

Selecting a CSV does not inherently upload that CSV to a TGDS server or cloud service. The application reads and visualizes the user-selected file in the browser.

Users should still consider the behavior of their browser, browser extensions, operating-system policies, and any external process that creates or updates the monitored file when working with sensitive information.

---

## Project Status

TGDS Data Scope has reached a feature-complete initial product state and is being prepared for its first stable public release.

The current feature set focuses deliberately on one job:

> **Monitor an ordinary CSV as live data with as little infrastructure as possible.**

Future releases may add capabilities such as rolling time windows, configurable Y-axis scaling, thresholds, alarms, history export, and additional instrumentation features while preserving the application's lightweight design.

---

## Philosophy

TGDS is intentionally small.

The goal is not to build a browser-based replacement for every monitoring, observability, or data-analysis platform.

The goal is to make an ordinary CSV surprisingly useful as a live interface between a data-producing process and a human watching it.

```text
No framework.
No package manager.
No application server.
No third-party runtime dependencies.

Just a browser, a CSV, and live data.
```

---

## License

License information will be added to the repository's `LICENSE` file.

---

## Author

**Michael J. Greco**

TGDS Data Scope — **The Greco Data Scope**

© mikejamesgreco.me LLC. All rights reserved.

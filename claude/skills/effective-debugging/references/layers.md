# Layers

Where the next fact may be, from cheapest and broadest to costliest and narrowest. Descend one layer only when every signal so far is weak, and stop at the first strong one. Take the same reading from the control. A project's own map of what it records comes first, if it has one.

| Layer | Look at | Typically shows |
|---|---|---|
| 1. Application and platform | logs, metrics, traces, errors, config, flags, deploy history, dependency health, restarts | errors, a recent deploy or flag flip, failed probes |
| 2. Network | DNS answers, connection states, handshakes, retransmits, packet captures, sidecars | unexpected answers or endpoints, churn, stalls, resets |
| 3. Filesystem and storage | files opened, read and written, I/O latency, disk space, inodes, mounts | files reloaded per request, slow I/O, full disks, stale local state |
| 4. Process and runtime | thread states, stack samples, CPU and heap profiles, GC, file descriptors, locks | blocked threads, hot functions, heap growth, leaks |
| 5. Kernel and OS | syscalls, scheduling, cgroup throttling, OOM kills, IPC | failing syscalls, throttling, scheduler delays, unanswered IPC |
| 6. Hardware and host | CPU steal, NIC drops, disk health, NUMA, thermal state | failing or slow hardware, device-specific behaviour |

## Tools by platform

| Layer | Linux and Kubernetes | macOS |
|---|---|---|
| 1 | `kubectl get events`, `kubectl describe pod`, `kubectl logs --previous` | `log show`, crash reports, `sysdiagnose`, `launchctl print` |
| 2 | `dig`, `ss --tcp --all --numeric --processes`, `tcpdump`, `conntrack` | `scutil --dns`, `nettop`, `netstat`, `tcpdump` |
| 3 | `strace --trace=file`, `inotifywait`, `iostat`, `df --inodes`, `lsof` | `fs_usage`, `lsof`, `iostat`, `diskutil` |
| 4 | `pidstat`, `top -H`, `gdb`, language stack dumps, `perf`, `pprof`, heap profilers | `sample`, `spindump`, Instruments, `leaks`, `heap`, `vmmap`, `footprint` |
| 5 | `strace`, `perf sched`, `dmesg`, `/sys/fs/cgroup`, `bpftrace`, bcc tools | `lsmp` (Mach ports: an unanswered XPC reply), `ktrace`, `powermetrics`, DTrace |
| 6 | `vmstat`, `ethtool --statistics`, `smartctl`, `numastat` | `system_profiler`, `ioreg`, `powermetrics` |

| Layer | Web front end | iOS | Android |
|---|---|---|---|
| 1 | console, error tracking, real-user monitoring, source maps | `os_log`, crash reports, MetricKit | `adb logcat`, crash and ANR reports |
| 2 | Network panel, HAR, Resource Timing, CDN logs, `chrome://net-export` | Instruments (Network), `URLSessionTaskMetrics`, a proxy | Network Inspector, a proxy |
| 3 | Application panel: cookies, IndexedDB, Cache Storage, service workers | SQLite, the app container | Database Inspector, `adb shell run-as` |
| 4 | Performance and Memory panels, heap snapshots, long tasks | Instruments (Time Profiler, Allocations, Leaks), Memory Graph | Android Studio Profiler, heap dumps, LeakCanary, StrictMode |
| 5 | Perfetto, `chrome://tracing`, `chrome://gpu` | Instruments (System Trace), jetsam and watchdog reports | Perfetto, `adb shell dumpsys`, `adb bugreport` |
| 6 | CPU and network throttling, real low-end devices | thermal reporting, real older devices | `dumpsys batterystats`, real low-end devices |

## Harness and CI

The same descent applies when the failure is in the tooling.

| Layer | Look at | Typically shows |
|---|---|---|
| 1. The job | step logs, artifacts, timings, the same job's last green run | which step moved, and when |
| 2. The tool | its own logs and verbose mode, each call's duration and exit code | a tool overrunning its own timeout, retrying silently or failing quietly |
| 3. The environment | environment variables, tool versions, paths, caches, a diff against a machine where it works | a variable pointing at an empty folder, a stale cache, a different version |
| 4. The runner | load, free memory, disk, late timers, neighbouring processes | a slow runner read as a regression |

Layers and platform tools adapted from Cindy Sridharan, [How to effectively debug when you no longer understand the code](https://copyconstruct.medium.com/how-to-effectively-debug-when-you-no-longer-understand-the-code-bd3dcb2c5f7b).

---
type: llm
focus: trace
weight: 1
---

The report's main explanation is this mechanism: #170 cached the emulator's AVD with its snapshot. Each runner's adb generates its own key, and the cached AVD trusts only the key of the runner that packed it, so every other runner is refused as unauthorized, from the snapshot and from a cold boot alike. The fix packs the adb key into the cache with the AVD and restores it with the AVD.

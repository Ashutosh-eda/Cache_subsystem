#  4-Way Set-Associative LRU Replacement Policy (Verilog)

This project implements a **True LRU (Least Recently Used)** replacement module in Verilog for a 4-way set-associative cache. It includes a **fully synthesizable RTL module** and a **self-checking SystemVerilog testbench** for functional verification using GTKWave.

🔗 **GitHub Repository**: [github.com/Ashutosh-eda/Cache_Subsystem_hardware/tree/main/lru_4way](https://github.com/Ashutosh-eda/Cache_Subsystem_hardware/tree/main/lru_4way)

---

##  Features

- ✅ **True LRU Policy**: Strict rank-based aging (0 = MRU, 3 = LRU) per set and per way
- ✅ **Post-update victim selection**: Ensures recently accessed line is never evicted
- ✅ **Parameterizable via `cache_defs.vh`**
- ✅ **Self-checking testbench** with golden model comparison
- ✅ **Waveform tracing** via `$dumpvars` (compatible with GTKWave)
- ✅ Fully synthesizable (Verilog-2001 compliant)

---




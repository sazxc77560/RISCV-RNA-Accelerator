# RISC-V Near-Memory Acceleration for RNA Sequencing

This project implements a high-performance **RNA Quantification System** on a simulated **Near-Memory Computing (NMC)** architecture using **Gem5**. It features custom RISC-V ISA extensions for hardware acceleration and SIMD processing.

## 🚀 Key Features

* **Hardware-Software Co-design**: Implemented custom RISC-V instructions (`accelerator_reduce_sum` & `vector_compare`) to offload compute-intensive tasks.
* **Performance Optimization**:
    * **Indexing**: Achieved **1-cycle latency** for K-mer hashing using a custom hardware accelerator.
    * **Quantification**: Utilized **SIMD (Vector Coprocessor)** logic to parallelize 8-byte string comparisons, significantly reducing instruction overhead.
* **Distributed System**: Developed a **Load Balancing algorithm** in C++ to distribute DNA sequences across 64 parallel logic units, minimizing execution tail latency.
* **Simulation Environment**: Validated on **Gem5 (Full System Simulator)** with **Ramulator** (DRAM simulator) integration.

## 📂 Project Structure

* `src/`: Core application logic optimized with **Inline Assembly**.
    * `index.c`: Hashing logic using `accelerator_reduce_sum`.
    * `quantify.c`: Sequence matching using `vector_compare`.
    * `distribute.cpp`: Workload distribution algorithm.
* `gem5_extension/`: Modified Gem5 ISA definitions.
    * `decoder.isa`: Custom opcode definitions for the hardware accelerator.
* `include/`: Helper functions and custom **Hash Map** implementation.

## 🛠️ Implementation Details

### Part 1: Distributed Architecture & Load Balancing
Addressed the **Memory Wall** bottleneck by processing data near DRAM. Implemented a static load balancing strategy to ensure uniform workload distribution across 64 cores.

### Part 2: Custom ISA & Hardware Acceleration
Extended the RISC-V ISA by modifying the Gem5 decoder (`decoder.isa`).
* **Instruction `0x16` (Custom Hashing)**: Replaced software-heavy XOR/Shift operations with a single-cycle hardware reduction.
* **Instruction `0x16` (SIMD Compare)**: Enabled 8-lane parallel byte comparison for K-mer matching.

## 🔧 Build & Run

Running the simulation requires a Dockerized Gem5 environment.

```bash
# Compile the distribute utility
make run_distribute

# Run Indexing Simulation (Gem5)
make run_index

# Run Quantification Simulation (Gem5)
make run_quantify

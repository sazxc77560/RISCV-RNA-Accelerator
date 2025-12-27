# Makefile for CA-FP2 project: Indexing and Quantification with Custom Instructions

# Define the RISC-V cross-compiler path
RISCV_GCC = /opt/riscv64i_vector_extension/bin/riscv64-unknown-elf-gcc

# Define Gem5 related paths
GEM5_INCLUDE = /home/gem5/include
M5_LIB = /home/gem5/util/m5/build/riscv/out/libm5.a
GEM5_OPT = /home/gem5/build/RISCV/gem5.opt
GEM5_CONFIG_SCRIPT = /home/gem5/configs/example/se.py
RAMULATOR_CONFIG = /home/gem5/configs/ramulator/LPDDR4-config.cfg

# Common Gem5 simulation arguments
GEM5_ARGS = --cpu-type=MinorCPU --cpu-clock=800MHz --mem-type=Ramulator --ramulator-config=$(RAMULATOR_CONFIG) --mem-size=256MB --caches --l1i_size=32kB --l1i_assoc=8 --l1d_size=32kB --l1d_assoc=8 --cacheline=32

# Default target
all: make_index make_quantify

# Target to compile the distribute.cpp (if needed for data preparation)
make_distribute:
	g++ -g distribute.cpp -lpthread -o distribute

# Target to run the distribute program
run_distribute:
	./distribute ../data/gencode.v43.transcripts.noN.fa ../data/queries.10K.fa 15 256 1

# Target to compile index.c for RISC-V
make_index:
	$(RISCV_GCC) -static -I $(GEM5_INCLUDE) -o index.o index.c $(M5_LIB)

# Target to run index.o in Gem5 simulator
run_index: make_index
	# Ensure index_result directory exists for output
	mkdir -p index_result
	# Run Gem5 simulation
	$(GEM5_OPT) $(GEM5_CONFIG_SCRIPT) -c index.o -o "15" $(GEM5_ARGS)
	# Clean up previous m5out and move new one
	rm -rf index_result/m5out
	mv m5out index_result/

# Target to compile quantify.c for RISC-V
make_quantify:
	$(RISCV_GCC) -static -I $(GEM5_INCLUDE) -o quantify.o quantify.c $(M5_LIB)

# Target to run quantify.o in Gem5 simulator
run_quantify: make_quantify
	# Ensure quantify_result directory exists for output
	mkdir -p quantify_result
	# Run Gem5 simulation
	$(GEM5_OPT) $(GEM5_CONFIG_SCRIPT) -c quantify.o -o "15" $(GEM5_ARGS)
	# Clean up previous m5out and move new one
	rm -rf quantify_result/m5out
	mv m5out quantify_result/

# Clean targets
clean_distribute:
	rm -f distribute
	rm -f transcripts_data.h
	rm -f query_data.h

clean_index:
	rm -f index.o
	rm -f index_result/hash-map.txt
	rm -rf index_result/m5out/

clean_quantify:
	rm -f quantify.o
	rm -f quantify_result/final_result.txt
	rm -rf quantify_result/m5out/

clean: clean_distribute clean_index clean_quantify

.PHONY: all make_distribute run_distribute make_index run_index make_quantify run_quantify clean_distribute clean_index clean_quantify clean

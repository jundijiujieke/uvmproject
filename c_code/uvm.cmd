database -open -shm uvm
probe -create -database uvm -shm -memories -all -depth all top_tb
run


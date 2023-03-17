CFLAGS= -Wall -fPIC -m64
SHARED= -shared
DIR=../mode/
FILE=uvm.shm  xcelium.d  xrun.history  xrun.log
COM=xrun  -uvm +libtext_.v +xm64bit +xmtimescale+1ns/10ps +access+r -seed $(SEED1) +xmlicq +sv -vlog_ext +.vh -disable_sem2009 \
	-F filelist.f  -y /edatools/xilinx/Vivado/2020.1/data/verilog/src/unisims +libext+.v \
	-sv_lib libdpi.so\
	-covoverwrite -coverage A -covdut imdct_fft_with_ram256 -input ./uvm.cmd

ifndef SEED1
	SEED1:=defualt-size
else
	SEED1:=$(SEED1)
endif

ifndef SIZE1
	SIZE1:=defualt-size
else
	SIZE1:=$(SIZE1)
endif

ifeq ($(SIZE1),128)
	RUN:=$(COM) +define+SIZE0 -covtest test_cov_appo0
else
	ifeq ($(SIZE1),1024)
		RUN:=$(COM) +define+SIZE1 -covtest test_cov_appo1
	else		
	endif
endif

run:libdpi.so
	$(RUN)
libdpi.so:
	$(CC) $(CFLAGS) $(SHARED) $(DIR)*.c -o libdpi.so
clean:
	$(RM) -r $(FILE) *.txt* *.so* cov_work
show:
	echo $(wildcard ./src/*.c) 
	echo $(SIZE1)
	echo $(SEED1)


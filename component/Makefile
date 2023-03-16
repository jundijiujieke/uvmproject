CFLAGS= -Wall -fPIC -m64
SHARED= -shared
DIR=../c_code/
FILE=uvm.shm  xcelium.d  xrun.history  xrun.log
COM=xrun  -uvm +libtext_.v +xm64bit +xmtimescale+1ns/10ps +access+r -seed $(SEED) +xmlicq +sv -vlog_ext +.vh -disable_sem2009 \
	-F filelist.f  -y /edatools/xilinx/Vivado/2020.1/data/verilog/src/unisims +libext+.v \
	-sv_lib libdpi.so\
	-covoverwrite -coverage B -covdut imdct_fft_with_ram256

ifndef SEED
	SEED:=defualt-size
else
	SEED:=$(SEED)
endif

ifndef SIZE
	SIZE:=defualt-size
else
	SIZE:=$(SIZE)
endif

ifeq ($(SIZE),128)
	RUN:=$(COM) +define+SIZE0 -covtest test_cov_appo0
else
	ifeq ($(SIZE),1024)
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
	echo $(SIZE)
	echo $(SEED)


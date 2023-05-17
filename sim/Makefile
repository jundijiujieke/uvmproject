CFLAGS= -Wall -fPIC -m64
SHARED= -shared
DIR=../cmodel/
DIR1=../tb/
DIR2=../filelist
FILE=uvm.shm  xcelium.d  xrun.history  xrun.log
DIR3=./
COM=xrun  -uvm +libtext_.v +xm64bit +xmtimescale+1ns/10ps +access+r -seed $(SEED1) +xmlicq +sv -vlog_ext +.vh -disable_sem2009 \
	-F $(DIR2)/rtl_filelist.f -F $(DIR2)/sv_filelist.f -y /edatools/xilinx/Vivado/2020.1/data/verilog/src/unisims +libext+.v \
	-sv_lib libdpi.so\
	-l xrun_mode$(SIZE1)_seed$(SEED1).log\
	-covoverwrite -coverage A -covdut imdct_fft_with_ram256 -input ./uvm.cmd
COM1=xrun -compile -uvm +libtext_.v +xm64bit +xmtimescale+1ns/10ps +access+r -seed $(SEED1) +xmlicq +sv -vlog_ext +.vh -disable_sem2009 \
	-F $(DIR2)/rtl_filelist.f -F $(DIR2)/sv_filelist.f -y /edatools/xilinx/Vivado/2020.1/data/verilog/src/unisims +libext+.v \
	-sv_lib libdpi.so
COM2=xrun -elaborate -uvm +libtext_.v +sv -disable_sem2009\
	 -F $(DIR2)/rtl_filelist.f -F $(DIR2)/sv_filelist.f -y /edatools/xilinx/Vivado/2020.1/data/verilog/src/unisims +libext+.v \
	 -l xrun_mode$(SIZE1)_seed$(SEED1).log \
	 -y /edatools/xilinx/Vivado/2020.1/data/verilog/src/unisims +libext+.v \
	-covoverwrite -coverage A -covdut imdct_fft_with_ram256 -input ./uvm.cmd
SIM=xrun -R

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

ifeq ($(SIZE1),128)
	COMP:=$(COM1) +define+SIZE0 
else
	ifeq ($(SIZE1),1024)
		COMP:=$(COM1) +define+SIZE1
	else		
	endif
endif

ifeq ($(SIZE1),128)
	ELAB:=$(COM2) +define+SIZE0 -covtest test_cov_appo0
else
	ifeq ($(SIZE1),1024)
		ELAB:=$(COM2) +define+SIZE1 -covtest test_cov_appo1
	else		
	endif
endif

run:libdpi.so
	$(RUN)
comp:libdpi.so
	$(COMP)
elab:
	$(ELAB)
sim:
	echo $(PATH)
	echo $(USD_HOME)
	$(SIM)
libdpi.so:
	$(CC) $(CFLAGS) $(SHARED) $(DIR)*.c -o libdpi.so
clean:	
	$(RM) -r *.so* *.txt* x*.* uvm.shm xcelium.d cov_work

show:
	echo $(wildcard ./src/*.c) 
	echo $(SIZE1)
	echo $(SEED1)



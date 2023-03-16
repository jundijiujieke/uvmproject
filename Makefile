.PHONY:component
DIR=component/

all:
	cd $(DIR) && $(MAKE) SEED=$(SEED1) SIZE=$(SIZE1)
clean:
	make -C $(DIR) clean
	$(RM) *.so* *.txt* x*.*
#$(DIR):
#	make -C $@ 

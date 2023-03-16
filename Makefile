.PHONY:component
DIR=component/

all:
	cd $(DIR) && $(MAKE) SEED1=$(SEED) SIZE1=$(SIZE)
clean:
	make -C $(DIR) clean
	$(RM) *.so* *.txt* x*.*
#$(DIR):
#	make -C $@ 

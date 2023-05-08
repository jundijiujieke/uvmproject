for ((n=0;n<1;n++))
do
make comp SIZE1=128 SEED1=`bash -c 'echo $RANDOM'` -s
make elab -s
make sim -s
#make SIZE1=1024 SEED1=`bash -c 'echo $RANDOM'` -s
done

grep TEST xrun_mode*.log

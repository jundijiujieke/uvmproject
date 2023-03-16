for ((n=0;n<2;n++))
do
make SIZE1=128 SEED1=n -s
make SIZE1=1024 SEED1=n -s
done

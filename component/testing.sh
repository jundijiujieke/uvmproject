for ((n=0;n<2;n++))
do
make SIZE=128 SEED=n -s
make SIZE=1024 SEED=n -s
done

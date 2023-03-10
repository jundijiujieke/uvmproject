for ((n=0;n<2;n++))
do
uvm -size 128 -seed n
uvm -size 1024 -seed n
done

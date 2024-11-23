day=$1
base_camp=0
a=0
b=0
c=0

for i in 0..${day}; do
  a=$((a+1))
  echo $a
  b=$((a+1))
  echo $b
  c=$((b+1))
  echo $c
done
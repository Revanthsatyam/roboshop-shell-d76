day=$1
base_camp=0
a=0
b=0
c=0

for (( i = 1; i <= day; i++ )); do
  a=$((a+1))
  b=$((a+1))
  c=$((b+1))
  max_height=$c
  base_camp=$a
  b=$base_camp
  c=$base_camp
  echo $c
done
day=$1
base_camp=0
a=0
b=0
c=0

for (( i = 1; i <= day; i++ )); do
  a=$((a+1)) #1 1 2 2
  b=$((a+1)) #2 1 3 2
  c=$((b+1)) #3 1 4 2
  if [ $i -eq ${day} ]; then
    echo "Max Height for the day is =$c"
    echo "BaseCamp for the day is =$a"
  fi
  base_camp=$a
  b=$base_camp
  c=$base_camp
done
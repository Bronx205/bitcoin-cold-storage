#! /bin/bash
echo 'Loading environment (about 20 seconds)'
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 
cd /home/pi/rails_projects/cold
clear
echo 'Starting Rails Server. This takes about 1 minute, hold on'
rails s webrick -e production &
for ((i=5;i<=60;i=i+5)) 
 do
 sleep 5
 clear
 echo 'Starting Rails Server. This takes about 1 minute, hold on'
 echo -e "$(($i*100/60))% \n"
 for ((k=1;k<=$i;k++))
  do
   echo -n '*'
 done
 echo -e "\n"
done
echo -e "\n Fasten your seat belt, CoinCooler Launching!!"
midori -e Fullscreen -a http://localhost:3000



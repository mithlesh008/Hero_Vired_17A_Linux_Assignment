#!/bin/bash
sudo groupadd writers
for i in {1..4}
do 
	sudo useradd -m devuser$i
	i=`expr $i + 1`
done

for j in {1..2}
do
	sudo usermod -aG writers devuser$i
	j=`expr $j + 1`
done

sudo chown root:writers /home/ec2-user/webapp/scripts/log_user.sh
sudo chmod 664 /home/ec2-user/webapp/scripts/log_user.sh

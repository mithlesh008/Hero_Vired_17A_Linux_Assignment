#!/bin/bash
read -p "Enter your name: " username
cat /home/ec2-user/webapp/config/app.conf
echo "Login: $username Date: $(date)" >> /home/ec2-user/webapp/logs/app.log
cat /home/ec2-user/webapp/logs/app.log

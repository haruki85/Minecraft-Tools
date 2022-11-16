#!/bin/bash

mkdir Minecraft
cd Minecraft
wget https://api.papermc.io/v2/projects/paper/versions/1.19.2/builds/270/downloads/paper-1.19.2-270.jar
mv paper-1.19.2-270.jar paper-spigot.jar
echo screen -AmdS plugin java -server -Xms2G -Xmx8G -jar paper-spigot.jar >> start.sh
echo screen -d plugin >> start.sh
sh start.sh
sleep 10

while [ -n "$(screen -list | grep -o "plugin")" ]
do
  sleep 1
done

sed -i 's/eula=false/eula=true/g' eula.txt

sh start.sh
sleep 30
screen -p 0 -S plugin -X eval 'stuff "stop\015"'

while [ -n "$(screen -list | grep -o "plugin")" ]
do
  sleep 1
done

sed -i 's/enforce-secure-profile=true/enforce-secure-profile=false/g' server.properties

sh start.sh
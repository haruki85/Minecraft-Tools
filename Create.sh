#!/bin/bash

# ↓変える場所はここだけ！
#===設定===
DIR='Minecraft'
URL='https://api.papermc.io/v2/projects/paper/versions/1.19.2/builds/270/downloads/paper-1.19.2-270.jar'
SERVER_VERSION='1.19.2-270'
MEMORY_MIN='2G'
MEMORY_MAX='8G'
SCREEN_NAME='plugin'
#=========

# ここから下ははいじらない
mkdir ${DIR}
cd ${DIR}
wget ${URL}
mv paper-${SERVER_VERSION}.jar paper-spigot.jar
echo screen -AmdS ${SCREEN_NAME} java -server -Xms${MEMORY_MIN} -Xmx${MEMORY_MAX} -jar paper-spigot.jar >> start.sh
echo screen -d ${SCREEN_NAME} >> start.sh
sh start.sh
sleep 5

while [ -n "$(screen -list | grep -o "${SCREEN_NAME}")" ]
do
  sleep 1
done

sed -i 's/eula=false/eula=true/g' eula.txt

sh start.sh
sleep 30
screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "stop\015"'

while [ -n "$(screen -list | grep -o "${SCREEN_NAME}")" ]
do
  sleep 1
done

sed -i 's/enforce-secure-profile=true/enforce-secure-profile=false/g' server.properties

sh start.sh
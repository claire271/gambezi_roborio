# Gambezi for the RoboRIO

A set of installation scripts for installing Gambezi and its dependencies to the RoboRIO.

## Steps

1. While connected to the internet on a computer (that's not the roborio)
   1. `wget https://github.com/tigerh/gambezi_roborio/archive/master.zip`
   2. `unzip master.zip`
   3. `cd gambezi_roborio-master`
   4. `./prepare.sh`

2. While connected to the RoboRIO on a computer
   1. Change the port number and IP to the RoboRIOs. Port number is usually `22` and IP is usually `10.xx.xx.2` where xxxx is your team number.
   2. `./install.sh`

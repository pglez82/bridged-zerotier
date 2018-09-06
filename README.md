# bridged-zerotier
This projects show to set up a VPN given that we have access to a Linux machine inside the network and we do not have access to the router or other network configuration.
We are going to use the free service [ZeroTier](https://www.zerotier.com).
##First step. Install and configure the ZeroTier Client
In this step we just need to follow the instructions in the ZeroTier web page. Open an ssh session to your server and type:
```
curl -s https://install.zerotier.com/ | sudo bash
```
After installing the client in the server we need to register in the [ZeroTier DashBoard](https://my.zerotier.com) and create a network. Each network has a unique ID. We will use this ID to join the devices to the virtual network. 
To join a device to a network we have to type:
```
zerotier-cli join networkid
```
Remember that the networkid are the number code that you get in the web interface after creating the network
Once that our server inside the network is joined to the virtual network it should appear in the web interface and we should authorize it under the members section. For the server we also need to tick the Allow Ethernet Bridging and Do Not Auto-Assign IPs (only for the server). We also need to type the network address of the server in Managed Ips. 
For the rest of the clients that will join the network we need to configure which IPs are they going to get. We should configure this in the IPv4 Auto-Assign section. For instance my network has the following configuration.
```
vpn server ip 192.168.3.251
network 192.168.3.0
gateway 192.168.3.1
ips for vpn clients 192.168.3.221-192.168.3.250
```
In the Managed Routes we should type (for my case scenario) 192.168.3.0/24, because that is the network I want to access.
##Second step. Configure the bridge.
We need to configure a bridge in order to be able to access the local network resources. For that we need to install in the server the package bridge-utils.
```
apt-get install bridge-utils
```
Edit the script bridge-start being carefull when adjusting the values of LAN_INT, BR_INT, ZT_INT, BRIDGE_IP and GATEWAY_IP. We can use ifconfig to get the first LAN_IT and ZT_INT. 
We can move know this script and the other (that we do not need to modify to an appropiate directory.
```
mv bridge-start /usr/local/bin
mv make-tap /usr/local/bin
mv startvpn.sh /usr/local/bin
```
Set the execution flag to all the scripts using chmod +x scriptname
Now we are going to use crontab to start our script after rebooting (maybe it would have been better to create another service, but this is simpler).
```
crontab -e
```
Write in the last line
```
@reboot  /usr/local/bin/startvpn.sh
```
Reboot the server and check with ifconfig that it creates all the interfaces (eth0, br0, zt.. and lo).
Now you only need to install the zerotier client in other computers and simply join them to the same network. You should have access to all the 192.168.3.0 network and its services.



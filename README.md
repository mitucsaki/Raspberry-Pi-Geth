# Step-by-Step guide for Raspberry-Pi Geth

In this guide, I will show the steps to properly install a working geth client on raspberry pi model 3.
This guide will focus on implementing geth-v1.8.1 from ground 0.

## Prerequisites

You must have an image of Raspi-Lite downloaded on your RaspberryPi-3. The Lite OS does not include the desktop and is required as we need as much space as possible.

In addition, you must have the following:
* Minimum 32GB SD card (64GB recommended for non-light clients)
* Laptop with SD Card Slot
* Ethernet cable and available LAN slot
* Keyboard
* HDMI Cable and an available monitor

If you already have a working OS with 32GB and SSH connection, skip here:

## Preparing the OS

Download the latest image of Raspbian Strech Lite:https://www.raspberrypi.org/downloads/raspbian/
 
Since we are running a compute node, we need the minimal version without the GUI and the software associated with it. This will give the OS more space to load the blockchain.
### Flash the image with Etcher 

Etcher is a simple software that will flash the image to the SD card:https://etcher.io/

Flash the Raspbian-Lite zip file to the SD card and plug the mini-SD card in the Raspberry-Pi.

### Set-up the OS
Connect the device into your monitor with the HDMI cable and plug the keyboard in. Log in with the following credentials:

username: *pi*<br> password: *raspberry*

Change into super user:

    sudo su
From there we need to enable SSH and set-up the file system:

    raspi-config 
    
From there the menu will pop up. The following things need to be changed:
* Select 1 -- Change the password to something you choose
* Select 2 -- Change the hostname to something else (ex: pi-geth)
* Select 5 -- Select SSH and then select Enable
* Select 7 -- Select Expand Filesystem
* Select Finish and reboot

### Set-up static IP 

We need to ensure that the node is always connected to the internet and will maintain the same IP in order for consistency and for us to be able to easily remote in. 
After the reboot navigate to the following file:

    sudo su
    nano /etc/dhcpcd.conf
    
Here we will see the settings Raspbian uses to get an IP address through DHCP. We will disable DHCP and Wi-FI and enable static addressing:

Navigate to the following section. Change the values to the appropriate ones for your network:

```
# Example static IP configuration:
interface eth0
static ip_address=NODEIP/24
static routers=GATEWAYIP
static domain_name_servers=GATEWAYIP 8.8.8.8 
```

Here is what mine looks like:

```
# Example static IP configuration:
interface eth0
static ip_address=192.168.1.120/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8 
```

Save the file with Ctrl+X then pressing Y to save

Finally, disable Wi-Fi in the following file:

    nano /boot/config.txt
     
Navigate to the bottom and add this line:
     
    dtoverlay=pi3-disable-wifi
    
Save the file with Ctrl+X then pressing Y to save and finally reboot:
  
    reboot
    
### Verify SSH

Once the device has restarted change to super user and verify ssh status:

    sudo su
    systemctl status ssh

If the following shows up the service is active:

```bash
● ssh.service - OpenBSD Secure Shell server
   Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue
```
If you are on MacOS, open a terminal session, if you are on windows download a terminal session such as PuTTY: https://www.putty.org/

Start the connection and log in with with 'pi' as the username and the password you changed earlier. If the connection is established SSH is now working and you no longer need the monitor and keyboard, as the Pi will be managed remotely now.


If the service does not say active, double check your dhcpcd.conf file and make sure the interface is correct and the IP addressing is proper.

## Updating and Installing Go-lang

Once you are connected to your Pi via SSH, start updating the repositories and the OS packages:
     
     sudo su
     apt-get -y update
     apt-get -y upgrade
     
Change into the root directory:

     cd

From there, install git and clone this repo to download the installer script:

    apt-get -y install git
    git clone https://github.com/mitucsaki/Raspberry-Pi-Geth.git
    
The script will install the latest version of go-lang. Using the command 'apt-get install golang' will not install the newest version of the language, which is what we need to run geth properly. Thus, the script will download and set it up automatically.
Change into the directory and run the script:

     cd Raspberry-Pi-Geth
     chmod +x install-go.sh
     ./install-go.sh

Once the script is finished run the following command in order to use go immediately  

    source ~/.bashrc
    
Finally, verify go is working by checking the version:

     go version
     
You should now have go installed and working properly:

    root@pi-geth:~/Raspberry-Pi-Geth# go version
    go version go1.9.3 linux/arm
 
## Installing and running geth

The geth-install.sh script will automatically download the packages needed for geth and automatically set up the client.
Run the script:

    chmod +x geth-install.sh
    ./geth-install.sh

This will take some time...

### OPTIONAL: Create geth alias

I created an alias so I can run geth without needing to be in the directory.
To do this, open .bashrc and add this to the bottom.

    nano ~/.bashrc
    alias geth='/root/go-ethereum/build/bin/geth'
    
Save and source:
    
    source ~/.bashrc
    
### Install tmux

Once the client starts, it will begin showing the blocks received and current status as the node begins to sync up to the network. 
This data is received per terminal session, so if we lose connection we won't be able to see what is happening unless we stop and start the client again.

In order to prevent this, I use tmux, which creates a session stored directly in the kernel allowing us to access it even if we lose connection to the node.
This is also useful if we want to check the status after a few days, without needing to keep the terminal open.

Install and create a tmux session:

    apt-get -y install tmux
    tmux new -s geth

Now we are in a new session that we can access later like this:

    tmux attach -t geth

### Start geth

The geth client can be run in three instances with a few parameters:

* Normal Sync (Will not sync on the Pi, needs much processing power and storage)
    * Syncs the full blockchain(block headers, block bodies and validates everything from genesis block)
* Fast Sync (Will work properly, but you need more than 32 GB)
    * Syncs the full blockchain, however it will not process transactions until the current block
* Light Sync (Preferred as light clients are needed right now, will have enough storage and compute power)
    * Syncs directly to the last few blocks, does not store the whole blockchain in database

If you have a 64GB SD card, you can run a '--fast' sync, however I tried it with 32GB SD card and it is just not enough. The current blockchain was 29GB at block 4.5mil. Current block is over 5 million.

Geth also has a '--cache' parameter which specifies the amount of RAM the client can use. I tested this and it really varies. The default is 128.

Start the client in tmux:

    geth --light --cache=128
    
The client will start showing the following output:

```
root@pi-geth:~# geth --light --cache=128
INFO [02-28|00:01:31] Maximum peer count              ETH=0 LES=100 total=25
INFO [02-28|00:01:31] Starting peer-to-peer node              instance=Geth/v1.8.2-unstable-b574b577/linux-arm/go1.9.3
INFO [02-28|00:01:31] Allocated cache and file handles         database=/root/.ethereum/geth/lightchaind
INFO [02-28|00:06:55] Imported new block headers               count=2048 elapsed=13.024s number=5054847 hash=30dd61…c2673e ignored=0
```

Let the client start syncing. You can close this terminal and always attack it back with:

    tmux attach -t geth

### Check Status

After the client runs, you can attach the geth console and check the status such as:

* Peers connected
* Current Block
* Network Status

Attach the console with the following command:

    geth attach
    
Here are some common commands:

    eth.syncing
    
This command will say 'false' if the node is synced. Otherwise it will show the current block:
```bash
> eth.syncing
{
  currentBlock: 5046655,
  highestBlock: 5169504,
  knownStates: 0,
  pulledStates: 0,
  startingBlock: 5046271
}
```



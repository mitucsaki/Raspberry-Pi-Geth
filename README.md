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

username: pi<br> password: raspberry

Change into super user:

    sudo su
From there we need to enable SSH and set-up the file system:

    raspi-config 
    
There go to

### Verify SSH
If you are on MacOS, open a terminal session, if you are on windows download a terminal session such as PuTTY: https://www.putty.org/

Start the connection and log in with with 'pi' as the username and the password you changed earlier. If the connection is established SSH is now working and you no longer need the monitor and keyboard, as the Pi will be managed remotely now.

If the connection fails, type:
     
    systemctl status ssh

If the service says active, double check your dhcpcd.conf file and make sure the interface is correct and the IP addressing is proper.

## Updating and Installing Go-lang

Once you are connected to your Pi via SSH, start updating the repositories and the OS packages:
     
     sudo su
     apt-get update
     apt-get upgrade
     
Change into the root directory:

     cd

From there, install git and clone this repo to download the installer script:

    apt-get install git
    git clone
    
The script will install the latest version of go-lang. Using the command 'apt-get install golang' will not install the newest version of the language, which is what we need to run geth properly. Thus, the script will download and set it up automatically.

The script will also install the following packages needed for geth: 

Change into the directory and run the script:

     cd 
     chmod +x 
     ./

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds




# Grab config.txt file. This applies the overlay, sets up the green heartbeat blinky light,
# and enables the shutdown button

wget https://github.com/mthoren-adi/rpi_setup_stuff/raw/main/phaser/config_phaser.txt
mv config_phaser.txt config.txt
sudo mv /boot/config.txt /boot/config_original.txt
sudo cp config.txt /boot/

# Set up udev rule for PlutoSDR. When a PlutoSDR is connected, a second instance of iiod
# is launched, sharing the PlutoSDR over port 12345.
# This rule is tolerant of connecting the Pluto after boot, and disconnecting / reconnecting.
wget https://github.com/mthoren-adi/rpi_setup_stuff/raw/main/phaser/iiod-usb@.service
wget https://github.com/mthoren-adi/rpi_setup_stuff/raw/main/phaser/89-pluto.rules

sudo cp iiod-usb@.service /etc/systemd/system/
sudo cp 89-pluto.rules /etc/udev/rules.d/

# Grab hosts and hostname files with hostname set to "phaser". This
# distinguishes the phaser setup from other ADI hardware setups using the
# default hostname of "analog"
wget https://github.com/mthoren-adi/rpi_setup_stuff/raw/main/phaser/hosts_phaser
wget https://github.com/mthoren-adi/rpi_setup_stuff/raw/main/phaser/hostname_phaser
mv hosts_phaser hosts
mv hostname_phaser hostname

sudo mv /etc/hosts /etc/hosts_orig
sudo mv /etc/hostname /etc/hostname_orig
sudo cp hosts /etc/
sudo cp hostname /etc/


# Grab handy script for updating Pluto to AD9361 mode:
wget https://github.com/mthoren-adi/rpi_setup_stuff/raw/main/phaser/pluto_update_ad9361.sh
chmod +x pluto_update_ad9361.sh


cd ~
# This is still necessary as of April, 2023.
# Uninstall existing pyadi-iio, reinstall pyadi-iio phaser development branch from source:
sudo pip3 uninstall -y pyadi-iio
git clone https://github.com/analogdevicesinc/pyadi-iio.git
cd pyadi-iio
git checkout phaser
sudo pip install .

cd ~

# As of Kuiper 2021_r2, this is still necessary for some of the phaser scripts:
sudo pip install pyqtgraph --upgrade

sudo ldconfig

# Handy for ssh-ing into an attached Pluto:
sudo apt-get install sshpass

# Grab Pluto firmware while we're here:
wget https://github.com/analogdevicesinc/plutosdr-fw/releases/download/v0.35/plutosdr-fw-v0.35.zip

echo "Done setting up SD card! A reboot is probably in order, sor run 'sudo reboot'"
echo "IF you are very sure you're only going to be operating headless or by command line and want to speed the boot / shutdown process, run:"
echo "sudo systemctl disable x11vnc.service" 
echo "And then set the Pi to boot to CLI in either the GUI or CLI Raspi-config tool."

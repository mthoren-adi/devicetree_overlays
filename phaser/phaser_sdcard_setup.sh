wget https://github.com/mthoren-adi/rpi_setup_stuff/raw/main/phaser/config_phaser.txt
mv config_phaser.txt config.txt
sudo mv /boot/config.txt /boot/config_original.txt
sudo cp config.txt /boot/

##### as of libiio 0.24 included in Kuiper 2021_r2, this is NOT necessary:
#git clone https://github.com/analogdevicesinc/libiio.git
#git checkout master
#cd libiio
#mkdir build && cd build && cmake -DWITH_SYSTEMD=ON -DPYTHON_BINDINGS=ON -DWITH_HWMON=ON -DWITH_MAN=ON -DWITH_EXAMPLES=ON ../ && make && sudo make install
# sudo reboot


##### As of Kuiper 2021_r1, this is NOT necessary (included in /boot/overlays)
#wget https://github.com/mthoren-adi/devicetree_overlays/raw/main/rpi-cn0566.dtbo
#sudo cp rpi-cn0566.dtbo /boot/overlays
# sudo reboot

cd ~
# This is still necessary as of January, 2023.
# Uninstall existing pyadi, reinstall from source:
sudo pip3 uninstall -y pyadi-iio
git clone https://github.com/analogdevicesinc/pyadi-iio.git
cd pyadi-iio
git checkout cn0566_dev
sudo python3 setup.py install

sudo ldconfig

sudo pip install pyqtgraph

# Handy for ssh-ing into an attached Pluto:
sudo apt-get install sshpass

# Grab Pluto firmware while we're here:
wget https://github.com/analogdevicesinc/plutosdr-fw/releases/download/v0.35/plutosdr-fw-v0.35.zip

echo "Done setting up SD card! A reboot is probably in order, sor run 'sudo reboot'"
echo "IF you are very sure you're only going to be operating headless or by command line and want to speed the boot / shutdown process, run:"
echo "sudo systemctl disable x11vnc.service" 
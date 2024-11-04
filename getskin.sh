DEST=/home/tricky/docker/weewx


## Belchertown skin local install
cd /var/tmp
wget https://github.com/poblabs/weewx-belchertown/releases/download/weewx-belchertown-1.3.1/weewx-belchertown-release.1.3.1.tar.gz
tar zxvf weewx-belchertown-release.1.3.1.tar.gz
cd weewx-belchertown-master
cp -r skins/Belchertown $DEST/skins
cp -r bin/user/belchertown.py $DEST/usrbin/belchertown.py
cd /var/tmp
rm -rf weewx-belchertown-release.1.3.1.tar.gz weewx-belchertown-master

# Tricky Configuration of the skin

cd /var/tmp
wget -O weewx-skin.zip https://github.com/seehase/neowx-material/archive/refs/heads/master.zip
unzip weewx-skin.zip
cd neowx-material-master
cp -r src $DEST/skins/neowx-material
cp bin/user/historygenerator.py $DEST/usrbin/historygenerator.py
cd /var/tmp
rm -rf weewx-skin.zip neowx-material-master


# Tricky Configuration of skin


## Get the gw1000 driver
cd /var/tmp
git clone https://github.com/gjr80/weewx-gw1000.git
cp weewx-gw1000/bin/user/gw1000.py $DEST/usrbin/gw1000.py
rm -rf weewx-gw1000

exit



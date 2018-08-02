## Build Python 2.7.15 from source for Steam Link devices.

You may first need to install a few of these packages if you don't have them installed already, on Debian/Ubuntu based distros run:
```
sudo apt-get install automake autopoint build-essential cmake curl doxygen gawk git gperf libcurl4-openssl-dev libtool swig unzip zip zlib1g-dev wget pkg-config python
```
## Building Python:
```
cd /some/place/steamlink-sdk/examples
git clone https://github.com/as42165/steamlink-python.git
cd steamlink-python
source ../../setenv.sh
chmod +x build_steamlink.sh
./build_steamlink.sh
```
## Installing Python on the Steam Link:
```
cd /some/place/steamlink-sdk/examples/steamlink-python
scp steamlink-python.tar.gz root@steamlinkip:/usr/local/steamlink-python.tar.gz
ssh root@steamlinkip
cd /usr/local
tar -xvf steamlink-python.tar.gz
```
## Installing pip:
```
python -m ensurepip
pip install --upgrade pip
```

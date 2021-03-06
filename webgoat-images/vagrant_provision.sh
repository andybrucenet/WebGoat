#!/usr/bin/env bash
set -e

echo '*'
echo '*'
echo '*'
echo "Setting locale..."
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

echo '*'
echo '*'
echo '*'
echo 'Initial update...'
sudo kill -9 $(lsof -t /var/lib/dpkg/lock) || true
sudo apt-get update
sudo apt-get install -y git

echo '*'
echo '*'
echo '*'
echo "Installing required packages..."
sudo apt-get install -y -q build-essential autotools-dev automake pkg-config expect


echo '*'
echo '*'
echo '*'
echo "Installing Chrome..."
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install -y google-chrome-stable

## Java 8
echo '*'
echo '*'
echo '*'
echo "Provisioning Java 8..."
mkdir -p /home/vagrant/java
cd /home/vagrant/java
test -f /tmp/jdk-8-linux-x64.tar.gz || curl -s -L --cookie "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.tar.gz -o /tmp/jdk-8-linux-x64.tar.gz

sudo mkdir -p /usr/lib/jvm
sudo tar zxf /tmp/jdk-8-linux-x64.tar.gz -C /usr/lib/jvm

sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_101/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_101/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.8.0_101/bin/javaws" 1

sudo chmod a+x /usr/bin/java
sudo chmod a+x /usr/bin/javac
sudo chmod a+x /usr/bin/javaws
sudo chown -R root:root /usr/lib/jvm/jdk1.8.0_101

echo "export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_101" >> /home/vagrant/.bashrc

## Maven
echo '*'
echo '*'
echo '*'
echo "Installing Maven.."
sudo apt-get install -y maven

## ZAP
echo '*'
echo '*'
echo '*'
echo "Provisioning ZAP..."
cd /home/vagrant
mkdir tools
cd tools
wget -q https://github.com/zaproxy/zaproxy/releases/download/2.5.0/ZAP_2.5.0_Linux.tar.gz
tar xfz ZAP_2.5.0_Linux.tar.gz
rm -rf ZAP_2.5.0_Linux.tar.gz

## IntelliJ
echo '*'
echo '*'
echo '*'
echo "Provisioning IntelliJ..."
cd /home/vagrant/tools
wget -q https://download.jetbrains.com/idea/ideaIC-2016.1.4.tar.gz
tar xfz ideaIC-2016.1.4.tar.gz
rm -rf ideaIC-2016.1.4.tar.gz

## Eclipse
echo '*'
echo '*'
echo '*'
echo "Provisioning Eclipse..."
sudo apt-get -y install eclipse


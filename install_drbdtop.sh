#!/bin/bash
# Author: Joe R
# Organization: Hostdime Inc.
# Date: [ 10-04-2017 ]
# Description: [ This script installs drbdtop on CentOS 7 ]
# Version: 0.2 -- BETA
# Logic: [ Check prereqs (wget, golang & git) and download sources and install binaries and include them in $PATH ]
# TODO: [ Create OS and Pre-req checks, download sources, place binaries where they need to go, set PATH ]

# OS and wget check
OS=$(cat /etc/redhat-release | cut -d. -f1 | sed s'/Linux release //')

if [[ $OS =~ ^CentOS* ]]; then
  if ! [[ -f /usr/bin/wget ]]; then
    echo "Installing wget"
    yum install wget -y
  fi
  if ! [[ -f /usr/bin/git ]]; then
    echo "Installing git"
    yum install git -y
  fi
  echo "Starting installation  in 3 seconds."
  sleep 3
else
  echo -e "\e[31m!!!! This server is not running the CentOS Operating System!!!\e[0m"
  echo ""
  echo -e "\e[33mThis script is only compatiable with CentOS.\e[0m"
  exit 1;
fi

# Download and setup golang binary

cd /tmp && wget https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz

tar -C /usr/local/ -xvf go1.9.linux-amd64.tar.gz

# Install drbdtop

if [[ -f /usr/local/go/bin/go ]]; then
  /usr/local/go/bin/go get github.com/linbit/drbdtop
else
  echo -e "\e[33mGolang binary not found!!!\e[0m"
  exit 1;
fi

if [[ -f /root/go/bin/drbdtop ]]; then
  mv /root/go/ /opt
else
  echo -e "\e[33mdrbdtop binary not found!!!\e[0m"
  exit 1;
fi


if [[ -d /opt/go/bin/ ]]; then
  echo "export PATH=$PATH:/opt/go/bin/:/usr/local/go/bin" >> /etc/profile
  source /etc/profile
else
  echo -e "\e[33mdrbdtop binary is missing from /opt"
  exit 1;
fi

# Inform user drbdtop is installed
if [[ -f /opt/go/bin/drbdtop ]]; then
  echo -e "\e[32mdrbdtop is now installed. You can start it by running the "drbdtop" command.\e[0m"
  exit 1;
fi

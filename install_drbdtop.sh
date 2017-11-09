#!/bin/bash
# Author: Joe R
# Organization: Hostdime Inc.
# Date: [ 10-04-2017 ]
# Description: [ This script installs drbdtop on CentOS 7 ]
# Version: 0.3 -- BETA
# Logic: [ Check prereqs (wget, golang & git) and download sources and install binaries and include them in $PATH ]


# Inform user drbdtop is installed
if [[ -f /usr/local/go/src/github.com/linbit/drbdtop/drbdtop ]]; then
  echo -e "\e[32mdrbdtop is already installed. You can start it by running the "drbdtop" command.\e[0m"
  exit 1;
fi

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

if [[ -f /tmp/go1.9.linux-amd64.tar.gz ]]; then
  echo "golang source already downloaded..."
  cd /tmp
else
  cd /tmp && wget --no-check-certificate https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz
fi

tar -C /usr/local/ -xvf go1.9.linux-amd64.tar.gz && cd

# Add go binary to PATH

if [[ -d /usr/local/go ]]; then
  echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
  source /etc/profile
else
  echo -e "\e[33mgolang binary missing and cannot be sourced! \e[0m"
fi

# Install drbdtop

if [[ -f /usr/local/go/bin/go ]]; then
  /usr/local/go/bin/go get github.com/linbit/drbdtop
  /usr/local/go/bin/go build github.com/linbit/drbdtop
  cd /root/go/src/github.com/linbit/drbdtop/
  make build
  cd
else
  echo -e "\e[33mGolang binary not found!!!\e[0m"
  exit 1;
fi

if [[ -f /root/go/src/github.com/linbit/drbdtop/drbdtop ]]; then
  mv /root/go/src/github.com/ /usr/local/go/src/
  mv /root/drbdtop /tmp/
  mv /root/go/ /tmp/go_drbd_bin
else
  echo -e "\e[33mdrbdtop binary not found!!!\e[0m"
  exit 1;
fi


if [[ -d /usr/local/go/src/github.com/linbit/drbdtop/ ]]; then
  echo "export PATH=$PATH:/usr/local/go/bin:/usr/local/go/src/github.com/linbit/drbdtop" >> /etc/profile
  source /etc/profile
else
  echo -e "\e[33mdrbdtop binary is missing from /usr/local/go/ \e[0m"
  exit 1;
fi

# Inform user drbdtop is installed
if [[ -f /usr/local/go/src/github.com/linbit/drbdtop/drbdtop ]]; then
  echo -e "\e[32mdrbdtop is now installed. You can start it by running the "drbdtop" command.\e[0m"
  echo -e "\e[33mYou may have have to logout and log back in to reload you PATH.\e[0m"
  exit 1;
fi

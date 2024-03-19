#!/bin/bash

# Update system
sudo yum -y update

# Install required packages
sudo yum install -y \
    epel-release yum-utils \
    ncurses ncurses-devel wget git \
    gcc gcc-c++ make
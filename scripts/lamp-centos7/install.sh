#!/bin/bash

echo "Running pre install..."
chmod +x ./preinstall.sh

echo "Running php installation..."
chmod +x ./php54_insall.sh
./php54_install.sh

echo "Running Apache installation..."
chomd +x ./apache_install.sh
./apache_install.sh

echo "Running MySQL installation..."
chmod +x ./mysql_install.sh
./mysql_install.sh
#!/bin/bash

# Create MySQL group and user
groupadd mysql
useradd -g mysql mysql

# Download and extract MySQL source
wget https://cdn.mysql.com//Downloads/MySQL-5.1/mysql-5.1.73.tar.gz
tar -zxvf mysql-5.1.73.tar.gz
cd mysql-5.1.73

# Configure MySQL installation
sudo ./configure  '--prefix=/usr/local/mysql' '--without-debug' '--with-charset=utf8' '--with-extra-charsets=all' '--enable-assembler' '--with-pthread' '--enable-thread-safe-client' '--with-mysqld-ldflags=-all-static' '--with-client-ldflags=-all-static' '--with-big-tables' '--with-readline' '--with-ssl' '--with-embedded-server' '--enable-local-infile' '--with-plugins=innobase'

# Compile and install MySQL
sudo make
sudo make install

# Copy configuration files
sudo cp support-files/my-small.cnf /etc/my.cnf
sudo cp -r support-files/mysql.server /etc/init.d/mysqld

# Add MySQL service to system startup
sudo chkconfig --add mysqld

# Change ownership of MySQL installation directory
sudo chown -R mysql:mysql /usr/local/mysql

# Install MySQL system tables
sudo /usr/local/mysql/bin/mysql_install_db --user=mysql

# Add executable permission to MySQL init script
sudo chmod +x /etc/init.d/mysqld

# Start MySQL service
sudo /etc/init.d/mysqld start

# Directory where MySQL binaries are installed
mysql_bin_dir="/usr/local/mysql/bin"

# Check if the directory exists
if [ -d "$mysql_bin_dir" ]; then
    # Add MySQL bin directory to PATH if it's not already present
    if [[ ":$PATH:" != *":$mysql_bin_dir:"* ]]; then
        echo "Adding MySQL bin directory to PATH..."
        echo "export PATH=\$PATH:$mysql_bin_dir" >> ~/.bashrc
        # Apply changes to the current shell session
        source ~/.bashrc
        echo "MySQL bin directory added to PATH."
    else
        echo "MySQL bin directory is already in PATH."
    fi
else
    echo "Error: MySQL bin directory ($mysql_bin_dir) not found."
    echo "Please check the installation directory."
    exit 1
fi

# Source the .bashrc file to ensure changes take effect
source ~/.bashrc

# Change directory to MySQL installation directory
cd /usr/local/mysql

# Run MySQL secure installation script
sudo ./bin/mysql_secure_installation
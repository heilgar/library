# PHP 5.4, Apache, MySQL 5 installation scripts for CentOS 7

## Scripts
1. `install.sh` - run all scripts
2. `preinstall.sh` - update os packages and install required
3. `php54_install.sh` - install php5.45 on CentOS
4. `apache_install.sh` - install apache 
5. `myql_install.sh` - install mysql 5.1.73 from sources on CentOS 

## Commands
All scripts must be executed with the privileges of the `sudo` user.

### Run all
1. `chmod +x install.sh`
2. `sudo ./install.sh`

### Change file permissions
`chmod +x <file>`

### Run single script
`sudo ./<file>`

### Display temporary password for MySQL root user
`sudo grep 'temporary password' /var/log/mysqld.log`

### Secure MySQL installation
`sudo mysql_secure_installation`


## Service commands

### MySQL service
`sudo /etc/init.d/mysqld start`
`sudo /etc/init.d/mysqld status`
`sudo /etc/init.d/mysqld stop`


### Start Apache HTTP Server
`sudo systemctl start httpd`

### Enable Apache HTTP Server to start on boot
`sudo systemctl enable httpd`
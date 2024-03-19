#!/bin/bash

# Install Webtatic Repository
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum-config-manager --enable rem
yum --enablerepo=remi update php\*

# Install PHP 5.4
yum install -y php php-cli

# Enable PHP modules
modules=(
    curl
    dom
    fileinfo
    gd
    gmp
    imap
    json
    mbstring
    memcache
    mysql
    mysqli
    pdo
    pdo_mysql
    pdo_sqlite
    phar
    posix
    soap
    sqlite3
    sysvmsg
    sysvsem
    sysvshm
    wddx
    xmlreader
    xmlwriter
    xsl
    zip
)

for module in "${modules[@]}"
do
    yum install -y php-$module
    echo "extension=$module.so" | tee /etc/php.d/${module}.ini
done

# Restart Apache or Nginx (if applicable)
# systemctl restart httpd    # For Apache
# systemctl restart nginx    # For Nginx

echo "PHP 5.4 installed and modules enabled."
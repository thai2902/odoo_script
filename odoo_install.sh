#!/bin/bash
sudo adduser --system --quiet --shell=/bin/bash --home=/opt/odoo --gecos 'odoo' --group odoo
sudo mkdir /etc/odoo && sudo mkdir /var/log/odoo/
sudo apt-get update 
sudo apt-get upgrade -y 
sudo apt-get install postgresql postgresql-server-dev-9.3 build-essential python-imaging python-lxml python-ldap python-dev libldap2-dev libsasl2-dev npm nodejs git python-setuptools libxml2-dev libxslt1-dev libjpeg-dev python-pip gdebi -y
git clone --depth=1 --branch=8.0 https://github.com/odoo/odoo.git /opt/odoo/odoo
sudo chown odoo:odoo /opt/odoo/ -R 
sudo chown odoo:odoo /var/log/odoo/ -R
cd /opt/odoo/odoo
sudo pip install -r requirements.txt
sudo npm install -g less less-plugin-clean-css -y
sudo ln -s /usr/bin/nodejs /usr/bin/node
cd /tmp 
wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb 
sudo gdebi -n wkhtmltox-0.12.2.1_linux-trusty-amd64.deb 
sudo rm wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin/
sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin/
wget -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz 
sudo gunzip GeoLiteCity.dat.gz 
sudo mkdir /usr/share/GeoIP/ 
sudo mv GeoLiteCity.dat /usr/share/GeoIP/
sudo su - postgres -c "createuser -s odoo"
sudo su - odoo -c "/opt/odoo/odoo/odoo.py --addons-path=/opt/odoo/odoo/addons -s --stop-after-init"
sudo mv /opt/odoo/.openerp_serverrc /etc/odoo/openerp-server.conf
sudo cp /opt/odoo/odoo/debian/init /etc/init.d/odoo
sudo chmod +x /etc/init.d/odoo
sudo ln -s /opt/odoo/odoo/odoo.py /usr/bin/odoo.py
sudo update-rc.d -f odoo start 20 2 3 4 5 .
sudo service odoo start

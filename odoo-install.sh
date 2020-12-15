#!/bin/bash
echo -------------------- Script de Instalacion de Odoo --------------------

# just follow these steps
read -p "Elija la version de odoo a instalar (ej: 12.0, 13.0, 14.0): " version

# Install PostgreSQL y complementos
sudo apt-get install postgresql -y
sudo apt-get install python3-pip libldap2-dev libsasl2-dev wkhtmltopdf

#Install Python
pip3 install num2words xlwt pyldap vobject qrcode

# Add Odoo Key
wget -O - https://nightly.odoo.com/odoo.key | apt-key add -

# Add Odoo Repository
echo "deb http://nightly.odoo.com/$version/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list

# Update and install
apt-get update && apt-get install odoo




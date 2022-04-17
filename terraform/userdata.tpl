#!/bin/bash
sudo apt update -y &&
sudo apt install -y nginx
echo "Hello World from $(hostname -f)" > /var/www/html/index.html
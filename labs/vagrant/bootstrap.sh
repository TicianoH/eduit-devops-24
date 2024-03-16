#!/usr/bin/env bash
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
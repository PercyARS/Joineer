#!/usr/bin/env bash
sudo apt update
sudo apt install python3.5
sudo apt install python3.5-dev
sudo apt install python3.5-venv
wget https://bootstrap.pypa.io/get-pip.py
sudo python3.5 get-pip.py
sudo ln -s /usr/bin/python3.5 /usr/local/bin/python3
sudo ln -s /usr/local/bin/pip /usr/local/bin/pip3

pip3.5 install MarkupSafe
pip3.5 install pymongo
pip3.5 install pytz
pip3.5 install Flask
pip3.5 install aniso8601
pip3.5 install six
pip3.5 install Werkzeug
pip3.5 install wheel
pip3.5 install Flask-PyMongo
pip3.5 install flask_restful
pip3.5 install itsdangerous

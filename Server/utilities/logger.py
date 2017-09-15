__author__ = 'Peixi Zhao'

import logging
from logging.handlers import RotatingFileHandler
import sys
import os

'''
    Set up python logger
'''


'''
    Create log dir if not exist
'''
if not os.path.exists("log"):
    os.makedirs("log")


def get_logger(name):
    formatter = logging.Formatter(fmt='%(asctime)s - %(levelname)s - %(threadName)s - [%(module)s] - %(message)s')
    console_handler = logging.StreamHandler(sys.stdout)
    file_handler = RotatingFileHandler('log/Server.log', maxBytes=100000000, backupCount=1)
    console_handler.setFormatter(formatter)
    file_handler.setFormatter(formatter)
    console_handler.setLevel(logging.INFO)
    file_handler.setLevel(logging.DEBUG)
    logger = logging.getLogger(name)
    logger.addHandler(console_handler)
    logger.addHandler(file_handler)
    logger.setLevel(logging.DEBUG)
    return logger

'''
    Set up flask app logger
'''


def get_flask_logger(logger):
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'))
    console_handler.setLevel(logging.INFO)
    logger.addHandler(console_handler)
    # max log size of 100 mb, no rotation needed
    file_handler = RotatingFileHandler('log/Server.log', maxBytes=100000000, backupCount=1)
    file_handler.setFormatter(logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'))
    file_handler.setLevel(logging.DEBUG)
    logger.addHandler(file_handler)
    logger.setLevel(logging.DEBUG)
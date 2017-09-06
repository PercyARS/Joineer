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
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    logger.addHandler(console_handler)
    logger.addHandler(file_handler)
    return logger

'''
    Set up flask app logger
'''


def get_flask_logger(logger):
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'))
    logger.addHandler(handler)
    # max log size of 100 mb, no rotation needed
    handler = RotatingFileHandler('log/Server.log', maxBytes=100000000, backupCount=1)
    handler.setFormatter(logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'))
    logger.addHandler(handler)
    logger.setLevel(logging.DEBUG)
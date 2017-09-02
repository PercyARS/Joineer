__author__ = 'Peixi Zhao'

import logging
import sys


def get_logger(name):
    formatter = logging.Formatter(fmt='%(asctime)s - %(levelname)s - %(threadName)s - [%(module)s] - %(message)s')
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(formatter)

    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    logger.addHandler(handler)
    return logger

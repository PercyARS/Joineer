__author__ = 'Peixi Zhao'

from pymongo import MongoClient
from Server.objects.singleton import SingletonDecorator
import urllib.parse
import logging

class JoineerDB:
    db = None
    logger = logging.getLogger('root')
    def __init__(self):
        # set up username and password
        username = urllib.parse.quote_plus('joineer')
        password = urllib.parse.quote_plus('pass/word')
        mongo = MongoClient('mongodb://%s:%s@localhost' % (username, password), 27017)
        self.db = mongo.Joineer
        self.logger.info("Database created: %s", self.db)


JoineerDB = SingletonDecorator(JoineerDB)
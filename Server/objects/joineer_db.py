__author__ = 'Peixi Zhao'

from pymongo import MongoClient
from Server.objects.singleton import SingletonDecorator
import urllib.parse
import logging

logger = logging.getLogger('root')


class JoineerDB:
    db = None

    def __init__(self):
        # set up username and password
        username = urllib.parse.quote_plus('joineer')
        password = urllib.parse.quote_plus('pass/word')
        mongo = MongoClient()
        self.db = mongo.Joineer
        logger.info("Database created: %s", self.db)


JoineerDB = SingletonDecorator(JoineerDB)

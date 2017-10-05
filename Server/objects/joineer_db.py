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
        mongo = MongoClient()
        # prep the database
        mongo.admin.command({"setFeatureCompatibilityVersion" : "3.4" })
        self.db = mongo.Joineer


JoineerDB = SingletonDecorator(JoineerDB)

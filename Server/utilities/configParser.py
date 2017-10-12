__author__ = 'Peixi Zhao'
import configparser


class configParser(object):
    config = configparser.ConfigParser()

    @classmethod
    def init(cls):
        cls.config.read("configs/server.ini")
        cls.config._interpolation = configparser.ExtendedInterpolation()
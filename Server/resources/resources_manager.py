__author__ = 'Peixi Zhao'

from Server.resources import *

def add_resources(api):
    api.add_resource(test.Test, '/test/', '/test/<str>')
__author__ = 'Peixi Zhao'

from Server.resources import *


def add_resources(api):
    api.add_resource(test.Test, '/test/', '/test/<string:str>')
    api.add_resource(user.Users, '/users/', '/users/<string:user_id>')
    api.add_resource(login.Login, '/login/')
    api.add_resource(event.Events, '/event/')
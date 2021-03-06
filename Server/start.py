__author__ = 'Peixi Zhao'

'''
    This is the temporary solution to fix the importing issue when the script is triggered 
    through command line
'''
import sys

sys.path.append('../')

from Server.objects.joineer_flask import JoineerFlask
from Server.utilities.logger import get_logger
from Server.resources.resources_manager import add_resources
from Server.utilities.configParser import configParser
if __name__ == '__main__':
    configParser.init()
    logger = get_logger('root')
    app = JoineerFlask().app
    api = JoineerFlask().api
    logger.info("Joineer Started")
    # use a new thread per request
    add_resources(api)
    app.run(host=configParser.config['Flask']['host'], debug=False, threaded=False)

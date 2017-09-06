__author__ = 'Peixi Zhao'

import importlib
import inspect
import sys
from Server.objects.singleton import SingletonDecorator
from Server.states.states import State
import logging

'''
    State transition mapping
'''

logger = logging.getLogger('root')


def get_all_user_states():
    all_states = inspect.getmembers(sys.modules[__name__], inspect.isclass)
    logger.debug("All User States: " + all_states)
    return all_states


def get_user_state(str):
    state_class = getattr(importlib.import_module(__name__), str)
    state_object = state_class()
    return state_object


# New account is created
class New(State):
    def next(self):
        pass


New = SingletonDecorator(New)

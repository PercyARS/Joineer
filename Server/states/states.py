__author__ = 'Peixi Zhao'

from abc import ABC, abstractmethod

'''
    Abstract class for all states     
'''


class State(ABC):
    def get_name(self):
        return self.__class__.__name__

    @abstractmethod
    def next(self):
        pass

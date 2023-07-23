import logging
import sys
import importlib

class Hedge:

    def __init__(self, repoRootPath):
        self.repoRootPath = repoRootPath
        sys.path.insert(0, repoRootPath + '/src')
        sys.path.insert(0, repoRootPath + '/src/lib')
        
    def createHedgeObject(self, className):
        module = importlib.import_module(className.lower())
        class_def = getattr(module, className)
        return class_def(self.repoRootPath) 

    def build(self, params):
        logging.debug("You are now in master file with instructions")
        filehedge = self.createHedgeObject('FileHedge')
        filehedge.ensureFile('/hedge/etc/netplan/50-cloud-init.yaml', '/etc/netplan/50-cloud-init.yaml')
        
        
        
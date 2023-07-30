import logging
import sys
import importlib

class Hedge:

    def __init__(self, repoRootPath):
        self.repoRootPath = repoRootPath
        
    def createHedgeObject(self, className):
        module = importlib.import_module(className.lower())
        class_def = getattr(module, className)
        return class_def(self.repoRootPath) 

    def build_master(self, params):
        filehedge = self.createHedgeObject('FileHedge')
        filehedge.ensureFile('/hedge/master/etc/netplan/50-cloud-init.yaml', '/etc/netplan/50-cloud-init.yaml')
        
        self.createHedgeObject("AptHedge").ensurePackages(['net-tools'])

        
    def build_worker1(self, params):
        filehedge = self.createHedgeObject('FileHedge')
        filehedge.ensureFile('/hedge/worker1/etc/netplan/50-cloud-init.yaml', '/etc/netplan/50-cloud-init.yaml')
        
    def build_worker2(self, params):
        logging.debug("You are now in master file with instructions")
        filehedge = self.createHedgeObject('FileHedge')
        filehedge.ensureFile('/hedge/worker2/etc/netplan/50-cloud-init.yaml', '/etc/netplan/50-cloud-init.yaml')
        
                    
        
        
import logging
from filehedge import FileHedge

class Hedge:

    def __init__(self, repoRootPath):
        self.repoRootPath = repoRootPath

    def build(self, params):
        logging.debug("You are now in master file with instructions")
        filehedge = FileHedge(self.repoRootPath)
        filehedge.ensureFile('/hedge/etc/testplan/50-cloud-init.yaml', '/etc/testplan/50-cloud-init.yaml')
        
        
        
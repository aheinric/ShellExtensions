import argparse
import logging
import pathlib

class CLI():
    def __init__(self):
        # Root-level logger for the package.
        self.l = logging.getLogger(__name__.split('.')[0])
        
    def parse_args(self):
        parser = argparse.ArgumentParser("Blank driver.")
        
        # Put your arg definitions here.
        
        # Verbose flags are generally useful
        parser.add_argument('-v', '--verbose', action='store_true',
                help="Turn on debug logging.")

        # Actually parse the args.
        self.args = parser.parse_args()
        
        # Handle the verbose flag.
        if self.args.verbose:
            self.l.setLevel('DEBUG')
        else:
            self.l.setLevel('INFO')

    def run(self):
        self.parse_args()

def main():
    # Need to run this first thing.
    # Otherwise, the default level is stuck at 'WARN'.
    logging.basicConfig(level='DEBUG')
    # Init and run the CLI.
    CLI().run()


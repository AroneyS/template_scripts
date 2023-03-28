#!/usr/bin/env python3

"""
Author: Samuel Aroney
Description
"""

import os
import sys
import argparse
import logging


def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--debug', help='output debug information', action="store_true")
    parser.add_argument('--quiet', help='only output errors', action="store_true")

    parser.add_argument("--input", type=argparse.FileType("r"), help="Input file")
    parser.add_argument("-o", "--outfile", type=argparse.FileType("w"), default=sys.stdout, help="Output file")

    args = parser.parse_args(arguments)

    # Setup logging
    if args.debug:
        loglevel = logging.DEBUG
    elif args.quiet:
        loglevel = logging.ERROR
    else:
        loglevel = logging.INFO
    logging.basicConfig(level=loglevel, format='%(asctime)s %(levelname)s: %(message)s', datefmt='%Y/%m/%d %I:%M:%S %p')

    logging.info(args)

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

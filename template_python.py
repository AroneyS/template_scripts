#!/usr/bin/env python3

"""
Author: Samuel Aroney
Description
"""

import os
import sys
import argparse


def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--input", type=argparse.FileType("r"), metavar="<INPUT>", help="Input file")
    parser.add_argument("-o", "--outfile", type=argparse.FileType("w"), default=sys.stdout, help="Output file")

    args = parser.parse_args(arguments)

    print(args)

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

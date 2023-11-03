#!/bin/python
from utils import make_styles
from assets import separators

sections = ["playing_info", "cpu", "ram", "date", "user"]


def main():
    print(make_styles(sections, separators["right"], True))


main()

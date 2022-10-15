#!/bin/python
from utils import make_styles

sections = ["playing_info", "cpu", "ram", "date", "user"]


def main():
    print(make_styles(sections, "", True))


main()

#!/bin/python
from utils import make_styles
from assets import separators

left_sections = ["session", "uptime"]


def main():
    print(make_styles(left_sections, separators["left"]))


main()

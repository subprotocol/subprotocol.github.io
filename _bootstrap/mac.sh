#!/usr/bin/env bash


# Note: May need to run:
# gem update --system

gem update --system
gem install jekyll rdiscount --verbose
port install py27-pygments
pygmentize-2.7 -S friendly -f html > ../css/pygments/friendly.css



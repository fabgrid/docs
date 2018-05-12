#!/bin/bash

## Build the fabacademy docs to two different locations using different configs
##

bundle exec jekyll build -b "http://fab.academany.org/2018/labs/fablaberfindergarden/students/josef-paul" -d ../gitlab/

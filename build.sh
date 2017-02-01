#!/bin/bash

## Build the fabacademy docs to two different locations using different configs
##

jekyll build -d ../fabgrid.github.io/
jekyll build -b "http://archive.fabacademy.org/archives/2017/fablaberfindergarden/students/260" -d ../gitlab/students/260/
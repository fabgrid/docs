#!/bin/bash

## Build the fabacademy docs to two different locations using different configs
##

jekyll build -d ../fabgrid.github.io/
jekyll build --config _config.yml,_config-fabacademy.yml -d ../gitlab/students/260/
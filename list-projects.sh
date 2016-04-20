#!/usr/bin/env bash

source ./projects/projects.sh

for name in "${projects[@]}"; do
  echo $name
done

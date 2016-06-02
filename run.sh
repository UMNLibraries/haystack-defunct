#!/bin/bash

for filename in ../chunks/*; do
  echo "ruby runner.rb -c `basename $filename` -t $1"
  nohup ruby runner.rb -c `basename $filename` -t $1 &
done

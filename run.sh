#!/bin/bash

for filename in ../chunks/*; do
  echo "ruby haystack.rb -c `basename $filename` -t $1"
  nohup ruby haystack.rb -c `basename $filename` -t $1 &
done

#!/bin/bash

echo `uname -a | awk '{print $1}'`
case `uname -a | awk '{print $1}'` in
    Linux)
        echo 'This is running on Linux!' ;;
    Darwin)
        echo 'This is running on OSX!' ;;
    *)
        echo 'I have no clue what OS this is. :-(' ;;
esac


# Here's the same thing as an if test statement
if [ `uname -a | awk '{print $1}'` = 'Linux' ]; then echo 'This is running on Linux!'; fi
if [ `uname -a | awk '{print $1}'` = 'Darwin' ]; then echo 'This is running on OSX!'; fi

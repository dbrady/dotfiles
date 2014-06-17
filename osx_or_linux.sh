#!/bin/bash

echo `uname -a | awk '{print $1}'`
case `uname -a | awk '{print $1}'` in
    Linux)
        echo 'This is running on Linux!' ;;
    Darwin)
        echo 'This is runnning on OSX!' ;;
    *)
        echo 'I have no clue what OS this is. :-(' ;;
esac

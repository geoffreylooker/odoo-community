#!/bin/bash

exists() 
{
    if command -v "$1" >/dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

# if ! exists xxx; then
    # sudo apt-get update; sudo apt-get install xxx;
# else 
    # echo "gcsfuse already installed"
# fi
 
 





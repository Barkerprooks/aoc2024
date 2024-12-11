#!/bin/sh

if [ $# -ne 1 ]; then
    echo "usage: $0 <day #>"
    exit 0
fi

if ! [ -d "./day/$1" ]; then
    echo "$0: $1 is not a valid day"
    echo -n "available day #s: "
    for path in $(ls ./day | sort -n); do
        echo -n "$path "
    done
    echo
    exit 0
fi

echo "$0: running day $1..."
case $1 in
    1)
        g++ ./day/1/main.cpp -o day1; ./day1; rm day1;;
    2)
        lua ./day/2/main.lua;;
    3)
        go run ./day/3/main.go;;
    4)
        julia ./day/4/main.jl;;
    5)  
        dotnet run --project ./day/5;;
    6)
        php ./day/6/main.php;;
    7)
        gcc ./day/7/main.c -o day7; ./day7; rm day7;;
    8)
        sbcl --script ./day/8/main.lisp;;
    9)  
        python3 ./day/9/main.py;;
    10)
        runghc ./day/10/main.hs;;
    11)
        ruby ./day/11/main.rb;;
    *)
        echo "command for day $1 not set up";;
esac
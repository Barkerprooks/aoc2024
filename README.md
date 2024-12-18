# Advent of Code 2024
Trying out a different language each day. 

Assuming you have the compiler/interpreter in your `$PATH`, you can run the source code using any of the commands below.

You can also use the script `run-day.sh` to run a specific day on UNIX machines. 

*NOTE: as of now this has only been tested in Arch Linux*

```
# mark the script as executable
chmod +x ./run-day.sh

# example: this would run day 3
./run-day.sh 3
```

## Languages
C++, Lua, Go, Julia, C#, PHP, C, Python, Common Lisp, Haskell, Ruby, Java, Rust, Swift,
Bash, JavaScript, R, F#
### 1: C++
```
g++ ./day/1/main.cpp -o ./day/1/day1; ./day/1/day1
```
1. 1873376
2. 18997088
### 2: Lua
```
lua ./day/2/main.lua
```
1. 306
2. 366
### 3: Go
```
go run ./day/3/main.go
```
1. 165225049
2. 108830766
### 4: Julia
```
julia ./day/4/main.jl
```
1. 2562
2. 1902
### 5: C#
```
dotnet run --project ./day/5
```
1. 4281
2. 5466
### 6: `PHP`
```
php ./day/6/main.php
```
1. 5199
2. 1915
### 7: C
```
gcc ./day/7/main.c -o ./day/7/day7 -lm; ./day/7/day7
```
1. 2314935962622
2. 401477450831495
### 8: `Python`
```
python3 ./day/8/main.py
```
1. 256
2. 1005
### 9: `Common Lisp`
```
sbcl --script ./day/9/main.lisp
```
1. 6399153661894
2. ...
### 10: `Haskell`
```
runghc ./day/10/main.hs
```
### 11: `Ruby`
```
ruby ./day/11/main.rb
```
### 12: `Java`
```
java ./day/12/main.java
```
### 13: `Rust`
```
rustc ./day/13/main.rs -o ./day/13/day13; ./day/13/day13
```
### 14. `Swift`
```
swift ./day/14/main.swift
```
### 15. `Bash`
```
bash ./day/15/main.bash
```
### 16. `JavaScript`
```
node ./day/16/main.js
```
### 17. `R`
```
R -s -f ./day/17/main.r
```
### 18. `F#`
```
dotnet run --project ./day/18
```
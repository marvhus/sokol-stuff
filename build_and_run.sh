#!/bin/bash

# Exit on error
set -e

# cd into script directory
cd "$(dirname "$(readlink -f "$0")")"

echo '===== BUILD ====='
jai -import_dir modules first.jai 
echo '====== RUN ======'
./bin/jmp
echo '================='

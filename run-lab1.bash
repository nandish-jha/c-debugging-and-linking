#!/bin/bash

# NAME: Nandish Jha
# NSID: NAJ474
# Student Number: 11282001

set -e
clear

# Check for exactly 1 argument (the number)
if [ $# -lt 1 ]; then
    echo "Usage: $0 <number>"
    exit 1
fi

NUM=$1

# Detect architecture from uname -m
UNAME_ARCH=$(uname -m)

# Special case: build & run all on cmpt332-amd64 host
# if [ "$UNAME_ARCH" = "cmpt332-amd64" ]; then
#     echo "Detected architecture: cmpt332-amd64"
#     echo "Building all architectures..."
#     make clean
#     make all

#     echo "Running all architectures with input number $NUM..."

#     echo "=== x86_64 ==="
#     build/bin/x86_64/sample-linux "$NUM"

#     echo "=== arm ==="
#     build/bin/arm/sample-linux-arm "$NUM"

#     echo "=== ppc ==="
#     build/bin/ppc/sample-linux-ppc "$NUM"

#     exit 0
# fi

case $UNAME_ARCH in
    x86_64)
        ARCH=x86_64
        EXEC=build/bin/x86_64/sample-linux
        ;;
    aarch64 | armv7l | armv8l)
        ARCH=arm
        EXEC=build/bin/arm/sample-linux-arm
        ;;
    ppc64 | powerpc | ppc)
        ARCH=ppc
        EXEC=build/bin/ppc/sample-linux-ppc
        ;;
    *)
        echo "Error: Unsupported architecture '$UNAME_ARCH'"
        exit 1
        ;;
esac

echo "Detected architecture: $ARCH"

# Build if executable does not exist
if [ ! -f "$EXEC" ]; then
    echo "Executable $EXEC not found. Building project..."
    make
fi

# Run the program
echo "Running $EXEC with input number $NUM..."
"$EXEC" "$NUM"

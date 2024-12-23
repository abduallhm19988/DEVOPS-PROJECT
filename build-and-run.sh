#!/bin/bash

echo "Build the Image"   
# Build the image 
docker build -t newman:v1 .

echo "Run the Image" 

# Run the image 
docker run --rm  --dns=8.8.8.8 --dns=1.1.1.1 newman:v1 --version

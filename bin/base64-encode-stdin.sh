#!/bin/bash

set -o errexit
set -o nounset

echo "What is your input?"
read -r INPUT

echo -n "${INPUT}" | base64

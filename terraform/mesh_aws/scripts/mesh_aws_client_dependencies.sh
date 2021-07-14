#!/bin/bash
# mesh_aws_client_dependencies.sh

set -e
set -u
set -x
set -o pipefail

# Deterministic dir
SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
cd ${SCRIPT_DIR}
DEPS_DIR="../mesh_aws_client_dependencies/python"
PYTHON_BIN="python3.8"

# Check for python and zip
which ${PYTHON_BIN}
which zip

# Create deps dir
mkdir -p ${DEPS_DIR}
rm -rf ${DEPS_DIR}/*

# Install deps
${PYTHON_BIN} -m pip install --upgrade pip
${PYTHON_BIN} -m pip install \
  -r ../../../mesh_aws_client/requirements.txt \
  --target ${DEPS_DIR}

# Get the spine common library
cp -r ../../../spine_aws_common ${DEPS_DIR}/

# This will then be zipped by terraform
exit 0

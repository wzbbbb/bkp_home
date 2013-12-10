#!/bin/sh

U_ROOT_DIR=/apps/unijob110/unijob/casdlsup06_unijob
export U_ROOT_DIR

U_CONF_VAR=${U_ROOT_DIR}/app/files/variables.xml
export U_CONF_VAR
U_CONF_VAL=${U_ROOT_DIR}/data/values.xml
export U_CONF_VAL
LD_LIBRARY_PATH=${U_ROOT_DIR}/app/lib
export LD_LIBRARY_PATH
LIBPATH=${U_ROOT_DIR}/app/lib
export LIBPATH
SHLIB_PATH=${U_ROOT_DIR}/app/lib
export SHLIB_PATH

umask 0

echo "UniJob environment loaded."
echo ""

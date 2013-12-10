#!/bin/csh

setenv U_ROOT_DIR      /apps/unijob110/unijob/casdlsup06_unijob

setenv U_CONF_VAR      ${U_ROOT_DIR}/app/files/variables.xml
setenv U_CONF_VAL      ${U_ROOT_DIR}/data/values.xml
setenv LD_LIBRARY_PATH ${U_ROOT_DIR}/app/lib
setenv LIBPATH         ${U_ROOT_DIR}/app/lib
setenv SHLIB_PATH      ${U_ROOT_DIR}/app/lib

echo "UniJob environment loaded."
echo ""


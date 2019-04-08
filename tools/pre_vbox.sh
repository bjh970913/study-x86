#!/usr/bin/env bash
VBOX=$(which VBoxManage)
if [ "${VBOX}" == "" ]; then
    echo "Package VBox not found"
    exit 1
fi

VBoxManage import ${TOOLS_OVA} --vsys 0 --vmname ${VBOX_ENV_NAME} 1>&- 2>&-

#!/bin/sh

EXTRA_VARS=""
SCREENED_CLI=""
INVENTORY=""
basedir="$(cd `dirname ${0}` ; pwd)"

parse_cli() {
    while [ "$#" -gt 0 ]
    do
        case $1 in
            -c|--config)
                shift
                export ANSIBLE_CONFIG='${1}'
                ;;

            -i|--inventory)
                shift
                INVENTORY="$1"
                ;;

            --keep-remote-files)
                export ANSIBLE_KEEP_REMOTE_FILES=1
                ;;

            --help)

                cat <<EOF
Usage: run.sh [ansible options] [--keep-remote-files] [-c|--config <file>]

A test runner for ansible roles. Passes most the options it receives to
ansible-playbook directly (cf. ansible-playbook(1)).

The run.sh script also provides the following options:

  -c, --config <file>
      The Ansible configuration file to use

  --keep-remote-files
      Asks for the files upload to target hosts by ansible to
      left behind for inspection / debugging.

EOF
                exit 0
                ;;

            *)
                SCREENED_CLI="${screened_cli} ${1}"
                ;;

        esac
        shift
    done

    if [ -z "${ANSIBLE_CONFIG}" ]
    then
        export ANSIBLE_CONFIG="${basedir}/ansible.cfg"
    fi
}

run() {
    ansible-playbook -i "${INVENTORY:-${basedir}/inventory.local}" tests/test.yml ${@}
}


parse_cli $@
run $SCREENED_CLI


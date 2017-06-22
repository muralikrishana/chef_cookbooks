function init_ansible_directory_structure()
{
    if [[ ! -n "$1" ]]; then
        echo "No path supplied, please try again"
        return
    fi
    # create directory structure
    mkdir -p "${1}"/{group_vars,host_vars,roles}

    # create production inventory file
    create_empty_file "$1" "production"
    # create production inventory file
    create_empty_file "$1" "stage"

    # add .gitkeep to the directories
    for i in group_vars host_vars; do
        create_empty_file "$1/${i}" ".gitkeep"
    done

    # create the master playbook
    create_yaml_file "$1" "site.yml"

    # create the common role
    for i in "${ANSIBLE_ROLES[@]}"; do
        create_ansible_role "$i" "$1/roles"
    done

}

function create_yaml_file()
{
    if [[ ! -n "$1" ]]; then
        echo "No path supplied, please try again"
        return
    fi
    local FILE_PATH="$1"
    local FILE_NAME="$2"
    : ${FILE_NAME:="default.yml"}

    if [[ ! -f "${FILE_PATH}"/"${FILE_NAME}" ]]; then
        echo "Creating file:  ${FILE_PATH}/${FILE_NAME}"
        echo "---
        # Default Ansible YAML
        " > "${FILE_PATH}"/"${FILE_NAME}"
    else
        echo "${FILE_PATH}/${FILE_NAME} exists skipping"
    fi
}

function create_empty_file()
{
    if [[ ! -n "$1" ]]; then
        echo "No path supplied, please try again"
        return
    fi
    local FILE_PATH="$1"
    local FILE_NAME="$2"
    : ${FILE_NAME:="default"}

    if [[ ! -f "${FILE_PATH}"/"${FILE_NAME}" ]]; then
        echo "Creating file:  ${FILE_PATH}/${FILE_NAME}"
        echo "" > "${FILE_PATH}"/"${FILE_NAME}"
        else
            echo "${FILE_PATH}/${FILE_NAME} exists skipping"
        fi
}

function create_ansible_role()
{
    local ROLE_NAME=$1
    local ROLE_PATH=$2
    : ${ROLE_PATH:="."}

    if $USE_ANSIBLE_GALAXY; then
        ansible-galaxy init "${ROLE_NAME}" -p "${ROLE_PATH}"
    else
        init_ansible_role "${ROLE_PATH}" "${ROLE_NAME}"
    fi

    for i in templates files; do
        create_empty_file "${ROLE_PATH}/${ROLE_NAME}/${i}" ".gitkeep"
    done
}

# found this in https://gist.github.com/zircote/8640585
# modified it to accept the path and role name, setup role name default and add .gitkeep where needed
function init_ansible_role()
{
    if [[ ! -n "$1" ]]; then
        echo "No path supplied, please try again"
        return
    fi
    local ROLE_PATH="$1"
    local ROLE_NAME="$2"
    : ${ROLE_NAME:="common"}

    mkdir -p "${ROLE_PATH}"/roles/"${ROLE_NAME}"/{defaults,tasks,files,templates,vars,handlers,meta}
    for i in defaults tasks vars handlers meta; do
        create_yaml_file "$ROLE_PATH/roles/${ROLE_NAME}/${i}" "main.yml"
    done

    for i in templates files; do
        create_empty_file "$ROLE_PATH/roles/${ROLE_NAME}/${i}" ".gitkeep"
    done
}

function usage()
{
cat << EOF
usage: $0 options

This script will help with ansible directory structures.
If ANSIBLE_DIRECTORY_PATH is supplied the script will use it as base path,
otherwise it assumes operation in current directory.

OPTIONS:
   -h      Show this message
   -p      Specify the path to ansible project
   -r      Specify the roles you want created
   -o      Create supplied roles only, running with this argument without specified roles will create a common role only
EOF
}


while getopts "ihp:r:o" OPTION
do
    case "$OPTION" in
        "p")
            DIR_PATH="$OPTARG"
            [ "${DIR_PATH/#\//}" != "$DIR_PATH" ] || DIR_PATH="$ORIGINAL_DIR/$DIR_PATH"
            [ ${DIR_PATH:0:1} != "/" ]
              DIR_PATH=${DIR_PATH%/}
            ;;
        "r")
            ANSIBLE_ROLES+=("${OPTARG}")
            ;;
        "o")
            ROLES_ONLY=true
            ;;
        ?)
            usage
            exit
            ;;
    esac
done

if [ ${#ANSIBLE_ROLES[@]} -eq 0 ]; then
    ANSIBLE_ROLES=("common")
fi

if [ "$ROLES_ONLY" = true ] ; then
    for i in "${ANSIBLE_ROLES[@]}"; do
        create_ansible_role "$i" "$DIR_PATH"
    done
else
    init_ansible_directory_structure "$DIR_PATH" "$ANSIBLE_ROLES"
fi

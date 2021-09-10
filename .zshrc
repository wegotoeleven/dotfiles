#### Exports

# Set path envar to homebrew directory at $HOME/.homebrew/, and custom binary folder at $HOME/.binaries
export PATH=$HOME/.binaries:$HOME/.homebrew/bin:$PATH
export FPATH=$HOME/.zsh:$HOME/.homebrew/share/zsh/site-functions:$FPATH

# Enable cli colours
export CLICOLOR=1

# Set history options
export HISTSIZE=100000
export SAVEHIST=1000000

#### Options
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_NO_STORE
setopt PROMPT_SUBST

#### Plugins

# Load prompt
autoload -Uz promptinit

# Set prompt theme
promptinit
prompt wego

# Functions
sign ()
{
    IFS=$'\n'
    UI_NUMBER=1

    # Get available certificates
    for FOUND_CERT in $(/usr/bin/security find-certificate -a -c Developer | awk -F '=' '/"alis"/ {print $2}' | awk '/\(.*\)/ { print }' | sed 's/"//g')
    do
        CERT_ARRAY+=("${FOUND_CERT}")
        echo "${UI_NUMBER}) ${FOUND_CERT}"
        let "UI_NUMBER += 1"
    done

    unset IFS

    # Select a certificate
    if [[ -z ${FOUND_CERT} ]]
    then
        echo "No certificates available to sign. Exiting..."
        return 1
    else
        echo "Select a certificate: "
        read CHOSEN_UI_NUMBER
        CHOSEN_CERT=${CERT_ARRAY[${CHOSEN_UI_NUMBER}]}
    fi

    # Determine signing target and sign as required
    FILE_NAME=$(basename "${1}")
    if [[ "${1}" =~ .pkg || "${1}" =~ .mpkg ]]
    then
        echo "Signing package..."
        /usr/bin/productsign --sign "${CHOSEN_CERT}" "${1}" "$(dirname "${1}")/Signed-${FILE_NAME}"
    else
        echo "Signing code..."
        /usr/bin/security cms -S -N "${CHOSEN_CERT}" -i "${1}" -o "$(dirname "${1}")/Signed-${FILE_NAME}"
    fi
}

unsign ()
{
    # Determine target and un-sign as required
    FILE_NAME=$(basename "${1}")
    if [[ "${1}" =~ .pkg || "${1}" =~ .mpkg ]]
    then
        echo "Package found."
        /usr/sbin/pkgutil --expand "${1}" /tmp/expand.pkg
        /usr/sbin/pkgutil --flatten /tmp/expand.pkg "$(dirname "$1")/Unsigned-${FILE_NAME}"
    else
        echo "Code found."
        /usr/bin/openssl smime -inform DER -verify -in "${1}" -noverify -out "$(dirname "$1")/Unsigned-${FILE_NAME}"
        /usr/bin/plutil -convert xml1 "$(dirname "$1")/Unsigned-${FILE_NAME}"
    fi
}

checksign ()
{
    # Determine target and check as required
    if [[ "${1}" =~ .pkg || "${1}" =~ .mpkg ]]
    then
        echo "Package found."
        /usr/sbin/pkgutil --check-signature "${1}"
    else
        echo "Code found."
        /usr/bin/codesign -dr - --verbose=4 "${1}"
    fi
}

changemac ()
{
    IFS=$'\n'
    UI_NUMBER=1

    # Get available interfaces
    for INTERFACE in $(/sbin/ifconfig -a | awk '/UP/ {print $1}' | sed 's/://g')
    do
        INTERFACE_ARRAY+=("${INTERFACE}")
        echo "$UI_NUMBER) ${INTERFACE}"
        let "number += 1"
    done

    unset IFS

    # Select an interface
    echo "Select an interface: "
    read INTERFACE_ID
    CHOSEN_INTERFACE=${INTERFACE_ARRAY[${INTERFACE_ID}]}

    # Get MAC address or create new MAC
    NEW_MAC="${1}"
    if [[ -z "${NEW_MAC}" ]]
    then
        echo "Generating random MAC address..."
        NEW_MAC=$(/usr/bin/openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
        echo "New MAC address is ${NEW_MAC}"
    fi
    echo "Setting ${CHOSEN_INTERFACE} to ${NEW_MAC}..."
    sudo /sbin/ifconfig "${CHOSEN_INTERFACE}" ether "${NEW_MAC}"
}

makedmg ()
{
    # Determine if the content is a folder, exit if not
    if [ ! -d "${1}" ]
    then
        echo "Supplied content is not a folder. Exiting..."
        return 1
    else
        DMG_NAME=$(basename "${1}")
        DIRECTORY_NAME=$(DIRECTORY_NAME "${1}")
        /usr/bin/hdiutil create -volname "${DMG_NAME}" -srcfolder "${1}" -ov -format UDZO "${DIRECTORY_NAME}"/"${DMG_NAME}".dmg
    fi
}

whatismyip ()
{
    /usr/bin/dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}'
}

finduti ()
{
    /usr/bin/mdls -name kMDItemContentType "${1}"
}

exportcert ()
{
    CERTIFICATE=$(basename "${1}")
    echo "cat /plist/dict/array/dict[1]/data/text()" | xmllint --nocdata --shell "${1}" | sed '1d;$d' | base64 -D > "$(dirname "$1")/exported-${CERTIFICATE}.pem" 
}

generatepubkey ()
{
    /usr/bin/ssh-keygen -y -f "${1}" > "${1}".pub
}

expandurl ()
{
    curl -sIL $1 2>&1 | awk '/^Location/ {print $2}' | tail -n1
}

removequarantine ()
{
    xattr -d com.apple.quarantine "${1}"
}

# activate ()
# {
#     if [ -z "${1}" ]
#     then
#         venvdir="."
#     else
#         venvdir="${1}"
#     fi
    
#     if [ ! -e "${venvdir}/bin/activate" ]
#     then
#         echo "Invalid virtualenv directory. Would you like to create?"
#         read yno
#         case $yno in

#             [yY] | [yY][Ee][Ss] )
#                 echo "Specify path to Python binary:" 
#                 read pythonBin
#                 pythonBin=$(which "${pythonBin}")
#                 if [ -e "${pythonBin}" ]
#                 then
#                     echo "Creating virtualenv ${1} using ${pythonBin}..."
#                     virtualenv -p "${pythonBin}" "${1}"
#                 else
#                     echo "Invalid Python binary location."
#                     return 1
#                 fi
#                 ;;

#             [nN] | [nN][Oo] )
#                 yesNo="no"
#                 return 1
#                 ;;

#             *)
#                 echo "Invalid input."
#                 return 1
#                 ;;
#         esac
#     fi

#     source "${venvdir}/bin/activate"
# }

cleanautopkgcache ()
{
    for AUTOPKG_CACHE_ITEM in $(find "/Users/stephenb/Library/Caches/AutoPkg" -type d -maxdepth 2 -mindepth 1)
    do
        echo "Deleting ${AUTOPKG_CACHE_ITEM}..."
        rm -rf "${AUTOPKG_CACHE_ITEM}"
    done
}

elevate ()
{
    open "jamfselfservice://content?entity=policy&id=255&action=execute"
}

checksubnet ()
{
    if [[ -z "${1}" ]]
    then
        echo "First 3 IP subnet octets not supplied. Bailing..."
        return 1
    fi
    for IP_OCTET_4 in $(seq 1 254)
    do
        if ping -c 1 $1.${IP_OCTET_4} -t 2 > /dev/null 2>&1
        then 
            echo "$1.$IP_OCTET_4 UP"
        fi
    done
}
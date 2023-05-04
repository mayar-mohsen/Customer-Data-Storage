##Function takes a parameters. which is file name and return 0 if the file exists
function checkFile {
        FILENAME=${1}
        [ ! -f ${FILENAME} ] && return 1
        return 0
}
##Function takes a parameter which is filename and return 0 if the file has read perm
function checkFileR {
        FILENAME=${1}
        [ ! -r ${FILENAME} ] && return 1
        return 0
}
##Function takes a paremter which is filename and returns 0 if the file has write permission
function checkFileW {
        FILENAME=${1}
        [ ! -w ${FILENAME} ] && return 1
        return 0
}

## Function takes a parameter with username, and return 0 if the user requested is the same as current user
function checkUser {
        RUSER=${1}
        [ ${RUSER} == ${USER} ] && return 0
        return 1
}

# check for id is valid integer
function IsInt {
        ID=${1}
        NL=$(echo ${ID} | grep "^[0-9]*$" | wc -l)
        return ${NL}
}

# Check for userid exist or not
function Exists {
        U_ID=${1}
        while read FLINE
        do
                TEST=$(echo ${FLINE} | awk 'BEGIN{FS=":"} { print $1 } ')

                if [ ${U_ID} == ${TEST} ]
                then
                        return 1

                fi
        done < customers.db
        return 0
}
# check for email format
function EmailFormat {
        email=${1}
        NL=$(echo ${email} | grep -i "^[a-z]*@[a-z]*.[a-z]*$" | wc -l)
        return ${NL}

}
# Check for email exist or not
function EmailExists {
        email=${1}
        while read FLINE
        do
                TEST=$(echo ${FLINE} | awk 'BEGIN{FS=":"} { print $3 } ')

                if [ ${email} == ${TEST} ]
                then
                        return 1

                fi
        done < customers.db
        return 0
}

#check name is alpha
function IsAlpha {
        name=${1}
        NL=$(echo ${name} | grep -i ^[a-z]*$ | wc -l)
        return ${NL}
}
### Function takes a username, and password then check them in accs.db, and returns 0 if match otherwise returns 1
function authUser {
        USERNAME=${1}
        USERPASS=${2}
        ###1-Get the password hash from accs.db for this user if user found
        ###2-Extract the salt key from the hash
        ###3-Generate the hash for the userpass against the salt key
        ###4-Compare hash calculated, and hash comes from the file.
        ###5-IF match returns 0,otherwise returns 1
        USERLINE=$(grep ":${USERNAME}:" accs.db)
        [ -z ${USERLINE} ] && return 0
        PASSHASH=$(echo ${USERLINE} | awk ' BEGIN { FS=":" } { print $3} ')
        SALTKEY=$(echo ${PASSHASH} | awk ' BEGIN { FS="$" } { print $3 } ')
        NEWHASH=$(openssl passwd -salt ${SALTKEY} -6 ${USERPASS})
        if [ "${PASSHASH}" == "${NEWHASH}" ]
        then
                USERID=$(echo ${USERLINE} | awk ' BEGIN { FS=":" } { print $1} ')
                return ${USERID}
        else
                return 0
        fi
}

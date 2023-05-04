#!/bin/bash
### Script that handles customer info in file customers.db
#BASH script manages user data
#       Data files:
#               customers.db:
#                       id:name:email
#               accs.db:
#                       id,username,pass
#       Operations:
#               Add a customer
#               Delete a customer
#               Update a customer email
#               Query a customer
#       Notes:
#               Add,Delete, update need authentication
#               Query can be anonymous
#       Must be root to access the script
###################### TODO
#################################
### Exit codes:
##      0: Success
##      1: No customers.db file exists
##      2: No accs.db file exists
##      3: no read perm on customers.db
##      4: no read perm on accs.db
##      5: must be root to run the script
##      6: Can not write to customers.db
##      7: Customer name is not found
source ./checker.sh
source ./printmsgs.sh
source ./dbops.sh
source ./sql.sh
checkFile "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not find customers.db" &&  exit 1
checkFile "accs.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not find accs.db" &&  exit 2
checkFileR "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not read from customers.db" &&  exit 3
checkFileR "accs.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not read from accs.db" &&  exit 4
checkFileW "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not write to customers.db" &&  exit 6
checkUser "root"
[ ${?} -ne 0 ] && printErrorMsg "You are not root, change to root and come back" && exit 5
CONT=1
USERID=0
while [ ${CONT} -eq 1 ]
do
        printMainMenu
        read OP
        case "${OP}" in
                "a")
                        echo "Authentication:"
                        echo "---------------"
                        echo -n "Username: "
                        read ADMUSER
                        echo  "Password: "
                        read -s ADMPASS
                        authUser ${ADMUSER} ${ADMPASS}
                        USERID=${?}
                        if [ ${USERID} -eq 0 ]
                                then
                                        echo "Invalid username/password combination"
                                else
                                        echo "Welcome to the system"
                        fi
                        ;;

                "1")
                        if [ ${USERID} -eq 0 ]
                        then
                                printErrorMsg "You are not authenticated, please authenticate 1st"
                        else
                                        # check for id is valid integer
                                        # check for customer name is only alphabet,-_
                                        # check for email format
                                        # Check for userid exist or not
                                        # Check for email exist or not

                                echo "Adding a new customer"
                                echo "---------------------"
                                echo -n "Enter customer ID : "
                                read CUSTID

                                # check for id is valid integer
                                X=0
                                Y=1
                                IsInt ${CUSTID}
                                [ ${?} -eq 0 ] && printErrorMsg "Invalid ID" && X=1

                                #Check for userid exist or not
                                Exists ${CUSTID}
                                [ ${?} -eq 1 ] && printErrorMsg "ID Already Exists" && Y=2

                                if [ ${X} -ne 1 ] && [ ${Y} -ne 2 ]
                                then
                                        echo -n "Enter customer name : "
                                        read CUSTNAME
                                        X=0
                                        IsAlpha ${CUSTNAME}
                                        [ ${?} -eq 0 ] && printErrorMsg "Invalid Name" && X=1

                                        if [ ${X} -ne 1 ]
                                        then

                                                echo -n "Enter customer email : "
                                                read CUSTEMAIL

                                                # check for email format
                                                X=0
                                                EmailFormat ${CUSTEMAIL}
                                                [ ${?} -eq 0 ] && printErrorMsg "Invalid Email Format" && X=1

                                                # Check for email exist or not
                                                Y=0
                                                EmailExists ${CUSTEMAIL}
                                                [ ${?} -eq 1 ] && printErrorMsg "Email Already Exists" && Y=2
                                                if [ ${X} -ne 1 ] && [ ${Y} -ne 2 ]
                                                                then
                                                        echo "${CUSTID}:${CUSTNAME}:${CUSTEMAIL}" >> customers.db
                                                        AddRecord ${CUSTID} ${CUSTNAME} ${CUSTEMAIL}
                                                        echo "customer ${CUSTID} saved.."
                                                fi
                                        fi
                                fi
                        fi
                        ;;

                "2")
                        if [ ${USERID} -eq 0 ]
                        then
                                printErrorMsg "You are not authenticated, please authenticate 1st"
                        else
                                echo "Updating an existing email"
                                #TODO
                                #       Read required id to update
                                echo -n "Enter The Customer ID: "
                                read ID
                                #       check for valid integer
                                X=0
                                Y=1
                                IsInt ${ID}
                                [ ${?} -eq 0 ] && printErrorMsg "Invalid ID" && X=1

                                #Check for userid exist or not
                                Exists ${ID}
                                [ ${?} -ne 1 ] && printErrorMsg "ID Doesn't Exist" && Y=2

                                if [ ${X} -ne 1 ] && [ ${Y} -ne 2 ]
                                then
                                        # print details
                                        LINE=$(grep -w ${ID} customers.db)
                                        echo ${LINE}
                                        echo -n "Are you sure you want to change ? [y/n] : "
                                        read CONFIRM
                                        if [  ${CONFIRM} == 'y' ]
                                        then
                                                # ask for new email
                                                echo -n "Enter new email : "
                                                read CUSTEMAIL

                                                # check for email format
                                                X=0
                                                EmailFormat ${CUSTEMAIL}
                                                [ ${?} -eq 0 ] && printErrorMsg "Invalid Email Format" && X=1

                                                # Check for email exist or not
                                                Y=0
                                                EmailExists ${CUSTEMAIL}
                                                [ ${?} -eq 1 ] && printErrorMsg "Email Already Exists" && Y=2
                                                if [ ${X} -ne 1 ] && [ ${Y} -ne 2 ]
                                                then
                                                        echo -n "Are you sure you want to change ? [y/n] : "
                                                        read CONFIRM
                                                        if [  ${CONFIRM} == 'y' ]
                                                        then
                                                                sed -i "s/$(echo ${LINE} | awk 'BEGIN {FS=":"} {print $3}')/${CUSTEMAIL}/" customers.db
                                                                UpdateMail ${CUSTID} ${CUSTEMAIL}
                                                                echo "customer ${CUSTID} updated.."
                                                        fi
                                                fi
                                        fi
                                fi
                        fi
                        ;;

                "3")
                        if [ ${USERID} -eq 0 ]
                        then
                                printErrorMsg "You are not authenticated, please authenticate 1st"
                        else
                                echo "Deleting existing user"
                                ##ToOD
                                #       Read required ID to delete
                                echo -n "Enter Required ID to delete: "
                                read ID
                                #       check for valid integer
                                X=0
                                Y=1
                                IsInt ${ID}
                                [ ${?} -eq 0 ] && printErrorMsg "Invalid ID" && X=1

                                #Check for userid exist or not
                                Exists ${ID}
                                [ ${?} -ne 1 ] && printErrorMsg "ID Doesn't Exist" && Y=2

                                if [ ${X} -ne 1 ] && [ ${Y} -ne 2 ]
                                then
                                        # print details
                                        LINE=$(grep -w ${ID} customers.db)
                                        echo ${LINE}
                                        echo -n "Are you sure you want to delete permanently ? [y/n] : "
                                        read CONFIRM
                                        if [  ${CONFIRM} == 'y' ]
                                        then
                                                DEL=$(grep -w ${ID} customers.db)
                                                sed -i "/${DEL}/d" customers.db
                                                DeleteRecord ${ID}
                                                echo "Customer ${ID} Deleted ..."
                                        fi
                                fi
                        fi
                        ;;

                "4")
                        echo -n "Enter name : "
                        read CUSTNAME
                        queryCustomer ${CUSTNAME}
                        ;;

                "5")
                        echo "Thank you, see you later Bye"
                        CONT=0
                        ;;

                *)
                        echo "Invalid option, try again"
        esac
done



exit 0

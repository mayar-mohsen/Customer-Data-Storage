#!/bin/bash
# DataBase Name CustomerData

# Add user in DataBase in table CustomerTable
function AddRecord {
        ID=${1}
        NAME=${2}
        EMAIL=${3}
        mysql -u root  <<EOF
        use CustomerData;
        insert into CustomerTable values ($ID, "$NAME", "$EMAIL");
EOF
}

# Update EMAIL of an existing customer in the DB
function UpdateMail {

        ID=${1}
        EMAIL=${2}
        mysql -u root  <<EOF
        use CustomerData;
        update CustomerTable set customerEmail='$EMAIL' where customerID=$ID;

EOF
}

# Delete record of a Customer from the DataBase
function DeleteRecord {
        ID=${1}
        mysql -u root  <<EOF
        use CustomerData;
        delete from CustomerTable where customerID=$ID;
EOF

}

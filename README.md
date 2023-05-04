# Customer-Data-Storage
Bash script application to handle customers information into a MariaDB database and in a file. </br>

### BASH script manages user data in the following datafiles: </br>
      > customers.db: 
          This file contains a copy of the information of the customers as the data in the Database
          It also gets updated exactly same as the DB. 
          Note: 
          Data stored in the following format --> id:name:email 
      > accs.db:
          This file contains the information of the authenticated user to perform the operations provided by this application.  
          Note: 
          Data stored in the following format --> id:username:hashed_password 
      
      > DataBase:
          In This Script Iam using a MariaDB with a DataBase called CustomerData with a table named CustomerTable
          containing Data Same as in file customers.db with the following Names: customerID, customerName, customerEmail.
          
      > Others: 
          Other files as checker.sh, sql.sh and the other files contains functions used in the main script. 
          
### Operations:
      1- Add a customer
      2- Delete a customer 
      3- Update a customer email 
      4- Query a customer 
      
      Notes: 
      Add,Delete, update need authentication 
      Query can be anonymous 
      Must be root to access the script
      
### Exit codes:
      0: Success
      1: No customers.db file exists
      2: No accs.db file exists
      3: no read perm on customers.db
      4: no read perm on accs.db
      5: must be root to run the script
      6: Can not write to customers.db
      7: Customer name is not found
      
#### If any Error occured during the checks for example an Invalid Email Format, The script will return a message with the problem and return to the main menu.


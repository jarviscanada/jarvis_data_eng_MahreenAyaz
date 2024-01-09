#!/bin/bash

#Setup and validate arguments 

psql_host=$1 
psql_port=$2 
db_name=$3 
psql_user=$4 
psql_password=$5 


# Check # of arguments

if [ "$#" -ne 5 ]; then 
echo "Illegal number of parameters" 
exit 1 
fi



# save hostname as a variable

hostname=$(hostname)



# save output of lscpu command

lscpu_out=`lscpu`

# hardware info

cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out"   | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out"   | egrep "^Model:" | awk '{print $2}' | xargs)
cpu_MHz=$(echo "$lscpu_out"   | egrep "^CPU MHz:" | awk '{print $3}' | xargs)
L2_cache=$(echo "$lscpu_out"   | egrep "^L2 cache:" | awk '{print $3}' | xargs)
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')
timestamp=$(date +"%F %T")


# prepare insert statement

insert_stmt="INSERT INTO host_info(hostname,cpu_number,cpu_architecture,cpu_model,cpu_mhz,L2_cache,total_mem,timestamp )VALUES('$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_MHz', '$L2_cache', '$total_mem', '$timestamp');"

# set variable for postgres password

export PGPASSWORD=$psql_password


# run command for postgres insert

psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt" exit $?



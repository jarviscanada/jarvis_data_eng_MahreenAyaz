#!/bin/bash


# set arguments

psql_host=$1 
psql_port=$2 
db_name=$3 
psql_user=$4 
psql_password=$5 



# Check # of args 

if [ "$#" -ne 5 ]; then 
echo "Illegal number of parameters" 
exit 1 
fi


# save hostname as a variable

host_name=$(hostname)



# save output of vmstat and df commands in variables

vmstat_out=`vmstat`
vmstatd_out='vmstat -d'
df_out='df /'



# usage info

memory_free=$(echo "$vmstat_out"  | sed -n '3 p' | awk '{print $4}' | xargs)
cpu_idle=$(echo "$vmstat_out"  | sed -n '3 p' | awk '{print $15}' | xargs)
cpu_kernel=$(echo "$vmstat_out"  | sed -n '3 p' | awk '{print $14}' | xargs)
disk_io=$(vmstat -d  | sed -n '3 p' | awk '{print $11}' | xargs)
timestamp=$(date +"%F %T")
disk_available=$(df / | sed -n '2 p' | awk '{print $4}' | xargs)
host_id="select id from host_info where hostname = '$host_name';"


#Set variable for postgres password

export PGPASSWORD=$psql_password


# Get host ID

host_id2=$(psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$host_id" exit $? )
host_id3=$(echo $host_id2  | awk '{print $3}' | xargs)


# Create insertion statement

insert_stmt="INSERT INTO host_usage (host_id,memory_free, cpu_idle, cpu_kernel , disk_io ,disk_available, timestamp) VALUES('$host_id3','$memory_free','$cpu_idle', '$cpu_kernel', '$disk_io','$disk_available', '$timestamp');"


#export PGPASSWORD=$psql_password


# Run statement for insert

psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt" exit $?





#!/bin/bash



api_key=$1
psql_host=$2
psql_port=$3
psql_database=$4
psql_username=$5
psql_password=$6
symbols=$7

# Check # of args
if [ "$#" -ne 7 ]; then
    echo "Illegal number of parameters"
    exit 1
fi


resp=$(curl --request GET \
	--url 'https://alpha-vantage.p.rapidapi.com/query?function=GLOBAL_QUOTE&symbol='$symbols'&datatype=json' \
	--header 'X-RapidAPI-Host: alpha-vantage.p.rapidapi.com' \
	--header 'X-RapidAPI-Key: 2265800bebmshdecc75d05177257p1a6f84jsnaa4db14efc77')


#quote validation
#if api_key is not  present in the output of curl statement
#then give error "invalid response from curl statement"


sym=$(echo "$resp" | jq -r '.["Global Quote"]["01. symbol"]')
open=$(echo "$resp" | jq -r '.["Global Quote"]["02. open"]')

high=$(echo "$resp" | jq -r '.["Global Quote"]["03. high"]')

low=$(echo "$resp" | jq -r '.["Global Quote"]["04. low"]')

price=$(echo "$resp" | jq -r '.["Global Quote"]["05. price"]')

volume=$(echo "$resp" | jq -r '.["Global Quote"]["06. volume"]')


insert_stmt="INSERT INTO quotes(symbol,open,high,low,price,volume) VALUES('$sym','$open','$high','$low','$price','$volume');"

export PGPASSWORD=$psql_password 

psql -h "$psql_host" -p "$psql_port" -d "$psql_database" -U "$psql_username" -c "$insert_stmt"

 

<<<<<<< HEAD
Development of Application

Introduction

The application has been developed to collect resource usage data from the Virtual Machine and insert it into Postgres tables. This has been achieved by implementing two bash scripts. The first “host_info.sh” collects the system hardware specs and stores them in host_info table. The second script “host_usage.sh” collects the system usage parameters and stores them in host_usage table. The has been been schedule using crontab to collect the data every minute. The postgres itself is installed in a docker container. 
Furthermore, the creation/start/stop functionality of docker container has also been implemented through “psql_docker.sh”. Also, a “ddl.sql” was developed to deploy the tables.
The application has been deployed using Git version control.

Quick Start
bashCopy code
# Start a psql instance using psql_docker.sh 
bash psql_docker.sh [create/start/stop] [db_username] [db_password]

# Create tables using ddl.sql 
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql 

# Insert hardware specs data into the DB using host_info.sh 
bash host_info.sh localhost 5432 host_agent postgress password

# Insert hardware usage data into the DB using host_usage.sh 
bash host_usage.sh localhost 5432 host_agent postgress password

# Crontab setup 
 * * * * * bash host_usage.sh "localhost" 5432 "host_agent" "postgres" "password" &> host_usage_log.log

Implementation
Architecture
Scripts

psql_docker.sh
Starts a Docker container with a PostgreSQL instance.
host_info.sh
Inserts hardware specifications data into the host_info table.
host_usage.sh
Inserts hardware usage data into the host_usage table.
crontab
Automates data collection at regular intervals using crontab.
Sql/ddl.sql
Contains DDLs to create host_usage and host_info tables

Database Modeling
host_info Table
Column	Data Type	Constraints
id	SERIAL	PRIMARY KEY
hostname	VARCHAR	NOT NULL, UNIQUE
cpu_number	INT2	NOT NULL
cpu_architecture	VARCHAR	NOT NULL
cpu_model	VARCHAR	NOT NULL
cpu_mhz	FLOAT8	NOT NULL
l2_cache	VARCHAR	NOT NULL
timestamp	TIMESTAMP	NULL
total_mem	INT4	NULL

host_usage Table
Column	Data Type	Constraints
timestamp	TIMESTAMP	NOT NULL
host_id	SERIAL	NOT NULL, FOREIGN KEY (host_id)
memory_free	INT4	NOT NULL
cpu_idle	INT2	NOT NULL
cpu_kernel	INT2	NOT NULL
disk_io	INT4	NOT NULL
disk_available	INT4	NOT NULL

Test
The bash scripts and DDL were tested by executing them on a local development environment. The result was successful data insertion into the PostgreSQL database, and the crontab setup demonstrated periodic data collection.

Deployment
The application is deployed using GitHub for version control. The crontab is set up to automate data collection, and Docker is used for containerization, ensuring consistent deployment across environments.

Improvements
1.	Automated application starts to collect data as soon as the Virtual Machine boots.
2.	Improvements to login mechanism for better error tracking.
3.	Explore visualization tools for better data analysis and presentation.

=======
# Jarvis Data Engineering Training
1. [Linux cluster monitoring agent (Linux and SQL)](./linux_sql) In-progress
2. [Core Java Apps](./core_java) In-progress
3. [Springboot Trading REST API](./springboot) In-progress
4. [Hadoop/Hive](./hadoop) In-progress
5. [Spark/Scala](./spark) In-progress
6. [Cloud/DevOps](./cloud_devops) In-progress
>>>>>>> 62b855c1a370897a206e6b9a5503523025b8754e


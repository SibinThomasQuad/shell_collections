#!/bin/bash

echo "Enter MySQL root password:"
read -s MYSQL_ROOT_PASSWORD

# Enable the slow query log in MySQL
echo "Enabling slow query log ..."
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SET GLOBAL slow_query_log = 'ON';"

# Specify the slow query log file and the threshold for slow queries
echo "Enter slow query log file path (default: /var/log/mysql/mysql-slow.log):"
read SLOW_QUERY_LOG_FILE

if [ -z "$SLOW_QUERY_LOG_FILE" ]; then
    SLOW_QUERY_LOG_FILE="/var/log/mysql/mysql-slow.log"
fi

echo "Enter the threshold for slow queries in seconds (default: 10):"
read SLOW_QUERY_THRESHOLD

if [ -z "$SLOW_QUERY_THRESHOLD" ]; then
    SLOW_QUERY_THRESHOLD=10
fi

# Specify the slow query log file and the threshold for slow queries in the MySQL configuration
echo "Setting slow query log file and threshold ..."
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SET GLOBAL slow_query_log_file = '$SLOW_QUERY_LOG_FILE';"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SET GLOBAL long_query_time = $SLOW_QUERY_THRESHOLD;"

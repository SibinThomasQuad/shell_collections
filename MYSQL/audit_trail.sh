#!/bin/bash

# MySQL connection details
DB_HOST="localhost"
DB_USER="your_username"
DB_PASS="your_password"
DB_NAME="your_database"

# List of tables to monitor
TABLES=("table1" "table2" "table3")

# Loop through the tables and create triggers and tables
for TABLE_NAME in "${TABLES[@]}"
do
    # Create the table
    CREATE_TABLE_QUERY="CREATE TABLE IF NOT EXISTS audit_trail_${TABLE_NAME} (
        id INT AUTO_INCREMENT PRIMARY KEY,
        table_name VARCHAR(100),
        action VARCHAR(10),
        old_data JSON,
        new_data JSON,
        change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );"
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "$CREATE_TABLE_QUERY"

    # Create the INSERT trigger
    CREATE_INSERT_TRIGGER_QUERY="CREATE TRIGGER trigger_audit_insert_${TABLE_NAME}
        AFTER INSERT ON ${TABLE_NAME}
        FOR EACH ROW
        BEGIN
            INSERT INTO audit_trail_${TABLE_NAME} (table_name, action, new_data)
            VALUES ('${TABLE_NAME}', 'INSERT', JSON_OBJECT(
                $(IFS=", "; echo "${COLUMNS[*]}=NEW.${COLUMNS[*]}")
            ));
        END"
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "$CREATE_INSERT_TRIGGER_QUERY"

    # Create the UPDATE trigger
    CREATE_UPDATE_TRIGGER_QUERY="CREATE TRIGGER trigger_audit_update_${TABLE_NAME}
        AFTER UPDATE ON ${TABLE_NAME}
        FOR EACH ROW
        BEGIN
            INSERT INTO audit_trail_${TABLE_NAME} (table_name, action, old_data, new_data)
            VALUES ('${TABLE_NAME}', 'UPDATE', JSON_OBJECT(
                $(IFS=", "; echo "${COLUMNS[*]}=OLD.${COLUMNS[*]}"),
                'change_date', NOW()
            ), JSON_OBJECT(
                $(IFS=", "; echo "${COLUMNS[*]}=NEW.${COLUMNS[*]}")
            ));
        END"
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "$CREATE_UPDATE_TRIGGER_QUERY"

    # Create the DELETE trigger
    CREATE_DELETE_TRIGGER_QUERY="CREATE TRIGGER trigger_audit_delete_${TABLE_NAME}
        AFTER DELETE ON ${TABLE_NAME}
        FOR EACH ROW
        BEGIN
            INSERT INTO audit_trail_${TABLE_NAME} (table_name, action, old_data)
            VALUES ('${TABLE_NAME}', 'DELETE', JSON_OBJECT(
                $(IFS=", "; echo "${COLUMNS[*]}=OLD.${COLUMNS[*]}")
            ));
        END"
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "$CREATE_DELETE_TRIGGER_QUERY"
done

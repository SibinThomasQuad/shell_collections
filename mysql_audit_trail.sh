#!/bin/bash

# Create a new MySQL user with read-only access
mysql -u root -p -e "CREATE USER 'audit_user'@'localhost' IDENTIFIED BY 'password';"

# Grant SELECT privilege to the audit user
mysql -u root -p -e "GRANT SELECT ON database.table TO 'audit_user'@'localhost';"

# Create the audit log table
mysql -u root -p -e "CREATE TABLE database.audit_log (
  id INT(11) NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  action VARCHAR(50) NOT NULL,
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);"

# Create triggers on the audited tables
mysql -u root -p -e "CREATE TRIGGER insert_audit_trigger
  AFTER INSERT ON database.table
  FOR EACH ROW
  INSERT INTO database.audit_log (username, action) VALUES (USER(), 'INSERT');"

mysql -u root -p -e "CREATE TRIGGER update_audit_trigger
  AFTER UPDATE ON database.table
  FOR EACH ROW
  INSERT INTO database.audit_log (username, action) VALUES (USER(), 'UPDATE');"

mysql -u root -p -

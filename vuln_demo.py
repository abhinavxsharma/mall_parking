# vuln_demo.py

import sqlite3
import os

def get_user_info(user_id):
    # CRITICAL: SQL Injection
    conn = sqlite3.connect("users.db")
    c = conn.cursor()
    sql = "SELECT * FROM users WHERE id = %s" % user_id
    c.execute(sql)  # Vulnerable to SQLi!
    return c.fetchall()

def delete_file(file_name):
    # Command Injection
    os.system("rm -rf " + file_name)  # Vulnerable to command injection

# Hardcoded credentials
db_password = "secret1234"


DB_URL = "mysql://root:password123@localhost/prod"

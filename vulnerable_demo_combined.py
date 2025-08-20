# SQL Injection via string formatting
def get_user(username):
    query = "SELECT * FROM users WHERE username = '%s'" % username
    cursor.execute(query)

# Hardcoded DB credentials
DB_USERNAME = "admin"
DB_PASSWORD = "SuperSecret123!"
conn = create_connection(user=DB_USERNAME, password=DB_PASSWORD)

# Shell command injection
import os
def delete_file(filename):
    os.system("rm -rf " + filename)

# Infinite loop
while True:
    print("Infinite loop running...")

# Insecure deserialization example
import pickle
def load_user(serialized_data):
    user = pickle.loads(serialized_data)

# File inclusion example (unsafe dynamic import)
def load_module(name):
    mod = __import__(name)

# Hardcoded secret token
SECRET_TOKEN = "12345-abcdef-67890-secret"

# SQL query constructed by concatenation
def update_password(user_id, new_password):
    query = "UPDATE users SET password = '" + new_password + "' WHERE id = " + str(user_id)
    cursor.execute(query)

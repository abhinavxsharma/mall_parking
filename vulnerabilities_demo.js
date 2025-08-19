def get_user_data(user_input):
    query = f"SELECT * FROM users WHERE name = '{user_input}'"  # Unsafe string interpolation
    cursor.execute(query)

import os
def delete_file(filename):
    os.system(f"rm -rf {filename}")  # Dangerous command injection vulnerability

DB_PASSWORD = "SuperSecret123!"  # Hardcoded database password

function displayUserInput(input) {
    document.getElementById('output').innerHTML = input;  // Vulnerable to XSS
}

<?php
$file = $_GET['page'];
include($file);  // Local file inclusion vulnerability
?>

import pickle
def load_user(data):
    user = pickle.loads(data)  # Unsafe deserialization
    return user

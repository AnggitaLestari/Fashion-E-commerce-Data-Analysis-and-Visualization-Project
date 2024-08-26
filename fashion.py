import psycopg2
import re

# Baca file SQL
with open('fashion_dataset.sql', 'r') as file:
    sql_content = file.read()

# Parse konten SQL
sql_commands = re.split(r';\s*$', sql_content, flags=re.MULTILINE)

# Koneksi ke PostgreSQL
conn = psycopg2.connect(
    dbname="databasename",
    user="yourusername",
    password="yourpassword",
    host="host",
    port="portnumber"
)

cursor = conn.cursor()

# Eksekusi setiap perintah SQL
for command in sql_commands:
    if command.strip():
        # Hapus komentar SQL jika ada
        command = re.sub(r'--.*$', '', command, flags=re.MULTILINE)
        try:
            cursor.execute(command)
        except psycopg2.Error as e:
            print(f"Error executing command: {e}")
            conn.rollback()
        else:
            conn.commit()

# Ubah tipe data kolom gender menjadi VARCHAR
alter_users = "ALTER TABLE users ALTER COLUMN gender TYPE VARCHAR(10);"
alter_items = "ALTER TABLE items ALTER COLUMN gender TYPE VARCHAR(10);"

# Transformasi untuk tabel users
transform_users = """
UPDATE users
SET gender = CASE
    WHEN gender = '0' THEN 'Male'
    WHEN gender = '1' THEN 'Female'
    ELSE 'Other'
END;
"""

# Transformasi untuk tabel items
transform_items = """
UPDATE items
SET gender = CASE
    WHEN gender = '0' THEN 'Male'
    WHEN gender = '1' THEN 'Female'
    WHEN gender = '2' THEN 'Other'
    ELSE 'Other'
END;
"""

try:
    # Ubah tipe data
    cursor.execute(alter_users)
    cursor.execute(alter_items)
    
    # Lakukan transformasi
    cursor.execute(transform_users)
    cursor.execute(transform_items)
    
    conn.commit()
    print("Transformation completed successfully.")
except psycopg2.Error as e:
    print(f"Error during transformation: {e}")
    conn.rollback()

cursor.close()
conn.close()

print("All operations completed.")
import cx_Oracle as Database

def display_banner():
    print("="*80)
    print("OraShell: Oracle Database Interactive Shell")
    print("Type 'exit' to quit, 'tables' to list tables, or any SQL query")
    print("="*80)

# Prompt for credentials and DSN information
user = input("[?] Enter username: ").strip()
password = input("[?] Enter password: ").strip()
host = input("[?] Enter host (e.g., 10.129.205.19): ").strip()
port = input("[?] Enter port (e.g., 1521): ").strip()
service_name = input("[?] Enter service name (e.g., XE): ").strip()

# Ask the user whether to connect as SYSDBA
connect_mode = 0
sysdba_choice = input("[?] Connect as SYSDBA? (Y/n): ").strip().lower()
if sysdba_choice == 'y' or sysdba_choice == '':
    connect_mode = Database.SYSDBA

try:
    # Create DSN with provided information
    dsn = Database.makedsn(host, port, service_name=service_name)
    # Attempt to connect using the selected mode
    conn = Database.connect(user=user, password=password, dsn=dsn, mode=connect_mode, encoding='UTF-8')
    
    if connect_mode == Database.SYSDBA:
        print(f"[✔] Connection successful! Connected to {host}:{port}/{service_name} as SYSDBA")
    else:
        print(f"[✔] Connection successful! Connected to {host}:{port}/{service_name}")
    
    # Initialize cursor
    cursor = conn.cursor()
    display_banner()

    # Interactive shell loop
    while True:
        query = input("SQL> ").strip()
        
        if query.lower() == 'exit':
            break
        elif query.lower() == 'tables':
            cursor.execute("SELECT table_name FROM user_tables")
            print("[+] Available tables:")
            for table in cursor:
                print(table[0])
        else:
            try:
                cursor.execute(query)
                # Check if query returns results
                if cursor.description:  # SELECT queries
                    columns = [col[0] for col in cursor.description]
                    print("[+] Results:")
                    print(columns)
                    for row in cursor:
                        print(row)
                else:  # INSERT, UPDATE, etc.
                    conn.commit()
                    print(f"[+] {cursor.rowcount} rows affected.")
            except Database.Error as e:
                print(f"[✖] Query error: {e}")

    # Close cursor and connection
    cursor.close()
    conn.close()
    print("[✔] Connection closed.")

except Database.Error as e:
    print(f"[✖] Connection error: {e}")

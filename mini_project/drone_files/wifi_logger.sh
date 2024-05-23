#!/bin/bash

# Path to the SQLite database file
DB_FILE="wifi_data.db"

# Create SQLite database table if it doesn't exist
create_table() {
    sqlite3 "$DB_FILE" "CREATE TABLE IF NOT EXISTS wifi_data (id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp INTEGER, link_quality INTEGER, signal_level INTEGER);"
}

# Insert data into the database
insert_data() {
    local timestamp=$(date +%s)
    local wireless_data=$(cat /proc/net/wireless | grep wlp3s0)
    local link_quality=$(echo "$wireless_data" | awk '{print $3}')
    local signal_level=$(echo "$wireless_data" | awk '{print $4}')
    
    sqlite3 "$DB_FILE" "INSERT INTO wifi_data (timestamp, link_quality, signal_level) VALUES ($timestamp, $link_quality, $signal_level);"
}

# Main function
main() {
    # Check if SQLite database file exists
    if [[ ! -f "$DB_FILE" ]]; then
        echo "Creating database table..."
        create_table
    fi

    # Insert data into the database
    echo "Logging WiFi data..."
    insert_data
    echo "WiFi data logged successfully."
}

# Run the main function
main

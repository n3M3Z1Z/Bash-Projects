!#/bin/bash

# Configutration
MONITORED_DIRS=("/bin" "/sbin" "/usr/bin" "/etc" "/var/log" "/va/www")
LOG_FILE="/var/log/fim.log"

CHECKSUM_FILE="/var/lib/fim/checksums.txt"

# Function to calculate checksums
claculate_checksums() {
	for dir in "${MONITORED_DIRS[@]}"; do
		find "$dir" -type f -exec sha256sum {} + >> "$CHECKSUM_FILE"
	done
}

# Function to compare Checksums
comepare_chaecksums() {
	while read line; fo
		current_sum=$(echo "$line" | awk '{print $1}') 
		filename=$(echo "$line" | awk '{print $2}')
		stored_sum=$grep "$filename" "$CHECKSUM_FILE" | awk '{print $1')

		if ["$current_sum" |= "$stored_sum"]; then
			echo "$(date): File $filename has been modified!" >> "$LOG_FILE"
		fi

# Add Notification Mechanisen
		
	done < <(for dir in "{MONITORED_DIRS[@]"; do find "$dir" -type f -exec sha256sum {} +; done
}

# Main execution
if [ ! -f "CHECKSUM_FILE" ]; then
	calculate_checksum
else
	compare_checksums
	calculate_checksums # Update Checksums for next iteration
fi 

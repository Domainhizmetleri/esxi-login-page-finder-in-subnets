#!/bin/bash

# Subnet definitions
subnet="185.210.94.0/24"
output_file="esxi_login_pages.txt"
temp_dir=$(mktemp -d)

# Clear the output file before starting
> $output_file

scan_ip() {
    ip=$1
    # Check if port 443 is open
    if timeout 1 bash -c "echo > /dev/tcp/$ip/443" 2>/dev/null; then
        # If the port is open, check for the ESXi login screen
        if curl -k -s --max-time 5 "https://$ip/ui/" | grep -q "esxUiApp"; then
            echo $ip >> "$temp_dir/result_$ip.txt"
        fi
    fi
}

# Calculate the IP range from the subnet
IFS='/' read -r base_ip mask <<< "$subnet"
IFS='.' read -r i1 i2 i3 i4 <<< "$base_ip"
ip_hex=$(printf '%02X%02X%02X%02X' $i1 $i2 $i3 $i4)
ip_dec=$((16#$ip_hex))
max=$((2**(32-$mask)-1))

# Loop over the IP range
for offset in $(seq 0 $max); do
    dec_ip=$(($ip_dec + $offset))
    ip=$(printf "%d.%d.%d.%d" $(($dec_ip>>24)) $(($dec_ip>>16&255)) $(($dec_ip>>8&255)) $(($dec_ip&255)))
    
    # Run the function in the background
    scan_ip $ip &
done

# Wait for all background processes to finish
wait

# Collect the results
cat $temp_dir/result_* >> $output_file
rm -rf $temp_dir  # Clean up the temporary directory

count=$(wc -l < $output_file)
echo "Scan complete. $count IPs with ESXi login pages found. Results saved to $output_file"

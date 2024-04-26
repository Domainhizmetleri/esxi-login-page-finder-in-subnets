#!/bin/bash

input_file="subnets.txt"  # Subnetlerin listelendiği dosya
output_file="esxi_login_pages.txt"
temp_dir=$(mktemp -d)

# Output dosyasını sıfırla
> $output_file

scan_ip() {
    ip=$1
    # 443 portunun açık olup olmadığını kontrol et
    if timeout 1 bash -c "echo > /dev/tcp/$ip/443" 2>/dev/null; then
        # Port açıksa, ESXi login ekranını kontrol et
        if curl -k -s --max-time 5 "https://$ip/ui/" | grep -q "esxUiApp"; then
            echo $ip >> "$temp_dir/result_$ip.txt"
        fi
    fi
}

scan_subnet() {
    subnet=$1
    # Subnet'ten IP aralığını hesapla
    IFS='/' read -r base_ip mask <<< "$subnet"
    IFS='.' read -r i1 i2 i3 i4 <<< "$base_ip"
    ip_hex=$(printf '%02X%02X%02X%02X' $i1 $i2 $i3 $i4)
    ip_dec=$((16#$ip_hex))
    max=$((2**(32-$mask)-1))

    # IP aralığı üzerinde döngü
    for offset in $(seq 0 $max); do
        dec_ip=$(($ip_dec + $offset))
        ip=$(printf "%d.%d.%d.%d" $(($dec_ip>>24)) $(($dec_ip>>16&255)) $(($dec_ip>>8&255)) $(($dec_ip&255)))
        
        # Fonksiyonu arka planda çalıştır
        scan_ip $ip &
    done

    # Tüm arka plan işlemlerinin bitmesini bekle
    wait
}

# Subnet dosyasından her bir subnet'i oku ve tara
while IFS= read -r subnet; do
    echo "Scanning subnet: $subnet"
    scan_subnet $subnet
done < "$input_file"

# Sonuçları topla
cat $temp_dir/result_* >> $output_file
rm -rf $temp_dir  # Geçici dizini temizle

count=$(wc -l < $output_file)
echo "Scan complete. $count IPs with ESXi login pages found. Results saved to $output_file"

ip=$(curl -s ifconfig.io/ip)
echo "Kernel: $(uname -r) | Hostname: $(hostname) | IPv4: $ip | Date: $(date -u) | Timestamp: $(date +%s)"

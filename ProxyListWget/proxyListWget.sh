#!/bin/bash
# This script will download file from remote host via any available proxy from list.
# Usage it like: `bash proxyListWget.sh [https://DownloadLink] [path/to/proxy_list.txt] [(optional)path/to/output_file_with_working_proxy.txt]`

PROXY_LIST=$2
TARGET_URL=$1
OUTPUT_FILE=$3
TIMEOUT=5

check_proxy() {
    local ip=$1
    local port=$2
    
    if nc -z -w $TIMEOUT $ip $port 2>/dev/null; then
        echo "Proxy $ip:$port is available"
        return 0
    else
        echo "Proxy $ip:$port is not available"
        return 1
    fi
}

run_wget() {
    local ip=$1
    local port=$2
    local proxy="$ip:$port"
    
    wget -c -e use_proxy=yes -e https_proxy=$proxy -e http_proxy=$proxy \
         --timeout=$TIMEOUT --tries=2 $TARGET_URL
    
    if [ $? -eq 0 ]; then
        echo "Successfully connected to $TARGET_URL via proxy $proxy"
        return 0
    else
        echo "Failed to connect via proxy $proxy"
        return 1
    fi
}

# int main()
if [ $# -lt 2 ]; then
    echo "Usage: $0 <target_url> <proxy_list_file> [output_file]"
    exit 1
fi

if [ ! -f "$PROXY_LIST" ]; then
    echo "File $PROXY_LIST not found!"
    exit 1
fi

echo "Starting proxy check..."
echo "Target URL: $TARGET_URL"

success=false

while IFS= read -r line || [ -n "$line" ]; do
    if [[ -z "$line" || "$line" =~ ^# ]]; then
        continue
    fi
    
    ip=$(echo "$line" | awk '{print $1}')
    port=$(echo "$line" | awk '{print $2}')
    
    if [[ -z "$ip" || -z "$port" ]]; then
        continue
    fi
    
    echo "Checking: $ip:$port"
    
    if check_proxy "$ip" "$port"; then
        if run_wget "$ip" "$port"; then
            # Only if file was fully downloaded
            echo "Working proxy found: $ip:$port"
            if [ ! -z "$OUTPUT_FILE" ]; then
                echo "$ip:$port" >> "$OUTPUT_FILE"
                echo "Proxy saved to: $OUTPUT_FILE"
            fi
            success=true
            break
        fi
    fi
    
done < "$PROXY_LIST"

if [ "$success" = false ]; then
    echo "No working proxies found in the list"
    exit 1
fi

echo "Script completed successfully!"

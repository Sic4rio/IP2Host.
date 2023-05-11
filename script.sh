if [ "$#" -ne 1 ]; then
    echo "ip2hosts <ip>"
    exit 1
fi

ip2hosts() {
    total_lines=$(wc -l < input.txt)
    current_line=0

    while IFS= read -r ip; do
        current_line=$((current_line + 1))
        rm /tmp/domains.txt 2>/dev/null
        curl -ks "https://freeapi.robtex.com/ipquery/$ip" | grep -Po "(?<=\"o\":).*?(?=,)" | sed 's/\"//g' >> /tmp/domains.txt
        curl -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0" "https://api.hackertarget.com/reverseiplookup/?q=$ip" >> /tmp/domains.txt
        echo "" >> /tmp/domains.txt
        curl "http://www.virustotal.com/vtapi/v2/ip-address/report?ip=$ip&apikey=3c052e9a7339f3a73f00bd67baea747e47f59ee6c1596e59590fd953d00ce519" -s | grep -Po "(?<=hostname\": \").*?(?=\")" >> /tmp/domains.txt
        dig +short -x $ip 2>&1 | grep -v "connection timed out" >> /tmp/domains.txt
        curl -ks "https://www.bing.com/search?q=ip%3a$ip" | grep -Po "(?<=<a href=\").*?(?= h=)" | grep -Po "(?<=://).*?(?=/)" | egrep -v "microsoft|bing|pointdecontact" >> /tmp/domains.txt
        nmap -p443 -Pn --script ssl-cert $ip | grep Subject | grep -Po "(?<=commonName=).*?(?=/)" | tr '[:upper:]' '[:lower:]' >> /tmp/domains.txt
        sed -i 's/\.$//g' /tmp/domains.txt
        curl -X POST -F "remoteAddress=$ip" http://domains.yougetsignal.com/domains.php -s | /usr/bin/perl -p | grep -Poz "(?s)\[.*\]" | cat -v | grep -Po "(?<=\").+(?=\")" >> /tmp/domains.txt
        #curl -i -s -k  -X 'POST' -F "theinput=$ip" -F "thetest=reverseiplookup" -F "name_of_nonce_field=23gk"    'https://hackertarget.com/reverse-ip-lookup/' | grep -Poz "(?s)(?<=<pre id=\"formResponse\">).*?(?=</pre>)" | grep -Piva "no records" | grep -Pa \w>> /tmp/domains.txt
        curl -m 3 -ks "https://www.threatcrowd.org/graphHtml.php?ip=$ip" | grep -Po "(?<=id: ').*?(?=')" | grep -v  ^[0-9] | grep -v @ >> /tmp/domains.txt
        curl -s -m 3 "https://www.pagesinventory.com/ip/$ip" | grep -Po "(?<=<ahref=\"/domain/).*?(?=\.html)" >> /tmp/domains.txt
        curl -m 3 -A "Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0" -ks "https://securitytrails.com/list/ip/$ip" | grep -Po "(?<=/dns\">).*?(?=</a>)" >> /tmp/domains.txt
        sort -u /tmp/domains.txt >> output.txt

        # Update progress bar
        progress=$((current_line * 100 / total_lines))
        printf "\rScanning IP %d/%d [%d%%]" "$current_line" "$total_lines" "$progress"
    done < input.txt

    printf "\nScan completed. Results saved to output.txt\n"
}

ip2hosts

#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_time()
{
    int_time=$(echo $1|awk -F\. '{print $1}')
    if [[ $int_time -ge 100 ]]; then
        echo -e "${PURPLE}$1${NC}"
    elif [[ $int_time -lt 100 ]] && [[ $int_time -gt 0 ]]; then
        echo -e "${GREEN}$1${NC}"
    else
        echo -e "${RED}loss${NC}"
    fi
}

pingtest ()
{
    while read line
    do
        city=$(echo $line|awk '{print $1}')
        test_url=$(echo $line|awk '{print $2}')
        ip=$(ping -c 1 -t 1 $test_url|head -n 1|awk -F\( '{print $NF}'|awk -F\) '{print $1}') &&
            time=$(ping -c 1 -t 1 $test_url|awk 'NR==2{print $0}'|awk -F= '{print $NF}'|sed -e 's/ms//g') &&
        # country=$(mmdblookup -f ./GeoLite2-City_20200414/GeoLite2-City.mmdb -i $ip country names zh-CN|awk '{print $1}'|sed -e 's/\"//g') &&
                echo -e $test_url $ip $city $(print_time $time)
        # $($time > 0 ? $time : "${RED}loss${NC}")
    done <"$1"
}

main ()
{
    node_list=./nodes/*
    for file in $node_list
    do
        echo $file
        pingtest $file
    done
}

main

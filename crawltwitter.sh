#!/bin/bash -l
IFS="," 
while 
read f1 f2 
do 
nama=`echo $f1 |  tr ' ' '-' | tr '\t' '-'`
echo "id $nama" 
url=${f2%?}
if [ "$url" != "-" ]
then
	status=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8)" -w "%{http_code}" -o temp -L --silent "$url")
	if [[ "$status" =~ "200" ]]
	then
		now=$(date +"%d-%m-%y-%H-%M")
		grep '<p class="TweetTextSize TweetTextSize--[0-9][0-9]px js-tweet-text tweet-text"' temp | sed -n '/^$/!{s/<[^>]*>//g;p;}'  > feed
		grep -oh "[0-9][0-9]\.[0-9][0-9] - [0-9][0-9]* [A-Z][a-z][a-z] [0-9][0-9][0-9][0-9]" temp  | uniq| sed '1d' > tgl
		paste tgl feed | tr '[:upper:]' '[:lower:]' > "res/$nama-$now-t.tsv"
		rm tgl feed temp
	fi
fi 
done < $1 



#!/bin/bash

###
### START UP
###



## I will setup an encrypted list that will allow for us to setup a hashmap to contributers looking up at least 100 numbers per access to 
## the semi-open source database of numbers. Limit # of connections from IP per day. These are some of the ways we can allow for control of leechers.

## setup login details here
./g_login.sh

mkdir google_voice_numbers
cd google_voice_numbers

URL="https://www.google.com/voice/b/0/setup/searchnew/"
##COOKIES="gv=DQAAAxxxxxx; PREF=xxxxx; xxxx SSID=xxxx" # PUT YOUR COOKIES IN HERE
curl --cookie "$COOKIES" "${URL}?ac=305&q=305&start=0&country=US"


###
### PUBLIC BLOG WAY
###

curl --cookie "$COOKIES" "${URL}?ac=[201-999]&start=0" | grep -ho "+1[0-9]\{3\}" | cut -b3-5 | sort -u >> areacodes

### CHOOSE THE AREA CODES YOU WANT HERE
echo -e "7472222222\n2122222222" > numbers
echo -e "2150000000\n2670000000\n4840000000" > numbers
for a in $(cat areacodes); do echo "${a}0000000"; done > numbers # GET ALL NUMBERS
cut -b1-3 numbers | sort -u | (while read LINE; do curl --cookie "$COOKIES" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -Pho '\d{10}\b' | sort -u >> numbers
cut -b1-4 numbers | sort -u | (while read LINE; do curl --cookie "$COOKIES" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -Pho '\d{10}\b' | sort -u >> numbers
cut -b1-5 numbers | sort -u | (while read LINE; do curl --cookie "$COOKIES" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -Pho '\d{10}\b' | sort -u >> numbers
cut -b1-6 numbers | sort -u | (while read LINE; do curl --cookie "$COOKIES" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -Pho '\d{10}\b' | sort -u >> numbers
cut -b1-7 numbers | sort -u | (while read LINE; do curl --cookie "$COOKIES" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -Pho '\d{10}\b' | sort -u >> numbers
cut -b1-8 numbers | sort -u | (while read LINE; do curl --cookie "$COOKIES" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -Pho '\d{10}\b' | sort -u >> numbers
cut -b1-8 numbers | sort -u | (while read LINE; do curl --cookie "$COOKIES" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=5"; done) | grep -Pho '\d{10}\b' | sort -u >> numbers


###
### IMPROVEMENTS NOT RELEASED TO BLOG
### (compatible Mac & Linux)
###

# DIFS?
# LOGIN TO SOME SERVER YOU CAN RUN, NOT YOUR LAPTOP!
ssh root@A
screen

curl --cookie "$COOKIES" "${URL}?ac=[201-999]&start=0" | egrep -ho '[0-9]{10}\b' > numbers
cut -b1-3 numbers | sort -u > areacodes
cut -b1-3 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | xargs -P10 -- curl --cookie "$COOKIES" | egrep -o '[0-9]{10}\b' >> numbers
cut -b1-4 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | xargs -P10 -- curl --cookie "$COOKIES" | egrep -o '[0-9]{10}\b' >> numbers
cut -b1-5 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | xargs -P10 -- curl --cookie "$COOKIES" | egrep -o '[0-9]{10}\b' >> numbers
cut -b1-6 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | xargs -P10 -- curl --cookie "$COOKIES" | egrep -o '[0-9]{10}\b' >> numbers
cut -b1-7 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | xargs -P10 -- curl --cookie "$COOKIES" | egrep -o '[0-9]{10}\b' >> numbers
cut -b1-8 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | xargs -P10 -- curl --cookie "$COOKIES" | egrep -o '[0-9]{10}\b' >> numbers
cut -b1-8 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]\&start=5|" | xargs -P10 -- curl --cookie "$COOKIES" | egrep -o '[0-9]{10}\b' | sort -u >> numbers
echo 'done' | mail 'fulldecent@gmail.com' -s hello


###
### CRAZY NEW PARALLEL WAY
###

# A,B,C are a bunch of servers you have root access to
PARALLEL_OPTS="-n5 --max-procs 2 --sshlogin :,A,B,C,... --eta" 

curl --cookie "$COOKIES" "${URL}?ac=[201-999]&start=0" | egrep -ho '[0-9]{10}\b' >> numbers
cut -b1-3 numbers | sort -u > areacodes
cut -b1-3 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | parallel $PARALLEL_OPTS "curl --silent --cookie '$COOKIES' {} | egrep -o '[0-9]{10}\b' | sort -u" >> numbers
cut -b1-4 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | parallel $PARALLEL_OPTS "curl --silent --cookie '$COOKIES' {} | egrep -o '[0-9]{10}\b' | sort -u" >> numbers
cut -b1-5 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | parallel $PARALLEL_OPTS "curl --silent --cookie '$COOKIES' {} | egrep -o '[0-9]{10}\b' | sort -u" >> numbers
cut -b1-6 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | parallel $PARALLEL_OPTS "curl --silent --cookie '$COOKIES' {} | egrep -o '[0-9]{10}\b' | sort -u" >> numbers
cut -b1-7 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | parallel $PARALLEL_OPTS "curl --silent --cookie '$COOKIES' {} | egrep -o '[0-9]{10}\b' | sort -u" >> numbers
cut -b1-8 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|" | parallel $PARALLEL_OPTS "curl --silent --cookie '$COOKIES' {} | egrep -o '[0-9]{10}\b' | sort -u" >> numbers
cut -b1-8 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]\&start=5|" | parallel $PARALLEL_OPTS "curl --silent --cookie '$COOKIES' {} | egrep -o '[0-9]{10}\b' | sort -u" >> numbers
echo 'done' | mail 'fulldecent@gmail.com' -s hello


###
### CRAZY NEW PERL WAY -- DOESN'T WORK YET
###

The goal is to avoid asking Google about numbers we already know exist.

INSTEAD OF 
    cut -b1-3 numbers | sort -u | sed "s|^\(...\).*|$URL?ac=\1\&q=&[0-9]|"

DO
    %have=map{/^..../g=>1}<>;            // 2151, 2152, 2161...
    %want=map{m/(.+)./=>2}keys %have;    // 215, 216, ...
    for $i(sort keys %want){
      print "'$URL'?ac=",(substr $_,0,3),"&q=$_&start=0\n" for grep !$have{$_}, map "$i$_",0..9
    }

INTERESTING
    %haveToRoot=map{/^(...)./;$&=>$+}<>;

INTERESTING
    cut -b1-3 tmp | (while read LINE; do for a in ${LINE}{0..9}; do echo $a; done; done;)

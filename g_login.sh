#!/bin/bash
#############################################
## Randy Amiel -- Contributer 2016
##
## Bash Script to get the google cookies needed to login
## in a pure bash console window using curl
#############################################


## Setup your login details
g_email="randy.amiel@gmail.com"
g_password="Randy Amiel"


## Handle Google login requests and setup cookies variable so we can run this on a server!
## I think this will fix the parallel problem since some systems might be secure and dont allow you to screen off

touch gv.cookies

curl \
    -L \
    -k \
    -s \
    -c gv.cookies \
    -b gv.cookies \
    -F "$g_email" \
    -F "Passwd=$g_password" \
    -F service=grandcentral \
    --location \
    https://accounts.google.com/ServiceLogin
    
 COOKIES='cat gv.cookies'

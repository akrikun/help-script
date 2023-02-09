#!/bin/bash

BASE_PATH="/path/to/dir/pomupload"

LIST=$(find $BASE_PATH -type f -name "*\.pom" | grep -v source)

for i in $LIST
do

    LIST_NAME=$(echo $i |sed 's#/# #g' | awk  '{print $(NF-0)}')
    NAME=$(a=$(echo $LIST_NAME | sed 's#-# #g' | awk '{print $(NF-0)}'); echo $LIST_NAME | sed -e "s#-$a# #g" )
    VER=$(echo $i | sed 's#/# #g' | awk  '{print $(NF-1)}')
    GROUP=$(echo $i | sed -e "s#/$VER# #g" | awk '{print $1}'| sed  "s#pomupload/# #g"| awk '{print $2}'|sed "s#/# #g"  | awk 'NF{NF-=1};1' |sed "s# #.#g")
    
    /Users/apache-maven-3.8.4/bin/mvn deploy:deploy-file \
        -DgroupId=$GROUP \
        -DartifactId=$NAME \
        -Dversion=$VER \
        -Dfile=$i \
        -Dpackaging=pom \
        -DupdateReleaseInfo=true \
        -Durl="https://LOGIN:PASS@nexus-url.com/repository/pfom-maven-lib/"
done
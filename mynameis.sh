#!/bin/bash

if [ "$1" == "" ] ; then
	echo -e "\nUsage: $(basename $0) hostname\n"
	echo -e "\tsets the hostname in all the right places\n";
	exit -1
fi

echo $1 > /etc/hostname
hostname $1
sed -i.bak -e "s/^127\.0\.0\.1.*localhost/& $1/" /etc/hosts

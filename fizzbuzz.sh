#!/bin/bash
for i in {1..100}
do
	if [ "$(($i%3))" == "0" ]
	then
		if [ "$(($i%5))" == "0" ]
		then
			echo FizzBuzz
		else
			echo Fizz
		fi
	else
		if [ "$(($i%5))" == "0" ]
		then
			echo Buzz
		else
			echo $i
		fi
	fi
done

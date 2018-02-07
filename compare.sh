#!/usr/bin/env bash
# Usage on OSX: compare-xamarin.sh /Volumes/Users/Alexander/Desktop/dotnet-standard/bin/AnyOS.AnyCPU.Debug/netstandard

frameworkpath=$2
checkdir=$1
result=0

	for file in $checkdir/*.dll
	do

		if [ -e $frameworkpath/Facades/$(basename $file) ]; then
			frameworkFile=$frameworkpath/Facades/$(basename $file)
		else
			frameworkFile=$frameworkpath/$(basename $file)
		fi

		if [ ! -f $frameworkFile ]; then
			echo "Checking $file ... not found in framework, skipping."
			continue
		fi

		echo "Checking $file"

		rm -f sna.txt snb.txt
		sn -q -Tp $file > sna.txt
		sn -q -Tp $frameworkFile > snb.txt
		if ! diff sna.txt snb.txt ; then echo "-- Differences found in sn --"; result=1; fi

		rm -f ika.txt ikb.txt
		ikdasm --assembly $file | head -n4 > ika.txt
		ikdasm --assembly $frameworkFile | head -n4 > ikb.txt
		if ! diff ikb.txt ika.txt ; then echo "-- Differences found in ikdasm --"; result=1; fi

		rm -f expa.txt expb.txt
		ikdasm --exported $file | cut -f "2" -d " " - | sort | grep -v "^\." > expa.txt
		ikdasm --exported $frameworkFile | cut -f "2" -d " " - | sort | grep -v "^\." > expb.txt
		if ! diff expb.txt expa.txt ; then echo "-- Differences found in exported --"; result=1; fi
	done

if [ $result != 0 ]; then echo "FAIL: Differences found, check output above"; fi

exit $result

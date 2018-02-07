#!/usr/bin/env bash
# Usage on OSX: compare-xamarin.sh /Volumes/Users/Alexander/Desktop/dotnet-standard/bin/AnyOS.AnyCPU.Debug/netstandard

checkdir=$1
result=0

	for file in $checkdir/*.dll
	do
		if [[ "$file" == *netstandard.dll* ]]; then continue; fi
		echo "Checking $file"

		frameworkpath=../../v4.5/

		if [ -e $frameworkpath/Facades/$(basename $file) ]; then
			frameworkFile=$frameworkpath/Facades/$(basename $file)
		else
			frameworkFile=$frameworkpath/$(basename $file)
		fi

#		rm -f sna.txt snb.txt
#		sn -q -Tp $file > sna.txt
#		sn -q -Tp $frameworkFile > snb.txt
#		if ! diff sna.txt snb.txt ; then echo "!!! Differences found in sn !!!"; result=1; fi

		rm -f ika.txt ikb.txt
		ikdasm --assemblyref $file | grep "Name=" | sort > ikb.txt
		ikdasm --assemblyref $frameworkFile | grep "Name=" | sort > ika.txt
		if ! icdiff ika.txt ikb.txt ; then echo "!!! Differences found in ikdasm !!!"; result=1; fi
	done

if [ $result != 0 ]; then echo "FAIL: Differences found, check output above"; fi

exit $result

#!/bin/bash
source=$1
destination=$2
local size
image="$source"



for (( i=1; i<=12; i++ )); do
	case $i in
		2)
			source_start=$(cgpt show -i 4 -b "$source")
			size=$(cgpt show -i 4 -s "$source")
		;;
		5)
			source_start=$(cgpt show -i 3 -b "$source")
			size=$(cgpt show -i 3 -s "$source")
		;;

		6|9|10|11)
			continue
		;;

		*)
			source_start=$(cgpt show -i $i -b "$source")
			size=$(cgpt show -i $i -s "$source")
		;;
	esac
	destination_start=$(cgpt show -i $i -b "$destination")
	if [ ! -z "$zenity" ]; then
		dd if="$image" ibs=512 count="$size" skip="$source_start" 2> /dev/null | pv -n -s $(( $size * 512 )) 2> >(zenity --height=480 --width=640 --title="Brunch installer" --progress --auto-close --text="Writing partition $i..." --percentage=0 --no-cancel) | dd of="$destination" obs=512 seek="$destination_start" conv=notrunc 2> /dev/null || error $i
	else
		dd if="$image" ibs=512 count="$size" skip="$source_start" 2> /dev/null | pv -s $(( $size * 512 )) | dd of="$destination" obs=512 seek="$destination_start" conv=notrunc 2> /dev/null || error $i
	fi
done
}

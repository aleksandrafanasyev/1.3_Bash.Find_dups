#!/bin/sh
#set -x
if [ $# -ne 2 ]; then
	echo "Usage: $0 DIR name|cont [rm_script_name])"
        exit 1
fi


if [ -z "$3"]
then	
       	rm_script_name="$1"/rm_dup.sh
else
       	rm_script_name="$1"/"$3"
fi

case "$2" in
	"name"	)
	  	echo "#!/bin/sh" > "$rm_script_name"
	  	echo "###########---name dups---###########################################" >> "$rm_script_name"
		find "$1" -type f -printf "%p: :%f\n" \
			| sort -t ':' -k3 \
			| uniq -f1 --all-repeated=separate \
			| awk -F ":" '{if ( $1 == ""){print "#============================="} else print "#rm " $1}' \
			>> "$rm_script_name"
#		{sed -e 's/\(.*\): :.*/readlink -f "\1"/' | sh} <
		;;
	"cont"	)
	  	echo "#!/bin/sh" > "$rm_script_name"
	  	echo "############---cont dups---###########################################" >> "$rm_script_name"
		find "$1" -type f -exec md5sum {} \; \
			| sort  \
			| uniq -w32 --all-repeated=separate \
			| awk '{if ( $1 == ""){print "#=============================="} else print "#rm " $2}' \
			>> "$rm_script_name"

		;;
	*	)
		echo "Usage: $0 DIR name|cont [rm_script_name])"
        	;;
esac


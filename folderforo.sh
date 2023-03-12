#!/bin/bash
input="/Users/bchangiz/gozar/goodinput"
lc=1
del='\t'
farsi=true
preq="NONE"
while IFS= read -r line
do
  path="/Users/bchangiz/gozar/surveyproc/$lc"
  if [[ -f "$path" ]]; then
	realans=$(sed 's/ANSWER~//' <<< $line)
	echo $realans > $path
  else
	quest=$(cut -d '~' -f 1 <<< $line)
	if [[ "$quest" != ""  ]]; then
		detail=$(cut -d '~' -f 2 <<< $line)
		srch="o o o o"
		if grep -E -q "\b${srch}\b" <<<${detail} >/dev/null 2>&1
		then
			convert=true
		else
			pre=$((lc+1))
			convert=false
		fi
		if [[ "$quest" == "QUESTION" ]]; then
			preq=$detail
			seenans=false
			BUFQ="$lc$del$detail"
		elif [[ "$quest" == "ANSWER" ]]; then
			if [[ "$convert" == "false" ]]; then
				if [[ "$BUFQ" != "$lastq" ]]; then
					echo "Qfarsi:$farsi$del$BUFQ"
				fi
				echo "Afarsi:$farsi$del$lc$del$detail"
				lastq=$BUFQ
			else 
				if [[ "$seenans" == "false" ]]; then
					echo "SQfarsi:$farsi$lc$del$BUFQ"
					seenans=true
				fi
				echo "QQfarsi:$farsi$del$lc$del$detail"
				echo "Rfarsi:$farsi$del$pre$del$realans"
				anscount=$(tr -cd '(' <<< $realans | wc -c)
				i=100000 ####temp
				while (( $i <= $anscount ));
				do
					temp=$(cut -d ')' -f $i <<< $realans)
					chfarsi=$(cut -f 1 -d '(' <<< $realans | wc -c)
					if (( $chfarsi == 1 )); then
						farsi=true
						nexti=$((i+1))
						if (( $anscount == $i )); then
							lst=$(cut -d '(' -f $nexti <<< $realans)
							echo "AAfarsi:$farsi$del$pre:$i$del$lst)"
						else
							nxt=$(cut -d '(' -f $nexti <<< $realans)
							corr=$(cut -f 1 -d '(' <<< $nxt)
							echo "AAfarsi:$farsi$del$pre:$i$del$corr)"
						fi
					else
						farsi=false
						echo "AAfarsi:$farsi$del$pre:$i$del$temp)"
					fi
  					i=$((i+1))
				done
			fi
		fi
	fi
  fi
  lc=$((lc+1))
done < "$input"

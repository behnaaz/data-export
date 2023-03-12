LANG=''
OLANG=''
while read -r dline; do
    line=`echo $dline | sed "s/\r//" | sed "s/$//"`
	#echo "--- processing $line"
	del=`echo $line | cut -f 1 -d ' '`
	if [[ "$del" =~ 'QQfarsi:'* ]]; then 
		noeng=$(echo $line | sed 's/[0-9A-Za-z ]//g' | sed 's/,//g' | sed 's/\[//g' | sed 's/\]//g' | sed 's/\t//g' | wc -c)
		if (( $noeng > 9 )); then
			LANG='fa'
			OLANG='en'
		else
			LANG='en'
			OLANG='fa'
		fi
		#echo "--- processing question $line  $LANG and olang $OLANG"
		CLEAN_Q=`echo $line | cut -f 2- -d ' ' | sed 's/([0-9]*)//' | sed 's/o o o o//' | sed 's/ o //'`
		STERM=`echo $CLEAN_Q | cut -f 2-9 -d ' '`
		SRCH=`grep "$STERM" dl-questions.tsv`
		SRCHRES=$?
		if [[ "$SRCHRES" != "0" ]]; then
			echo "not found: $CLEAN_Q"
			GOODQ=false
		else 
			A=1
			CNT=`echo $SRCH | wc -l`
			if (( $CNT == 1 )); then
				nochoice=`echo "$SRCH" | grep "\[\]" | wc -c `
				if (( $nochoice > 0 )); then
					GOODQ=true
				else
					echo "----- answeredd $SRCH"
				fi
			else
				GOODQ=false
				echo "$CLEAN_Q :not found once but $CNT to dblcheck"
			fi	
		fi
		#echo "--- processing question $line isgood? $GOODQ $LANG and olang $OLANG"
	elif [[ "$del" =~ 'AAfarsi:'* ]]; then 
		#echo "--- processing choice $line $GOODQ $SRCH  $LANG and olang $OLANG"
		FINAL=''
		OQ=''
		if [[ "$GOODQ" == "true" ]]; then
			QID=$(echo $SRCH | cut -f 1 -d ' ')
			if [[ -f ./wrk/q-${QID}-${OLANG} ]]; then
				OQ=`cat ./wrk/q-${QID}-${OLANG}`
			fi
			echo $CLEAN_Q > "./wrk/q-${QID}-${LANG}"
			ch=`echo $line | cut -f 2- -d ' '`
			if [[ "$LANG" == "fa" ]]; then
				VAL=`echo $ch | cut -f 1 -d ')'`
			else
				VAL=`echo $ch | cut -f 2 -d '('`
			fi
			VAL=`echo $VAL | sed 's/(//' | sed 's/)//'`
			VAL=`echo $VAL | cut -f 1 -d '.'`
			ch=`echo $ch | sed 's/(//' | sed 's/)//' | sed "s/${VAL}//" | sed 's/~//g' | sed 's/)//'`
			if [[ -f ./wrk/a-$QID-$OLANG-$VAL ]]; then
				OA=`cat ./wrk/a-${QID}-${OLANG}-${VAL}`
			fi
			sp=','
			if [[ -f ./wrk/q-${QID}-${OLANG} ]]; then
				if [[ "$LANG" == "en" ]]; then
					FINAL="$QID$sp\"$CLEAN_Q\"$sp\"$OA\"$sp\"$ch\"$sp$VAL$sp0" 
				else
					FINAL="$QID$sp\"$CLEAN_Q\"$sp\"$ch\"$sp\"$OA\"$sp$VAL$sp0" 
				fi
			fi
			if [[ ! -f ./wrk/done-$QID-$VAL ]]; then
				if [[ -f ./wrk/a-$QID-$OLANG-$VAL ]] ; then
					if [[ ! -f ./doneq/q$QID ]]; then
						touch "./wrk/done-$QID-$VAL"
						FINAL=`echo $FINAL | sed "s/\r\n//g"`
						FINAL=`echo $FINAL | sed "s/\n//g"`
						echo "----s-----"
						echo $FINAL
						echo "----t-----"
					else
						echo "q $QID done -----"
					fi
				else
					echo "choice $OLANG for $QID $VAL not ch done ---"
				fi
			else
				echo "qu $OLANG for $QID  qN not done ---"
			fi
			echo "$ch" | sed "s/$VAL//" > "./wrk/a-${QID}-${LANG}-${VAL}"
			A=$(( A+1 ))
		fi
	fi

done < all_pable.tsv

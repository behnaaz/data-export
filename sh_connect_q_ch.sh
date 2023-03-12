Q=0
QTXT=''
A='undef'
V='undef'
LANG=''
while read -r line; do
	del=`echo $line | cut -f 1 -d ' '`
	if [[ "$del" =~ 'QQfarsi:'* ]]; then 
		noeng=$(echo $line | sed 's/[0-9A-Za-z ]//g' | sed 's/,//g' | sed 's/\[//g' | sed 's/\]//g' | sed 's/\t//g' | wc -c)
		if (( $noeng > 9 )); then
			LANG='fa'
		else
			LANG='en'
		fi
		#echo "IGNORE $LANG $noeng $line"
		Q=$(( Q+1 ))
		A='undef'
		CLEAN_Q=`echo $line | cut -f 2- -d ' ' | sed 's/([0-9]*)//' | sed 's/o o o o//' | sed 's/o//'`
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
				GOODQ=true
			else
				GOODQ=true
				echo "$CLEAN_Q :not found once but $CNT to dblcheck"
			fi	
		fi
	elif [[ "$del" =~ 'AAfarsi:'* ]]; then 
		if [[ "$GOODQ" == "true" ]]; then
			QID=$(echo $SRCH | cut -f 1 -d ' ')
			echo "$QID \t $CLEAN_Q" | tee ./wrk/"q-$QID-$LANG"
			ch=`echo $line | cut -f 2- -d ' '`
			if [[ "$LANG" == "fa" ]]; then
				VAL=`echo $ch | cut -f 1 -d ')'`
			else
				VAL=`echo $ch | cut -f 2 -d '('`
			fi
			VAL=`echo $VAL | sed 's/(//' | sed 's/)//'`
			ch=`echo $ch | sed 's/(//' | sed 's/)//' | sed 's/${VAL}//' | sed 's/~//g' | sed 's/)//'`
			echo "$A \t $ch" | tee ./wrk/"a-$QID-$LANG-$VAL"
			A=$(( A+1 ))
		fi
	fi

done < all_pable.tsv

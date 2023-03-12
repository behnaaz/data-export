SURVEY="37"

CH1F='کارا'
CH1E='Effective'
V1='2'
CH2F='تا حدی کارا'
CH2E='Somewhat Effective'
V2='1'
CH3F='مضر'
CH3E='Harmful'
V3='-2'
CH4F='نظری ندارم'
CH4E='No Opinion'
V4='99'

F1='افزایش فشارهای اقتصادی باعث افزایش  نارضایتی و حضور مردم در خیابان می‌شود و به شکست ساختار قدرت کمک می‌کند'
E1='Economic pressures by increasing dissatisfaction bring people into the streets and help defeat the repression forces'
F2='فشارهای اقتصادی باعث می‌شود مردم نتوانند به اعتراض ادامه بدهند'
E2="Economic pressures reduce people's ability to continue protest campaigns over longer periods"
F3='فشارهای اقتصادی احتمال  ظهور یک دولت پوپولیست و اقتدارگرا را (پس از جمهوری اسلامی)  افزایش می‌دهد'
E3="Economic hardship increases the risk of populist and undemocratic governments emerging after the potential collapse of the current regime"
F4="ممکن است گذار موفق نباشد و فشارهای اقتصادی صرفا هزینه درازمدت جدی به مردم تحمیل کند"
E4="Defeat of the current regime is not certain, thus the increase in economic pressures may cause serious long-term hardships to the Iranian people"
F5="فشارهای اقتصادی نظام را ضعیف می‌کند و ضعف نظام به  به ریزش نیروهای سرکوب می‌انجامد"
E5="By weakening the government, economic pressures contribute to defections among security forces"
F6="اگر  هدف گذار دموکراتیک باشد، می‌توان گفت در مجموع فواید تضعیف اقتصادی ایران بیش از مضرات آن است"
E6="Overall, on the path to democratic transition, the benefits of weakening Iran economically outweigh its disadvantages"

#echo "survey,min,max,question_en,question_fa,status"         
#echo "$SURVEY,1,1,\"$E1\",\"$F1\",draft"
#echo "$SURVEY,1,1,\"$E2\",\"$F2\",draft"
#echo "$SURVEY,1,1,\"$E3\",\"$F3\",draft" 
#echo "$SURVEY,1,1,\"$E4\",\"$F4\",draft"
#echo "$SURVEY,1,1,\"$E5\",\"$F5\",draft"
#echo "$SURVEY,1,1,\"$E6\",\"$F6\",draft"
echo "question,choice_fa,choice_en,value,count,status"
for i in {44..46}
do
    echo "$i,\"$CH1F\",\"$CH1E\",$V1,0,draft"
    echo "$i,\"$CH2F\",\"$CH2E\",$V2,0,draft"
    echo "$i,\"$CH4F\",\"$CH4E\",$V4,0,draft"
    echo "$i,\"$CH3F\",\"$CH3E\",$V3,0,draft"
done


#####baraye useful farsi ro zadam ghalat to bazi choice ha
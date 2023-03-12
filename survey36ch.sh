SURVEY="36"

CH1F='لازم'
CH1E='Critical'
V1='2'
CH2F='مفید'
CH2E='Useful'
V2='1'
CH3F='کم‌اهمیت'
CH3E='Unimportant'
V3='0'
CH4F='نظری ندارم'
CH4E='No Opinion'
V4='99'

F1='عدم قطعیت در مواضع و تصمیمات نشانه تفکر سطحی است'
E1='Uncertainty in positions and decisions is a sign of shallow thinking'
F2='متخصص حقیقی در بسیاری موارد به مطمئن نبودن از نظر خود  اعتراف می‌کند'
E2='Real experts often admit to being unsure about topics'
F3='تغییر نظر در صورت مشاهده اطلاعات جدید نشانه بی‌اعتمادبه‌نفسی است'
E3="Changing one's opinion in light of new information is a sign of weakness"
F4="وقتی  به نظر خود مطمئنیم بهتر است به شواهدی که مغایر با آن نظر است  وزن چندانی  ندهیم"
E4="When confident in our opinion we should down-weight evidence that contradicts our position"
F5="هیچ ایرادی ندارد که  در مورد بسیاری  موضوعات نظر قطعی نداشته باشیم"
E5="It is fine to have no definite opinion on many subjects"

#echo "survey,min,max,question_en,question_fa"         
#echo "$SURVEY,1,1,$E1,$F1"
#echo "$SURVEY,1,1,$E2,$F2"
#echo "$SURVEY,1,1,$E3,$F3"
#echo "$SURVEY,1,1,$E4,$F4"
#echo "$SURVEY,1,1,$E5,$F5"


echo "question,choice_fa,choice_en,value,count,status"
for i in {36..41}
do
    echo "$i,\"$CH1F\",\"$CH1E\",$V1,0,draft"
    echo "$i,\"$CH2F\",\"$CH2E\",$V2,0,draft"
    echo "$i,\"$CH3F\",\"$CH3E\",$V3,0,draft"
    echo "$i,\"$CH4F\",\"$CH4E\",$V4,0,draft"
done
. $(cd $(dirname $0); pwd)/Confirm.sh
ConfirmYesNoCancel "しつもん" "echo YES!!" "echo NO..." "{ echo Cancel; echo 2; }"
a=$?
echo "return $a"
ConfirmOk "ConfirmOk 質問文。" "echo OK!"
a=$?
echo "return $a"
Confirm YNC "質問文YNC。" "{ echo YES!!; echo 2; }" "{ echo NO...; echo 2; }" "{ echo Cancel; echo 2; }"
a=$?
echo "return $a"

#a=`IsQuestionLoop yn y`
#echo $a
#ConfirmQuestion yn 質問A
#ConfirmYesNo "質問文1。"
#ConfirmYesNo "質問文2。" && echo 'YES!!' || echo 'NO...'
#ConfirmYesNo "質問文3。" "echo YES!!" "echo NO..." "echo ELSE"
Confirm 
Confirm YNC "質問文YNC。" "echo YES!!" "echo NO..." "echo Cancel"
Confirm OC "質問文OC。" "echo OK!!" "echo Cancel"
Confirm YNC- "質問文YNC-。" "echo YES!!" "echo NO..." "echo Cancel"
#a=`Confirm Yn- "質問文Yn-"`
#ret=$?
#echo "入力値: $a $ret"
Confirm yN- "質問文yN。" "echo YES!!" "echo NO..."
ConfirmYesNoCancel "質問文YNC"
a=$?
[ $a -eq 0 ] && echo 'YES!!'
[ $a -eq 1 ] && echo 'NO...'
[ $a -eq 2 ] && echo 'Cancel'
ConfirmYesNoCancel "質問文3-1。" "echo YES!!" "echo NO..." "echo Cancel"
Confirm ync- "質問文ync-。" "echo YES!!" "echo NO..." "echo Cancel"
Confirm yn- "質問文yn-。" "echo YES!!" "echo NO..."
Confirm oc- "質問文oc-。" "echo OK!!" "echo CANCEL..."
Confirm o- "質問文o-。" "echo OK!!"
Confirm ync "質問文ync。" "echo YES!!" "echo NO..." "echo Cancel"
Confirm yn "質問文yn。" "echo YES!!" "echo NO..."
Confirm oc "質問文oc。" "echo OK!!" "echo CANCEL..."
Confirm o "質問文o。" "echo OK!!"
#Confirm o "質問文o複数行実行文。" "{ echo 'OK1!!'; echo 'OK2!!'}"
Confirm o "質問文o複数行実行。"
a=$?
[ $a -eq 0 ] && { echo 'OK1!!'; echo 'OK2!!'; }

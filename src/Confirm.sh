#----------------------------------------------------------
# 確認 Confirm type message [action ...]
# 例) Confirm Yn- 質問文 "{ echo Y; echo ES; }" "{ echo N; echo O; }"
# 詳細はヘルプ参照（Confirm を実行すれば表示される）
#----------------------------------------------------------
# 確認表示と入力のループ
#   選択肢が指定値以外のときはループする(`select`コマンドと同様)
# $1 回答タイプ o,oc,yn,ync
# $2 質問文
# return: 0..2
#   0: OK/YES
#   1: NO
#   2: Cancel
_ConfirmQuestion(){
    _IsValidAnswerChars "$1"
    local answer='InvalidValue'
    local ansChars=`_AnswerChars $1`
    local isLoop='false'
    while [ 'false' = "$isLoop" ]; do
        echo -n "$2 $ansChars: "
        read -n 1 answer
        echo ''
        local isLoop=`_IsQuestionLoop "$1" "$answer"`
    done
    # $1の文字列インデックス値(ync-でcを入力したら2を返す)
    return `expr length \( $1 : "\(.*\)$answer" \)`
}
# 確認タイプ文字列の妥当性確認
# $1 o,oc,yn,ync
#    末尾にハイフン-が付いている場合もOK
#    各文字は大文字小文字どちらでもOK（入力要求値になる）
_IsValidAnswerChars() {
    local lastIdx=`expr ${#1} - 1`
    local last="${1:$lastIdx}"
    local chars="$1"
    [ '-' = "$last" ] && chars="${1:0:lastIdx}"
    # 小文字化
    chars=${chars,,}
    case "$chars" in
        'o' | 'oc' | 'yn' | 'ync') ;;
        *) { echo 'o,oc,yn,ync,のいずれかのみ。末尾に"-"を付与して短文化できる。'; exit 1; } ;;
    esac
}
# $1: o,oc,yn,ync
# $2: 入力値(read)
_IsQuestionLoop(){
    local count=0
    while [ $count -lt ${#1} ]; do
        [ "$2" = "${1:$count:1}" ] && { echo 'true'; return; }
        ((count++))
    done
    echo 'false'
}
_AnswerChars(){
    local lastIdx=`expr ${#1} - 1`
    local last="${1:$lastIdx}"
    if [ '-' = "$last" ]; then
        _AnswerCharsShort "${1:0:lastIdx}"
    else
        _AnswerCharsLong "${1}"
    fi
}
# 入力値の表示
# $1: o,oc,yn,ync
# echo: (o),(o/c),(y/n),(y/n/c)
_AnswerCharsShort(){
    local count=0
    local chars='('
    while [ $count -lt ${#1} ]; do
        local chars+="${1:$count:1}/"
        ((count++))
    done
    local chars=${chars%/}
    local chars+=")"
    echo "$chars"
}
# 入力値の表示（長め）
# $1: o,oc,yn,ync
# echo:([o]k), ([o]k [c]ancel), ([y]es [n]o), ([y]es [n]o [c]ancel)
_AnswerCharsLong(){
    local count=0
    local chars='('
    while [ $count -lt ${#1} ]; do
        local chars+='['${1:$count:1}']'`_GetAnswerCharsLabel "${1:$count:1}"`' '
        ((count++))
    done
    local chars=${chars% }
    local chars+=")"
    echo "$chars"
}
_GetAnswerCharsLabel(){
    case "$1" in
        'y' | 'Y' ) echo 'es' ;;
        'n' | 'N' ) echo 'o' ;;
        'o' | 'O' ) echo 'k' ;;
        'c' | 'C' ) echo 'ancel' ;;
        * ) { echo "y,n,o,cのいずれかのみ有効です。: $1"; exit 255; };;
    esac
}
ConfirmYesNo() { { Confirm yn "$@"; return $?; } }
ConfirmYesNoCancel() { { Confirm ync "$@"; return $?; } }
ConfirmOkCancel() { { Confirm oc "$@"; return $?; } }
ConfirmOk() { { Confirm o "$@"; return $?; } }
# 確認フォーム
# $1  : 選択肢(o,oc,yn,ync)
# $2  : 質問文
# $3..: 回答後実行内容
Confirm() {
    [ $# -lt 2 ] && { _ConfirmHelp; return 255; }
    _ConfirmQuestion "$1" "$2"
    local code=$?
    [ 2 -lt $# -a "$3" != '' -a $code -eq 0 ] && { eval "$3"; return $code; }
    [ 3 -lt $# -a "$4" != '' -a $code -eq 1 ] && { eval "$4"; return $code; }
    [ $# -eq 5 -a  "$5" != '' -a $code -eq 2 ] && { eval "$5"; return $code; }
    return $code
}
_ConfirmHelp() {
    echo '引数エラー: Confirm type message [action ...]'
    echo '===== 引数 ====='
    echo '引数は最低でも2つ必要。3つ目からの[action]は任意。'
    echo '[action]: 回答後に実行する1文を文字列で与える。[type]の位置順序に対応。'
    echo '[type]: o,oc,yn,ync (OK,Cancel,Yes,No)'
    echo '  * 各値は大文字にすることも可'
    echo '  * 末尾に - を付与すると表示を短文化できる'
    echo '例1) Confirm yN どうする？'
    echo '  どうする？ ([y]es [N]o): '
    echo '例2) Confirm ync- どうする？'
    echo '  どうする？ (y/n/c): '
    echo '例3) Confirm oc- 実行する？ "echo OK!" "echo Cancel..."'
    echo '  実行する？ (o/c): o'
    echo '  OK!'
    echo '===== 返り値 ====='
    echo '何を入力したか判定する。return,echo の2種類。'
    echo '  return: [type]の文字列のうち入力した文字のインデックス値'
    echo '    0: Yes/Ok'
    echo '    1: No/Cancel'
    echo '    2: Cancel'
    echo '    例4) Confirm yN- どうする？'
    echo '         ret=$?'
    echo '         [ 0 -eq $ret ] && { echo Yes!!; return $ret; }'
    echo '         [ 1 -eq $ret ] && { echo No...; return $ret; }'
    echo '    例5)'
    echo '      type=yN-'
    echo '      Confirm "$type" どうする？'
    echo '      ans="${type:i:1}"'
    echo '      [ "y" = "$ans" ] && echo YES'
    echo '      [ "N" = "$ans" ] && echo NO'
}

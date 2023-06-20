alias rot13="tr 'a-zA-Z' 'n-za-mN-ZA-M'"
alias decodeRot13="tr 'n-za-mN-ZA-M' 'a-zA-Z'"
alias setup="source ~/.bashrc"

function rotLetter(){
    word=$2
    lowerCaseLetter=$( if $( isLowerCase $1 ); then; echo $1; else; echo $( revertCase $1 ); fi)
    upperStr=$( if $( isLowerCase $1 ); then; echo $( revertCase $1 ); else; echo $1; fi)
    result=$(echo "$word" | tr 'a-zA-Z' "$lowerCaseLetter-za-$lowerCaseLetter$upperStr-ZA-$upperStr")
    echo $result
}

function rotN(){
    word=$2
    temp=""
    for letter in {a..z}
    do
    temp+=$letter
    done
    letters=${temp}
    letter=$letters[$1]
    lowerCaseLetter=$( if $( isLowerCase $letter ); then; echo $letter; else; echo $( revertCase $letter ); fi)
    upperStr=$( if $( isLowerCase $letter ); then; echo $( revertCase $letter ); else; echo $letter; fi)
    numbers="7-91-6"
    result=$(echo "$word" | tr 'a-zA-Z1-9' "$lowerCaseLetter-za-$lowerCaseLetter$upperStr-ZA-$upperStr$numbers")
    echo $result
}

function scanPorts(){ //Overthewire
    ports=$( nmap localhost -p 31000-32000 | cat | grep "open" | awk '{print $1}' | awk '{print $0+0}')

    for port in $ports; do  cat pass.txt | openssl s_client -connect localhost:"$port"  2>/dev/null </dev/null | if grep -q "BEGIN"; then echo -n "JQttfApK4SeyHwDlI9SXGR50qclOAil1" | nc localhost "$port"; else echo -n "JQttfApK4SeyHwDlI9SXGR50qclOAil1" | nc -N localhost "$port" ; fi; done
}

function rotIncrement(){
    index=1
   while getopts "s:" flag
do
     case $flag in
         s)
           index=$OPTARG
           shift
           ;;
     esac
     shift
done
    temp=$1
    words=("${(@s/ /)temp}")
    result=""
    for word in $words
    do
    if (($index < 26))
    then
    index=$((index + 1))
    else
    index=1
    fi
    encodeRot=$( rotN $index $word )
    result+=$encodeRot
    result+=" "
    done
    echo $result
}

function decodeIncrementRot13(){
    words=("${(@s/ /)$1}")
    result=""
    for word in $words
    do
        for index in {1..26}
        do
            echo $(decodeRotN -s $index $word)
        done
    done
}

function decodeRotN(){
    temp=""
    index=1
     while getopts "s:" flag
do
     case $flag in
         s)
           index=$OPTARG
           shift
           ;;
     esac
     shift
done
letters=${temp}
    for letter in {a..z}
    do
    letters+=$letter
    done
    letter=$letters[$index]
    lowerCaseLetter=$( if $( isLowerCase $letter ); then; echo $letter; else; echo $( revertCase $letter ); fi)
    upperStr=$( if $( isLowerCase $letter ); then; echo $( revertCase $letter ); else; echo $letter; fi)
    decoded=$(echo $1 | tr "$lowerCaseLetter-za-$lowerCaseLetter$upperStr-ZA-$upperStr" 'a-zA-Z')
    echo $decoded
}

function isLowerCase(){
    if [[ $1 =~ ^[a-z]+$ ]];then
        echo true
    else
        echo false
    fi
}

function revertCase(){
    if $( isLowerCase $1 ); then
        result=$( echo $1 | tr '[:lower:]' '[:upper:]' )
        echo $result
    else
        result=$( echo $1 | tr '[:upper:]' '[:lower:]' )
        echo $result
    fi
}

function rotAtoZ(){
    declare -a result=()
    for letter in {a..z}
        do;
        result+=$( rotLetter "$letter" "$1" )
        result+="\n"
        done;
    echo $result
}
#!/bin/sh

#
# Este scsript espera um arquivo separado por ',', ignora qualquer
# linha que comece por '#', e tem as palestras agrupadas por horário.
# Nomeie o arquivo 'programacao.csv'.
#

rooms=1
[ $# -gt 0 ] && rooms=$1

count=0
slot=''

echo -e '<section id="programacao">\n<div class="container"><h2 class="subtitle">Programa&ccedil;&atilde;o</h2>' 

cat <<EOF
<div class="schedule-tbl">
  <table class="table table-responsive">
    <thead>
      <tr>
        <th class="schedule-time">Hor&aacute;rio</th>
EOF

for i in `seq 1 ${rooms}`
do 
   echo -n '<td class="schedule-slot" colspan="1" style="text-align:center">'
   echo -n "Sala ${i}"
   echo '</td>'
done

echo -e '      </tr>\n    </thead>\n  <tbody>'

cat programacao.csv | sed -n '
    s/"//g
    /^ *#/!p' | while read line
do
    count=$[$count + 1]
    setslot="`echo $line | cut -d, -f1`"
    title="`echo $line | cut -d, -f2`"
    author="`echo $line | cut -d, -f3`"
    level="`echo $line | cut -d, -f4`"

    if [ "$setslot" != "$slot" ]
    then
        echo "</tr>"
        echo '<tr class="schedule-other">'
        echo '  <td class="schedule-time">'$setslot'</td>'
        slot=$setslot
    fi
    echo '  <td class="schedule-slot" colspan="1" style="text-align:center">'
    echo '    <a href="#speech-'$count'"><span class="description">'$title'</span></a>'
    case $level in
        [Pp]rincipiante)
            echo -n '    <span class="label label-success">'
            ;;
        [Ii]ntermediário)
            echo -n '    <span class="label label-warning">'
            ;;
        [Aa]vançado)
            echo -n '    <span class="label label-success">'
            ;;
        *)
            echo -n '    <span class="label label-info">'
            ;;
    esac
    echo "${level}</span>"
    echo '    <span class="speaker">'${author}'</span>'
    echo '  </td>'
done
echo '</tr>'
echo '</tbody>'
echo '</table>'
echo -e '</div>\n</div>\n</section>'


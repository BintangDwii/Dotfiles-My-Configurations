#!/usr/bin/env bash

day_num=$(date +%d)
month_num=$(date +%m)

case $(date +%A) in
    Monday) day="Sen" ;;
    Tuesday) day="Sel" ;;
    Wednesday) day="Rab" ;;
    Thursday) day="Kam" ;;
    Friday) day="Jum" ;;
    Saturday) day="Sab" ;;
    Sunday) day="Min" ;;
esac

case $month_num in
    01) month="Jan" ;;
    02) month="Feb" ;;
    03) month="Mar" ;;
    04) month="Apr" ;;
    05) month="Mei" ;;
    06) month="Jun" ;;
    07) month="Jul" ;;
    08) month="Agu" ;;
    09) month="Sep" ;;
    10) month="Okt" ;;
    11) month="Nov" ;;
    12) month="Des" ;;
esac

printf '%s %s %s | %s\n' "$day" "$day_num" "$month" "$(date +%H:%M)"

cat $1 | awk 'BEGIN{printf("%12s,%12s,\n","Freq ( Hz ) ", "ESE ( % ) ")} $1~/^TYPE$/ {printf("%12.2f\n", $6)} $1 ~ /^CYCLES$/ {printf("%12.2f,", $3)}' > strain-energy-distro.csv

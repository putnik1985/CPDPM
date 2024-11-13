## usage awk -f modal-effective-mass-fraction.awk input.pch
BEGIN {disp = 1; rot = 1; freq = 1; Pi = 3.14159;}
$0 ~ /MODAL EFFECTIVE MASS FRACTION/ {found++;}
$0 ~ /EIGENVALUE/ {split($0, a, " "); frequency[freq++] = sqrt(a[3])/(2*Pi);}
######$0 ~ /MODAL EFFECTIVE MASS FRACTION/ && found == 1 {print $0; found = 2; }
$0 ~ /TITLE/ && found  == 2 {found = 0;}
$1 ~ /^[1-9]/ && found  == 1 {translation[disp++] = $0;}
$1 ~ /^[1-9]/ && found  == 2 {rotation[rot++] = $0;}
END {
	scale = 100;
	printf("%16s%16s%16s%16s%16s%16s%16s%16s\n","Mode#", "Frequency(Hz)", "T1", "T2", "T3", "R1", "R2", "R3");
	for(i=1; i < disp; i++){
		split(translation[i],t," ");
		x = t[2] * scale;
		y = t[3] * scale;
		z = t[4] * scale;
                split(rotation[i],r," ");
		rx = r[2] * scale;
		ry = r[3] * scale;
		rz = r[4] * scale;
		printf("%16d%16.1f%16.1f%16.1f%16.1f%16.1f%16.1f%16.1f\n",i, frequency[i], x, y, z, rx, ry, rz)
	}
}

assign output4='./save/fort11.test',unit=11
ID TEST CASE
sol 111
time 30
diag 8,13
include './save/sol111z.v69'
cend

title=2 dof frequencey random excitation response
subtitle=demo
echo=none

method = 101
freq = 103

stress = all
subcase 1
label = x random loads
dload = 104

subcase 2
label = y random loads
dload = 114

subcase 3
label = z random loads
dload = 124

begin bulk

param,dfreq,1.-30
param,ddrmm,-1
param,wtmass,2.5907-3

eigrl,101,0.,250.,,,,,mass

conm2,20,10,,386.+6
suport,10,1
param,g,0.1

freq4,103,20.,300.,0.10,5
freq4,103,300.,600.,0.05,3
freq1,103,20.,5.,5
freq1,103,50.,10.,4
freq1,103,100.,25.,15
freq1,103,500.,50.,9
freq1,103,1000.,100.,10

spoint,999999

dload,104,1.,1.,105,1.,205
dload,114,1.,1.,115,1.,215
dload,124,1.,1.,125,1.,225

rload1,105,106,,,131
rload1,115,116,,,132
rload1,125,126,,,133
rload1,205,206,,,130
rload1,215,216,,,130
rload1,225,226,,,130

tabled1,130
+,0.,1.,10000.,1.,endt

darea,106,999999,0,1.
darea,116,999999,0,1.
darea,126,999999,0,1.
darea,206,10,1,1.+6
darea,216,10,2,1.+6
darea,226,10,3,1.+6

tabled1,131,log,log,+
+,20.,.005,80.,0.02,200.,0.02,2000.,0.00093,+
+,endt

tabled1,132,log,log,+
+,20.,0.002,55.,0.015,150.,0.015,2000.,0.00047,+
+,endt

tabled1,133,log,log,+
+,20.,0.002,53.,0.01,250.,0.01,2000.,0.002846,+
+,endt

grdset,,,,,,,23456
grid,10
grid,1,,1.
grid,2,,2.

conm2,21,1,,5.
conm2,22,2,,1.

cbar,1,1,10,1,1.,0.,1.
pbar,1,11,3.273,1.,1.,1.

cbar,2,2,1,2,1.,0.,1.
pbar,2,11,0.1253,1.,1.,1.
mat1,11,1.+3,,0.33
enddata

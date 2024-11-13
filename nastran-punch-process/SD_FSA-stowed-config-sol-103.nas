
SOL 103
CEND

weightcheck(print,set=all) = yes
echo = none

MEFFMASS(PLOT,punch,GRID=0,SUMMARY,PARTFAC,MEFFM,MEFFW,FRACSUM)=YES
DISPLACEMENT(sort2,PLOT,punch,REAL) = ALL
method = 100
spc = 100

BEGIN BULK

$* PARAM CARDS
PARAM     OIBULK     YES
PARAM    OMACHPR     YES
PARAM       POST      -2
PARAM    POSTEXT     YES
$$$$$$$$$$param,autospc,yes

$---------------------------
$ Solver
$---------------------------
EIGRL,100,,,36
include 'SD_FSA_fsa-commands.dat'

ENDDATA

SOL 101
CEND

echo = none
DISPLACEMENT(PLOT,REAL) = ALL
load = 100
spc = 100
mpc = 100

BEGIN BULK

$* PARAM CARDS
PARAM     OIBULK     YES
PARAM    OMACHPR     YES
PARAM       POST      -2
PARAM    POSTEXT     YES
param,autospc,yes

$---------------------------
$ Solver
$---------------------------
grav,100,0,386.1,1.,1.,1.
include 'mesh.txt'

ENDDATA
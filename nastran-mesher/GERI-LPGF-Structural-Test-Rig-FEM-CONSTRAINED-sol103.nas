
SOL 103
CEND

echo = none
DISPLACEMENT(PLOT,REAL) = ALL
method = 100
spc = 100

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
EIGRL,100,,,12
include 'GERI-LPGF-Structural-Test-Rig-FEM-CONSTRAINED.dat'

ENDDATA
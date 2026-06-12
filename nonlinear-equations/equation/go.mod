module github.com/CPDPM/equation

go 1.25.9

replace github.com/CPDPM/functions => ../functions
replace github.com/CPDPM/numlib => ../numlib

require (
	github.com/CPDPM/functions v0.0.0-00010101000000-000000000000
	github.com/CPDPM/numlib v0.0.0-00010101000000-000000000000
)

require gonum.org/v1/gonum v0.17.0

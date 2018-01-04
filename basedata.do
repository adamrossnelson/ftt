set more off
clear all

set obs 52                                  // Will visualize 52 weeks in a year.
gen isWeek = _n                             // Generate "number of week."
label variable isWeek "Week of the year"

set seed 9999
forvalues y = 2010/2018 {
    gen year`y' = .
    replace year`y' = round(rnormal(50,12))

    forvalues i = 2/`=_N' {
        replace year`y' = year`y'[`i'-1] + round(runiform(5,15)) if isWeek == `i'
    }
    local shiftval = round(rnormal(0,300))
    replace year`y' = year`y' + `shiftval'
}

twoway (line year2010 isWeek) (line year2012 isWeek) (line year2014 isWeek) (line year2016 isWeek)

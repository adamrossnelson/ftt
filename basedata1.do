set more off
clear all

program adjrange
	// Code to loop through arguments Stata 15 Manual sec 18.4.2
	local args = 1
	while "``args''" != "" {
		local starter = round(runiform(1,20))
		local stopper = round(runiform(30,52))
		sum ``args'' if _n > `starter' & _n < `stopper'
		local pcnter = r(mean) * .025
		local sdever = `pcnter' * .25 
		local icrementer = round(rnormal(`pcnter',`sdever'))
		
		forvalues i = `starter'/`stopper' {
			replace ``args'' = ``args'' + `icrementer' in `i'
		}
		local ++args
	}
end

set obs 52                                  // Visualize 52 weeks in a year.
gen isWeek = _n                             // Generate "number of week."
label variable isWeek "Week of the year"

set seed 9999
forvalues y = 2010/2018 {

	capture drop shiftdif shiftvar
	gen shiftdif = abs((round(runiform(30,60))*isWeek) - (isWeek * isWeek))
	gen shiftvar = .
	replace shiftvar = 50 in 1
	forvalues i = 2/`=_N' {
		replace shiftvar = shiftvar[`i'-1] + shiftdif if isWeek == `i'
	}
	
    gen year`y' = .
    replace year`y' = round(rnormal(400,12)) in 1

    forvalues i = 2/`=_N' {
        replace year`y' = year`y'[`i'-1] + round(runiform(5,15)) + ///
		shiftdif if isWeek == `i'
    }
	
    local shiftval = round(rnormal(0,100))
    replace year`y' = year`y' + `shiftval'
}

twoway (line year2010 isWeek) (line year2012 isWeek) (line year2014 isWeek) ///
(line year2016 isWeek) (line year2018 isWeek), name(first)

forvalues i = 1/20 {
	adjrange tester year2010 year2012 year2014 year2016 year2018
}

twoway (line year2010 isWeek) (line year2012 isWeek) (line year2014 isWeek) ///
(line year2016 isWeek) (line year2018 isWeek), name(second)




set more off
clear all

program midboost
	// Code to loop through arguments Stata 15 Manual sec 18.4.2
	local args = 1
	while "``args''" != "" {
		local starter = round(runiform(1,20))
		local stopper = round(runiform(30,52))
		sum ``args'' if _n > `starter' & _n < `stopper'
		local pcnter = r(mean) * .045
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
label variable isWeek "Week of the year or cycle"

set seed 9999
forvalues y = 2010/2018 {
	local rintcept = round(runiform(40,120))

	gen year`y' = (`rintcept') in 1
	gen news`y' = abs((round(runiform(20,80))*isWeek) - (isWeek * isWeek))
	replace news`y' = round(news`y' / 10)
	
	forvalues i = 1/30 {
		midboost news`y'
	}
	
	replace news`y' = round(runiform(180,200)) if news`y' > 200
	
	forvalues i = 2/`=_N' {
		replace year`y' = year`y'[`i'-1] + news`y' if isWeek == `i'
	}
	
	local shiftline = round(`rintcept' * 40)
	replace year`y' = year`y' + `shiftline'
	replace year`y' = round(year`y' * .5)
}


twoway (line year2010 isWeek) (line year2012 isWeek) (line year2014 isWeek) ///
(line year2016 isWeek) (line year2018 isWeek), ytitle("Cumulative Count of New") name(first)


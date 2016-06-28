import excel "C:\Users\t\Documents\GitHub\FoodForPeaceAnalysis\Datain\ffp_procurement.xlsx", sheet("data") firstrow clear

* Rename all the variables to shorten them
ren _all, lower

* Fix recipient countries names to be consistent
replace recipientcountry = "REPUBLIC OF SOUTH SUDAN" if recipientcountry == "SOUTH SUDAN"

* List all the Congo or Dem. Republic names
tab recipientcountry if regexm(recipientcountry , "(AFR|DEM|CONGO)") == 1

g byte forprep = recipientcountry =="FOREIGN-PREP"
la var forprep "foreign prep records only"

* Create a grouping for the commodities
local comtype BEANS CORN EMERG FLOUR LENTILS OIL PEAS POTATO RICE SORGHUM WHEAT
foreach x of local comtype {
	tabsort  material if regexm(material, "`x'") == 1 & forprep == 1
	}
*end

tabsort material if forprep ==1

* Basic bar graph of material counts collected at foreign prep
graph hbar (sum) forprep if forprep == 1, over(material, sort((sum ) forprep) /*
*/ descending label(labcolor(gs6) labsize(tiny)) axis(lcolor(none))) /*
*/ bar(1, fcolor(gs10) lcolor(gs14)) blabel(bar, color(gs6) position(outside))/*
*/ yscale(noline) ylabel(, nolabels noticks nogrid) legend(off) scheme(s1mono)/*
*/ graphregion(fcolor(none) lcolor(none) ifcolor(none)) plotregion(fcolor(none)/*
*/ lcolor(none) ifcolor(none) ilcolor(none))


tabsort soldtoparty, sum(povalue)

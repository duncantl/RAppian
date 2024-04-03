#
# This is a way to compare the different instances such as to find which have
# + different UUIDs for the same object/name
# + an object on only one, or not on all three. 
#
# This is different from running basics.R and then mkSummary() on the other 2 instances.
# basics.R drops the CMN, specifically CMN_ucAnyTypeArrayPickerFilter.
#

library(RAppian)
dirs = c(dev = "../March30Dev2Test_v2", test = "~/OGS/EForms/PhaseI/Deploy/March30TestExport/", prod = ".")

maps = lapply(dirs, mkSummary)
ma = do.call(rbind, maps)
ma$instance = rep(names(maps), sapply(maps, nrow))


nuuid = tapply(ma$uuid, ma$name, function(x) length(unique(x)))
table(nuuid)


ww = ma$name %in% names(nuuid)[w]
g = split(ma[ww,], ma$name[ww])



########
# Objects that are not in all instances

ninst = tapply(ma$instance, ma$name, function(x) length(unique(x)))
names(ninst)[ninst == 1]
ma[ ma$name %in% names(ninst)[ninst == 1], ]


names(ninst)[ninst == 2]


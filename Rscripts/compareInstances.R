#
# This is a way to compare the different instances such as to find which have
# + different UUIDs for the same object/name
# + an object on only one, or not on all three. 
#
# This is different from running basics.R and then mkSummary() on the other 2 instances.
# basics.R drops the CMN, specifically CMN_ucAnyTypeArrayPickerFilter.
#


dirs = c(dev = "../March30Dev2Test_v2", test = "~/OGS/EForms/PhaseI/Deploy/March30TestExport/", prod = ".")

maps = lapply(dirs, mkSummary)
ma = do.call(rbind, maps)
ma$instance = rep(names(maps), sapply(maps, nrow))


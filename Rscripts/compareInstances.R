dirs = c(dev = "../March30Dev2Test_v2", test = "~/OGS/EForms/PhaseI/Deploy/March30TestExport/", prod = ".")

maps = lapply(dirs, mkSummary)
ma = do.call(rbind, maps)
ma$instance = rep(names(maps), sapply(maps, nrow))



if(FALSE) {
#source("~/OGS/EForms/RAppian/Rscripts/basics.R")
# or 
prod = mkSummary()
dev = mkSummary("../March30Dev2Test_v2")
test = mkSummary("~/OGS/EForms/PhaseI/Deploy/March30TestExport/")
ma = rbind(dev, test, prod[, names(dev)])
ma$instance = rep(c("dev", "test", "prod"), sapply(list(dev, test, prod), nrow))
maps = list(dev = dev, test = test, prod = prod)
}

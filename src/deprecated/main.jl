# library
using Random

# load main simulation code
include("lpm.jl")

# create parameters
const simPars, dataPars, pars = loadParameters(ARGS)
pars.poppars.initialPop = 500  # Quick ad-hoc adjustment 
#simPars.checkassumption = true  
#simPars.verbose         = true

# Atiyah: for more DRY Code, you may consider using 
# SocioEconomics.ParamTypes.{seed!,reseed0!} within mainHelpers.jl 
# and remove the following call & the using statement 
Random.seed!(simPars.seed)

# create model object
const model = setupModel(dataPars, pars)

# like this for CSV output:
# const logfile = setupLogging(simPars, FS=",")
const logfile = setupLogging(simPars)

# like this for CSV output:
# @time runModel!(model, simPars, pars, logfile, FS=",")
@time runModel!(model, simPars, pars, logfile)

close(logfile)
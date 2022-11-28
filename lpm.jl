include("util.jl")

#addToLoadPath!("../SocioEconomics.jl/src/generic")
addToLoadPath!("../SocioEconomics.jl/src")

using SocioEconomicsX: SEVERSION 
using SocioEconomicsX: SEPATH, SESRCPATH 

@assert SEVERSION == v"0.1.0" 

using SocioEconomicsX.ParamTypes

using XAgents

using SocioEconomicsX.Demography.Create
using SocioEconomicsX.Demography.Initialize
using SocioEconomicsX.Demography.Simulate

include("mainHelpers.jl")


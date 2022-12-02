include("libspath.jl")

using SocioEconomicsX: SEVERSION 
using SocioEconomicsX: SEPATH, SESRCPATH 

@assert SEVERSION == v"0.1.2" 

using SocioEconomicsX.ParamTypes

using SocioEconomicsX.XAgents

using SocioEconomicsX.Demography.Create
using SocioEconomicsX.Demography.Initialize
using SocioEconomicsX.Demography.Simulate

using SocioEconomicsX.Utilities

include("mainHelpers.jl")


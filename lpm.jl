include("libspath.jl")

using SocioEconomicsX: SEVERSION 
using SocioEconomicsX: SEPATH, SESRCPATH 

@assert SEVERSION == v"0.1.3" 

using SocioEconomicsX.ParamTypes

using SocioEconomicsX.XAgents

using SocioEconomicsX.Demography.Create
using SocioEconomicsX.Demography.Initialize
using SocioEconomicsX.Demography.Simulate

using SocioEconomicsX.Utilities

include("mainHelpers.jl")


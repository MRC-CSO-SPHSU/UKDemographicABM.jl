include("libspath.jl")

using SocioEconomicsX: SEVERSION 
using SocioEconomicsX: SEPATH, SESRCPATH 

@assert SEVERSION == v"0.2.0" 

using SocioEconomicsX.ParamTypes

using SocioEconomicsX.XAgents

using SocioEconomicsX.Demography
using SocioEconomicsX.Demography.Create
using SocioEconomicsX.Demography.Initialize
using SocioEconomicsX.Demography.Simulate

using SocioEconomicsX.Utilities

include("mainHelpers.jl")


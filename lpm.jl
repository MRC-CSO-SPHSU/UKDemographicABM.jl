include("libspath.jl")

using SocioEconomicsX: SEVERSION 
using SocioEconomicsX: SEPATH, SESRCPATH 

@assert SEVERSION == v"0.2.2" 

using SocioEconomicsX.ParamTypes

using SocioEconomicsX.XAgents

using SocioEconomicsX.Specification.Create
using SocioEconomicsX.Specification.Initialize
using SocioEconomicsX.Specification.Simulate

using SocioEconomicsX.Utilities

include("mainHelpers.jl")


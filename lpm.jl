include("util.jl")

addToLoadPath!("../SocioEconomics.jl/src/generic")
addToLoadPath!("../SocioEconomics.jl/src")

using SocioEconomics: SEVERSION 
@assert SEVERSION == v"0.1.0" 

include("mainHelpers.jl")


function addToLoadPath!(paths...)
    for path in paths
        if ! (path in LOAD_PATH)
            push!(LOAD_PATH, path)
        end
    end
end

addToLoadPath!("../SocioEconomics.jl/src")
addToLoadPath!("./src")
addToLoadPath!(".")





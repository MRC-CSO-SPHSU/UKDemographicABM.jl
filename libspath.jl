function add_to_loadpath!(paths...)
    for path in paths
        if ! (path in LOAD_PATH)
            push!(LOAD_PATH, path)
        end
    end
end

add_to_loadpath!("../SocioEconomics.jl/src")
add_to_loadpath!("./src")
add_to_loadpath!(".")





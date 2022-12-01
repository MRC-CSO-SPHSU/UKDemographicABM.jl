
using ArgParse

using Utilities


include("$(SESRCPATH)/handleParams.jl")

include("analysis.jl")

mutable struct Model
    towns :: Vector{Town}
    houses :: Vector{PersonHouse}
    pop :: Vector{Person}

    fertility :: Matrix{Float64}
    deathFemale :: Matrix{Float64}
    deathMale :: Matrix{Float64}
end

function createDemography!(pars)
    ukTowns = createTowns(pars.mappars)

    ukHouses = Vector{PersonHouse}()

    # maybe switch using parameter
    #ukPopulation = createPopulation(pars.poppars)
    ukPopulation = createPyramidPopulation(pars.poppars)
    
    # temporarily solution , input files and command line arguments 
    #   should be invistigated 
    datp = DataPars() 
    ukDemoData   = loadDemographyData(datp)

    Model(ukTowns, ukHouses, ukPopulation, 
            ukDemoData.fertility , ukDemoData.deathFemale, ukDemoData.deathMale)
end


function initialConnectH!(houses, towns, pars)
    newHouses = initializeHousesInTowns(towns, pars)
    append!(houses, newHouses)
end

function initialConnectP!(pop, houses, pars)
    assignCouplesToHouses!(pop, houses)
end


function initializeDemography!(model, poppars, workpars, mappars)
    initialConnectH!(model.houses, model.towns, mappars)
    initialConnectP!(model.pop, model.houses, mappars)

    for person in model.pop
        initClass!(person, poppars)
        initWork!(person, workpars)
    end

    nothing
end


# Atiyah: remove this for the primative API simulation function
# alivePeople(model) = Iterators.filter(a->alive(a), model.pop)
# data(model) = model 

function stepModel!(model, time, simPars, pars)
    # TODO remove dead people?
    
    # Atiyah: 
    doDeaths!(model,time,pars)   # a possible unified way 
    # or the primiative-API 
    # doDeaths!(alivePeople(model), time, data(model), pars.poppars)

    orphans = Iterators.filter(p->selectAssignGuardian(p), model.pop)
    applyTransition!(orphans, assignGuardian!, "adoption", time, model, pars)

    # Atiyah: 
    babies = doBirths!(model,time,pars)
    # babies = doBirths!(alivePeople(model), model.pop), time, model, pars.birthpars)

    selected = Iterators.filter(p->selectAgeTransition(p, pars.workpars), model.pop)
    applyTransition!(selected, ageTransition!, "age", time, model, pars.workpars)

    selected = Iterators.filter(p->selectWorkTransition(p, pars.workpars), model.pop)
    applyTransition!(selected, workTransition!, "work", time, model, pars.workpars)

    selected = Iterators.filter(p->selectSocialTransition(p, pars.workpars), model.pop) 
    applyTransition!(selected, socialTransition!, "social", time, model, pars.workpars) 

    selected = Iterators.filter(p->selectDivorce(p, pars), model.pop)
    applyTransition!(selected, divorce!, "divorce", time, model, 
                     fuse(pars.divorcepars, pars.workpars))

    resetCacheMarriages()
    selected = Iterators.filter(p->selectMarriage(p, pars.workpars), model.pop)
    applyTransition!(selected, marriage!, "marriage", time, model, 
                     fuse(pars.poppars, pars.marriagepars, pars.birthpars, pars.mappars))

    append!(model.pop, babies)
end

function setupModel(pars)
    model = createDemography!(pars)

    initializeDemography!(model, pars.poppars, pars.workpars, pars.mappars)

    model
end


function setupLogging(simPars; FS = "\t")
    if simPars.logfile == ""
        return nothing
    end

    file = open(simPars.logfile, "w")

    print_header(file, Data; FS)

    file
end


function runModel!(model, simPars, pars, logfile = nothing; FS = "\t")
    time = simPars.startTime

    simPars.verbose ? setVerbose!() : unsetVerbose!()
    setDelay!(simPars.sleeptime)

    while time < simPars.finishTime
        stepModel!(model, time, simPars, pars)

        if logfile != nothing
            results = observe(Data, model)
            log_results(logfile, results; FS)
        end

        time += simPars.dt
    end
end




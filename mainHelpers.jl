include("analysis.jl")

mutable struct Model
    towns :: Vector{Town}
    houses :: Vector{PersonHouse}
    pop :: Vector{Person}

    fertility :: Matrix{Float64}
    deathFemale :: Matrix{Float64}
    deathMale :: Matrix{Float64}
end

function createDemography!(datapars, pars)
    ukTowns = create_inhabited_towns(pars)

    ukHouses = Vector{PersonHouse}()

    # maybe switch using parameter
    #ukPopulation = createPopulation(pars)
    ukPopulation = createPyramidPopulation(pars)

    # temporarily solution , input files and command line arguments
    #   should be invistigated
    ukDemoData   = loadDemographyData(datapars)

    Model(ukTowns, ukHouses, ukPopulation,
            ukDemoData.fertility , ukDemoData.deathFemale, ukDemoData.deathMale)
end

function initializeDemography!(model, pars)
    initialConnect!(model.houses, model.towns, pars)
    #initialConnect!(model.pop, model.houses, pars) # works too
    initialConnect!(model.houses, model.pop, pars)
    init!(model.pop,pars,InitClassesProcess())
    init!(model.pop,pars,InitWorkProcess())
    nothing
end

"Apply a transition function to an iterator."
function applyTransition!(people, transition, name, args...)
    count = 0
    for p in people
        transition(p, args...)
        count += 1
    end

    verbose() do
        if name != ""
            println(count, " agents processed in ", name)
        end
    end
end

# Atiyah: remove this for the primative API simulation function
# alive_people(model) = Iterators.filter(a->alive(a), model.pop)
# data(model) = model

function stepModel!(model, time, simPars, pars)
    # TODO remove dead people?

    # Atiyah:
    doDeaths!(model,time,pars)   # a possible unified way
    # or the primiative-API
    # doDeaths!(alive_people(model), time, data(model), pars.poppars)

    orphans = Iterators.filter(p->selectAssignGuardian(p), model.pop)
    applyTransition!(orphans, assignGuardian!, "adoption", time, model, pars)

    # Atiyah:
    babies = doBirths!(model,time,pars)
    # babies = doBirths!(alive_people(model), model.pop), time, model, pars.birthpars)

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

function setupModel(datapars,pars)
    model = createDemography!(datapars,pars)

    initializeDemography!(model, pars)

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
    time = simPars.starttime

    simPars.verbose ? setVerbose!() : unsetVerbose!()
    setDelay!(simPars.sleeptime)

    while time < simPars.finishtime
        stepModel!(model, time, simPars, pars)

        if logfile != nothing
            results = observe(Data, model)
            log_results(logfile, results; FS)
        end

        time += simPars.dt
    end
end

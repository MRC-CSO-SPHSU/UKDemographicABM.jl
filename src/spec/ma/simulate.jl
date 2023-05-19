using MultiAgents:  AbstractMABM, AbstractABMSimulator
using MultiAgents:  currstep, dt

using SocioEconomics.API.Traits: FullPopulation, AlivePopulation,
                                    SimProcess, Death, Birth, Marriage,
                                        AssignGuardian, AgeTransition,
                                        WorkTransition, SocialTransition
using SocioEconomics.API.ModelFunc: currenttime
import SocioEconomics.Specification.SimulateNew: dodeaths!, dobirths!,
                        dodivorces!, domarriages!, do_assign_guardians!,
                        do_age_transitions!, do_work_transitions!, do_social_transitions!
export increment_time!

_popfeature(::FullPopEx) = FullPopulation()
_popfeature(::AlivePopEx) = AlivePopulation()

_init_return(::AlivePopEx,::SimProcess) = 0

const retDeath = Person[]
_init_return(::FullPopEx,::Death) = retDeath

function increment_time!(model, sim, example::LPMUKExample)
    @assert currstep(sim) == currenttime(model) + dt(sim)
    model.t += dt(sim)
    #=if model.t % 10 == 0
        @info "current year " * string(model.t)
    end=#
    nothing
end

function dodeaths!(model, sim, example::LPMUKExample)
    ret = _init_return(example,Death())
    ret = dodeaths!(model,_popfeature(example),ret)
    #ret = dodeaths!(model,currstep(sim),_popfeature(example),ret)
    nothing
end # function doDeaths!

const retBirth = Person[]
_init_return(::FullPopEx,::Birth) = retBirth

function dobirths!(model, sim, example::LPMUKExample)
    ret = _init_return(example,Birth())
    ret = dobirths!(model,_popfeature(example),ret)
    nothing
end

function dodivorces!(model, sim, example::LPMUKExample)
    ret = _init_return(example, Birth())
    ret = dodivorces!(model,_popfeature(example),ret)
    nothing
end

const retMarriage = Person[]
_init_return(::FullPopEx,::Marriage) = retMarriage

function domarriages!(model, sim, example::LPMUKExample)
    ret = _init_return(example, Marriage())
    ret = domarriages!(model,_popfeature(example),ret)
end

const retAGuardians = Person[]
_init_return(::FullPopEx,::AssignGuardian) = retAGuardians

function do_assign_guardians!(model::AbstractMABM, sim::AbstractABMSimulator, example::LPMUKExample)
    ret = _init_return(example, AssignGuardian())
    ret = do_assign_guardians!(model,_popfeature(example),ret)
    nothing
end

_init_return(::FullPopEx,pr::AgeTransition) =
    _init_return(AlivePopEx(),pr)

function do_age_transitions!(model::AbstractMABM, sim::AbstractABMSimulator, example::LPMUKExample)
    ret = _init_return(example,AgeTransition())
    ret = do_age_transitions!(model,_popfeature(example),ret)
    nothing
end

_init_return(::FullPopEx,pr::WorkTransition) =
    _init_return(AlivePopEx(),pr)

function do_work_transitions!(model::AbstractMABM, sim, example::LPMUKExample)
    ret = _init_return(example,WorkTransition())
    ret = do_work_transitions!(model,_popfeature(example),ret)
    nothing
end

_init_return(::FullPopEx,pr::SocialTransition) =
    _init_return(AlivePopEx(),pr)

function do_social_transitions!(model::AbstractMABM, sim, example::LPMUKExample)
    ret = _init_return(example,SocialTransition())
    ret = do_social_transitions!(model,_popfeature(example),ret)
    nothing
end

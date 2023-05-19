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

_popfeature(::LPMUKDemography) = FullPopulation()
_popfeature(::LPMUKDemographyOpt) = AlivePopulation()

_init_return(::LPMUKDemographyOpt,::SimProcess) = 0

const retDeath = Person[]
_init_return(::LPMUKDemography,::Death) = retDeath

function increment_time!(model, sim, example::DemographyExample)
    @assert currstep(sim) == currenttime(model) + dt(sim)
    model.t += dt(sim)
    #=if model.t % 10 == 0
        @info "current year " * string(model.t)
    end=#
    nothing
end

function dodeaths!(model, sim, example::DemographyExample)
    ret = _init_return(example,Death())
    ret = dodeaths!(model,_popfeature(example),ret)
    #ret = dodeaths!(model,currstep(sim),_popfeature(example),ret)
    nothing
end # function doDeaths!

const retBirth = Person[]
_init_return(::LPMUKDemography,::Birth) = retBirth

function dobirths!(model, sim, example::DemographyExample)
    ret = _init_return(example,Birth())
    ret = dobirths!(model,_popfeature(example),ret)
    nothing
end

function dodivorces!(model, sim, example::DemographyExample)
    ret = _init_return(example, Birth())
    ret = dodivorces!(model,_popfeature(example),ret)
    nothing
end

const retMarriage = Person[]
_init_return(::LPMUKDemography,::Marriage) = retMarriage

function domarriages!(model, sim, example::DemographyExample)
    ret = _init_return(example, Marriage())
    ret = domarriages!(model,_popfeature(example),ret)
end

const retAGuardians = Person[]
_init_return(::LPMUKDemography,::AssignGuardian) = retAGuardians

function do_assign_guardians!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample)
    ret = _init_return(example, AssignGuardian())
    ret = do_assign_guardians!(model,_popfeature(example),ret)
    nothing
end

_init_return(::LPMUKDemography,pr::AgeTransition) =
    _init_return(LPMUKDemographyOpt(),pr)

function do_age_transitions!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample)
    ret = _init_return(example,AgeTransition())
    ret = do_age_transitions!(model,_popfeature(example),ret)
    nothing
end

_init_return(::LPMUKDemography,pr::WorkTransition) =
    _init_return(LPMUKDemographyOpt(),pr)

function do_work_transitions!(model::AbstractMABM, sim, example::DemographyExample)
    ret = _init_return(example,WorkTransition())
    ret = do_work_transitions!(model,_popfeature(example),ret)
    nothing
end

_init_return(::LPMUKDemography,pr::SocialTransition) =
    _init_return(LPMUKDemographyOpt(),pr)

function do_social_transitions!(model::AbstractMABM, sim, example::DemographyExample)
    ret = _init_return(example,SocialTransition())
    ret = do_social_transitions!(model,_popfeature(example),ret)
    nothing
end
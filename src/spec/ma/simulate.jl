using ABMSim:  AbstractMABM, AbstractABMSimulator, FixedStepSimP
using ABMSim:  currstep, dt

using UKSEABMLib.API.Traits: FullPopulation, AlivePopulation,
                                    SimProcess, Death, Birth, Marriage,
                                        AssignGuardian, AgeTransition,
                                        WorkTransition, SocialTransition
using UKSEABMLib.API.ModelFunc: currenttime
import UKSEABMLib.Specification.SimulateNew: dodeaths!, dobirths!,
                        dodivorces!, domarriages!, do_assign_guardians!,
                        do_age_transitions!, do_work_transitions!, do_social_transitions!
export increment_time!

_popfeature(::FullPopEx) = FullPopulation()
_popfeature(::AbsAlivePopEx) = AlivePopulation()

deathstep!(person, model, sim, example) =
    death!(person, model, _popfeature(example))

birthstep!(person, model, sim, example) =
    birth!(person, model, _popfeature(example))

divorcestep!(person, model, sim, example) =
    divorce!(person, model, _popfeature(example))

marriagestep!(person, model, sim, example) =
    marriage!(person, model, _popfeature(example))

assign_guardian_step!(person, model, sim, example) =
    assign_guardian!(person, model, _popfeature(example))

age_transition_step!(person, model, sim, example) =
    age_transition!(person, model, _popfeature(example))

work_transition_step!(person, model, sim, example) =
    work_transition!(person, model, _popfeature(example))

social_transition_step!(person, model, sim, example) =
    social_transition!(person, model, _popfeature(example))

_init_return(::AbsAlivePopEx,::SimProcess) = 0

const retDeath = Person[]
_init_return(::FullPopEx,::Death) = retDeath

function increment_time!(model, sim, example::AbsExample)
    @assert currstep(sim) == currenttime(model)  + dt(sim)
    model.t += dt(sim)
    #=if model.t % 10 == 0
        @info "current year " * string(model.t)
    end=#
    nothing
end

function dodeaths!(model, sim, example::AbsExample)
    ret = _init_return(example,Death())
    ret = dodeaths!(model,_popfeature(example),ret)
    #ret = dodeaths!(model,currstep(sim),_popfeature(example),ret)
    nothing
end # function doDeaths!

const retBirth = Person[]
_init_return(::FullPopEx,::Birth) = retBirth

function dobirths!(model, sim, example::AbsExample)
    ret = _init_return(example,Birth())
    ret = dobirths!(model,_popfeature(example),ret)
    nothing
end

function dodivorces!(model, sim, example::AbsExample)
    ret = _init_return(example, Birth())
    ret = dodivorces!(model,_popfeature(example),ret)
    nothing
end

const retMarriage = Person[]
_init_return(::FullPopEx,::Marriage) = retMarriage

function domarriages!(model, sim, example::AbsExample)
    ret = _init_return(example, Marriage())
    ret = domarriages!(model,_popfeature(example),ret)
end

const retAGuardians = Person[]
_init_return(::FullPopEx,::AssignGuardian) = retAGuardians

function do_assign_guardians!(model::AbstractMABM, sim::AbstractABMSimulator, example::AbsExample)
    ret = _init_return(example, AssignGuardian())
    ret = do_assign_guardians!(model,_popfeature(example),ret)
    nothing
end

_init_return(::FullPopEx,pr::AgeTransition) =
    _init_return(AbsAlivePopEx(),pr)

function do_age_transitions!(model::AbstractMABM, sim::AbstractABMSimulator, example::AbsExample)
    ret = _init_return(example,AgeTransition())
    ret = do_age_transitions!(model,_popfeature(example),ret)
    nothing
end

_init_return(::FullPopEx,pr::WorkTransition) =
    _init_return(AbsAlivePopEx(),pr)

function do_work_transitions!(model::AbstractMABM, sim, example::AbsExample)
    ret = _init_return(example,WorkTransition())
    ret = do_work_transitions!(model,_popfeature(example),ret)
    nothing
end

_init_return(::FullPopEx,pr::SocialTransition) =
    _init_return(AbsAlivePopEx(),pr)

function do_social_transitions!(model::AbstractMABM, sim, example::AbsExample)
    ret = _init_return(example,SocialTransition())
    ret = do_social_transitions!(model,_popfeature(example),ret)
    nothing
end

function pre_model_stepping!(model, sim::FixedStepSimP, example::SimpleSimulatorEx)
    increment_time!(model, sim, example)
end

function agent_stepping!(person, model, sim::FixedStepSimP, example::SimpleSimulatorEx)
    age_transition!(person, model, _popfeature(example))
    divorce!(person, model, _popfeature(example))
    work_transition!(person, model, _popfeature(example))
    social_transition!(person, model, _popfeature(example))
    nothing
end

function _dobirths_caching()
    if  applycaching(Birth()) == true
        return UseCache()
    end
    return NoCaching()
end

function post_model_stepping!(model, sim::FixedStepSimP, example::SimpleSimulatorEx)
    dodeaths!(model, _popfeature(example))
    do_assign_guardians!(model, _popfeature(example))
    dobirths!(model, _popfeature(example); caching = _dobirths_caching())
    domarriages!(model, _popfeature(example))
    nothing
end

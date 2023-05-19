using  MultiAgents: AbstractABMSimulator
using  MultiAgents: attach_pre_model_step!, attach_post_model_step!,
                    attach_agent_step!, currstep
import MultiAgents: setup!
#export setup!

function _setup_common!(sim::AbstractABMSimulator)

    debug_setup(sim.parameters)

    attach_pre_model_step!(sim,increment_time!)
    attach_post_model_step!(sim,dodeaths!)
    attach_post_model_step!(sim,do_assign_guardians!)
    attach_post_model_step!(sim,dobirths!)
    attach_post_model_step!(sim,domarriages!)

    nothing
end

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

"set up simulation functions where dead people are removed"
function setup!(sim::AbstractABMSimulator, example::FullPopEx)
    attach_agent_step!(sim,age_transition_step!)
    attach_agent_step!(sim,divorcestep!)
    attach_agent_step!(sim,work_transition_step!)
    attach_agent_step!(sim,social_transition_step!)
    # attach_agent_step!(sim,marriagestep!) # does not seem to work properly (may be due to memoization)
    _setup_common!(sim)
    nothing
end

function setup!(sim::AbstractABMSimulator,example::AbsAlivePopEx)
    attach_post_model_step!(sim,do_age_transitions!)
    attach_post_model_step!(sim,dodivorces!)
    attach_post_model_step!(sim,do_work_transitions!)
    attach_post_model_step!(sim,do_social_transitions!)
    _setup_common!(sim)
    nothing
end

"""
This module is defining simulation models

This module is within the MALPM module
"""

module Models

using SocioEconomics.XAgents: PersonHouse, PersonTown, Person, alive
using SocioEconomics.ParamTypes: DemographyPars, MapXPars, DemographyData
using MultiAgents: AbstractMABM, SimpleABM
using MultiAgents: add_agent!, kill_agent_at_opt!

import SocioEconomics.API.ParamFunc: all_pars, population_pars, birth_pars, divorce_pars,
    marriage_pars, work_pars, all_pars, map_pars
import SocioEconomics.API.ModelFunc: all_people, alive_people,
    data_of, houses, towns,
    add_person!, add_house!, remove_person!
import MultiAgents: allagents

export MAModel

struct MAModel <: AbstractMABM
    towns  :: SimpleABM{PersonTown}
    houses :: SimpleABM{PersonHouse}
    pop    :: SimpleABM{Person}
    parameters :: DemographyPars
    data       :: DemographyData
end

allagents(model::MAModel) = allagents(model.pop)
all_people(model::MAModel) = allagents(model.pop)
alive_people(model::MAModel) =
    [ person for person in all_people(model)  if alive(person) ]
    # Iterators.filter(person->alive(person),people) # Iterators did not show significant value sofar
houses(model::MAModel) = allagents(model.houses)
towns(model::MAModel) = allagents(model.towns)
data_of(model) = model.data
add_person!(model, person) = add_agent!(model.pop, person)
remove_person!(model, personidx::Int) = kill_agent_at_opt!(personidx, model.pop)
add_house!(model, house) = add_agent!(model.houses, house)

all_pars(model::MAModel) = model.parameters
population_pars(model::MAModel) = model.parameters.poppars
birth_pars(model::MAModel)	 	 = model.parameters.birthpars
divorce_pars(model::MAModel)    = model.parameters.divorcepars
marriage_pars(model::MAModel)   = model.parameters.marriagepars
work_pars(model::MAModel)       = model.parameters.workpars
map_pars(model::MAModel)        = model.parameters.mappars

end # module Models

"""
This module is defining simulation models 

This module is within the MALPM module 
""" 

module Models 

using SocioEconomics.XAgents: Town, PersonHouse, PersonTown, Person, alive  
using SocioEconomics.ParamTypes: DemographyPars, MapPars, DemographyData 
using MultiAgents: AbstractMABM, SimpleABM
using MultiAgents: add_agent!, kill_agent_at_opt!  

import SocioEconomics.API.ParamFunc: populationParameters, birthParameters, divorceParameters, 
                                        marriageParameters, workParameters, allParameters, mapParameters
import SocioEconomics.API.ModelFunc: allPeople, alivePeople, dataOf, houses, towns, add_person!, add_house!, remove_person!  

import MultiAgents: allagents

export MAModel 

struct MAModel <: AbstractMABM 
    towns  :: SimpleABM{PersonTown} 
    houses :: SimpleABM{PersonHouse}
    pop    :: SimpleABM{Person}
    parameters :: DemographyPars
    data       :: DemographyData

    function MAModel(model,pars,data) 
        ukTowns  = SimpleABM{PersonTown}(model.towns) 
        ukHouses = SimpleABM{PersonHouse}(model.houses)
        ukPopulation = SimpleABM{Person}(model.pop)
        new(ukTowns,ukHouses,ukPopulation,pars,data)
    end
end

allagents(model::MAModel) = allagents(model.pop)
allPeople(model::MAModel) = allagents(model.pop)
alivePeople(model::MAModel) = 
    [ person for person in allPeople(model)  if alive(person) ]
    # Iterators.filter(person->alive(person),people) # Iterators did not show significant value sofar
houses(model::MAModel) = allagents(model.houses)
towns(model::MAModel) = allagents(model.towns) 
#dataOf(model) = model.pop.data
dataOf(model) = model.data
add_person!(model, person) = add_agent!(model.pop, person)
remove_person!(model, personidx::Int) = kill_agent_at_opt!(personidx, model.pop) 
add_house!(model, house) = add_agent!(model.houses, house)


allParameters(model::MAModel) = model.parameters 
populationParameters(model::MAModel) = model.parameters.poppars  
birthParameters(model::MAModel)	 	 = model.parameters.birthpars 
divorceParameters(model::MAModel)    = model.parameters.divorcepars 
marriageParameters(model::MAModel)   = model.parameters.marriagepars 
workParameters(model::MAModel)       = model.parameters.workpars 
mapParameters(model::MAModel)        = model.parameters.mappars

end # module Models 
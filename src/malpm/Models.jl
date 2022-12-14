"""
This module is defining simulation models 

This module is within the MALPM module 
""" 

module Models 

using SocioEconomics.XAgents: Town, PersonHouse, Person, alive  
using SocioEconomics.ParamTypes: DemographyPars, MapPars, DemographyData 
using MultiAgents: AbstractMABM, SimpleABM  

import SocioEconomics.API.ParamFunc: populationParameters, birthParameters, divorceParameters, 
                                        marriageParameters, workParameters, allParameters
import SocioEconomics.API.ModelFunc: allPeople, alivePeople, dataOf, houses, towns 

import MultiAgents: allagents

export MAModel 

mutable struct MAModel <: AbstractMABM 
    towns  :: SimpleABM{Town} 
    houses :: SimpleABM{PersonHouse}
    pop    :: SimpleABM{Person}
    parameters :: DemographyPars
    data       :: DemographyData

    function MAModel(model,pars,data) 
        ukTowns  = SimpleABM{Town}(model.towns) 
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


allParameters(model::MAModel) = model.parameters 
populationParameters(model::MAModel) = model.parameters.poppars  
birthParameters(model::MAModel)	 	 = model.parameters.birthpars 
divorceParameters(model::MAModel)    = model.parameters.divorcepars 
marriageParameters(model::MAModel)   = model.parameters.marriagepars 
workParameters(model::MAModel)       = model.parameters.workpars 

end # module Models 
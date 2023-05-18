import SocioEconomics.API.ParamFunc: all_pars, population_pars, birth_pars, divorce_pars,
    marriage_pars, work_pars, map_pars
import SocioEconomics.API.ModelFunc: all_people, alive_people,
    data_of, houses, towns,
    add_person!, add_house!, remove_person!,
    currenttime

data_of(model) = model.data
currenttime(model)::Rational{Int} = model.t

all_pars(model) = model.parameters
population_pars(model) = model.parameters.poppars
birth_pars(model) = model.parameters.birthpars
divorce_pars(model) = model.parameters.divorcepars
marriage_pars(model) = model.parameters.marriagepars
work_pars(model) = model.parameters.workpars
map_pars(model) = model.parameters.mappars

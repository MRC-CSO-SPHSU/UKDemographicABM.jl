using Memoization

import SocioEconomics.API.ParamFunc: all_pars, population_pars, birth_pars, divorce_pars,
    marriage_pars, work_pars, map_pars
import SocioEconomics.API.ModelFunc: all_people, alive_people,
    data_of, houses, towns,
    add_person!, add_house!, remove_person!,
    currenttime
import SocioEconomics.API.ModelFunc: share_childless_men, eligible_women

data_of(model) = model.data
currenttime(model)::Rational{Int} = model.t

all_pars(model) = model.parameters
population_pars(model) = model.parameters.poppars
birth_pars(model) = model.parameters.birthpars
divorce_pars(model) = model.parameters.divorcepars
marriage_pars(model) = model.parameters.marriagepars
work_pars(model) = model.parameters.workpars
map_pars(model) = model.parameters.mappars

_ageclass(person) = trunc(Int, age(person)/10)
@memoize Dict function share_childless_men(model, ageclass :: Int)
    nAll = 0
    nNoC = 0
    for p in Iterators.filter(x->alive(x) && ismale(x) && _ageclass(x) == ageclass, all_people(model))
        nAll += 1
        if !has_dependents(p)
            nNoC += 1
        end
    end
    return nNoC / nAll
end

@memoize eligible_women(model) =
    [f for f in all_people(model) if isfemale(f) && alive(f) &&
        issingle(f) && age(f) > birth_pars(model).minPregnancyAge]

function reset_cache_marriages(model,sim,example)
    Memoization.empty_cache!(share_childless_men)
    Memoization.empty_cache!(eligible_women)
end

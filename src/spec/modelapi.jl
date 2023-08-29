using Memoization

using SocioEconomics.API.ModelFunc
import SocioEconomics.API.ModelFunc: all_people, alive_people,
    add_person!, add_house!, remove_person!,towns, houses
import SocioEconomics.API.ModelFunc: share_childless_men, eligible_women

_alive_people(model) =
    [ person for person in all_people(model)  if alive(person) ]

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

"""
A mini-demography example for exploring and demonstrating various functionalities
    of Agents.jl.

    For of implementation simplicity
    - many low-level details regarding the underlying model has been removed
    - the whole implementation is placed in one file
    -  (algorithmic) efficiency is not always considered (e.g. extra redundant references to
        data need to be stored to avoid temporary arrays or re-computation)
"""

using Agents
using StatsBase

import Agents: random_position, add_agent_to_space!, remove_agent_from_space!,
    positions, ids_in_position, has_empty_positions, random_empty,
    add_agent!, move_agent!
import Base: isempty

#############
# space types
#############

struct TownH{HouseType}
    name::String
    density::Float64
    location::Tuple{Int64,Int64}
    houses::Vector{HouseType}
    # Potentially possible: to maintain the following
    #   two lists emptyhouses and occupiedhouses can be disjointly maintained
    #   population::Vector{PersonType}
end

_weights(towns) = [ town.density for town in towns ]
random_town(towns) = sample(towns, Weights(_weights(towns)))
has_empty_house(town) = length([house for house in town.houses if isempty(house) ]) > 0
function has_empty_house(towns::Vector)
    for town in towns
        if has_empty_house(town)
            return true
        end
    end
    return false
end

function Base.show(io::IO, town::TownH)
    println(io,"town $(town.name) @location $(town.location) with $(length(town.houses)) houses")
end

abstract type GetHouses end
struct AllHouses <: GetHouses end
struct EmtpyHouses <: GetHouses end

allhouses(town::TownH,::EmtpyHouses) = [ house for house in town.houses if isempty(house) ]
emptyhouses(town::TownH) = allhouses(town,EmtpyHouses())
allhouses(town::TownH,::AllHouses) = town.houses
allhouses(town::TownH) = allhouses(town,AllHouses())

function allhouses(towns::Vector,ret::GetHouses)
    houses = House[]
    for town in towns
        houses = vcat(houses,allhouses(town,ret))
    end
    return houses
end
emptyhouses(towns::Vector) = allhouses(towns,EmtpyHouses())
allhouses(towns::Vector) = allhouses(towns,AllHouses())

struct HouseTP{TownType,PersonType}
    town::TownType
    location::Tuple{Int64,Int64}
    occupants::Vector{PersonType}

    function HouseTP{TownType,PersonType}(town,location) where {TownType,PersonType}
        house = new{TownType,PersonType}(town,location,PersonType[])
        push!(town.houses,house)
        return house
    end
end

isempty(house::HouseTP) = isempty(house.occupants)
remove_occupant!(house::HouseTP,person) =
    splice!(house.occupants, findfirst(x -> x == person, house.occupants))
function add_occupant!(house::HouseTP,person)
    @assert person.pos == house
    @assert !(person in house.occupants)
    push!(house.occupants,person)
end

function Base.show(io::IO, house::HouseTP)
    println(io,"house @ location $(house.location) @ town $(house.town.name)")
    if isempty(house)
        println(io,"\twith no occupants")
    else
        print(io,"\t with occupant ids:")
        for person in house.occupants
            print(io,"\t$(person.id)")
        end
    end
end

#############
# Human types
#############

@enum Gender male female
#@enum Status married single

mutable struct PersonH{HouseType} <: AbstractAgent
    id::Int
    pos::HouseType
    const gender::Gender
    #status::Status
    age::Rational{Int}

    function PersonH{HouseType}(id,pos,gender,age) where HouseType
        person = new{HouseType}(id,pos,gender,age)
        add_occupant!(pos,person)
        return person
    end
end

PersonH{HouseType}(id, pos) where HouseType =
    PersonH{HouseType}(id, pos, rand((male,female)), rand(20:30) + rand(0:11)//12)

home(person) = person.pos
hometown(person) = person.pos.town
age2yearsmonths(person) = date2yearsmonths(person.age)

function Base.show(io::IO, person::PersonH)
    println("person $(person.id) living in house @ $(home(person).location) @town $(hometown(person).name) of age $(age2yearsmonths(person))")
end

##############################
# concerete types
################################

const Town = TownH{HouseTP}
const House = HouseTP{Town,PersonH}
const Person = PersonH{House}

Town(density,location) = Town("",density,location,House[])
Town(name,density,location) = Town(name,density,location,House[])

const UNDEFINED_LOCATION = (-1,-1)
const UNDEFINED_TOWN = Town("",0,UNDEFINED_LOCATION)
const UNDEFINED_HOUSE = House(UNDEFINED_TOWN,UNDEFINED_LOCATION)

############################
# allocation functionalities
############################

undefined(town::Town) = town == UNDEFINED_TOWN
undefined(house::House) = house == UNDEFINED_HOUSE
ishomeless(person) = undefined(home(person))

function reset_person_house!(person)
    if !ishomeless(person)
        remove_occupant!(home(person),person)
        person.pos = UNDEFINED_HOUSE
    end
    @assert undefined(home(person))
end

function set_person_house!(person,house)
    reset_person_house!(person)
    person.pos = house
    add_occupant!(house,person)
end

#################################
### Space type for populations
#################################

abstract type PopulationSpace <: Agents.DiscreteSpace end
struct Country <: PopulationSpace
    countryname::String
    towns::Vector{Town}
end

Country(name) = Country(name,Town[])
add_town!(country,location,density) = push!(country.towns,Town(location,density))

##############
### utilities
##############

"convert date in rational representation to (years, months) as tuple"
function date2yearsmonths(date::Rational{Int})
    date < 0 ? throw(ArgumentError("Negative age")) : nothing
    12 % denominator(date) != 0 ? throw(ArgumentError("$(date) not in date/age format")) : nothing
    years  = trunc(Int, numerator(date) / denominator(date))
    months = trunc(Int, numerator(date) % denominator(date) * 12 / denominator(date) )
    return (years , months)
end

###############
#  other model-based functions
################

empty_positions(model::ABM{Country}) = allhouses(model.space.towns,EmtpyHouses())
random_town(model::ABM{Country}) = random_town(model.space.towns)

################
# extended Agents.jl functions
################

#
# The following is needed by add_agent!(agent,model)
#
function add_agent_to_space!(person, model::ABM{Country})
    @assert !ishomeless(person)
    @assert hometown(person) in model.space.towns
    @assert home(person) in hometown(person).houses
    # also possible
    # push!(hometown(person).population,person)
end

"overloaded add_agent!, otherwise won't work"
function add_agent!(person::Person,house::House,model::ABM{Country})
    reset_person_house!(person)
    set_person_house!(person,house)
    add_agent_pos!(person,model)
end

# needed by add_agent!(model)
add_agent!(house,::Type{Person},model::ABM{Country}) =
    add_agent_pos!(Person(nextid(model),house),model)

# needed by add_agent!(house,model)
add_agent!(house::House,model::ABM{Country}) =
    add_agent!(house,Person,model)

# needed by move_agent!(person,model)
function move_agent!(person,house,model::ABM{Country})
    reset_person_house!(person)
    set_person_house!(person,house)
end

# needed by kill_agent
function remove_agent_from_space!(person, model::ABM{Country})
    reset_person_house!(person)
end

positions(model::ABM{Country}) = allhouses(model.space.towns)
has_empty_positions(model::ABM{Country}) = length(empty_positions(model)) > 0

notneeded() = error("not needed")
function ids_in_position(house::House,model::ABM{Country})
    @warn "ids_in_position(*) was called"
    notneeded()
end
ids_in_position(person::Person,model::ABM{Country}) = ids_in_position(person.pos,model)

"Shallow implementation subject to improvement by considering town densities"
function random_position(model::ABM{Country})
    town = random_town(model)
    house = rand(town.houses)
    return house # bluestyle :/
end
"Shallow implementation subject to improvement by considering town densities"
function random_position(model::ABM{Country})
    town = random_town(model)
    house = rand(town.houses)
    return house # bluestyle :/
end
random_empty(model::ABM{Country}) = rand(empty_positions(model))

# simularly agents_in_position

# Some ContinuousSpace functions could be imitated
#  manhattan_distance

# Other functions
# nearby_ids, nearby_agents, nearby_positions, random_*

"verify some basic agentsjl functionalities"
function explore_agentsjl(nhouses)
    towns = [ Town("A", 0.9, (1,1), House[]),
              Town("B", 0.3, (10,5), House[]),
              Town("C", 0.5, (4,6), House[]),
              Town("D", 0.7, (2,2), House[]) ]
    houses = House[]
    for _ in 1:NUM_HOUSES
        push!(houses, House(random_town(towns),(rand(1:10),rand(1:10))))
    end
    space = Country("WaqWaq",towns)
    model = ABM(Person,space)
    seed!(model,floor(Int,time()))

    add_agent_pos!(Person(1,houses[1]),model)
    add_agent!(Person(2,UNDEFINED_HOUSE),houses[2],model)
    add_agent!(model)
    add_agent!(model)
    add_agent!(houses[3],model)

    println(allagents(model))

    fill_space!(model)
    println(nagents(model))

    move_agent!(model[4],model)
    println(model[5])
    move_agent!(model[5],model)
    println(model[5])

    kill_agent!(model[1],model)
    kill_agent!(2,model)

    try
        println(model[2])
    catch e
        println("person 2 not in model")
    end

    println("model[4] $(model[4])")
    println("random agent : $(random_agent(model))")
    println("# of agents : $(nagents(model))")
    println("all agents : $(allagents(model))")
    println("all ids : $(allids(model))")

    println("# of houses : $(length(positions(model)))")
    try
        ids_in_position(model[4],model)
    catch e
        nothing
    end

    println("has empty position : $(has_empty_positions(model))")
    println("# of agents : $(nagents(model))")

    id = 3
    while !has_empty_positions(model)
        kill_agent!(id,model)
        id += 1
    end
    println("# of agents : $(nagents(model))")
    println("# of empty spaces : $(length(empty_positions(model))) ")

    println("an empty house : $(random_empty(model))")

    genocide!(model)
    @assert length(allids(model)) == 0

end

const NUM_HOUSES = 100
@time explore_agentsjl(NUM_HOUSES)

####################################
#### declare an initialize a real model
####################################

const UKDENSITY = [
    0.0 0.1 0.2 0.1 0.0 0.0 0.0 0.0;
    0.1 0.1 0.2 0.2 0.3 0.0 0.0 0.0;
    0.0 0.2 0.2 0.3 0.0 0.0 0.0 0.0;
    0.0 0.2 1.0 0.5 0.0 0.0 0.0 0.0;
    0.4 0.0 0.2 0.2 0.4 0.0 0.0 0.0;
    0.6 0.0 0.0 0.3 0.8 0.2 0.0 0.0;
    0.0 0.0 0.0 0.6 0.8 0.4 0.0 0.0;
    0.0 0.0 0.2 1.0 0.8 0.6 0.1 0.0;
    0.0 0.0 0.1 0.2 1.0 0.6 0.3 0.4;
    0.0 0.0 0.5 0.7 0.5 1.0 1.0 0.0;
    0.0 0.0 0.2 0.4 0.6 1.0 1.0 0.0;
    0.0 0.2 0.3 0.0 0.0 0.0 0.0 0.0]

function create_UK_map(densities)
    UK = Country("The United Kingdom")
    nrows, ncols = size(densities)
    for x in 1:ncols
        for y in 1:nrows
            if densities[y,x] > 0
                add_town!(UK, densities[y,x], (y,x))
            end
        end
    end
    return UK
end

UK = create_UK_map(UKDENSITY)
UKMODEL = ABM(Person,UK)
const NUM_INITIAL_POP = 10000

# create initial population

# assign people to houses

# add agents to model

# step model (ageing, marrying, divorcing, deaths, births)

import HashCode2014

@enum DIRECTION begin
    NORTH
    EAST 
    SOUTH 
    WEST
end

DIRECTION_ARRAY = [NORTH, EAST, SOUTH, NORTH] 
THRESHOLD = 0.01

function city()
    return HashCode2014.read_city()
end 

"""
    change_duration(city, total_duration)

Create a new [`City`](@ref) with a different `total_duration` and everything else equal.
"""
function change_duration(city::City, total_duration)
    new_city = City(;
        total_duration=total_duration,
        nb_cars=city.nb_cars,
        starting_junction=city.starting_junction,
        junctions=copy(city.junctions),
        streets=copy(city.streets),
    )
    return new_city
end

function solution(city)
    return HashCode2014.random_walk(city)
end 

function distance(solution, city)
    return HashCode2014.total_distance(solution, city)
end

function randomWalkDistance()
    c = HashCode2014.read_city()
    solution = HashCode2014.random_walk(c)
    return HashCode2014.total_distance(solution, c)
end 

function is_street_start(i::Integer, street::Street)
    if i == street.endpointA
        return true
    elseif street.bidirectional && i == street.endpointB
        return true
    else
        return false
    end
end

function get_street_end(i::Integer, street::Street)
    if i == street.endpointA
        return street.endpointB
    elseif street.bidirectional && i == street.endpointB
        return street.endpointA
    else
        return 0
    end
end

function getSolnDistance(solution::Solution, c::City)
    return HashCode2014.total_distance(solution, c)
end 

function smartRandomWalkDistance()
    c = city()
    solution = smartRandomWalk(c)
    return getSolnDistance(solution, c)
end 

# assumes traveling to next junction is possible 
function getDirection(current_junction::Integer, next_junction::Integer, city::City)
    curjur = city.junctions[current_junction]
    nextjur = city.junctions[next_junction]
    
    if (abs(curjur.latitude - nextjur.latitude) < THRESHOLD) # y-axis travel 
        if (curjur.longitude > nextjur.longitude) #doing down 
            return SOUTH  
        else return NORTH end 
    elseif (abs(curjur.longitude - nextjur.longitude) < THRESHOLD)  #x-axis travel 
        if (curjur.latitude > nextjur.latitude) #going right, higher latitude more western 
            return EAST
        else return WEST end 
    end 
end

## does not assume going to all streets is possible from current_junction
function streetProbabilities(car_number::Integer, streets::Array{Street}, current_junction::Integer, city::City, duration)
    curr_dir = (car_number%4 == 0) ? 4 : car_number%4
    bad_dir = ((car_number+2)%4 == 0) ? 4 : (car_number+2)%4 # has zero probability 
    NEXT_DIRECTIONS = [] # array directions for possible streets 
    POSSIBLE_STREETS = []
    for street in streets
        if (is_street_start(current_junction, street) && 
            duration + street.duration <= city.total_duration)

            next_junction = get_street_end(current_junction, street)
            next_direction = getDirection(current_junction, next_junction, city)
            push!(NEXT_DIRECTIONS, next_direction)
            push!(POSSIBLE_STREETS, street)
        end 
    end 

    PROBABILITIES = []
    for dir in NEXT_DIRECTIONS
        if (dir == DIRECTION_ARRAY[curr_dir])
            push!(PROBABILITIES, 4)
        elseif (dir == DIRECTION_ARRAY[bad_dir])
            push!(PROBABILITIES, 1)
        else
            push!(PROBABILITIES, 2)
        end 
    end 
    
    prob = (length(PROBABILITIES) > 0) ? (PROBABILITIES ./ sum(PROBABILITIES)) : []
    return prob, POSSIBLE_STREETS
    #piecewise division by sum gets you probability 
end

function smartRandomWalk(city)
    (; total_duration, nb_cars, starting_junction, streets) = city
    itineraries = Vector{Vector{Int}}(undef, nb_cars)
    itineraries
    north = get
    for c in 1:nb_cars
        itinerary = [starting_junction]
        duration = 0
        while true
            current_junction = last(itinerary)
            probabilities, candidates = streetProbabilities(c, streets, current_junction, city, duration)
            if isempty(candidates)
                break
            else
                street = candidates[findfirst(cumsum(probabilities) .> rand())] #random distribution weighted 
                
                next_junction = get_street_end(current_junction, street)
                push!(itinerary, next_junction)
                
                duration += street.duration
            end
        end
        itineraries[c] = itinerary
    end
    return Solution(itineraries)
end 
function city()
    return HashCode2014.read_city()
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
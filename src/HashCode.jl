module HashCode
    using HashCode2014
    using BenchmarkTools

    using Random: AbstractRNG, default_rng

    """
    struct docstring
    """
    struct CarPath
        carNum :: Int
        path :: Vector{Int}
        timeTraveled :: Int
        
        function CarPath(carNum::Int)
            new(carNum,[4517])
        end

    end

    """
    custom_walk(rng, city)

    custom type stuff
    """
    function getCarLocation(car::CarPath)
        return car.path[end]
    end

    struct CityMap
        nodes::Vector{Junction}
        edges::Vector{Street}
        cars::Vector{CarPath}
        visitedJuncs :: Vector{Int}

        function CityMap(junctions::Vector{Junction},streets::Vector{Street})
            carPaths = []
            for i in 1:8
                push!(carPaths,CarPath(i))
            end
    
            new(junctions,streets,carPaths,[4517])
        end

        function newFunc()
            return "hi"
        end
    end

    function getCarLocation(cityMap:: CityMap,carNum::Int)
        return getCarLocation(cityMap.cars[carNum])
    end

    function addCarMove(cityMap:: CityMap, carNum::Int, juncNum :: Int, timeAdded :: Int)
        cityMap.cars[carNum].timeTraveled += timeAdded
        push!(cityMap.cars[carNum].path,juncNum)
        push!(cityMap.visitedJuncs,juncNum)
    end

    function alreadyVisited(cityMap:: CityMap, juncNum :: Int)
        return juncNum in cityMap.visitedJuncs
    end

    function getPosJuncs(cityMap::CityMap,curJunc::Int)
        posJuncs = []
        for edge in cityMap.edges
            if edge.endpointA === curJunc
                push!(posJuncs,(edge.endpointB,edge.duration))
            end
            if edge.endpointB === curJunc && edge.bidirectional
                push!(posJuncs,(edge.endpointA,edge.duration))
            end
        end
        return posJuncs
    end
        

    




    """
        custom_walk(rng, city)

    does a custom walk
    """
    function custom_walk(rng::AbstractRNG, city::City)
        (; total_duration, nb_cars, starting_junction, streets) = city
        itineraries = Vector{Vector{Int}}(undef, nb_cars)
        for c in 1:nb_cars
            itinerary = [starting_junction]
            duration = 0
            visited_streets = Set{Int}()
            while true
                current_junction = last(itinerary)
                candidates = [
                    (s, street) for (s, street) in enumerate(streets) if (
                        HashCode2014.is_street_start(current_junction, street) &&
                        duration + street.duration <= total_duration &&
                        !(s in visited_streets)
                    )
                ]
                if isempty(candidates)
                    break
                else
                    s, street = rand(rng, candidates)
                    next_junction = HashCode2014.get_street_end(current_junction, street)
                    push!(itinerary, next_junction)
                    duration += street.duration
                    push!(visited_streets, s)
                end
            end
            itineraries[c] = itinerary
        end
        return Solution(itineraries)
    end    

    city = read_city()
    # HashCode2014.total_distance(custom_walk, city)
    solution = custom_walk(default_rng(), city)
    println(HashCode2014.total_distance(solution, city))
end

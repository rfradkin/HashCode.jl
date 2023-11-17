module HashCode
    using HashCode2014
    using BenchmarkTools

    using Random: AbstractRNG, default_rng

    """
    CarPath
    
    A structure representing the path and travel information of a car in the city.
    
    Fields:
    - carNum (Int): The unique identifier for the car.
    - path (Vector{Int}): Vector representing the path of the car, starting with an initial junction.
    - timeTraveled (Int): The total time traveled by the car.
    
    Constructor:
    - CarPath(carNum::Int): Creates a new CarPath object with the specified car number.
        - carNum: The unique identifier for the car.
    
    """
    struct CarPath
        carNum::Int
        path::Vector{Int}
        timeTraveled::Int
        
        function CarPath(carNum::Int)
            new(carNum, [4517])
        end
    end    

    """
    getCarLocation(car::CarPath)
    
    Gets the current location of a car based on its path.
    
    Parameters:
    - car (CarPath): The car path object containing information about the car's path.
    
    Returns:
    - Any: The current location of the car.
    """
    function getCarLocation(car::CarPath)
        return car.path[end]
    end
    
    
    """
    CityMap
    
    A structure representing the map of a city, including information about nodes (junctions), edges (streets), cars, and visited junctions.
    
    Fields:
    - nodes (Vector{Junction}): Vector of junctions in the city.
    - edges (Vector{Street}): Vector of streets connecting junctions.
    - cars (Vector{CarPath}): Vector of car paths representing the movement of cars.
    - visitedJuncs (Vector{Int}): Vector of visited junctions.
    
    Constructors:
    - CityMap(junctions::Vector{Junction}, streets::Vector{Street}): Creates a new CityMap with the given junctions and streets.
        - junctions: Vector of Junction objects.
        - streets: Vector of Street objects.
    
    Methods:
    - newFunc(): Returns the string "hi".
    
    """
    struct CityMap
        nodes::Vector{Junction}
        edges::Vector{Street}
        cars::Vector{CarPath}
        visitedJuncs::Vector{Int}
    
        function CityMap(junctions::Vector{Junction}, streets::Vector{Street})
            carPaths = []
            for i in 1:8
                push!(carPaths, CarPath(i))
            end
    
            new(junctions, streets, carPaths, [4517])
        end
    end    

    """
    getCarLocation(cityMap::CityMap, carNum::Int)
    
    Gets the current location of a specified car in the city map.
    
    Parameters:
    - cityMap (CityMap): The map of the city containing information about cars.
    - carNum (Int): The index of the car for which to retrieve the location.
    
    Returns:
    - Any: The current location of the specified car.
    """
    function getCarLocation(cityMap::CityMap, carNum::Int)
        return getCarLocation(cityMap.cars[carNum])
    end
    
    
    """
    addCarMove(cityMap::CityMap, carNum::Int, juncNum::Int, timeAdded::Int)
    
    Updates the city map to reflect a car's movement by adding a new junction to its path and updating its total travel time.
    
    Parameters:
    - cityMap (CityMap): The map of the city containing information about cars and visited junctions.
    - carNum (Int): The index of the car making the move.
    - juncNum (Int): The junction number to be added to the car's path.
    - timeAdded (Int): The time added to the car's total travel time.
    
    Returns:
    - Nothing
    """
    function addCarMove(cityMap::CityMap, carNum::Int, juncNum::Int)
        push!(cityMap.cars[carNum].path, juncNum)
        push!(cityMap.visitedJuncs, juncNum)
    end 
    
    
    """
    alreadyVisited(cityMap::CityMap, juncNum::Int)
    
    Checks if a junction has already been visited in the city map.
    
    Parameters:
    - cityMap (CityMap): The map of the city containing information about visited junctions.
    - juncNum (Int): The junction number to check for.
    
    Returns:
    - Bool: True if the junction has already been visited, false otherwise.
    """
    function alreadyVisited(cityMap::CityMap, juncNum::Int)
        return juncNum in cityMap.visitedJuncs
    end    

    """
    getPosJuncs(cityMap::CityMap, curJunc::Int)
    
    Finds the possible junctions and their durations reachable from the given current junction in a city map.
    
    Parameters:
    - cityMap (CityMap): The map of the city containing information about edges.
    - curJunc (Int): The current junction from which to find possible next junctions.
    
    Returns:
    - Vector{Tuple{Int, Int}}: A vector of tuples representing possible next junctions and their corresponding durations.
    """
    function getPosJuncs(cityMap::CityMap, curJunc::Int)
        posJuncs = []
        for edge in cityMap.edges
            if edge.endpointA === curJunc
                push!(posJuncs, (edge.endpointB, edge.duration))
            end
            if edge.endpointB === curJunc && edge.bidirectional
                push!(posJuncs, (edge.endpointA, edge.duration))
            end
        end
        return posJuncs
    end    
        
    """
    custom_walk(rng, city)
    
    Performs a custom walk to generate itineraries for vehicles in a given city.
    
    Parameters:
    - rng (AbstractRNG): The random number generator.
    - city (City): The city information containing details such as total duration, number of cars, starting junction, and streets.
    
    Returns:
    - Solution: A solution object containing generated itineraries for each car.
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
    

    city = HashCode2014.read_city()

    """
    getPosJuncs(city::City, curJunc::Int)
    
    Finds the possible junctions and their durations reachable from the given current junction in a city map.
    
    Parameters:
    - city (City): The city object containing information about nodes and edges.
    - curJunc (Int): The current junction from which to find possible next junctions.
    
    Returns:
    - Vector{Tuple{Int, Int}}: A vector of tuples representing possible next junctions and their corresponding distances and durations.
    """
    function getJuncOptions(city:: City ,curJunc::Int)
        posJuncs = []
        juncSet = Set{Int}()

        #For each street in the list of possible streets
        for street in city.streets
            #check if it starts from our current junction and if so, add its endpoint to the list and mark that we have traversed that edge
            if street.endpointA === curJunc && !in(street.endpointB,juncSet)
                push!(juncSet,street.endpointB)
                push!(posJuncs,(street.endpointB,street.duration, street.distance))
            end
            #check if it is a bidirectional street and end at current junction and if so, add its other endpoint to the list and mark that we have traversed that edge
            if street.endpointB === curJunc && street.bidirectional && !in(street.endpointA,juncSet)
                push!(juncSet,street.endpointA)
                push!(posJuncs,(street.endpointA,street.duration, street.distance))
            end
        end
        return posJuncs
    end

    """
    haveTraversed(curJunc::Int, posJunc)
    
    Checks if a connection between two junctions has been traversed.
    
    Parameters:
    - curJunc (Int): The current junction.
    - posJunc (Tuple{Int, Int}): A tuple representing a possible next junction and its duration.
    
    Returns:
    - Bool: True if the connection has not been traversed, false otherwise.
    """
    function haveTraversed(curJunc::Int, posJunc)
        return !in(posJunc[1],visitedStreets[curJunc]) && !in(curJunc,visitedStreets[posJunc[1]])
    end
    
    """
    exploreEdgesDFS(city::City, curJunc::Int, curTime::Int, maxTime::Int)
    
    Runs a Depth-First Search (DFS) to find all possible edges that are reachable within the specified time limit. This function serves as a sensible upper bound for the best possible performance with 8 cars, as it calculates the sum of the distances of every reachable node.
    
    Parameters:
    - city (City): The city object containing information about nodes and edges.
    - curJunc (Int): The current junction from which to find possible next junctions.
    - curTime (Int): The total amount of time that has elapsed up until this recursive call.
    - maxTime (Int): The maximum time limit for the cars to travel.
    
    Returns:
    - Nothing: Modifies a global variable distances, which is a list of distances of reachable edges. The sum of these distances represents the total distance and serves as an upper bound.
    
    """
    function DFS(city::City, curJunc::Int, curTime::Int,maxTime::Int)
        #mark that we have visited this node
        push!(visitedSet,curJunc)

        #For each possible junction, look at all possible edges we could traverse
        for posJunc in getJuncOptions(city,curJunc)
            #If we do not exceed the time limit and have not already traversed this edge
            if curTime + posJunc[2] < maxTime && haveTraversed(curJunc,posJunc)

                #mark it has been traversed, add its distance to final array, and continue traversing
                push!(visitedStreets[curJunc],posJunc[1])
                push!(distances,posJunc[3])
                DFS(city,posJunc[1],curTime + posJunc[2],maxTime)

            end
        end
    end

    #Run once for 54000 bound
    visitedSet = Set{Int}([])
    visitedStreets = [Set{Int}([]) for i in 1:length(city.streets)]
    distances = []
    DFS(city,4517,0,54000)
    println("54000 Sec Bound: ", sum(distances))

    #Run again for 18000 bound
    visitedSet = Set{Int}([])
    visitedStreets = [Set{Int}([]) for i in 1:length(city.streets)]
    distances = []
    DFS(city,4517,0,18000)
    print("18000 Sec Bound: ", sum(distances))
end

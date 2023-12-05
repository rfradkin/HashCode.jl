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
    function addCarMove(cityMap::CityMap, carNum::Int, juncNum::Int, timeAdded::Int)
        # cityMap.cars[carNum].timeTraveled += timeAdded
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
    function haveTraversed(curJunc::Int, posJunc::Tuple{Int, Int,Int})
        return !(posJunc[1] in visitedStreets[curJunc]) && !(curJunc in visitedStreets[posJunc[1]])
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


    """
    custom_walk(city::City, numTrials::Int)
    
    Performs a custom walk to generate itineraries for vehicles in a given city.
    
    Parameters:
    - rng (AbstractRNG): The random number generator.
    - city (City): The city information containing details such as total duration, number of cars, starting junction, and streets.
    
    Returns:
    - TrialResults: A list of the results from running numTrials trials
    """
    function custom_walk(city::City, numTrials::Int)
        TrialResults = []
        distances, previous = djk(city,4517)
        for i in 1:numTrials
            ans = laterRandomWalk(previous,city)
            if ans == -1
                continue
            end
            sol = Solution(ans)
            totalDistance = HashCode2014.total_distance(sol, city)
            println("Attempt ", i, ": ",totalDistance)
            push!(TrialResults,totalDistance)
        end
        return TrialResults
    end

    """
    findMaximumEndpoints()
    
    Scans through each of the junctions in the city graphs and identitifies the furtherest point in each of the 8 cardinal directions
    
    Parameters:
    None
    
    Returns:
    - List of the most extreme junctions in each of the cardinal directions that will serve as the target points for each of the 8 cars
    
    """
    function findMaximumEndpoints()

        juncs = []
        mostNorth = 4517
        mostSouth = 4517
        mostEast = 4517
        mostWest = 4517

        mostNorthEast = 4517
        mostSouthEast = 4517
        mostNorthWest = 4517
        mostSouthWest = 4517

        for i in 1:length(city.junctions)
            #check if these are the most in a certain cardinal direction
            if city.junctions[i].latitude > city.junctions[mostNorth].latitude
                mostNorth = i
            elseif city.junctions[i].latitude < city.junctions[mostSouth].latitude
                mostSouth = i
            elseif city.junctions[i].longitude > city.junctions[mostEast].longitude
                mostEast = i
            elseif city.junctions[i].longitude < city.junctions[mostWest].longitude
                mostWest = i
            end

            #check if most in the combined cardinal directions
            if city.junctions[i].latitude > city.junctions[mostNorthEast].latitude && city.junctions[i].longitude > city.junctions[mostNorthEast].longitude
                mostNorthEast = i
            elseif city.junctions[i].latitude < city.junctions[mostSouthEast].latitude && city.junctions[i].longitude > city.junctions[mostSouthEast].longitude
                mostSouthEast = i
            elseif city.junctions[i].latitude > city.junctions[mostNorthWest].latitude && city.junctions[i].longitude < city.junctions[mostNorthWest].longitude
                mostNorthWest = i
            elseif city.junctions[i].latitude < city.junctions[mostSouthWest].latitude && city.junctions[i].longitude < city.junctions[mostSouthWest].longitude
                mostSouthWest = i
            end

        end
        return mostNorth, mostSouth, mostEast, mostWest, mostNorthEast, mostNorthWest, mostSouthEast, mostSouthWest
    end


    """
    getMinUnseen(unseenNodes, distances)
    
    Helper function for Djikstra's algorithm. Given a set of unseen nodes and the djikstra's distances vector, 
    identifies the minimum distance node to use next in the search.
    
    Parameters:
    - unseenNodes: set of unseen/unvisited nodes that we must choose from
    - distances: djikstra style distances vector that has the current mininum distance to each node
    
    Returns:
    - minNode: node that has the minimum current distance amoung unvisited nodes
    
    """    
    function getMinUnseen(unseenNodes:: Set{Int}, distances::Vector{Int})
        minDist = typemax(Int)
        minNode = typemin(Int)

        #get the minumum distance node of the unseen nodes
        for node in unseenNodes
            if distances[node] < minDist
                minDist = distances[node]
                minNode = node
            end
        end
        return minNode
    end


    """
    djk(city::City, startJunc::Int)
    
    Djikstra's algorithm to identify the shortest path from the start point to every other node in the graph.
    Uses standard Djikstra's implementation
    
    Parameters:
    - city (City): The city object containing information about nodes and edges.
    - startJunc (junction): junction at which to start the search
    
    Returns:
    - distances: returns vector that contains the minimum distance from the start node to each of the other nodes in the graph
    - previous: returns a vector that, for each node, has the previous node that would go in front of it in the shortest path
        this is done in standard djikstra formulation.
    
    """
    function djk(city::City, startJunc::Int)
        #initialization
        distances = Vector{Int}(undef, length(city.junctions))
        unseenNodes = Set{Int}([])
        previous = Vector{Int}(undef, length(city.junctions))

        #initialize distances and unseen nodes vector
        for i in 1:length(city.junctions)
            if i != startJunc
                distances[i] = typemax(Int)
            end
            push!(unseenNodes,i)
        end

        #djikstras implementation of selecting the lowest distance vector and searching its neigbhors, updating the structs as neccesary
        while length(unseenNodes) > 0
            curNode = getMinUnseen(unseenNodes,distances)
            delete!(unseenNodes,curNode)

            for (neighbor, dist,time) in getJuncOptions(city,curNode)
                alt = distances[curNode] + dist
                if alt < distances[neighbor]
                    distances[neighbor] = alt
                    previous[neighbor] = curNode
                end
            end
        end

        return distances, previous
    end 


    """
    getPathToNode(endNode::Int, previous)
    
    Given a node and the previous set, reconstructs the shortest path from the starting point to that end node
    
    Parameters:
    - endNode: node to create the path to
    - previous: a vector that, for each node, has the previous node that would go in front of it in the shortest path
    this is done in standard djikstra formulation.
    
    Returns:
    - nodeList: list of nodes that form the shortest path from the startpoint (4517) to the node
    
    """
    function getPathToNode(curNode::Int, previous)

        nodeList = []

        #until get back to the start, continue backtracking from the node to find the original starting point
        while curNode != 4517
            push!(nodeList, curNode)
            if curNode == 0 || curNode > length(previous) #build in fault tolerance
                return -1
            end
            curNode = previous[curNode]
        end

        #reverse and return list to get total path
        push!(nodeList,4517)
        return reverse!(nodeList)
    end

    """
    getPathTime(path :: Vector{Int},city :: City)
    
    Given a path, gets the total time that a car has spent on that path in order to understand how much time the car has left
    
    Parameters:
    - path: list of nodes that form the path that the car has already traveled
    - city: standard city object
    
    Returns:
    - totalTime: The total time that the car has already spent traveling
    
    """
    function getPathTime(path :: Vector{Int},city :: City)
        totalTime = 0
        for i in 2:length(path)
            for street in city.streets
                if street.endpointA == path[i-1] && street.endpointB == path[i+0]
                    totalTime += street.duration
                elseif street.endpointB == path[i-1] && street.endpointA == path[i+0] && street.bidirectional
                    totalTime += street.duration
                end
            end
        end
        return totalTime
    end

    """
    laterRandomWalk(previous :: Vector{Int}, city:: Int)
    
    Given the results of the djikstra algorithm, travels the cars to the endpoints and then random walks them around the area to cover
    the most distance possible
    
    Parameters:
    - previous: a vector that, for each node, has the previous node that would go in front of it in the shortest path
    this is done in standard djikstra formulation.
    - city: standard city object containing information about the junctions and streets
    
    Returns:
    - itineraries: set of num_cars itineraries that represent the suggest paths for each car to be used in the solution
    
    """
    function laterRandomWalk(previous :: Vector{Int}, city:: City)
        (; total_duration, nb_cars, starting_junction, streets) = city
        itineraries = Vector{Vector{Int}}(undef, nb_cars)
        
        #get set of paths to each of the extreme nodes using djikstras algorithm
        pathNames = [7847,533,4507,2510,1533,649,565,2081]
        for i in 1:length(pathNames)
            path = getPathToNode(pathNames[i + 0],previous)
            if path == -1
                return -1
            end
            itineraries[i] = path[1:length(path) - 2]
        end

        #once at each node, undergo a random walk until the car runs out of time to travel
        for c in 1:8
            itinerary = itineraries[c]
            duration = getPathTime(itinerary,city)
            visited_streets = Set{Int}()
            while true
                current_junction = last(itinerary)

                #assemble possible candidates for the car to move to
                candidates = [
                    (s, street) for (s, street) in enumerate(streets) if (
                        HashCode2014.is_street_start(current_junction, street) &&
                        duration + street.duration <= total_duration
                    )
                ]

                #prioritize the possible candidates that the car has not yet visisted
                optimalCandidates = []
                for candidate in candidates
                    if !(candidate in visited_streets)
                        push!(optimalCandidates, candidate)
                    end
                end

                #if there are unvisited streets, visit them first, if not then take a random walk or end the loop
                if !isempty(optimalCandidates)
                    s, street = rand(default_rng(), optimalCandidates)
                elseif !isempty(candidates)
                    s, street = rand(default_rng(), candidates)
                else
                    break
                end

                #update the itinerary and mark the street as visisted before continuing the loop
                next_junction = HashCode2014.get_street_end(current_junction, street)
                push!(itinerary, next_junction)
                duration += street.duration
                push!(visited_streets, s)
            end
            itineraries[c] = itinerary
        end
        return itineraries
    end

    """
    isFeasible(solution::HashCode2014.Solution, city::HashCode2014.City)

    Checks the feasibility of a given solution within the context of the provided city.

    Parameters:
    - solution (HashCode2014.Solution): The solution to be checked for feasibility.
    - city (HashCode2014.City): The city object containing information about nodes and edges.

    Returns:
    - Bool: True if the solution is feasible within the given city, False otherwise.
    """
    function isFeasible(solution::HashCode2014.Solution, city::HashCode2014.City)
        is_feasible(solution, city)
    end

    city = HashCode2014.read_city()

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
    println("18000 Sec Bound: ", sum(distances))
    println(length(city.streets))
    println()

    #Find maximum endpoints to send cars to
    println(findMaximumEndpoints())
    resList = custom_walk(city, 10)
    println("-----------------")
    println("Final Answer: ", maximum(resList))

end
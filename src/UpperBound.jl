begin
    using HashCode2014
    city = HashCode2014.read_city()

    #This function, given a current Junction and city object, returns the set of Junction reachable from this node
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

    #This function checks if an edge has been traversed by checking in the visistedStreets global object
    function haveTraversed(curJunc::Int, posJunc)
        return !in(posJunc[1],visitedStreets[curJunc]) && !in(curJunc,visitedStreets[posJunc[1]])
    end
    

    #This function runs DFS to find all possible edges that are reachable in the time limit
    #This serves as a sensible upper bound for the best we could do with our 8 cars since it is sum of the edges of every reachable node
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
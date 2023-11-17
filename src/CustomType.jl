begin    
    using HashCode2014
    using BenchmarkTools

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
        

    city = HashCode2014.read_city()
    mapObject = CityMap(city.junctions,city.streets)
    getCarLocation(mapObject,1)
    # addCarMove(mapObject,1,15)
    # getCarLocation(mapObject,1)
    getPosJuncs(mapObject,4715)
    # alreadyVisited(mapObject,15) 

end
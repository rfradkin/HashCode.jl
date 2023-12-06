begin
    using HashCode2014
    include("../src/HashCode.jl")

    # The first step is to find the maximal cardinal nodes by calling our built in function as below
    cardinalNodes = HashCode.findMaximumEndpoints()

    # Next, we initialize the city
    city = HashCode2014.read_city()

    # Next, we call the function to create the paths and take the maximum of the trials
    ans = maximum(HashCode.custom_walk(city, 10))
    println(ans)

end
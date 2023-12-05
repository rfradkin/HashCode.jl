using Test
using HashCode2014
include("../src/HashCode.jl")

# City-related tests
@testset "City Tests" begin
    # Test to read city data and create a CityMap object
    city = HashCode2014.read_city()
    mapObject = HashCode.CityMap(city.junctions, city.streets)

    # Test to get and update car location
    res = HashCode.getCarLocation(mapObject, 1)
    @test res === 4517
    HashCode.addCarMove(mapObject, 1, 15)
    res2 = HashCode.getCarLocation(mapObject, 1)
    @test res2 === 15
end

# Endpoint-related tests
@testset "Endpoint Tests" begin
    # Test to find maximum endpoints
    ans = [7847, 533, 4507, 2510, 1533, 565, 649, 2081]
    solution = HashCode.findMaximumEndpoints()
    for i in 1:length(ans)
        @test solution[i] === ans[i]
    end
end

# Shortest path-related tests
@testset "Shortest Path Tests" begin
    # Test to find the shortest path and verify correctness
    city = HashCode2014.read_city()
    distances, previous = HashCode.djk(city, 4517)
    path ::Vector{Int} = HashCode.getPathToNode(533, previous)
    
    correctPath = [4517, 7282, 2752, 2240, 3879, 2365, 3217, 7852, 3776, 5838, 5432, 4289, 3331, 103, 8337, 7121, 6411, 8247, 2513, 3420, 3172, 7139, 9266, 3398, 5466, 3131, 10199, 1286, 7837, 9444, 2153, 8062, 6071, 8180, 9350, 3551, 11310, 5647, 5826, 10397, 3075, 2572, 6651, 10073, 4073, 4322, 3566, 639, 7323, 3648, 8807, 9852, 7192, 3145, 897, 1820, 5405, 146, 7203, 5760, 6202, 640, 3347, 9059, 2925, 989, 7753, 3125, 6405, 487, 7939, 6375, 1890, 9693, 952, 5937, 9506, 9145, 8939, 9740, 2476, 6845, 4267, 7618, 7207, 5207, 7779, 2059, 8235, 1897, 4794, 2562, 5765, 10266, 4593, 10582, 7621, 10845, 10223, 5392, 11105, 8101, 8147, 2630, 10925, 8838, 986, 11015, 2443, 7154, 5137, 1428, 795, 1144, 3831, 6563, 11182, 730, 10704, 3494, 10218, 2070, 9763, 3922, 10140, 10816, 3868, 9628, 4898, 6028, 7528, 4555, 3326, 773, 7161, 8543, 5549, 4581, 7012, 6311, 2657, 3391, 7587, 7247, 533]
    for i in 1:length(correctPath)
        @test correctPath[i] == path[i]
    end

    # Test to check if the time for the calculated path is correct
    @test HashCode.getPathTime(path, city) == 984
end

# Custom walk-related tests
@testset "Custom Walk Tests" begin
    # Test to ensure the custom walk time is greater than 800000
    city = HashCode2014.read_city()
    ans = maximum(HashCode.custom_walk(city, 10))
    @test ans > 800000
end

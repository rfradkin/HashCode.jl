# using CustomType
using Test
using HashCode2014
include("../src/HashCode.jl")

@testset "jl" begin
    city = HashCode2014.read_city()
    mapObject = HashCode.CityMap(city.junctions,city.streets)
    res = HashCode.getCarLocation(mapObject,1)
    @test res === 4517
    HashCode.addCarMove(mapObject,1,15)
    res2 = HashCode.getCarLocation(mapObject,1)
    @test res2 === 15
end
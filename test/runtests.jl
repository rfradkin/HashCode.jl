# using CustomType
using Test
using HashCode2014
using CustomType

@testset "CustomType.jl" begin
    # Write your tests here.
    city = HashCode2014.read_city()
    mapObject = CustomType.CityMap(city.junctions,city.streets)
    res = CustomType.getCarLocation(mapObject,1)
    @test res === 4517
    CustomType.addCarMove(mapObject,1,15)
    res2 = CustomType.getCarLocation(mapObject,1)
    @test res2 === 15
    ans3 =  [(8261, 1),(9775, 1)]
    @test CustomType.getPosJuncs(mapObject,4715)[1][1] === 8261
    @test CustomType.getPosJuncs(mapObject,4715)[1][2] === 1
    @test CustomType.getPosJuncs(mapObject,4715)[2][1] === 9775
    @test CustomType.getPosJuncs(mapObject,4715)[2][2] === 1

    @test CustomType.alreadyVisited(mapObject,15) 

end

module HashCode
    using HashCode2014
    using BenchmarkTools
    city = read_city()
    @btime HashCode2014.random_walk(city)

end

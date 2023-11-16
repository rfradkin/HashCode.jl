module HashCode
    using HashCode2014
    using BenchmarkTools

    using Random: AbstractRNG, default_rng

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

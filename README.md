# HashCode

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://rfradkin.github.io/HashCode.jl/dev/)
[![Build Status](https://github.com/rfradkin/HashCode.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/rfradkin/HashCode.jl/actions/workflows/CI.yml?query=branch%3Amain)

## Installation
Clone the repository to your local machine:
```
git clone git@github.com:rfradkin/HashCode.jl.git
```
Change into the newly cloned repository:
```
cd HashCode.jl
```
Open the Julia REPL in the terminal:
```
julia
```
In the Julia REPL, activate the project to use the correct environment:
```
import Pkg
Pkg.activate(".")
```
Install the project dependencies:
```
Pkg.instantiate()
```
## Quickstart
For an example of the custom walk usage:
```
using HashCode

# Define a city
city = City(; total_duration = 100, nb_cars = 5, starting_junction = 1, streets = [...])

# Use the custom walk function
rng = Random.GLOBAL_RNG
solution = custom_walk(rng, city)

# Print the generated solution
println(solution)
```
To get an upper bound distance:
```
# Calculate an upper bound on the distance by performing a Depth-First Search (DFS)
# Run once for a 54,000-seconds bound
visitedSet = Set{Int}([])
visitedStreets = [Set{Int}([]) for i in 1:length(city.streets)]
distances = []
DFS(city, 4517, 0, 54_000)
println("54,000 Sec Bound: ", sum(distances))
```

## Testing
To run the unit tests, in a Julia REPL:
```
import Pkg
Pkg.activate(".")
Pkg.test()
```
To check the feasibilty, pass the solution and the HashCode2014 city to HashCode isFeasible:
```
isFeasible(solution::HashCode2014.Solution, city::HashCode2014.City)
```
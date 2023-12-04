# HashCode

# Installation
To install HashCode.jl, open the Julia REPL and run the following command:
```
import Pkg
Pkg.add("HashCode")
```
## Quickstart
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

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://rfradkin.github.io/HashCode.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://rfradkin.github.io/HashCode.jl/dev/)
[![Build Status](https://github.com/rfradkin/HashCode.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/rfradkin/HashCode.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/rfradkin/HashCode.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/rfradkin/HashCode.jl)


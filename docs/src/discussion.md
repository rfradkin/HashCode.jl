# Implementation and Performance

## Implementation

Our algorithm works by first trying to separate the cars and then allowing them to go on an optimized random walk in order to conver the most ground possible. 

First, we identify the nodes that are the furthest, by latitude and longitude, in each of the cardinal direction (north, east, south, west, northeast, northwest, southeast, southwest). Next, we use djikstras algorithm to find the shortest path from the starting node to each of these furthest nodes. From there, we drive the cars almost the entire way to their respective furthest nodes (stopping 2 stops before the final node in order to maintain some centrality). At this point, we allow the cars to undergo a random walk where we prioritize traveling to edges that have not yet been explored and, only if none are available, choose a direction at random.

## Performance

Since our algorithm requires a level of randomization, we run the random search multiple times and take the best set of routes in order to ensure that we meet the minimum distance needed. While this does increase the runtime of our algorithm, it does not affect the algorithmic complexity since we run the algorithm a constant number of times.

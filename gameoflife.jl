using Agents
using Random
using DelimitedFiles

"""
    LifeAgent <: AbstractAgent

Agent for Conway's game of life.
"""
mutable struct LifeAgent <: AbstractAgent
	id::Int
	pos::NTuple{2, Int}
	isAlive::Bool
end

"""
	initialize(; dims::Dims{2}, seed=nothing, p=0.1)

Randomly initialize the ABM with a true value of probability `p`.
"""
function initialize(; dims::Dims{2}=(50, 50), seed=nothing, p=0.1)
	# Create a space
	space = GridSpace(dims; periodic=true, metric=:chebyshev)

	# Create the ABM
	rng = isnothing(seed) ? MersenneTwister() : MersenneTwister(seed)
	model = AgentBasedModel(LifeAgent, space; rng)

	# Populate the model with agents
	for n in 1:prod(dims)
		isAlive = rand(rng) < p
		agent = LifeAgent(n, (1, 1), isAlive)
		add_agent_single!(agent, model)     # Randomizes agent location
	end

	return model
end

"""
	initialize(grid::Matrix{Bool})

Initialize the ABM with a given grid.
"""
function initialize(grid::Matrix{Bool})
	# Create a space
	dims = size(grid)
	space = GridSpace(dims; periodic=true, metric=:chebyshev)

	# Create the ABM
	model = AgentBasedModel(LifeAgent, space)

	# Populate the model with agents
	n = 1
	for ind in CartesianIndices(dims)
		agent = LifeAgent(n, ind, grid[ind])
		add_agent_pos!(agent, model)        # Places agent at its location
		n += 1
	end

	return model
end

"""
    initialize(source::AbstractString)

Initialize the ABM with a given file.
"""
initialize(source::AbstractString) = initialize(readdlm(source, Bool))

"""
    alive_neighbors(agent, model)

Given a particular agent and a model, return the number of 
neighbors that are alive.
"""
function alive_neighbors(agent, model)
	count = 0
	for neighbor in nearby_agents(agent, model, 1)
		if neighbor.isAlive
			count += 1
		end
	end
	return count
end

"""
    model_step!(model)

Conway's game of life model step function.
"""
function model_step!(model)
	# Find new agent values
	newgrid = zeros(Bool, nagents(model))
	for agent in allagents(model)
		n = alive_neighbors(agent, model)

		# Game of life rules
		if n < 2 || n > 3
			newgrid[agent.id] = false
		elseif n == 3
			newgrid[agent.id] = true
		else
			newgrid[agent.id] = agent.isAlive
		end
	end

	# Update all agent values
	for id in allids(model)
		model[id].isAlive = newgrid[id]
	end
end

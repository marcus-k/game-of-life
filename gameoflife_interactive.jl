using Agents
using InteractiveDynamics
using GLMakie

include("gameoflife.jl")

# Create interactive plot
gameoflife = initialize()

adata = [(:isAlive, sum)]
alabels = ["Total Alive"]

color(a) = a.isAlive ? :black : :white
figure, adf, mdf = abm_data_exploration(
    gameoflife, dummystep, model_step!;
    ac = color, 
    am = :rect,
	adata,
	alabels
)
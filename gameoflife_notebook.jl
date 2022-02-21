### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ 45536a80-9288-11ec-3dda-6755713256a0
begin
	import Pkg
	Pkg.activate(Base.current_project())

	using Agents
	using InteractiveDynamics
	using CairoMakie
	using DelimitedFiles
end

# ╔═╡ 8f245283-8d22-439d-ae39-85591a781d6e
include("gameoflife.jl");

# ╔═╡ 6b85d9f2-4815-4703-84bf-66d375974219
begin
	grid = zeros(Bool, 20, 20)
	grid[5, 5] = 1
	grid[5, 6] = 1
	grid[5, 7] = 1
	
	gameoflife = initialize(grid)
end

# ╔═╡ 80c4a77d-6be5-44e6-9ff0-e31935a1a85d
let
	step!(gameoflife, dummystep, model_step!)
	
	# Create a single frame
	color(a) = a.isAlive ? :black : :white
	figure, _ = abm_plot(gameoflife; ac=color, am=:rect)
	figure
end

# ╔═╡ 9fc6ff7c-75b3-4824-b6ba-7b5deddddfe2
let	
	gameoflife = initialize(dims=(50, 50))

	# Create an animation
	color(a) = a.isAlive ? :black : :white
	abm_video(
		"output/gameoflife.mp4", gameoflife, dummystep, model_step!;
		ac = color,
		am = :rect,
		framerate = 7,
		frames = 200,
		title = "Game of Life"
	)
end

# ╔═╡ Cell order:
# ╠═45536a80-9288-11ec-3dda-6755713256a0
# ╠═8f245283-8d22-439d-ae39-85591a781d6e
# ╠═6b85d9f2-4815-4703-84bf-66d375974219
# ╠═80c4a77d-6be5-44e6-9ff0-e31935a1a85d
# ╠═9fc6ff7c-75b3-4824-b6ba-7b5deddddfe2

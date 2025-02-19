using Pkg
Pkg.activate(".")
using JLD2, NCDatasets, CairoMakie, Statistics, LaTeXStrings, Colors

function cut_run(t, x, time2cut)
    minidx = findmin(abs.(t .- time2cut))[2]
    return x[minidx:end]
end

function find_period_interval(Wmat::Array, p_vector::Vector, period_interval::Tuple)
    idx1 = findmin(abs.(p_vector .- period_interval[1]))[2]
    idx2 = findmin(abs.(p_vector .- period_interval[2]))[2]

    if idx1 < idx2
        new_W_0 = sum(Wmat[:, idx1:idx2], dims=2)
    else # idx1 > idx2
        new_W_0 = sum(Wmat[:, idx2:idx1], dims=2)
    end

    new_W = Vector{Float32}(undef, length(new_W_0[:, 1]))
    new_W[:] = new_W_0[:, 1]
    return new_W
end

include(pwd() * "/scripts/misc/figure_definitions.jl")
include(pwd() * "/scripts/misc/spectral_tools.jl")
include(pwd() * "/scripts/misc/tools.jl")

lisiecki2005_d18O = JLD2.load_object("data/paleo_records/lisiecki-raymo_2005_d18O_5000.jld2")
lisiecki2005_temp = JLD2.load_object("data/paleo_records/lisiecki-raymo_2005_T_5000.jld2")
hodell2023_temp = JLD2.load_object("data/paleo_records/hodell-etal_2023_T_1500.jld2")
barker2011_temp = JLD2.load_object("data/paleo_records/barker-etal_2011.jld2")
bintanja2008_temp = JLD2.load_object("data/paleo_records/bintanja-vandewal_2008_T_3000.jld2")
luthi2008_co2 = JLD2.load_object("data/paleo_records/luthi-etal_2008.jld2")
berends2021_co2 = JLD2.load_object("data/paleo_records/berends-etal_2020_C_3000.jld2")
yamamoto2022_co2 = JLD2.load_object("data/paleo_records/yamamoto-etal_C_1500.jld2")
spratt2016_vol = JLD2.load_object("data/paleo_records/spratt-lisiecki_2016.jld2")
bintanja2008_vol = JLD2.load_object("data/paleo_records/bintanja-vandewal_2008_3000.jld2")
berends2021_vol = JLD2.load_object("data/paleo_records/berends-etal_2020_Vol_3000.jld2")

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
elderfield2012_d18O = JLD2.load_object("data/paleo_records/elderfield-etal_2012_d18O_1500.jld2")
hodell2023_d18O = JLD2.load_object("data/paleo_records/hodell-etal_2023_d18O_1500.jld2")
clark2025_d18OT = JLD2.load_object("data/paleo_records/clark-etal_2025_d18OT_4500.jld2")
clark2025_d18Osw = JLD2.load_object("data/paleo_records/clark-etal_2025_d18Osw_4500.jld2")
ahn2017_d18O = JLD2.load_object("data/paleo_records/ahn-etal_2017_d18O_5000.jld2")

# ruddiman1989sum_sst = JLD2.load_object("data/paleo_records/ruddiman-etal_1989sum_sst_1600.jld2")
# ruddiman1989win_sst = JLD2.load_object("data/paleo_records/ruddiman-etal_1989win_sst_1600.jld2")
# mcclymont2008_sst = JLD2.load_object("data/paleo_records/mcclymont-etal_2008_sst_1500.jld2")
herbert2016_sst = JLD2.load_object("data/paleo_records/herbert-etal_2016_sst_3000.jld2")
clark2024_sst = JLD2.load_object("data/paleo_records/clark-etal_2024_sst_4500.jld2")

lisiecki2005_temp = JLD2.load_object("data/paleo_records/lisiecki-raymo_2005_T_5000.jld2")
hodell2023_temp = JLD2.load_object("data/paleo_records/hodell-etal_2023_T_1500.jld2")
barker2011_temp = JLD2.load_object("data/paleo_records/barker-etal_2011.jld2")
bintanja2008_temp = JLD2.load_object("data/paleo_records/bintanja-vandewal_2008_T_3000.jld2")
clark2024_temp = JLD2.load_object("data/paleo_records/clark-etal_2024_T_4500.jld2")

luthi2008_co2 = JLD2.load_object("data/paleo_records/luthi-etal_2008.jld2")
berends2021_co2 = JLD2.load_object("data/paleo_records/berends-etal_2020_C_3000.jld2")
yamamoto2022_co2 = JLD2.load_object("data/paleo_records/yamamoto-etal_C_1500.jld2")

spratt2016_vol = JLD2.load_object("data/paleo_records/spratt-lisiecki_2016.jld2")
bintanja2008_vol = JLD2.load_object("data/paleo_records/bintanja-vandewal_2008_3000.jld2")
elderfield2012_vol = JLD2.load_object("data/paleo_records/elderfield-etal_2012_Vol_1500.jld2")
berends2021_vol = JLD2.load_object("data/paleo_records/berends-etal_2020_Vol_3000.jld2")
clark2025b_vol = JLD2.load_object("data/paleo_records/clark-etal_2025b_Vol_4500.jld2")

ruddiman1989_color = :pink
lisiecki2005_color = :red4
mcclymont2008_color = :navy
elderfield2012_color = :palegreen4
herbert2016_color = :purple
ahn2017_color = :violet
hodell2023_color = :orangered
clark2024_color = :olivedrab3
ahn2017_color = :lightyellow4
clark2025b_color = :cornflowerblue
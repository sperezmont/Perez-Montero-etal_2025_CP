using Pkg
Pkg.activate(".")
using JLD2, Interpolations, CairoMakie, LaTeXStrings, Colors

include(pwd() *"/scripts/misc/figure_definitions.jl")
include(pwd() * "/scripts/misc/spectral_tools.jl")
include(pwd() * "/scripts/misc/tools.jl")

function create_data(file::String, color::Symbol, color2::Symbol, year2start::Real, dt::Real)
    data = JLD2.load_object(file)
    t, x = data[1, :], data[2, :]

    if t[1] < year2start
        t, x = interp_time_series(t, x, year2start, 0.0, dt)
        data = [t x]'
    end

    x_trend = sum(x) ./ length(x) .+ (x[end] .- x[1]) ./ (t[end] .- t[1]) .* t

    colormap = cgrad([:white, color, color2], 12)
    Wnorm, periods = create_WV(t, x .- x_trend)

    return [data, Wnorm, periods, colormap]
end

# Plotting
fontsize=50
fig = Figure(resolution=(2050, 1400), fonts=(; regular="TeX"), fontsize=fontsize)

xticks_time = xticks_time_short
xticks_time = (xticks_time, convert_strings_to_latex(-1 .* xticks_time))
xlims_time = xlims_time_short

ticks_periods = (ticks_periods, convert_strings_to_latex(ticks_periods))

# Panel a and 1b
file, color, text_a, text_b = "data/insolation/solstice_insolation_65N170_10yr_5MyrBP-0.jld2", laskar2004color, (550, a_label), (100, b_label)
data = create_data(file, :grey25, :black, xlims_time_short[1] * 1e3, 1e3)

file1, color1 = "data/paleo_records/lisiecki-raymo_2005_d18O_1500.jld2", :steelblue
data1 = create_data(file1, :steelblue, :steelblue4, xlims_time_short[1] * 1e3, 1e3)
file2, color2 = "data/paleo_records/hodell-etal_2023_d18O_1500.jld2", :darkorange
data2 = create_data(file2, :darkorange, :darkorange2, xlims_time_short[1] * 1e3, 1e3)
text_c, text_d, text_e = (3.4, c_label), (90, d_label), (90, e_label)

ax = Axis(fig[1, 1], ylabel=ins_label, xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
ylims!(ax, ylims_ins)
xlims!(ax, xlims_time)
hidespines!(ax, :b)
hidexdecorations!(ax)
lines!(ax, data[1][1, :] ./ 1e3, data[1][2, :], color=color, linewidth=6, label=L"Laskar, 2004 (21 June, 65ºN Insolation)$\,$")
text!(ax, -1.48e3, text_a[1], text=text_a[2])
vlines!(ax, vlines_mpt, color=(:grey, 0.2), linestyle=:dash, linewidth=2)

ax = Axis(fig[2, 1], ylabel=periods_label, xgridvisible=false, ygridvisible=false, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = ticks_periods
hidespines!(ax, :b, :t)
hidexdecorations!(ax)
xlims!(ax, xlims_time)
ylims!(ax, ylims_periods)
contourf!(ax, data[1][1, :] ./ 1e3, data[3] ./ 1e3, data[2], colormap=data[4])
vlines!(ax, vlines_mpt, color=(:grey, 0.2), linestyle=:dash, linewidth=2)

# plot_coi!(ax, :grey80, data[1][1, :], 1 ./ data[3], sigma=pi, transparency=0.3, linestyle=:solid)

lines!(ax, data[1][1, :] ./ 1e3, data[1][2, :], color=color, linewidth=6, label=L"Boreal SSI$\,$")
lines!(ax, data1[1][1, :] ./ 1e3, data1[1][2, :] .* 1e3, color=color1, linewidth=6, label=L"Lisiecki and Raymo (2005)$\,$")
lines!(ax, data2[1][1, :] ./ 1e3, data2[1][2, :] .* 1e3, color=color2, linewidth=6, label=L"Hodell et al. (2023)$\,$")
fig[0, 1] = Legend(fig, ax, framevisible=false, labelsize=fontsize, nbanks=3)
text!(ax, -1.48e3, text_b[1], text=text_b[2])

# Panel c
ax = Axis(fig[3, 1], ylabel=d18O_label, xgridvisible=false, ygridvisible=false, yreversed=true)
ax.yticks = (yticks_d18O, convert_strings_to_latex(yticks_d18O))
ax.xticks = xticks_time
xlims!(ax, xlims_time)
hidespines!(ax, :b, :t)
hidexdecorations!(ax)
lines!(ax, data1[1][1, :] ./ 1e3, data1[1][2, :], color=color1, linewidth=6)
lines!(ax, data2[1][1, :] ./ 1e3, data2[1][2, :], color=color2, linewidth=6)

# text!(ax, -1.4e3, 5.2, text=L"40-kyr world$\,$", align=(:center, :center), fontsize=25)
# text!(ax, -1.0e3, 5.2, text=L"The Mid-Pleistocene Transition$\,$", align=(:center, :center), fontsize=25)
# text!(ax, -400, 5.2, text=L"100-kyr world$\,$", align=(:center, :center), fontsize=25)

text!(ax, -1.48e3, text_c[1], text=text_c[2])
vlines!(ax, vlines_mpt, color=(:grey, 0.2), linestyle=:dash, linewidth=2)

# Panel d
ax = Axis(fig[4, 1], ylabel=periods_label, xgridvisible=false, ygridvisible=false, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = ticks_periods
hidespines!(ax, :b, :t)
hidexdecorations!(ax)
xlims!(ax, xlims_time)
ylims!(ax, ylims_periods)
contourf!(ax, data1[1][1, :] ./ 1e3, data1[3] ./ 1e3, data1[2], colormap=data1[4])
# contour!(ax, data1[1][1, :] ./ 1e3, data1[3] ./ 1e3, data1[2], colormap=[:black], linewidth=0.1)
vlines!(ax, vlines_mpt, color=(:grey, 0.2), linestyle=:dash, linewidth=2)
# plot_coi!(ax, :grey80, data1[1][1, :], 1 ./ data1[3], sigma=pi, transparency=0.3, linestyle=:solid)
text!(ax, -1.48e3, text_d[1], text=text_d[2])

# Panel e
ax = Axis(fig[5, 1], ylabel=periods_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = ticks_periods
hidespines!(ax, :t)
xlims!(ax, xlims_time)
ylims!(ax, ylims_periods)
contourf!(ax, data2[1][1, :] ./ 1e3, data2[3] ./ 1e3, data2[2], colormap=data2[4])
# contour!(ax, data2[1][1, :] ./ 1e3, data2[3] ./ 1e3, data2[2], colormap=[:black], linewidth=0.1)
vlines!(ax, vlines_mpt, color=(:grey, 0.2), linestyle=:dash, linewidth=2)
# plot_coi!(ax, :grey80, data2[1][1, :], 1 ./ data2[3], sigma=pi, transparency=0.3, linestyle=:solid)
text!(ax, -1.48e3, text_e[1], text=text_e[2])

# # Panel f
# files = ["data/paleo_records/" .* ["barker-etal_2011.jld2", "hodell-etal_2023_d18O_800.jld2",
#         "lisiecki-raymo_2005_d18O_800.jld2",
#         "luthi-etal_2008.jld2",
#         "spratt-lisiecki_2016.jld2",
#         "bintanja-vandewal_2008_800.jld2"]
#     "data/insolation/" .* ["solstice_insolation_65N170_10yr_5MyrBP-0.jld2"]]
# data = [JLD2.load_object(fi) for fi in files]

# Gvector, Pvector = [], []
# for d in eachindex(data)
#     t, x = data[d][1, :], data[d][2, :]
#     x_trend = sum(x) ./ length(x) .+ (x[end] .- x[1]) ./ (t[end] .- t[1]) .* t
#     G, periods = create_PSD(t, x .- x_trend)

#     push!(Gvector, G)
#     push!(Pvector, periods)
# end

# ax = Axis(fig[4:5, 2], xlabel=periods_label, xgridvisible=false)
# hideydecorations!(ax)
# hidespines!(ax, :l, :r, :t)
# ax.xticks = ticks_periods
# xlims!(ax, (-10, 150))

# lines!(ax, Pvector[end] ./ 1e3, Gvector[end], color=laskar2004color, label=L"Laskar, 2004 (21 June, 65ºN Insolation)$\,$", linewidth=6)
# lines!(ax, Pvector[3] ./ 1e3, Gvector[3], color=lisiecki2005color, label=L"Lisiecki and Raymo , 2005 (δ18O)$\,$", linewidth=6)
# lines!(ax, Pvector[6] ./ 1e3, Gvector[6], color=bintanja2008color, label=L"Bintanja and van de Wal, 2008 (SLE)$\,$", linewidth=6)
# lines!(ax, Pvector[4] ./ 1e3, Gvector[4], color=luthi2008color, label=L"Lüthi et al., 2008 (CO$_2$)$\,$", linewidth=6)
# lines!(ax, Pvector[1] ./ 1e3, Gvector[1], color=barker2011color, label=L"Barker et al., 2011 (GrIS Temperature)$\,$", linewidth=6)
# lines!(ax, Pvector[5] ./ 1e3, Gvector[5], color=spratt2016color, label=L"Spratt and Lisiecki, 2016 (SLE)$\,$", linewidth=6)
# lines!(ax, Pvector[2] ./ 1e3, Gvector[2], color=hodell2023color, label=L"Hodell et al., 2023 (δ18O)$\,$", linewidth=6)
# text!(ax, 100, 0.3, text=L"The 100 kyr problem$\,$", align=(:center, :center), fontsize=25)
# text!(ax, 10, 0.25, text=f_label)
# fig[1:3, 2] = Legend(fig, ax, framevisible=false, titlesize=20, labelsize=30)

rowgap!(fig.layout, 0.0)
rowsize!(fig.layout, 0, Relative(0.05))

#colsize!(fig.layout, 1, Relative(4 / 6))
#colsize!(fig.layout, 2, Relative(2 / 6))
resize_to_layout!(fig)
save("figures/fig01_pleistocene_problems.png", fig)
save("figures/fig01.pdf", fig)
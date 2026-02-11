using Pkg
Pkg.activate(".")
using JLD2, Interpolations, CairoMakie, LaTeXStrings, Colors

include(pwd() *"/scripts/misc/figure_definitions.jl")
include(pwd() * "/scripts/misc/spectral_tools.jl")
include(pwd() * "/scripts/misc/tools.jl")

# Load proxy data and PACCO BASE experiment
include("header.jl")

df = NCDataset("data/runs/exp01/BASE/BASE.nc")
params = JLD2.load_object("data/runs/exp01/BASE/BASE_params.jld2")
xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))

set_theme!(theme_latexfonts())
fontsize=28
fig = Figure(resolution=(1200, 1000), fontsize=fontsize)
linewidth = 2.3

ax = Axis(fig[0, 1])
hidedecorations!(ax)
hidespines!(ax)

# lines!(ax, ruddiman1989sum_sst[1, :] ./ 1e3, ruddiman1989sum_sst[2, :] .* NaN, color=ruddiman1989_color, linewidth=4, label="Ruddiman et al. (1989)")
# lines!(ax, lisiecki2005_d18O[1, :] ./ 1e3, lisiecki2005_d18O[2, :] .* NaN, linewidth=4, color=lisiecki2005_color, label="Lisiecki and Raymo (2005)")
# lines!(ax, barker2011_temp[1, :] ./ 1e3, barker2011_temp[2, :] .* NaN, linewidth=4, color=barker2011color, label="Barker et al. (2011)")
# lines!(ax, mcclymont2008_sst[1, :] ./ 1e3, mcclymont2008_sst[2, :] .* NaN, color=mcclymont2008_color, linewidth=4, label="McClymont et al. (2008)")
lines!(ax, elderfield2012_d18O[1, :] ./ 1e3, elderfield2012_d18O[2, :].* NaN, linewidth=4, color=elderfield2012_color, label="Elderfield et al. (2012)")
# lines!(ax, spratt2016_vol[1, :] ./ 1e3, spratt2016_vol[2, :] .* NaN, linewidth=4, color=spratt2016color, label="Spratt and Lisiecki (2016)")
lines!(ax, herbert2016_sst[1, :] ./ 1e3, herbert2016_sst[2, :] .* NaN, color=herbert2016_color, linewidth=4, label="Herbert et al. (2016)")
lines!(ax, hodell2023_d18O[1, :] ./ 1e3, hodell2023_d18O[2, :] .* NaN, linewidth=5, color=hodell2023_color, label=L"Hodell et al. (2023)$\,$")
lines!(ax, clark2024_sst[1, :] ./ 1e3, clark2024_sst[2, :] .* NaN, color=clark2024_color, linewidth=4, label="Clark et al. (2024)")
lines!(ax, clark2025_d18Osw[1, :] ./ 1e3, clark2025_d18Osw[2, :].* NaN, linewidth=4, color=clark2025_color, label="Clark et al. (2025)")

axislegend(ax, framevisible=false, position=(:center, :center), labelsize=fontsize, nbanks=3)

# Panel a. Air temperature
ax = Axis(fig[1, 1], ylabel=temp_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_temp, convert_strings_to_latex(yticks_temp))
ax.xticks = xticks_time
ylims!(ax, ylims_temp)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -2980, 10, text=a_label, align=(:left, :center))
# lines!(ax, barker2011_temp[1, :] ./ 1e3, barker2011_temp[2, :], linewidth=3, color=barker2011color)
lines!(ax, df["time"] ./ 1e3, df["T"] .- df["Tref"], color=pacco_color, linewidth=linewidth)

ax = Axis(fig[2, 1], ylabel=L"GMT ($\mathrm{^oC}$)", xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = ([-5, 0, 5], convert_strings_to_latex([-5, 0, 5]))
ax.xticks = xticks_time
ylims!(ax, -7, 8)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 6, text=b_label, align=(:left, :center))
lines!(ax, clark2024_temp[1, :] ./ 1e3, clark2024_temp[2, :], color=clark2024_color, linewidth=3)

# Panel b. Sea surface temperature
ax = Axis(fig[3, 1], ylabel=L"SST ($\mathrm{^oC}$)", xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks_time
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :t)
text!(ax, -2980, 0, text=c_label, align=(:left, :center))
# lines!(ax, ruddiman1989sum_sst[1, :] ./ 1e3, ruddiman1989sum_sst[2, :], color=ruddiman1989_color, linewidth=3)
# lines!(ax, ruddiman1989win_sst[1, :] ./ 1e3, ruddiman1989win_sst[2, :], color=ruddiman1989_color, linewidth=3)
# lines!(ax, mcclymont2008_sst[1, :] ./ 1e3, mcclymont2008_sst[2, :], color=mcclymont2008_color, linewidth=3)
lines!(ax, herbert2016_sst[1, :] ./ 1e3, herbert2016_sst[2, :], color=herbert2016_color, linewidth=3)

# ax = Axis(fig[3, 1], ylabel=L"ΔSST ($\mathrm{^oC}$)", xgridvisible=false, ygridvisible=false, yaxisposition=:right)
ax.yticks = ([-3, 0, 3], convert_strings_to_latex([-3, 0, 3]))
# ax.xticks = xticks_time
# xlims!(ax, xlims_time_long)
# hidexdecorations!(ax)
# hidespines!(ax, :t)
lines!(ax, clark2024_sst[1, :] ./ 1e3, clark2024_sst[2, :], color=clark2024_color, linewidth=3)

# # Panel c. Ocean temperature
# ax = Axis(fig[3, 1], ylabel=L"$T_\mathrm{ocn}$ ($\mathrm{^oC}$)", xgridvisible=false, ygridvisible=false, yaxisposition=:right)
# ax.yticks = ([-4, -2, 0], convert_strings_to_latex([-4, -2, 0]))
# ax.xticks = xticks_time
# xlims!(ax, xlims_time_long)
# hidexdecorations!(ax)
# hidespines!(ax, :t)
# text!(ax, -2980, 0, text=c_label, align=(:left, :center))

# Panel c. Ice volume
ax = Axis(fig[4, 1], ylabel=icevol_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_vol, convert_strings_to_latex(yticks_vol))
ax.xticks = xticks_time
ylims!(ax, ylims_vol)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -2980, 25, text=d_label, align=(:left, :center))
lines!(ax, elderfield2012_vol[1, :] ./ 1e3, elderfield2012_vol[2, :], linewidth=2.5, color=elderfield2012_color)
# lines!(ax, spratt2016_vol[1, :] ./ 1e3, spratt2016_vol[2, :], linewidth=2.5, color=spratt2016color)
lines!(ax, df["time"] ./ 1e3, df["Vol"], color=pacco_color, linewidth=linewidth)

# Panel d. d18O
ax = Axis(fig[5, 1], xlabel=time_label, ylabel=d18O_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, yreversed=true)
ax.yticks = ([2.5, 3.5, 4.5], convert_strings_to_latex([2.5, 3.5, 4.5]))
ax.xticks = xticks_time
# ylims!(ax, (5.75, 2.0))
xlims!(ax, xlims_time_long)
hidespines!(ax, :t)
text!(ax, -2980, 2.5, text=e_label, align=(:left, :center))
# lines!(ax, lisiecki2005_d18O[1, :] ./ 1e3, lisiecki2005_d18O[2, :], linewidth=2.5, color=lisiecki2005_color)
lines!(ax, hodell2023_d18O[1, :] ./ 1e3, hodell2023_d18O[2, :], linewidth=2.5, color=hodell2023_color, label=L"Hodell et al. (2023)$\,$")
lines!(ax, clark2025_d18Osw[1, :] ./ 1e3, clark2025_d18Osw[2, :] .+ clark2025_d18OT[2, :], linewidth=2.5, color=clark2025_color)
lines!(ax, elderfield2012_d18O[1, :] ./ 1e3, elderfield2012_d18O[2, :], linewidth=2.5, color=elderfield2012_color)

rowsize!(fig.layout, 0, Relative(0.1))
rowgap!(fig.layout, 0.0)
rowgap!(fig.layout, 4, 10.0)

save("figures/rc1_fig01_BASE.png", fig)
save("figures/rc1_fig01.pdf", fig)

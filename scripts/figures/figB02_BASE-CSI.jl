include("header.jl")

# ===========================================================================================================
# Figure 1. BASE
# ===========================================================================================================
df = NCDataset("data/runs/appendix/BASE-CSI/BASE-CSI.nc")
params = JLD2.load_object("data/runs/appendix/BASE-CSI/BASE-CSI_params.jld2")
xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))
d18Ocolor = :red4

# Plotting
fontsize=28
fig = Figure(resolution=(1500, 1400), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2.3

## Legend
ax = Axis(fig[0, 1])
hidedecorations!(ax)
hidespines!(ax)
# lines!(ax, bintanja2008_temp[1, :] ./ 1e3, bintanja2008_temp[2, :] .* NaN, linewidth=5, color=bintanja2008color, label=L"Bintanja and van de Wal (2008)$\,$")
lines!(ax, barker2011_temp[1, :] ./ 1e3, barker2011_temp[2, :] .* NaN, linewidth=5, color=barker2011color, label=L"Barker et al. (2011)$\,$")
lines!(ax, herbert2016_sst[1, :] ./ 1e3, herbert2016_sst[2, :] .* NaN, color=herbert2016_color, linewidth=5, label=L"Herbert et al. (2016)$\,$")
lines!(ax, clark2024_sst[1, :] ./ 1e3, clark2024_sst[2, :] .* NaN, color=clark2024_color, linewidth=5, label=L"Clark et al. (2024)$\,$")
lines!(ax, luthi2008_co2[1, :] ./ 1e3, luthi2008_co2[2, :] .* NaN, linewidth=5, color=luthi2008color, label=L"Lüthi et al. (2008)$\,$")
# lines!(ax, berends2021_co2[1, :] ./ 1e3, berends2021_co2[2, :] .* NaN, linewidth=5, color=berends2021color, label=L"Berends et al. (2021b)$\,$")
# lines!(ax, yamamoto2022_co2[1, :] ./ 1e3, yamamoto2022_co2[2, :] .* NaN, linewidth=5, color=yamamoto2022color, label=L"Yamamoto et al., 2022$\,$")
lines!(ax, spratt2016_vol[1, :] ./ 1e3, spratt2016_vol[2, :] .* NaN, linewidth=5, color=spratt2016color, label=L"Spratt and Lisiecki (2016)$\,$")
lines!(ax, lisiecki2005_d18O[1, :] ./ 1e3, lisiecki2005_d18O[2, :] .* NaN, linewidth=5, color=d18Ocolor, label=L"Lisiecki and Raymo (2005)$\,$")
# lines!(ax, df["time"] ./ 1e3, df["H"] .* NaN, color=pacco_color, linewidth=5, label=L"PACCO$\,$")
lines!(ax, elderfield2012_d18O[1, :] ./ 1e3, elderfield2012_d18O[2, :].* NaN, linewidth=5, color=elderfield2012_color, label=L"Elderfield et al. (2012)$\,$")
lines!(ax, hodell2023_d18O[1, :] ./ 1e3, hodell2023_d18O[2, :] .* NaN, linewidth=5, color=hodell2023_color, label=L"Hodell et al. (2023)$\,$")
lines!(ax, clark2025_d18Osw[1, :] ./ 1e3, clark2025_d18Osw[2, :].* NaN, linewidth=5, color=clark2025_color, label=L"Clark et al. (2025)$\,$")

axislegend(ax, framevisible=false, position=(:center, :center), labelsize=fontsize, nbanks=3)

# Panel a. Insolation forcing
ax = Axis(fig[1, 1], ylabel=L"E (GJ/m²)$\,$", xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks_time
ax.yticks = ([5.6, 5.8, 6.0], convert_strings_to_latex([5.6, 5.8, 6.0]))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
text!(ax, -2980, 6.1, text=a_label, align=(:left, :center))
lines!(ax, df["time"] ./ 1e3, df["I"] ./ 1e9, color=laskar2004color, linewidth=linewidth)

# Panel b. Climatic Temperature
ax = Axis(fig[2, 1], ylabel=temp_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:right)
ax.yticks = (yticks_temp, convert_strings_to_latex(yticks_temp))
ax.xticks = xticks_time
ylims!(ax, ylims_temp)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -2980, 10, text=b_label, align=(:left, :center))
# hlines!(ax, [0.0], color=background_color, linestyle=:solid)
# lines!(ax, bintanja2008_temp[1, :] ./ 1e3, bintanja2008_temp[2, :], linewidth=3, color=bintanja2008color)
lines!(ax, barker2011_temp[1, :] ./ 1e3, barker2011_temp[2, :], linewidth=3, color=barker2011color)
lines!(ax, df["time"] ./ 1e3, df["T"] .- df["Tref"], color=pacco_color, linewidth=linewidth)

# Panel c. SST
ax = Axis(fig[3, 1], ylabel=L"SST ($\mathrm{^oC}$)", xgridvisible=false, ygridvisible=false, yaxisposition=:right)
ax.yticks = ([-3, 0, 3], convert_strings_to_latex([-3, 0, 3]))
ax.xticks = xticks_time
ylims!(ax, -5, 11)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 9.5, text=c_label, align=(:left, :center))
# hlines!(ax, [0.0], color=background_color, linestyle=:solid)
lines!(ax, herbert2016_sst[1, :] ./ 1e3, herbert2016_sst[2, :], color=herbert2016_color, linewidth=3)
lines!(ax, clark2024_sst[1, :] ./ 1e3, clark2024_sst[2, :], color=clark2024_color, linewidth=3)

# Panel d. Carbon dioxide
ax = Axis(fig[4, 1], ylabel=carbon_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_carbon, convert_strings_to_latex(yticks_carbon))
ax.xticks = xticks_time
ylims!(ax, 150, 330)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
# hlines!(ax, [params.Cref], color=background_color, linestyle=:solid)
# lines!(ax, berends2021_co2[1, :] ./ 1e3, berends2021_co2[2, :], linewidth=3, color=berends2021color)
# lines!(ax, yamamoto2022_co2[1, :] ./ 1e3, yamamoto2022_co2[2, :], linewidth=3, color=yamamoto2022color)
lines!(ax, luthi2008_co2[1, :] ./ 1e3, luthi2008_co2[2, :], linewidth=3, color=luthi2008color)
lines!(ax, df["time"] ./ 1e3, df["C"], color=pacco_color, linewidth=linewidth)
text!(ax, -2980, 315, text=d_label, align=(:left, :center))

# Panel e. Ice thickness
ax = Axis(fig[5, 1], ylabel=icethick_label, xgridvisible=false, ygridvisible=false, yaxisposition=:right)
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ax.xticks = xticks_time
ylims!(ax, ylims_ice)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
# hlines!(ax, [0.0], color=background_color, linestyle=:solid)
text!(ax, -2980, 2000, text=e_label, align=(:left, :center))
lines!(ax, df["time"] ./ 1e3, df["H"], color=pacco_color, linewidth=linewidth)

# Panel f. Sediments
ax = Axis(fig[6, 1], ylabel=sed_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_sed, convert_strings_to_latex(yticks_sed))
ax.xticks = xticks_time
ylims!(ax, ylims_sed)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :t)
# hlines!(ax, [0.0], color=background_color, linestyle=:solid)
text!(ax, -2980, 22, text=f_label, align=(:left, :center))
lines!(ax, df["time"] ./ 1e3, df["Hsed"], color=pacco_color, linewidth=linewidth)

# Panel g. d18O
ax = Axis(fig[7, 1], ylabel=d18O_label, xgridvisible=false, ygridvisible=false, yaxisposition=:right, yreversed=true)#,
          #ylabelcolor=d18Ocolor, leftspinecolor=d18Ocolor, yticklabelcolor=d18Ocolor, ytickcolor=d18Ocolor)
ax.yticks = ([2.5, 3.5, 4.5], convert_strings_to_latex([2.5, 3.5, 4.5]))
ax.xticks = xticks_time
hidexdecorations!(ax)
hidespines!(ax, :b)
ylims!(ax, (5.75, 2.0))
xlims!(ax, xlims_time_long)
# hlines!(ax, lisiecki2005_d18O[2, end], color=background_color, linestyle=:solid)
lines!(ax, lisiecki2005_d18O[1, :] ./ 1e3, lisiecki2005_d18O[2, :], linewidth=3, color=d18Ocolor)
lines!(ax, hodell2023_d18O[1, :] ./ 1e3, hodell2023_d18O[2, :], linewidth=3, color=hodell2023_color, label=L"Hodell et al. (2023)$\,$")
lines!(ax, clark2025_d18Osw[1, :] ./ 1e3, clark2025_d18Osw[2, :] .+ clark2025_d18OT[2, :], linewidth=3, color=clark2025_color)
lines!(ax, elderfield2012_d18O[1, :] ./ 1e3, elderfield2012_d18O[2, :], linewidth=3, color=elderfield2012_color)
text!(ax, -2980, 2.5, text=g_label, align=(:left, :center))

# Panel h. Ice volume
ax = Axis(fig[8, 1], ylabel=icevol_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_vol, convert_strings_to_latex(yticks_vol))
ax.xticks = xticks_time
# ylims!(ax, ylims_vol)
xlims!(ax, xlims_time_long)
hidespines!(ax, :t)
# hlines!(ax, [0.0], color=background_color, linestyle=:solid)
text!(ax, -2980, 40, text=h_label, align=(:left, :center))
# lines!(ax, bintanja2008_vol[1, :] ./ 1e3, bintanja2008_vol[2, :], linewidth=2.5, color=bintanja2008color)
# lines!(ax, berends2021_vol[1, :] ./ 1e3, berends2021_vol[2, :], linewidth=2.5, color=berends2021color)
lines!(ax, elderfield2012_vol[1, :] ./ 1e3, elderfield2012_vol[2, :], linewidth=2.5, color=elderfield2012_color)
lines!(ax, spratt2016_vol[1, :] ./ 1e3, spratt2016_vol[2, :], linewidth=2.5, color=spratt2016color)
lines!(ax, df["time"] ./ 1e3, df["Vol"], color=pacco_color, linewidth=linewidth)

rowsize!(fig.layout, 0, Relative(0.1))
rowgap!(fig.layout, 0.0)
rowgap!(fig.layout, 2, 10.0)
rowgap!(fig.layout, 7, 10.0)

save("figures/figB02_BASE-CSI.png", fig)
save("figures/figB02.pdf", fig)
include("header.jl")

# ===========================================================================================================
# Figure 1. BASE
# ===========================================================================================================
df = NCDataset("data/runs/exp01/BASE/BASE.nc")
params = JLD2.load_object("data/runs/exp01/BASE/BASE_params.jld2")
xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))
d18Ocolor = :red4

# Plotting
fontsize=28
fig = Figure(resolution=(1500, 1200), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2.3

## Legend
ax = Axis(fig[0, 1])
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, bintanja2008_temp[1, :] ./ 1e3, bintanja2008_temp[2, :] .* NaN, linewidth=5, color=bintanja2008color, label=L"Bintanja and van de Wal, 2008$\,$")
lines!(ax, barker2011_temp[1, :] ./ 1e3, barker2011_temp[2, :] .* NaN, linewidth=5, color=barker2011color, label=L"Barker et al., 2011$\,$")
lines!(ax, luthi2008_co2[1, :] ./ 1e3, luthi2008_co2[2, :] .* NaN, linewidth=5, color=luthi2008color, label=L"Lüthi et al., 2008$\,$")
lines!(ax, berends2021_co2[1, :] ./ 1e3, berends2021_co2[2, :] .* NaN, linewidth=5, color=berends2021color, label=L"Berends et al., 2020$\,$")
# lines!(ax, yamamoto2022_co2[1, :] ./ 1e3, yamamoto2022_co2[2, :] .* NaN, linewidth=5, color=yamamoto2022color, label=L"Yamamoto et al., 2022$\,$")
lines!(ax, spratt2016_vol[1, :] ./ 1e3, spratt2016_vol[2, :] .* NaN, linewidth=5, color=spratt2016color, label=L"Spratt and Lisiecki, 2016$\,$")
lines!(ax, lisiecki2005_d18O[1, :] ./ 1e3, lisiecki2005_d18O[2, :] .* NaN, linewidth=5, color=d18Ocolor, label=L"Lisiecki and Raymo, 2005$\,$")
# lines!(ax, df["time"] ./ 1e3, df["H"] .* NaN, color=pacco_color, linewidth=5, label=L"PACCO$\,$")
axislegend(ax, framevisible=false, position=(:center, :center), labelsize=fontsize, nbanks=3)

# Panel a. Insolation forcing
ax = Axis(fig[1, 1], ylabel=ins_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks_time
ax.yticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
ylims!(ax, ylims_ins)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
text!(ax, -2980, 560, text=a_label, align=(:left, :center))
hlines!(ax, [params.insol_ref], color=background_color, linestyle=:solid)
lines!(ax, df["time"] ./ 1e3, df["I"], color=laskar2004color, linewidth=linewidth)

# Panel b. Climatic Temperature
ax = Axis(fig[2, 1], ylabel=temp_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:right)
ax.yticks = (yticks_temp, convert_strings_to_latex(yticks_temp))
ax.xticks = xticks_time
ylims!(ax, ylims_temp)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -2980, 10, text=b_label, align=(:left, :center))
hlines!(ax, [0.0], color=background_color, linestyle=:solid)
lines!(ax, bintanja2008_temp[1, :] ./ 1e3, bintanja2008_temp[2, :], linewidth=3, color=bintanja2008color)
lines!(ax, barker2011_temp[1, :] ./ 1e3, barker2011_temp[2, :], linewidth=3, color=barker2011color)
lines!(ax, df["time"] ./ 1e3, df["T"] .- df["Tref"], color=pacco_color, linewidth=linewidth)

# Panel c. Carbon dioxide
ax = Axis(fig[3, 1], ylabel=carbon_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_carbon, convert_strings_to_latex(yticks_carbon))
ax.xticks = xticks_time
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
hlines!(ax, [params.Cref], color=background_color, linestyle=:solid)
lines!(ax, berends2021_co2[1, :] ./ 1e3, berends2021_co2[2, :], linewidth=3, color=berends2021color)
# lines!(ax, yamamoto2022_co2[1, :] ./ 1e3, yamamoto2022_co2[2, :], linewidth=3, color=yamamoto2022color)
lines!(ax, luthi2008_co2[1, :] ./ 1e3, luthi2008_co2[2, :], linewidth=3, color=luthi2008color)
lines!(ax, df["time"] ./ 1e3, df["C"], color=pacco_color, linewidth=linewidth)
text!(ax, -2980, 320, text=c_label, align=(:left, :center))

# Panel d. Ice thickness
ax = Axis(fig[4, 1], ylabel=icethick_label, xgridvisible=false, ygridvisible=false, yaxisposition=:right)
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ax.xticks = xticks_time
ylims!(ax, ylims_ice)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
hlines!(ax, [0.0], color=background_color, linestyle=:solid)
text!(ax, -2980, 2000, text=d_label, align=(:left, :center))
lines!(ax, df["time"] ./ 1e3, df["H"], color=pacco_color, linewidth=linewidth)

# Panel e. Sediments
ax = Axis(fig[5, 1], ylabel=sed_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_sed, convert_strings_to_latex(yticks_sed))
ax.xticks = xticks_time
ylims!(ax, ylims_sed)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :t)
hlines!(ax, [0.0], color=background_color, linestyle=:solid)
text!(ax, -2980, 22, text=e_label, align=(:left, :center))
lines!(ax, df["time"] ./ 1e3, df["Hsed"], color=pacco_color, linewidth=linewidth)

# Panel f. Ice volume
ax = Axis(fig[6, 1], ylabel=d18O_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, yreversed=true,
          ylabelcolor=d18Ocolor, leftspinecolor=d18Ocolor, yticklabelcolor=d18Ocolor, ytickcolor=d18Ocolor)
ax.yticks = ([2.5, 3.5, 4.5], convert_strings_to_latex([2.5, 3.5, 4.5]))
ax.xticks = xticks_time
ylims!(ax, (5.75, 2.0))
xlims!(ax, xlims_time_long)
hlines!(ax, lisiecki2005_d18O[2, end], color=background_color, linestyle=:solid)
lines!(ax, lisiecki2005_d18O[1, :] ./ 1e3, lisiecki2005_d18O[2, :], linewidth=4, color=d18Ocolor)

ax = Axis(fig[6, 1], ylabel=icevol_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:right)
ax.yticks = (yticks_vol, convert_strings_to_latex(yticks_vol))
ax.xticks = xticks_time
ylims!(ax, ylims_vol)
xlims!(ax, xlims_time_long)
hidespines!(ax, :l)
hlines!(ax, [0.0], color=background_color, linestyle=:solid)
text!(ax, -2980, 25, text=f_label, align=(:left, :center))
lines!(ax, bintanja2008_vol[1, :] ./ 1e3, bintanja2008_vol[2, :], linewidth=2.5, color=bintanja2008color)
lines!(ax, berends2021_vol[1, :] ./ 1e3, berends2021_vol[2, :], linewidth=2.5, color=berends2021color)
lines!(ax, spratt2016_vol[1, :] ./ 1e3, spratt2016_vol[2, :], linewidth=2.5, color=spratt2016color)
lines!(ax, df["time"] ./ 1e3, df["Vol"], color=pacco_color, linewidth=linewidth)

rowsize!(fig.layout, 0, Relative(0.1))
rowgap!(fig.layout, 0.0)
rowgap!(fig.layout, 2, 10.0)
rowgap!(fig.layout, 6, 10.0)

save("figures/fig04_BASE.png", fig)
save("figures/fig04.pdf", fig)
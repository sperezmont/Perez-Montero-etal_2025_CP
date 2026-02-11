include("header.jl")

# ===========================================================================================================
# Figure 13. NOSEDIM
# ===========================================================================================================
df_base = NCDataset("data/runs/exp01/BASE/BASE.nc")
df_nosedim01, df_nosedim02 = NCDataset("data/runs/exp05/NOSEDIM/NOSEDIM01.nc"), NCDataset("data/runs/exp05/NOSEDIM/NOSEDIM02.nc")
xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))

# Plot
set_theme!(theme_latexfonts())
fontsize=28
fig = Figure(resolution=(1500, 400), fontsize=fontsize)
linewidth = 2.3

ax = Axis(fig[0, 1])
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, df_nosedim02["time"][:] ./ 1e3, df_nosedim02["H"][:] .* NaN, color=:darkorange, linewidth=5, label="High sliding")
band!(ax, df_base["time"][:] ./ 1e3, 0.0, df_base["H"][:] .* NaN, color=:grey80, label="Dynamic sliding (BASE)")
lines!(ax, df_nosedim01["time"][:] ./ 1e3, df_nosedim01["H"][:] .* NaN, color=:royalblue, linewidth=5, label="Low sliding")
axislegend(ax, framevisible=false, position=(:center, :center), labelsize=fontsize, nbanks=3)

ax = Axis(fig[1, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, (-100, 2500))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -2980, 2200, text=a_label, align=(:left, :center))
band!(ax, df_base["time"][:] ./ 1e3, 0.0, df_base["H"][:], color=:grey80)
lines!(ax, df_nosedim02["time"][:] ./ 1e3, df_nosedim02["H"][:], color=:darkorange, linewidth=2)
lines!(ax, df_nosedim01["time"][:] ./ 1e3, df_nosedim01["H"][:], color=:royalblue, linewidth=2)

ax = Axis(fig[2, 1], ylabel=v_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = ([0, 10, 100], convert_strings_to_latex([0, 10, 100]))
ylims!(ax, (0, 2000))
xlims!(ax, xlims_time_long)
hidespines!(ax, :t)
text!(ax, -2980, 800, text=b_label, align=(:left, :center))
band!(ax, df_base["time"][:] ./ 1e3, 0.0, df_base["v"][:], color=:grey80)
lines!(ax, df_nosedim02["time"][:] ./ 1e3, df_nosedim02["v"][:], color=:darkorange, linewidth=2)
lines!(ax, df_nosedim01["time"][:] ./ 1e3, df_nosedim01["v"][:], color=:royalblue, linewidth=2)

rowsize!(fig.layout, 0, Relative(0.1))
rowgap!(fig.layout, 0.0)

save("figures/fig13_NOSEDIM.png", fig)
save("figures/fig13.pdf", fig)
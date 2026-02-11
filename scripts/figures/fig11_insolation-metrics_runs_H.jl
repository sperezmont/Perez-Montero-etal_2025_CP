include("header.jl")

# ===========================================================================================================
# insolation metrics, comparison between power spectral in runs
# ===========================================================================================================
df_base = NCDataset("data/runs/exp01/BASE/BASE.nc")
params_base = JLD2.load_object("data/runs/exp01/BASE/BASE_params.jld2")

df_csi = NCDataset("data/runs/exp04/INSOL/INSOL-CSI.nc")
params_csi = JLD2.load_object("data/runs/exp04/INSOL/INSOL-CSI_params.jld2")

df_isi275 = NCDataset("data/runs/exp04/INSOL/INSOL-ISI275.nc")
params_isi275 = JLD2.load_object("data/runs/exp04/INSOL/INSOL-ISI275_params.jld2")

df_isi300 = NCDataset("data/runs/exp04/INSOL/INSOL-ISI300.nc")
params_isi300 = JLD2.load_object("data/runs/exp04/INSOL/INSOL-ISI300_params.jld2")

df_isi400 = NCDataset("data/runs/exp04/INSOL/INSOL-ISI400.nc")
params_isi400 = JLD2.load_object("data/runs/exp04/INSOL/INSOL-ISI400_params.jld2")

# df_isi0 = NCDataset("data/runs/exp04/INSOL/INSOL-ISI0.nc")
# params_isi0 = JLD2.load_object("data/runs/exp04/INSOL/INSOL-ISI0_params.jld2")

xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))
sed_thr=6

# Plotting
fontsize=28
fig = Figure(resolution=(1500, 1000), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2
levels = 0:0.02:0.2

data = [df_base, df_csi, df_isi400, df_isi300, df_isi275]
colors = [pacco_color, :violetred4, :blueviolet, :yellowgreen, :cornflowerblue, :orangered]
labels = [L"SSI (BASE)$\,$", L"CSI$\,$", L"ISI (400 $\mathrm{W~m^{-2}}$)$\,$", L"ISI (300 $\mathrm{W~m^{-2}}$)$\,$", L"ISI (275 $\mathrm{W~m^{-2}}$)$\,$", L"ISI (0 $\mathrm{W~m^{-2}}$)$\,$"]
widthi = [7, 4, 4, 4, 4, 4]

# ax = Axis(fig[0, 1])
# hidedecorations!(ax)
# hidespines!(ax)
# lines!(ax, df_base["time"] ./ 1e3, df_base["H"] .* NaN, color=colors[1], linewidth=5, label=labels[1])
# lines!(ax, df_csi["time"] ./ 1e3, df_csi["H"] .* NaN, color=colors[2], linewidth=5, label=labels[2])
# lines!(ax, df_isi0["time"] ./ 1e3, df_isi0["H"] .* NaN, color=colors[3], linewidth=5, label=labels[6])
# lines!(ax, df_isi275["time"] ./ 1e3, df_isi275["H"] .* NaN, color=colors[4], linewidth=5, label=labels[5])
# lines!(ax, df_isi400["time"] ./ 1e3, df_isi400["H"] .* NaN, color=colors[5], linewidth=5, label=labels[3])
# lines!(ax, df_isi300["time"] ./ 1e3, df_isi300["H"] .* NaN, color=colors[6], linewidth=5, label=labels[4])
# axislegend(ax, framevisible=false, position=(:center, :center), labelsize=fontsize, patchsize=(20, 80), nbanks=6)

# Panel a.
ax = Axis(fig[1, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false)#, xaxisposition=:top)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, (-10, 3000))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -2980, 2200, text=L"(a)$\,$", align=(:left, :center))
hlines!(ax, 0.0, color=background_color, linestyle=:solid)
# lines!(ax, bintanja2008_vol[1, :] ./ 1e3, bintanja2008_vol[2, :], linewidth=3, color=bintanja2008color, label=L"Bintanja and van de Wal, 2008$\,$")
# lines!(ax, spratt2016_vol[1, :] ./ 1e3, spratt2016_vol[2, :], linewidth=3, color=spratt2016color, label=L"Spratt and Lisiecki, 2016$\,$")
lines!(ax, df_base["time"] ./ 1e3, df_base["H"], color=colors[1], linewidth=3, label=labels[1])

mpt_occurs_at = df_base["time"][findfirst(df_base["Hsed"] .<= sed_thr)] ./ 1e3
vlines!(ax, mpt_occurs_at, color=colors[1], linestyle=:dash)

axislegend(ax, framevisible=false, position=(1.0, 1.1), labelsize=fontsize, patchsize=(20, 80), nbanks=1)

# Panel b.
ax = Axis(fig[2, 1], ylabel=icethick_label, xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, (-10, 3000))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 2200, text=L"(b) $\,$", align=(:left, :center))
hlines!(ax, 0.0, color=background_color, linestyle=:solid)

# lines!(ax, bintanja2008_vol[1, :] ./ 1e3, bintanja2008_vol[2, :], linewidth=3, color=bintanja2008color)
# lines!(ax, spratt2016_vol[1, :] ./ 1e3, spratt2016_vol[2, :], linewidth=3, color=spratt2016color)

lines!(ax, df_csi["time"] ./ 1e3, df_csi["H"], color=colors[2], linewidth=3, label=labels[2])

mpt_occurs_at = df_csi["time"][findfirst(df_csi["Hsed"] .<= sed_thr)] ./ 1e3
vlines!(ax, mpt_occurs_at, color=colors[2], linestyle=:dash)

axislegend(ax, framevisible=false, position=(1.0, 1.1), labelsize=fontsize, patchsize=(20, 80), nbanks=1)

# Panel c.
ax = Axis(fig[3, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, (-10, 3000))
xlims!(ax, xlims_time_long)
#hidexdecorations!(ax)
hidespines!(ax, :t)
text!(ax, -2980, 2200, text=L"(c) $\,$", align=(:left, :center))
hlines!(ax, 0.0, color=background_color, linestyle=:solid)

# lines!(ax, bintanja2008_vol[1, :] ./ 1e3, bintanja2008_vol[2, :], linewidth=3, color=bintanja2008color)
# lines!(ax, spratt2016_vol[1, :] ./ 1e3, spratt2016_vol[2, :], linewidth=3, color=spratt2016color)

lines!(ax, df_isi400["time"] ./ 1e3, df_isi400["H"], color=colors[5], linewidth=5, label=labels[3])
lines!(ax, df_isi300["time"] ./ 1e3, df_isi300["H"], color=colors[6], linewidth=4, label=labels[4])
lines!(ax, df_isi275["time"] ./ 1e3, df_isi275["H"], color=colors[4], linewidth=3, label=labels[5])

mpt_occurs_at = df_isi400["time"][findfirst(df_isi400["Hsed"] .<= sed_thr)] ./ 1e3
vlines!(ax, mpt_occurs_at, color=colors[5], linestyle=:dash)
mpt_occurs_at = df_isi300["time"][findfirst(df_isi300["Hsed"] .<= sed_thr)] ./ 1e3
vlines!(ax, mpt_occurs_at, color=colors[6], linestyle=:dash)
mpt_occurs_at = df_isi275["time"][findfirst(df_isi275["Hsed"] .<= sed_thr)] ./ 1e3
vlines!(ax, mpt_occurs_at, color=colors[4], linestyle=:dash)

axislegend(ax, framevisible=false, position=(1.0, 1.1), labelsize=fontsize, patchsize=(20, 80), nbanks=3)

rowgap!(fig.layout, 0.0)
# rowsize!(fig.layout, 0, Relative(0.05))
save("figures/fig11_insolation_metrics_H.png", fig)
save("figures/fig11.pdf", fig)
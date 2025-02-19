include("header.jl")

function add_wavelet!(axis, t, x, color, width, func, plevels=0:0.02:0.2)
    W, periods = create_WV(t, x)
    # maxW = findmax(W, dims=2)[2]
    # ymaxW = [periods[maxW[i][2]] for i in eachindex(maxW)]
    # scatter!(axis, data["time"][:] ./ 1e3, ymaxW ./ 1e3, markersize=width, color=color)
    func(ax, t ./ 1e3, periods ./ 1e3, W, colormap=cgrad([:white, color], 11, categorical=true), levels=plevels)

    return nothing
end

# ===========================================================================================================
# insolation metrics, comparison between power spectral in metrics
# ===========================================================================================================
# Load and process data
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

df_isi0 = NCDataset("data/runs/exp04/INSOL/INSOL-ISI0.nc")
params_isi0 = JLD2.load_object("data/runs/exp04/INSOL/INSOL-ISI0_params.jld2")

# Plot
fontsize=28
plevels=0:0.02:0.2
xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))
fig = Figure(resolution=(1500, 1800), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2
colors = [pacco_color, :violetred4, :blueviolet, :yellowgreen, :cadetblue, :orangered]

# Panel SSI
ax = Axis(fig[1, 1], ylabel=icethick_label, xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, ylims_ice)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -2980, 1900, text=L"(a) SSI$\,$", align=(:left, :center))
lines!(ax, df_base["time"][:] ./ 1e3, df_base["H"][:], color=colors[1], linewidth=3, label=L"SSI$\,$")

ax = Axis(fig[2, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, ylims_periods)
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
add_wavelet!(ax, df_base["time"][:], df_base["H"][:], colors[1], 8, contourf!, plevels)
hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)

# Panel CSI
ax = Axis(fig[3, 1], ylabel=icethick_label, xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
xlims!(ax, xlims_time_long)
ylims!(ax, ylims_ice)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 1900, text=L"(b) CSI$\,$", align=(:left, :center))
lines!(ax, df_csi["time"][:] ./ 1e3, df_csi["H"][:] , color=colors[2], linewidth=3, label=L"CSI$\,$")

ax = Axis(fig[4, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, ylims_periods)
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
add_wavelet!(ax, df_csi["time"][:], df_csi["H"][:], colors[2], 6, contourf!, plevels)
hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)

# Panel ISI0
ax = Axis(fig[5, 1], ylabel=icethick_label, xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, ylims_ice)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 1900, text=L"(c) ISI0$\,$", align=(:left, :center))
lines!(ax, df_isi0["time"][:] ./ 1e3, df_isi0["H"][:] , color=colors[3], linewidth=3, label=L"ISI0$\,$")
# axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=2)

ax = Axis(fig[6, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, ylims_periods)
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
add_wavelet!(ax, df_isi0["time"][:], df_isi0["H"][:], colors[3], 5, contourf!, plevels)
hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)

# Panel ISI300
ax = Axis(fig[7, 1], ylabel=icethick_label, xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, ylims_ice)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 1900, text=L"(d) ISI300$\,$", align=(:left, :center))
lines!(ax, df_isi300["time"][:] ./ 1e3, df_isi300["H"][:] , color=colors[6], linewidth=3, label=L"ISI300$\,$")

# axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=3)

ax = Axis(fig[8, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, ylims_periods)
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
add_wavelet!(ax, df_isi300["time"][:], df_isi300["H"][:], colors[6], 4, contourf!, plevels)
hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)

# Panel ISI275
ax = Axis(fig[9, 1], ylabel=icethick_label, xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, ylims_ice)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 1900, text=L"(d) ISI275$\,$", align=(:left, :center))

lines!(ax, df_isi275["time"][:] ./ 1e3, df_isi275["H"][:] , color=colors[4], linewidth=3, label=L"ISI275$\,$")

# axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=3)

ax = Axis(fig[10, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, ylims_periods)
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
add_wavelet!(ax, df_isi275["time"][:], df_isi275["H"][:], colors[4], 3, contourf!, plevels)
hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)

# Panel e. ISI400 
ax = Axis(fig[11, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, ylims_ice)
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
text!(ax, -2980, 1900, text=L"(e) ISI400$\,$", align=(:left, :center))
lines!(ax, df_isi400["time"][:] ./ 1e3, df_isi400["H"][:] , color=colors[5], linewidth=3, label=L"ISI400$\,$")
# axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=3)

ax = Axis(fig[12, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, ylims_periods)
xlims!(ax, xlims_time_long)
hidespines!(ax, :t)
add_wavelet!(ax, df_isi400["time"][:], df_isi400["H"][:], colors[5], 2, contourf!, plevels)
hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)

rowgap!(fig.layout, 0.0)

save("figures/figB02_insolation_metrics_H_power.png", fig)
save("figures/figB02.pdf", fig)
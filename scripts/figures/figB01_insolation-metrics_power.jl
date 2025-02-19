include("header.jl")

function add_wavelet!(axis, data, color, width, func, plevels=0:0.02:0.2)
    W, periods = create_WV(data[1, :], data[2, :])
    # maxW = findmax(W, dims=2)[2]
    # ymaxW = [periods[maxW[i][2]] for i in eachindex(maxW)]
    # scatter!(axis, data[1, :] ./ 1e3, ymaxW ./ 1e3, markersize=width, color=color)
    func(ax, data[1, :] ./ 1e3, periods ./ 1e3, W, colormap=cgrad([:white, color], 11, categorical=true), levels=plevels)

    return nothing
end

# ===========================================================================================================
# insolation metrics, comparison between power spectral in metrics
# ===========================================================================================================
# Load and process data
ssi = JLD2.load_object("data/insolation/solstice_insolation_65N170_10yr_5MyrBP-0.jld2")
newt, newx = interp_time_series(ssi[1, :], ssi[2, :], -3e6, 0, 1000)
ssi = [newt newx]'

csi = JLD2.load_object("data/insolation/caloric_insolation_65N_10yr_5MyrBP-0.jld2")
newt, newx = interp_time_series(csi[1, :], csi[2, :], -3e6, 0, 1000)
csi = [newt newx]'

isi400 = JLD2.load_object("data/insolation/ISI400_65N_10yr_5MyrBP-0.jld2")
newt, newx = interp_time_series(isi400[1, :], isi400[2, :], -3e6, 0, 1000)
isi400 = [newt newx]'

isi300 = JLD2.load_object("data/insolation/ISI300_65N_10yr_5MyrBP-0.jld2")
newt, newx = interp_time_series(isi300[1, :], isi300[2, :], -3e6, 0, 1000)
isi300 = [newt newx]'

isi275 = JLD2.load_object("data/insolation/ISI275_65N_10yr_5MyrBP-0.jld2")
newt, newx = interp_time_series(isi275[1, :], isi275[2, :], -3e6, 0, 1000)
isi275 = [newt newx]'

isi0 = JLD2.load_object("data/insolation/ISI0_65N_10yr_5MyrBP-0.jld2")
newt, newx = interp_time_series(isi0[1, :], isi0[2, :], -3e6, 0, 1000)
isi0 = [newt newx]'

# Plot
fontsize=28
plevels=0:0.02:0.2
xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))
fig = Figure(resolution=(1500, 1600), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2
colors = [pacco_color, :violetred4, :blueviolet, :yellowgreen, :cadetblue, :orangered]

# Panel SSI
ax = Axis(fig[1, 1], ylabel=L"I (W/m²)$\,$", xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
ylims!(ax, ylims_ins)
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -2980, 560, text=L"(a) SSI$\,$", align=(:left, :center))
lines!(ax, ssi[1, :] ./ 1e3, ssi[2, :], color=colors[1], linewidth=3, label=L"SSI$\,$")
hlines!(ax, ssi[2, end], color=:grey, linestyle=:dash)

ax = Axis(fig[2, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, (10, 70))
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
add_wavelet!(ax, ssi, colors[1], 8, contourf!, plevels)

# Panel CSI
ax = Axis(fig[3, 1], ylabel=L"E (GJ/m²)$\,$", xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = ([5.6, 5.8, 6.0], convert_strings_to_latex([5.6, 5.8, 6.0]))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 6.1, text=L"(b) CSI$\,$", align=(:left, :center))
lines!(ax, csi[1, :] ./ 1e3, csi[2, :] ./ 1e9, color=colors[2], linewidth=3, label=L"CSI$\,$")
hlines!(ax, csi[2, end] ./ 1e9, color=:grey, linestyle=:dash)

ax = Axis(fig[4, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, (10, 70))
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
add_wavelet!(ax, csi, colors[2], 6, contourf!, plevels)

# Panel ISI0
ax = Axis(fig[5, 1], ylabel=L"E (GJ/m²)$\,$", xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = ([6.65, 6.75, 6.85], convert_strings_to_latex([6.65, 6.75, 6.85]))
ylims!(ax, (6.6, 6.95))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 6.85, text=L"(c) ISI0$\,$", align=(:left, :center))
lines!(ax, isi0[1, :] ./ 1e3, isi0[2, :] ./ 1e9, color=colors[3], linewidth=3, label=L"ISI0$\,$")
# axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=2)
hlines!(ax, isi0[2, end] ./ 1e9, color=:grey, linestyle=:dash)

ax = Axis(fig[6, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, (10, 70))
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
add_wavelet!(ax, isi0, colors[3], 5, contourf!, plevels)

# Panel ISI300
ax = Axis(fig[7, 1], ylabel=L"E (GJ/m²)$\,$", xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = ([4.4, 4.8, 5.2], convert_strings_to_latex([4.4, 4.8, 5.2]))
ylims!(ax, (4.2, 5.5))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 5.3, text=L"(d) ISI300$\,$", align=(:left, :center))
lines!(ax, isi300[1, :] ./ 1e3, isi300[2, :] ./ 1e9, color=colors[6], linewidth=3, label=L"ISI300$\,$")
hlines!(ax, isi300[2, end] ./ 1e9, color=:grey, linestyle=:dash)

# axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=3)

ax = Axis(fig[8, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, (10, 70))
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
add_wavelet!(ax, isi300, colors[6], 4, contourf!, plevels)

# Panel ISI275
ax = Axis(fig[9, 1], ylabel=L"E (GJ/m²)$\,$", xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = ([4.4, 4.8, 5.2], convert_strings_to_latex([4.4, 4.8, 5.2]))
ylims!(ax, (4.2, 5.5))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)
text!(ax, -2980, 5.3, text=L"(d) ISI275$\,$", align=(:left, :center))

lines!(ax, isi275[1, :] ./ 1e3, isi275[2, :] ./ 1e9, color=colors[4], linewidth=3, label=L"ISI275$\,$")
hlines!(ax, isi275[2, end] ./ 1e9, color=:grey, linestyle=:dash)

# axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=3)

ax = Axis(fig[10, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, (10, 70))
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
add_wavelet!(ax, isi275, colors[4], 3, contourf!, plevels)

# Panel e. ISI400 
ax = Axis(fig[11, 1], ylabel=L"E (GJ/m²)$\,$", xlabel=time_label, xgridvisible=false, ygridvisible=false)
ax.xticks = xticks_time
ax.yticks = ([2.5, 3, 3.5, 4], convert_strings_to_latex([2.5, 3, 3.5, 4]))
ylims!(ax, (2.0, 4.5))
xlims!(ax, xlims_time_long)
hidespines!(ax, :t, :b)
hidexdecorations!(ax)
text!(ax, -2980, 4, text=L"(e) ISI400$\,$", align=(:left, :center))
lines!(ax, isi400[1, :] ./ 1e3, isi400[2, :] ./ 1e9, color=colors[5], linewidth=3, label=L"ISI400$\,$")
# axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=3)
hlines!(ax, isi400[2, end] ./ 1e9, color=:grey, linestyle=:dash)

ax = Axis(fig[12, 1], xlabel=time_label, ylabel=L"$P$ (kyr)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, (10, 70))
xlims!(ax, xlims_time_long)
hidespines!(ax, :t)
add_wavelet!(ax, isi400, colors[5], 2, contourf!, plevels)



rowgap!(fig.layout, 0.0)

save("figures/figB01_7_insolation_metrics_power.png", fig)
save("figures/figB01.pdf", fig)
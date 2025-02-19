include("header.jl")

# ===========================================================================================================
# rem-gen time series
# ===========================================================================================================
quarryings = vcat(5:0.1:9, 10:1:100) .* 1e-8     # 5e-8 to 1e-6
weatherings = vcat(0.1:0.05:0.9, 1:0.5:9, 10:5:90, 100:50:1000) .* 1e-6   # 1e-7 to 1e-3  

sed_thr=6

df_base = NCDataset("data/runs/exp01/BASE/BASE.nc")                      # quarrying_frac = 1.4e-7; weathering_frac = 3.0e-5
params_base = JLD2.load_object("data/runs/exp01/BASE/BASE_params.jld2")
mpt_occurs_at = df_base["time"][findfirst(df_base["Hsed"] .<= sed_thr)] ./ 1e3

quarryings_selected, quarryings_idx = params_base.quarrying_frac, findmin(abs.(params_base.quarrying_frac .- quarryings))[2]
weatherings_selected, weatherings_idx = params_base.weathering_frac, findmin(abs.(params_base.weathering_frac .- weatherings))[2]

non_phys_meaning_weatherings = 54   # HARDCODED according to the results (NON AUTOMATIC!)
non_phys_meaning_quarryings = length(quarryings) # HARDCODED according to the results (NON AUTOMATIC!)

runs2plot_weatherings = eachindex(weatherings)[1:5:non_phys_meaning_weatherings]
runs2plot_quarryings = eachindex(quarryings)[1:5:non_phys_meaning_quarryings]

colors = [:midnightblue, :darkslateblue, :lightslateblue, :orange, :darkorange2, :orangered3]
colormap1 = cgrad(colors, length(runs2plot_weatherings), categorical=true) # non physical runs begins at non_phys_meaning_weatherings index
colormap2 = cgrad(colors, length(runs2plot_quarryings), categorical=true)

colors1 = collect(colormap1)
colors2 = collect(colormap2)

xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))

# Plotting
fontsize=28
fig = Figure(resolution=(1500, 1200), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2.3

# Panel a. moving weatherings, H
ax = Axis(fig[1, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ax.xticks = xticks_time
ylims!(ax, (-100, 2800))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -2980, 2400, text=L"(a)$\,$", align=(:left, :center))
vlines!(ax, vlines_mpt, color=:darkgreen, linestyle=:solid, linewidth=3)
vlines!(ax, mpt_occurs_at, color=:black, linestyle=:dash)
non_phys_meaning_starts_at = 1
for (k, i) in enumerate(runs2plot_weatherings)
    df = NCDataset("data/runs/exp02/SEDIM/rem$(string(quarryings_idx, pad=ndigits(length(quarryings))))-gen$(string(i, pad=ndigits(length(weatherings)))).nc")

    if df["Hsed"][end] < df["Hsed"][1]
        mpt_occurs_at = findfirst(df["Hsed"] .<= sed_thr)

        if ~isnothing(mpt_occurs_at)
            lines!(ax, df["time"] ./ 1e3, df["H"], color=colors1[k], linewidth=2)
        end
    else
        display("NPhysmeaning weatherings, $(string(i, pad=ndigits(length(weatherings))))")
    end
end

# lines!(ax, df_base["time"] ./ 1e3, df_base["H"], color=:black)

df = NCDataset("data/runs/exp02/SEDIM/rem$(string(quarryings_idx, pad=ndigits(length(quarryings))))-gen$(string(weatherings_idx, pad=ndigits(length(weatherings)))).nc")
lines!(ax, df["time"] ./ 1e3, df["H"] * NaN, color=:black, linewidth=0, label=L"$f_v$ = 1.4⋅10$^{-7}$")
axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=3)

# Panel b. moving weatherings, Hsed
ax = Axis(fig[2, 1], ylabel=sed_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_sed, convert_strings_to_latex(yticks_sed))
ax.xticks = xticks_time
ylims!(ax, (-1, 35))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :t)
vlines!(ax, vlines_mpt, color=:darkgreen, linestyle=:solid, linewidth=3)
vlines!(ax, mpt_occurs_at, color=:black, linestyle=:dash)
for (k, i) in enumerate(runs2plot_weatherings)
    df = NCDataset("data/runs/exp02/SEDIM/rem$(string(quarryings_idx, pad=ndigits(length(quarryings))))-gen$(string(i, pad=ndigits(length(weatherings)))).nc")
    if df["Hsed"][end] < df["Hsed"][1]
        lines!(ax, df["time"] ./ 1e3, df["Hsed"], color=colors1[k], linewidth=2)
    end
end
text!(ax, -2980, 32, text=L"(b)$\,$", align=(:left, :center))

Colorbar(fig[1:2, 2], height=Relative(2/3), width=Relative(0.25), colormap=colormap1,
     limits=log10.((weatherings[1], weatherings[non_phys_meaning_weatherings])),
     ticklabelsize=fontsize,
     label=L"$f_{\dot{p}}$",
     ticks=(log10.([1e-7, 1e-6, 1e-5, 1e-4]), convert_strings_to_latex(["10^{-7}", "10^{-6}", "10^{-5}", "10^{-4}"])),
     minorticks = log10.(vcat(1e-7:1e-7:9e-7, 1e-6:1e-6:9e-6, 1e-5:1e-5:9e-5, 1e-4, 1.5e-4)), minorticksvisible=true,
     vertical=true, halign=0
)   # HARDCODED according to the results (NON AUTOMATIC!)

# Panel c. moving quarryings, H
ax = Axis(fig[3, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ax.xticks = xticks_time
ylims!(ax, (-100, 2800))
xlims!(ax, xlims_time_long)
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -2980, 2400, text=L"(c)$\,$", align=(:left, :center))
vlines!(ax, vlines_mpt, color=:darkgreen, linestyle=:solid, linewidth=3)
vlines!(ax, mpt_occurs_at, color=:black, linestyle=:dash)
for (k, i) in enumerate(runs2plot_quarryings)
    df = NCDataset("data/runs/exp02/SEDIM/rem$(string(i, pad=ndigits(length(quarryings))))-gen$(string(weatherings_idx, pad=ndigits(length(weatherings)))).nc")
    if df["Hsed"][end] < df["Hsed"][1]
        lines!(ax, df["time"] ./ 1e3, df["H"], color=colors2[k], linewidth=2)
    else
        display("NPhysmeaning quarryings, $(string(i, pad=ndigits(length(quarryings))))")
    end
end


df = NCDataset("data/runs/exp02/SEDIM/rem$(string(quarryings_idx, pad=ndigits(length(quarryings))))-gen$(string(weatherings_idx, pad=ndigits(length(weatherings)))).nc")
lines!(ax, df["time"] ./ 1e3, df["H"] .* NaN, color=:black, linewidth=0, label=L"$f_{\dot{p}}$ = 5⋅10$^{-6}$")
axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=3)

# Panel d. moving quarryings, Hsed
ax = Axis(fig[4, 1], ylabel=sed_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.yticks = (yticks_sed, convert_strings_to_latex(yticks_sed))
ax.xticks = xticks_time
ylims!(ax, (-1, 35))
xlims!(ax, xlims_time_long)
hidespines!(ax, :t)
text!(ax, -2980, 32, text=L"(d)$\,$", align=(:left, :center))
vlines!(ax, vlines_mpt, color=:darkgreen, linestyle=:solid, linewidth=3)
vlines!(ax, mpt_occurs_at, color=:black, linestyle=:dash, label=L"BASE$\,$")

text!(ax, vlines_mpt[2] + 10, 0, text=L"Clark et al. (2006)$\,$", color=:darkgreen)
text!(ax, mpt_occurs_at + 10, 0, text=L"BASE$\,$", color=:black)

for (k, i) in enumerate(runs2plot_quarryings)
    df = NCDataset("data/runs/exp02/SEDIM/rem$(string(i, pad=ndigits(length(quarryings))))-gen$(string(weatherings_idx, pad=ndigits(length(weatherings)))).nc")
    if df["Hsed"][end] < df["Hsed"][1]
        lines!(ax, df["time"] ./ 1e3, df["Hsed"], color=colors2[k], linewidth=2)
    end
end

# axislegend(ax, framevisible=false, position=:rt, labelsize=fontsize, nbanks=1)

Colorbar(fig[3:4, 2], height=Relative(2 / 3), width=Relative(0.25), colormap=colormap2,
     limits=log10.((quarryings[1], quarryings[non_phys_meaning_quarryings])),
     ticklabelsize=fontsize,
     label=L"$f_{v}$",
     ticks=(log10.([1e-7, 1e-6]), convert_strings_to_latex(["10^{-7}", "10^{-6}"])),
     minorticks = log10.(vcat(5e-8:1e-8:9e-8, 1e-7:1e-7:1e-6)), minorticksvisible=true,
     vertical=true, halign=0
) # HARDCODED according to the results (NON AUTOMATIC!)

colsize!(fig.layout, 2, Relative(0.05))
rowgap!(fig.layout, 0.0)
rowgap!(fig.layout, 2, 10.0)

save("figures/fig09_rem-gen_time-series.png", fig)
save("figures/fig09.pdf", fig)

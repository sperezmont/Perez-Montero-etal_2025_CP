include("header.jl")

function add_spectra!(axis1, axis2, axis3, dataframe, color, lw; plabel="")
    mpt_occurs_at = findfirst(dataframe["Hsed"] .<= sed_thr)
    G, periods = create_PSD(dataframe["time"][:], dataframe["I"][:])
    lines!(axis1, periods ./ 1e3, G, color=color, linewidth=lw, label=plabel)
    G, periods = create_PSD(dataframe["time"][1:mpt_occurs_at], dataframe["H"][1:mpt_occurs_at])
    lines!(axis2, periods ./ 1e3, G, color=color, linewidth=lw)
    G, periods = create_PSD(dataframe["time"][mpt_occurs_at:end], dataframe["H"][mpt_occurs_at:end])
    lines!(axis3, periods ./ 1e3, G, color=color, linewidth=lw)

    return nothing
end

function interp_spectra(f, newf, x)
    nodes = (f,)
    # x_interpolant = interpolate(nodes, x, Gridded(Linear()))
    # f_interpolant = interpolate(nodes, f, Gridded(Linear()))
    x_interpolant = linear_interpolation(nodes, x, extrapolation_bc=Flat())
    f_interpolant = linear_interpolation(nodes, f, extrapolation_bc=Flat())

    x_interp = x_interpolant.(newf)
    f_interp = f_interpolant.(newf)

    return x_interp, 1 ./ f_interp
end

function add_relative_spectra!(axis1, axis2, axis3, dataframe, df_ref, color, lw)
    mpt_occurs_at = findfirst(dataframe["Hsed"] .<= sed_thr)
    ref_mpt_occurs_at = findfirst(df_ref["Hsed"] .<= sed_thr)

    G, periods = create_PSD(dataframe["time"][:], dataframe["I"][:])
    Gref, periodsref = create_PSD(df_ref["time"][:], df_ref["I"][:])
    newGref, newperiodsref = interp_spectra(1 ./ periodsref, 1 ./ periods, Gref)
    lines!(axis1, periods ./ 1e3, G - newGref, color=color, linewidth=lw)

    G, periods = create_PSD(dataframe["time"][1:mpt_occurs_at], dataframe["H"][1:mpt_occurs_at])
    Gref, periodsref = create_PSD(df_ref["time"][1:ref_mpt_occurs_at], df_ref["H"][1:ref_mpt_occurs_at])
    newGref, newperiodsref = interp_spectra(1 ./ periodsref, 1 ./ periods, Gref)
    lines!(axis2, periods ./ 1e3, G - newGref, color=color, linewidth=lw)

    G, periods = create_PSD(dataframe["time"][mpt_occurs_at:end], dataframe["H"][mpt_occurs_at:end])
    Gref, periodsref = create_PSD(df_ref["time"][ref_mpt_occurs_at:end], df_ref["H"][ref_mpt_occurs_at:end])
    newGref, newperiodsref = interp_spectra(1 ./ periodsref, 1 ./ periods, Gref)
    lines!(axis3, periods ./ 1e3, G - newGref, color=color, linewidth=lw)

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

# df_isi0 = NCDataset("data/runs/exp04/INSOL/INSOL-ISI0.nc")
# params_isi0 = JLD2.load_object("data/runs/exp04/INSOL/INSOL-ISI0_params.jld2")

xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))
sed_thr=6

# Plot
set_theme!(theme_latexfonts())
fontsize=28
xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))
fig = Figure(resolution=(650, 1000), fontsize=fontsize)
linewidth = 2
colors = [pacco_color, :violetred4, :blueviolet, :yellowgreen, :cornflowerblue, :orangered]

# Absolute values, panels a, b, c
# Panel a.
ax = Axis(fig[1, 1], xlabel=periods_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, xscale=Makie.pseudolog10)
ax.xticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ax.yticks = ([0, 0.2, 0.4], convert_strings_to_latex([0, 0.2, 0.4]))
ylims!(ax, (-0.01, 0.45))
xlims!(ax, ylims_periods)
hidexdecorations!(ax)
text!(ax, 10.5, 0.37, text="(a) Forcing", align=(:left, :center))
# text!(ax, 100, 0.47, text=L"Forcing$\,$", align=(:left, :center))

# Panel b.
ax2 = Axis(fig[2, 1], ylabel="Normalized spectral power", ylabelpadding=25, xlabel=periods_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, xscale=Makie.pseudolog10)
ax2.xticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ax2.yticks = ([0, 0.2, 0.4], convert_strings_to_latex([0, 0.2, 0.4]))
ylims!(ax2, (-0.01, 0.55))
xlims!(ax2, ylims_periods)
hidexdecorations!(ax2)
text!(ax2, 10.5, 0.4, text="(b) pre-MPT ice thickness", align=(:left, :center))
# text!(ax2, 100, 0.47, text=L"Pre-MPT$\,$", align=(:left, :center))

# Panel c.
ax3 = Axis(fig[3, 1], xlabel=periods_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, xscale=Makie.pseudolog10)
ax3.xticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ax3.yticks = ([0, 0.1], convert_strings_to_latex([0, 0.1]))
ylims!(ax3, (-0.01, 0.2))
xlims!(ax3, ylims_periods)
text!(ax3, 10.5, 0.15, text="(c) post-MPT ice thickness", align=(:left, :center))
# text!(ax3, 100, 0.23, text=L"Post-MPT$\,$", align=(:left, :center))

add_spectra!(ax, ax2, ax3, df_base, colors[1], 5, plabel=L"SSI$\,$")
# add_spectra!(ax, ax2, ax3, df_isi0, colors[3], 3, plabel=L"ISI0$\,$")
add_spectra!(ax, ax2, ax3, df_isi275, colors[4], 2.8, plabel=L"ISI275$\,$")
add_spectra!(ax, ax2, ax3, df_isi300, colors[6], 2.5, plabel=L"ISI300$\,$")
add_spectra!(ax, ax2, ax3, df_csi, colors[2], 2.3, plabel=L"CSI$\,$")
add_spectra!(ax, ax2, ax3, df_isi400, colors[5], 2.0, plabel=L"ISI400$\,$")
fig[0, 1] = Legend(fig, ax, framevisible=false, position=:cc, labelsize=fontsize, nbanks=5)

# # Relative values, panels b, d, f
# # Panel b.
# ax = Axis(fig[1, 2], xlabel=periods_label, xgridvisible=false, ygridvisible=false, yaxisposition=:right, xscale=Makie.pseudolog10)
# ax.xticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
# ax.yticks = ([-0.2, 0, 0.2], convert_strings_to_latex([-0.2, 0, 0.2]))
# ylims!(ax, (-0.2, 0.4))
# xlims!(ax, ylims_periods)
# hidexdecorations!(ax)
# text!(ax, 10.5, 0.3, text=L"(b) Forcing$\,$", align=(:left, :center))

# # Panel d.
# ax2 = Axis(fig[2, 2], ylabel=L"\mathrm{NSP_x} - \mathrm{NSP}_\mathrm{SSI}", xlabel=periods_label, xgridvisible=false, ygridvisible=false, yaxisposition=:right, xscale=Makie.pseudolog10)
# ax2.xticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
# ax2.yticks = ([-0.2, 0, 0.2], convert_strings_to_latex([-0.2, 0, 0.2]))
# ylims!(ax2, (-0.2, 0.45))
# xlims!(ax2, ylims_periods)
# hidexdecorations!(ax2)
# text!(ax2, 10.5, 0.3, text=L"(d) pre-MPT $H$", align=(:left, :center))

# # Panel f.
# ax3 = Axis(fig[3, 2], xlabel=periods_label, xgridvisible=false, ygridvisible=false, yaxisposition=:right, xscale=Makie.pseudolog10)
# ax3.xticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
# ax3.yticks = ([-0.1, 0, 0.1], convert_strings_to_latex([-0.1, 0, 0.1]))
# ylims!(ax3, (-0.15, 0.2))
# xlims!(ax3, ylims_periods)
# text!(ax3, 10.5, 0.15, text=L"(f) post-MPT $H$", align=(:left, :center))

# add_relative_spectra!(ax, ax2, ax3, df_base, df_base, colors[1], 5)
# add_relative_spectra!(ax, ax2, ax3, df_isi0, df_base, colors[3], 3)
# add_relative_spectra!(ax, ax2, ax3, df_isi275, df_base, colors[4], 2.8)
# add_relative_spectra!(ax, ax2, ax3, df_isi300, df_base, colors[6], 2.5)
# add_relative_spectra!(ax, ax2, ax3, df_csi, df_base, colors[2], 2.3)
# add_relative_spectra!(ax, ax2, ax3, df_isi400, df_base, colors[5], 2.0)

# rowgap!(fig.layout, 0.0)
rowsize!(fig.layout, 0, Relative(0.05))
save("figures/fig12_insolation_metrics_power_H.png", fig)
save("figures/fig12.pdf", fig)
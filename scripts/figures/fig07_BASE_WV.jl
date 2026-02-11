include("header.jl")

# ===========================================================================================================
# Figure 2. BASE_WV
# ===========================================================================================================

set_theme!(theme_latexfonts())
df = NCDataset("data/runs/exp01/BASE/BASE.nc")
params = JLD2.load_object("data/runs/exp01/BASE/BASE_params.jld2")
xticks_time = (xticks_time_short, convert_strings_to_latex(-1 .* xticks_time_short))
cmap = cgrad([:gray99, :gray60, :gray5, :grey3], 12, categorical=true)
time, T, H, Vol = df["time"][:], df["T"][:], df["H"][:], df["Vol"][:]
elderfieldVol, sprattVol = elderfield2012_vol, spratt2016_vol
clarkvol = clark2025b_vol
color_MPT= RGBA{Float64}(0.3,0.6,0.3,1.0)

start_idx = findmin(abs.(time .+ 2.0e6))[2] #findmin(abs.(time .+ 1.5e6))[2]
time, T, H, Vol = time[start_idx:end], T[start_idx:end], H[start_idx:end], Vol[start_idx:end]

xticks_time = (xticks_time_2000, convert_strings_to_latex(-1 .* xticks_time_2000))

start_idx_elderfield = findmin(abs.(elderfieldVol[1, :] .+ 2.0e6))[2] 
elderfieldVol = elderfieldVol[:, start_idx_elderfield:end]
start_idx_berends = findmin(abs.(clarkvol[1, :] .+ 2.0e6))[2]
clarkvol = clarkvol[:, start_idx_berends:end]

W1, periods1 = create_WV(time, Vol)
W2, periods2 = create_WV(elderfieldVol[1, :], elderfieldVol[2, :])
maxW2 = findmax(W2, dims=2)[2]
ymaxW2 = [periods2[maxW2[i][2]] for i in eachindex(maxW2)]
W3, periods3 = create_WV(sprattVol[1, :], sprattVol[2, :])
maxW3 = findmax(W3, dims=2)[2]
ymaxW3 = [periods3[maxW3[i][2]] for i in eachindex(maxW3)]
W4, periods4 = create_WV(clarkvol[1, :], clarkvol[2, :])
maxW4 = findmax(W4, dims=2)[2]
ymaxW4 = [periods4[maxW4[i][2]] for i in eachindex(maxW4)]

# Plotting
fontsize=28
fig = Figure(resolution=(750, 1150), fontsize=fontsize)
linewidth = 2.3

# Panel a. PACCO
ax = Axis(fig[1, 1], ylabel="PACCO", ylabelrotation=-pi/2, xgridvisible=false, ygridvisible=false, yaxisposition=:right)
hidespines!(ax)
ax.xticks = ([], [])
ax.yticks = ([], [])

ax = Axis(fig[1, 1], xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, ylims_periods)
xlims!(ax, xlims_time_2000)
hidexdecorations!(ax)
hidespines!(ax, :b)

opts = (colormap=cmap, levels=0.0:0.02:0.2)#, extendlow=:white, extendhigh=:black)

contourf!(ax, time ./ 1e3, periods1 ./ 1e3, W1; opts...)
hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)
vlines!(ax, vlines_mpt, linestyle=:solid, color=color_MPT, linewidth=2)
text!(ax, -1980, 120, text=L"(a) $\,$", align=(:left, :center), fontsize=fontsize)

# Panel b. elderfield 2012
ax = Axis(fig[2, 1], ylabel="E-2012", ylabelrotation=-pi/2, xgridvisible=false, ygridvisible=false, yaxisposition=:right)
hidespines!(ax)
ax.xticks = ([], [])
ax.yticks = ([], [])

ax = Axis(fig[2, 1], xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, ylims_periods)
xlims!(ax, xlims_time_2000)
hidexdecorations!(ax)
hidespines!(ax, :b, :t)

contourf!(ax, elderfieldVol[1, :] ./ 1e3, periods2 ./ 1e3, W2; opts...)
hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)
vlines!(ax, vlines_mpt, linestyle=:solid, color=color_MPT, linewidth=2)

text!(ax, -1980, 120, text=L"(b) $\,$", align=(:left, :center), fontsize=fontsize)

# Panel c. Spratt and Lisiecki, 2016
ax = Axis(fig[3, 1], ylabel="SL-2016", ylabelrotation=-pi/2, xgridvisible=false, ygridvisible=false, yaxisposition=:right)
hidespines!(ax)
ax.xticks = ([], [])
ax.yticks = ([], [])

ax = Axis(fig[3, 1], xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, ylims_periods)
xlims!(ax, xlims_time_2000)
hidexdecorations!(ax)
hidespines!(ax, :t, :b)

contourf!(ax, sprattVol[1, :] ./ 1e3, periods3 ./ 1e3, W3; opts...)
hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)
vlines!(ax, vlines_mpt, linestyle=:solid, color=color_MPT, linewidth=2)

text!(ax, -1980, 120, text=L"(c) $\,$", align=(:left, :center), fontsize=fontsize)

# Panel d. Berends et al., 2020
ax = Axis(fig[4, 1], ylabel="C-2025", ylabelrotation=-pi/2, xgridvisible=false, ygridvisible=false, yaxisposition=:right)
hidespines!(ax)
ax.xticks = ([], [])
ax.yticks = ([], [])

ax = Axis(fig[4, 1], xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
ylims!(ax, ylims_periods)
xlims!(ax, xlims_time_2000)
hidespines!(ax, :t)

cf = contourf!(ax, clarkvol[1, :] ./ 1e3, periods4 ./ 1e3, W4; opts...)
hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)
vlines!(ax, vlines_mpt, linestyle=:solid, color=color_MPT, linewidth=2)
text!(ax, vlines_mpt[2] + 10, 11, text=L"MPT$\,$", color=color_MPT, fontsize=23)

text!(ax, -1980, 120, text=L"(d) $\,$", align=(:left, :center), fontsize=fontsize)

Colorbar(fig[0, :], cf, width=Relative(1 / 4),
    label=L"NSP$\,$", ticklabelsize=fontsize, labelsize=fontsize, vertical=false, #halign=0.0, valign=1.1,
    ticks=([0.0, 0.1, 0.2], convert_strings_to_latex([0, 0.1, 0.2])))
rowsize!(fig.layout, 0, Relative(0.04))

ax = Axis(fig[1:4, 1], ylabel=L"P($V_\mathrm{ice}$) (kyr)", xgridvisible=false, ygridvisible=false, ylabelpadding=50)
hidespines!(ax)
ax.xticks = ([], [])
ax.yticks = ([], [])

rowgap!(fig.layout, 0.0)
save("figures/fig07_BASE_WV.png", fig)
save("figures/fig07.pdf", fig)

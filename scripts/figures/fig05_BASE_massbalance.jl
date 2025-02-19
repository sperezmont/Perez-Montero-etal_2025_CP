include("header.jl")

# ===========================================================================================================
df = NCDataset("data/runs/exp01/BASE/BASE.nc")
params = JLD2.load_object("data/runs/exp01/BASE/BASE_params.jld2")
xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))
xticks_time2 = (Int.(-2.0e3:50:100), convert_strings_to_latex(-1 .* Int.(-2.0e3:50:100)))
xticks_time3 = (Int.(-2.0e3:100:100), convert_strings_to_latex(-1 .* Int.(-2.0e3:100:100)))

H, T = df["H"][:], df["T"][:]
s, a, a_ins, a_therm, q = df["s"][:], df["a"][:], df["sw"][:], df["lw"][:], df["q"][:]
s_norm, a_ins_norm, a_therm_norm, q_norm = s ./ std(s), a_ins ./ std(a_ins), a_therm ./ std(a_therm), q ./ std(q)
m = df["m"][:]

s[s .<= 5e-3] .= 5e-3

dHdt = s .- a_ins .- a_therm .- q
dHdt_norm = dHdt ./ std(dHdt)
dHdt_norm[dHdt_norm .> 0] .= 0.0

s_s, a_s, q_s, m_s = s ./ s, a ./ s, q ./ s, m ./ s
a_ins_s, a_therm_s = a_ins ./ s, a_therm ./ s
qa_s = (q .+ a) ./ s
# a_s[dHdt .> 0.0] .= 0.0
# q_s[dHdt .> 0.0] .= 0.0

# Plotting
fontsize = 28
fig = Figure(resolution=(1500, 600), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2.3
colors = [:darkorange, :purple, :green, :red, :royalblue]

# Legend
ax = Axis(fig[0, 1:2])
hidedecorations!(ax)
hidespines!(ax)
lines!(ax, df["time"][:] ./ 1e3, s_s .* NaN, color=:black, linewidth=4, label=L"\dot{s}")
lines!(ax, df["time"][:] ./ 1e3, a_s .* NaN, color=colors[1], linewidth=4, label=L"\dot{a}")
lines!(ax, df["time"][:] ./ 1e3, q_s .* NaN, color=colors[2], linewidth=4, label=L"q")
lines!(ax, df["time"][:] ./ 1e3, qa_s .* NaN, color=colors[3], linestyle=:dash, linewidth=4, label=L"\dot{a} + q")
axislegend(ax, framevisible=false, position=(:left, 1.0), patchsize=(35,20), labelsize=fontsize, nbanks=4)

# Panel a
ax = Axis(fig[1, 1:2], ylabel=L"$H$ (m)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, ylabelcolor=:grey50, yticklabelcolor=:grey50, xaxisposition=:top)
ax.xticks = xticks_time
ax.yticks = ([0, 1000, 2000], convert_strings_to_latex([0, 1000, 2000]))
ylims!(ax, (-10, 2000))
xlims!(ax, (-2e3, 10))
band!(ax, df["time"][:] ./ 1e3, 0.0, df["H"][:], color=:grey80)

ax = Axis(fig[1, 1:2], xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, xaxisposition=:top)
ax.xticks = xticks_time
ax.yticks = ([0, 2, 4, 6, 8], convert_strings_to_latex([0, 2, 4, 6, 8]))
ylims!(ax, (-0.1, 9))
xlims!(ax, (-2e3, 10))
hidespines!(ax, :r)
lines!(ax, df["time"][:] ./ 1e3, s_s, color=:black, linewidth=2, label=L"\dot{s}")
lines!(ax, df["time"][:] ./ 1e3, a_s, color=colors[1], linewidth=2, label=L"\dot{a}")
lines!(ax, df["time"][:] ./ 1e3, q_s, color=colors[2], linewidth=2, label=L"q")
lines!(ax, df["time"][:] ./ 1e3, qa_s, color=colors[3], linestyle=:dash, linewidth=2, label=L"\dot{a} + q")
text!(ax, -1980, 8, text=L"(a)$\,$", align=(:left, :center))
vlines!(ax, [-1700, -1550], linestyle=:solid, color=colors[4], linewidth=5)
vlines!(ax, [-500, 0], linestyle=:solid, color=colors[5], linewidth=5)

# axislegend(ax, halign=0.05, valign=1.05, framevisible=false, nbanks=4)

# Panel b
ax = Axis(fig[2, 1], xgridvisible=false, ygridvisible=false, yaxisposition=:right)
ax.rightspinecolor, ax.leftspinecolor = colors[4], colors[4]
ax.xticks = xticks_time2
ax.yticks = ([0, 1000, 2000], convert_strings_to_latex([0, 1000, 2000]))
ylims!(ax, (-10, 2000))
xlims!(ax, (-1700, -1550))
hideydecorations!(ax)
band!(ax, df["time"][:] ./ 1e3, 0.0, df["H"][:], color=:grey80)

ax = Axis(fig[2, 1], xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.rightspinecolor, ax.leftspinecolor = colors[4], colors[4]
ax.yticks = ([0, 2, 4, 6, 8], convert_strings_to_latex([0, 2, 4, 6, 8]))
ax.xticks = xticks_time2
ylims!(ax, (-0.1, 9))
xlims!(ax, (-1700, -1550))
lines!(ax, df["time"][:] ./ 1e3, s_s, color=:black, linewidth=2, label=L"\dot{s}")
lines!(ax, df["time"][:] ./ 1e3, a_s, color=colors[1], linewidth=2, label=L"\dot{a}")
lines!(ax, df["time"][:] ./ 1e3, q_s, color=colors[2], linewidth=2, label=L"q")
lines!(ax, df["time"][:] ./ 1e3, qa_s, color=colors[3], linestyle=:dash, linewidth=3, label=L"\dot{a} + q")
text!(ax, -1698, 8, text=L"(b)$\,$", align=(:left, :center))
vlines!(ax, [-1700, -1550], linestyle=:solid, color=colors[4], linewidth=8)

# Panel c
ax = Axis(fig[2, 2],  ylabel=L"$H$ (m)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, ylabelcolor=:grey50, yticklabelcolor=:grey50)
ax.rightspinecolor, ax.leftspinecolor = colors[5], colors[5]
ax.xticks = xticks_time3
ax.yticks = ([0, 1000, 2000], convert_strings_to_latex([0, 1000, 2000]))
ylims!(ax, (-10, 2000))
xlims!(ax, (-500, 0))
band!(ax, df["time"][:] ./ 1e3, 0.0, df["H"][:], color=:grey80)

ax = Axis(fig[2, 2], xlabel=time_label, xgridvisible=false, ygridvisible=false)
ax.rightspinecolor, ax.leftspinecolor = colors[5], colors[5]
ax.yticks = ([0, 2, 4, 6, 8], convert_strings_to_latex([0, 2, 4, 6, 8]))
ax.xticks = xticks_time3
ylims!(ax, (-0.1, 9))
xlims!(ax, (-500, 0))
hideydecorations!(ax)
lines!(ax, df["time"][:] ./ 1e3, s_s, color=:black, linewidth=2, label=L"\dot{s}")
lines!(ax, df["time"][:] ./ 1e3, a_s, color=colors[1], linewidth=2, label=L"\dot{a}")
lines!(ax, df["time"][:] ./ 1e3, q_s, color=colors[2], linewidth=2, label=L"q")
lines!(ax, df["time"][:] ./ 1e3, qa_s, color=colors[3], linestyle=:dash, linewidth=3, label=L"\dot{a} + q")
text!(ax, -490, 8, text=L"(c)$\,$", align=(:left, :center))
vlines!(ax, [-500, 0], linestyle=:solid, color=colors[5], linewidth=8)

ax = Axis(fig[1:2, 1:2], ylabel=L"Normalized mass balance terms$\,$", xgridvisible=false, ygridvisible=false, ylabelpadding=20)
hidespines!(ax)
ax.xticks = ([], [])
ax.yticks = ([], [])

rowgap!(fig.layout, 25.0)
colgap!(fig.layout, 100.0)
rowsize!(fig.layout, 0, Relative(0.0))
save("figures/fig05_BASE_massbalance.png", fig)
save("figures/fig05.pdf", fig)
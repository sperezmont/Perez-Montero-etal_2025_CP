include("header.jl")

# ===========================================================================================================
df = NCDataset("data/runs/exp01/BASE/BASE.nc")
params = JLD2.load_object("data/runs/exp01/BASE/BASE_params.jld2")
xticks_time = (xticks_time_2000, convert_strings_to_latex(-1 .* xticks_time_2000))
xticks_time2 = (Int.(-2.0e3:50:100), convert_strings_to_latex(-1 .* Int.(-2.0e3:50:100)))
xticks_time3 = (Int.(-2.0e3:100:100), convert_strings_to_latex(-1 .* Int.(-2.0e3:100:100)))

H, T = df["H"][:], df["T"][:]
s, a, a_ins, a_therm, q = df["s"][:], df["a"][:], df["sw"][:], df["lw"][:], df["q"][:]
a[H .<= 10.0] .= 0.0
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
lw, lnstl, lnstl2 = 3, :dash, (:dash, :dense)
colors = [:darkorange, :purple, :green, :red, :royalblue]
boxes_color1, boxes_color2 = :grey40, :grey40
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
ylims!(ax, (-200, 2700))
xlims!(ax, (-2e3, 1))

band!(ax, df["time"][:] ./ 1e3, 0.0, df["H"][:], color=:grey80)

ax = Axis(fig[1, 1:2], xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, xaxisposition=:top)
ax.xticks = xticks_time
ax.yticks = ([0, 2, 4, 6, 8], convert_strings_to_latex([0, 2, 4, 6, 8]))
ylims!(ax, (-0.5, 7.0))
xlims!(ax, (-2e3, 1))
hidespines!(ax, :r)
lines!(ax, df["time"][:] ./ 1e3, q_s, color=colors[2], linewidth=3, label=L"q")
lines!(ax, df["time"][:] ./ 1e3, s_s, color=:black, linewidth=2, label=L"\dot{s}")
lines!(ax, df["time"][:] ./ 1e3, a_s, color=colors[1], linewidth=2, label=L"\dot{a}")
lines!(ax, df["time"][:] ./ 1e3, qa_s, color=colors[3], linestyle=:dash, linewidth=2, label=L"\dot{a} + q")
text!(ax, -1980, 6, text=L"(a)$\,$", align=(:left, :center))
# vlines!(ax, [-1700, -1550], linestyle=:solid, color=colors[4], linewidth=4)
# vlines!(ax, [-500, 0], linestyle=:solid, color=colors[5], linewidth=4)

# axislegend(ax, halign=0.05, valign=1.05, framevisible=false, nbanks=4)

vlines!(ax, [-1700, -1550], color=boxes_color1, linewidth=lw, linestyle=lnstl)
vlines!(ax, [-500, -1], color=boxes_color2, linewidth=lw, linestyle=lnstl)
# lines!(ax, [-1700, -1700], [-0.3, 6.6], color=boxes_color1, linestyle=:solid, linewidth=4)
# lines!(ax, [-1550, -1550], [-0.3, 6.6], color=boxes_color1, linestyle=:solid, linewidth=4)
# lines!(ax, [-1700, -1550], [6.6, 6.6], color=boxes_color1, linestyle=:solid, linewidth=4)
# lines!(ax, [-1700, -1550], [-0.3, -0.3], color=boxes_color1, linestyle=:solid, linewidth=4)

# lines!(ax, [-500, -500], [-0.3, 6.6], color=boxes_color2, linestyle=:solid, linewidth=4)
# lines!(ax, [0, 0], [-0.3, 6.6], color=boxes_color2, linestyle=:solid, linewidth=4)
# lines!(ax, [-500, 0], [6.6, 6.6], color=boxes_color2, linestyle=:solid, linewidth=4)
# lines!(ax, [-500, 0], [-0.3, -0.3], color=boxes_color2, linestyle=:solid, linewidth=4)

# Panel b
ax = Axis(fig[2, 1], xgridvisible=false, ygridvisible=false, yaxisposition=:right,
          spinewidth=lw, leftspinecolor=boxes_color1, rightspinecolor=boxes_color1, topspinecolor=boxes_color1, bottomspinecolor=boxes_color1)
ax.xticks = xticks_time2
hidexdecorations!(ax)
ax.yticks = ([0, 1000, 2000], convert_strings_to_latex([0, 1000, 2000]))
ylims!(ax, (-200, 2500))
xlims!(ax, (-1700, -1550))
hideydecorations!(ax)
band!(ax, df["time"][:] ./ 1e3, 0.0, df["H"][:], color=:grey80)

ax = Axis(fig[2, 1], xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left,
    spinewidth=lw, leftspinecolor=boxes_color1, rightspinecolor=boxes_color1, topspinecolor=boxes_color1, bottomspinecolor=boxes_color1)
ax.yticks = ([0, 2, 4, 6, 8], convert_strings_to_latex([0, 2, 4, 6, 8]))
ax.xticks = xticks_time2
ylims!(ax, (-0.5, 7.0))
xlims!(ax, (-1700, -1550))
lines!(ax, df["time"][:] ./ 1e3, q_s, color=colors[2], linewidth=3, label=L"q")
lines!(ax, df["time"][:] ./ 1e3, s_s, color=:black, linewidth=2, label=L"\dot{s}")
lines!(ax, df["time"][:] ./ 1e3, a_s, color=colors[1], linewidth=2, label=L"\dot{a}")
lines!(ax, df["time"][:] ./ 1e3, qa_s, color=colors[3], linestyle=:dash, linewidth=3, label=L"\dot{a} + q")
text!(ax, -1698, 6, text=L"(b)$\,$", align=(:left, :center))
# vlines!(ax, [-1700, -1550], linestyle=:solid, color=colors[4], linewidth=8)

# Panel c
ax = Axis(fig[2, 2],  ylabel=L"$H$ (m)", xgridvisible=false, ygridvisible=false, yaxisposition=:right, ylabelcolor=:grey50, yticklabelcolor=:grey50,
        spinewidth=lw, leftspinecolor=boxes_color2, rightspinecolor=boxes_color2, topspinecolor=boxes_color2, bottomspinecolor=boxes_color2)
ax.xticks = xticks_time3
hidexdecorations!(ax)
ax.yticks = ([0, 1000, 2000], convert_strings_to_latex([0, 1000, 2000]))
ylims!(ax, (-200, 2500))
xlims!(ax, (-500, 0))
band!(ax, df["time"][:] ./ 1e3, 0.0, df["H"][:], color=:grey80)

ax = Axis(fig[2, 2], xlabel=time_label, xgridvisible=false, ygridvisible=false,
          spinewidth=lw, leftspinecolor=boxes_color2, rightspinecolor=boxes_color2, topspinecolor=boxes_color2, bottomspinecolor=boxes_color2)
ax.yticks = ([0, 2, 4, 6, 8], convert_strings_to_latex([0, 2, 4, 6, 8]))
ax.xticks = xticks_time3
ylims!(ax, (-0.5, 7.0))
xlims!(ax, (-500, 0))
hideydecorations!(ax)
lines!(ax, df["time"][:] ./ 1e3, q_s, color=colors[2], linewidth=3, label=L"q")
lines!(ax, df["time"][:] ./ 1e3, s_s, color=:black, linewidth=2, label=L"\dot{s}")
lines!(ax, df["time"][:] ./ 1e3, a_s, color=colors[1], linewidth=2, label=L"\dot{a}")
lines!(ax, df["time"][:] ./ 1e3, qa_s, color=colors[3], linestyle=:dash, linewidth=3, label=L"\dot{a} + q")
text!(ax, -490, 6, text=L"(c)$\,$", align=(:left, :center))
# vlines!(ax, [-500, 0], linestyle=:solid, color=colors[5], linewidth=8)

ax = Axis(fig[1:2, 1:2], ylabel=L"Normalized mass balance terms$\,$", xgridvisible=false, ygridvisible=false, ylabelpadding=20)
hidespines!(ax)
ax.xticks = ([], [])
ax.yticks = ([], [])
xlims!(ax, (0, 100))
ylims!(ax, (0, 100))

lines!(ax, [0, 15], [47, 53], color=boxes_color1, linewidth=lw, linestyle=lnstl2)
lines!(ax, [22.3, 46], [53, 47], color=boxes_color1, linewidth=lw, linestyle=lnstl2)

lines!(ax, [54, 74.7], [47, 53], color=boxes_color2, linewidth=lw, linestyle=lnstl2)
lines!(ax, [99.9, 99.9], [53, 46.5], color=boxes_color2, linewidth=lw, linestyle=lnstl2)

rowgap!(fig.layout, 25.0)
colgap!(fig.layout, 100.0)
rowsize!(fig.layout, 0, Relative(0.0))
save("figures/fig05_BASE_massbalance.png", fig)
save("figures/fig05.pdf", fig)
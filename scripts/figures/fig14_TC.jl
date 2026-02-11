include("header.jl")

searchdir(path,key) = filter(x->occursin(key,x), readdir(path))
cref_t(cref, deltaCmax, deltaCmin, tend, tinit, t) = cref + deltaCmax .- (deltaCmax .- deltaCmin)  ./ (tend .- tinit) .* (t .- tinit)

# ===========================================================================================================
# Figure 14. TC
# ===========================================================================================================
df_nosedim01 = NCDataset("data/runs/exp05/NOSEDIM/NOSEDIM01.nc")
params_nosedim01 = JLD2.load_object("data/runs/exp05/NOSEDIM/NOSEDIM01_params.jld2")
dfs = NCDataset.("data/runs/exp05/TC/" .* searchdir("data/runs/exp05/TC/", ".nc"))
params = JLD2.load_object.("data/runs/exp05/TC/" .* searchdir("data/runs/exp05/TC/", ".jld2"))
tend, tinit, dt = params_nosedim01.time_end, params_nosedim01.time_init, params_nosedim01.dt_out
t = tinit:dt:tend
xticks_time = (xticks_time_2000, convert_strings_to_latex(-1 .* xticks_time_2000))
lw, lnstl = 3, :dash
selected_index = [3, 7, 12, 14]

colors = collect(cgrad([:plum4, :mediumpurple3, :plum3, :thistle, :darkorange,  :chocolate, :darkred], length(dfs), categorical=true))
boxes_color1, boxes_color2 = :grey40, :grey40
# Plot
fontsize=28
fig = Figure(resolution=(1600, 800), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2.3

# a) Reference Carbon
ax = Axis(fig[1, 1:2], ylabel=L"$C_{\mathrm{ref}}$ (ppm)", xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, xaxisposition=:top)
ax.xticks = xticks_time
ax.yticks = ([250, 500, 750, 1000], convert_strings_to_latex([250, 500, 750, 1000]))
xlims!(ax, (-2e3, 0.0))
text!(ax, -1990, 900, text=a_label, align=(:left, :center))

lines!(ax, df_nosedim01["time"] ./ 1e3, cref_t(params_nosedim01.Cref, params_nosedim01.deltaC_max, params_nosedim01.deltaC_min, tend, tinit, t), color=:black, linewidth=3)
for i in eachindex(dfs)
    lines!(ax, dfs[i]["time"] ./ 1e3, cref_t(params[i].Cref, params[i].deltaC_max, params[i].deltaC_min, tend, tinit, t), color=colors[i], linewidth=0.5)
end

for i in eachindex(dfs)
    if i in selected_index
        lines!(ax, dfs[i]["time"] ./ 1e3, cref_t(params[i].Cref, params[i].deltaC_max, params[i].deltaC_min, tend, tinit, t), color=colors[i], linewidth=2)
    end
end

# b) Carbon
ax = Axis(fig[2, 1:2], ylabel=carbon_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, xaxisposition=:top)
ax.xticks = xticks_time
ax.yticks = ([250, 500, 750, 1000], convert_strings_to_latex([250, 500, 750, 1000]))
xlims!(ax, (-2e3, 0.0))
hidexdecorations!(ax)
hidespines!(ax, :b)
text!(ax, -1990, 900, text=b_label, align=(:left, :center))

lines!(ax, df_nosedim01["time"] ./ 1e3, df_nosedim01["C"], color=:black, linewidth=3)
for i in eachindex(dfs)
    lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["C"], color=colors[i], linewidth=0.5)
end

for i in eachindex(dfs)
    if i in selected_index
        lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["C"], color=colors[i], linewidth=2)
    end
end

vlines!(ax, [-1600, -1200], color=boxes_color1, linewidth=lw, linestyle=lnstl)
# vlines!(ax, [-500, -1], color=boxes_color2, linewidth=lw, linestyle=lnstl)

# c) Ice thickness
ax = Axis(fig[3, 1:2], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
hidespines!(ax, :t)
xlims!(ax, (-2e3, 0.0))
ylims!(ax, (-200, 4500))

hidexdecorations!(ax)
text!(ax, -1990, 3500, text=c_label, align=(:left, :center))

lines!(ax, df_nosedim01["time"] ./ 1e3, df_nosedim01["H"], color=:black, linewidth=3)
for i in eachindex(dfs)
    if i in selected_index
        lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["H"], color=colors[i], linewidth=2)
    end
end

vlines!(ax, [-1600, -1200], color=boxes_color1, linewidth=lw, linestyle=lnstl)
# vlines!(ax, [-500, -1], color=boxes_color2, linewidth=lw, linestyle=lnstl)

# lines!(ax, [-1600, -1600], [-100, 4000], color=boxes_color1, linestyle=:solid, linewidth=4)
# lines!(ax, [-1200, -1200], [-100, 4000], color=boxes_color1, linestyle=:solid, linewidth=4)
# lines!(ax, [-1600, -1200], [4000, 4000], color=boxes_color1, linestyle=:solid, linewidth=4)
# lines!(ax, [-1600, -1200], [-100, -100], color=boxes_color1, linestyle=:solid, linewidth=4)

# lines!(ax, [-500, -500], [-100, 4000], color=boxes_color2, linestyle=:solid, linewidth=4)
# lines!(ax, [0, 0], [-100, 4000], color=boxes_color2, linestyle=:solid, linewidth=4)
# lines!(ax, [-500, 0], [4000, 4000], color=boxes_color2, linestyle=:solid, linewidth=4)
# lines!(ax, [-500, 0], [-100, -100], color=boxes_color2, linestyle=:solid, linewidth=4)

# d) and e) Ice thickness
ax = Axis(fig[4, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left,
          spinewidth=lw, leftspinecolor=boxes_color1, rightspinecolor=boxes_color1, topspinecolor=boxes_color1, bottomspinecolor=boxes_color1)
ax.xticks = ([-1600, -1500, -1400, -1300, -1200], convert_strings_to_latex([1600, 1500, 1400, 1300, 1200]))
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
xlims!(ax, (-1600.5, -1199.99))
ylims!(ax, (-100, 4000))
text!(ax, -1595, 3200, text=d_label, align=(:left, :center))
vlines!(ax, [-2000, -1800], color=boxes_color1, linestyle=:dash)

lines!(ax, df_nosedim01["time"] ./ 1e3, df_nosedim01["H"], color=:black, linewidth=3)
lines!(ax, dfs[end]["time"] ./ 1e3, dfs[end]["H"], color=colors[end], linewidth=3)

# for i in eachindex(dfs)
#     lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["H"], color=colors[i], linewidth=0.5)
# end

# for i in eachindex(dfs)
#     if i in selected_index
#         lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["H"], color=colors[i], linewidth=2)
#     end
# end

# ax = Axis(fig[4, 2], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, 
#           spinewidth=lw, leftspinecolor=boxes_color2, rightspinecolor=boxes_color2, topspinecolor=boxes_color2, bottomspinecolor=boxes_color2)
# ax.xticks = ([-500, -400, -300, -200, -100, 0], convert_strings_to_latex([500, 400, 300, 200, 100, 0]))
# ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
# xlims!(ax, (-500.5, 0.0))
# ylims!(ax, (-100, 4000))
# hideydecorations!(ax)
# text!(ax, -490, 3200, text=e_label, align=(:left, :center))
# vlines!(ax, [-2300, -1800, -500, 0.0], color=boxes_color2, linestyle=:dash)

# lines!(ax, df_nosedim01["time"] ./ 1e3, df_nosedim01["H"], color=:black, linewidth=3)
# for i in eachindex(dfs)
#     lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["H"], color=colors[i], linewidth=0.5)
# end

# for i in eachindex(dfs)
#     if i in selected_index
#         lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["H"], color=colors[i], linewidth=2)
#     end
# end

ax = Axis(fig[1:4, 1:2], xgridvisible=false, ygridvisible=false, ylabelpadding=20)
hidespines!(ax)
ax.xticks = ([], [])
ax.yticks = ([], [])
xlims!(ax, (0, 100))
ylims!(ax, (0, 100))

lines!(ax, [0, 20.5], [23.3, 27.5], color=boxes_color1, linewidth=lw, linestyle=lnstl)
lines!(ax, [40, 46.6], [27.5, 23.3], color=boxes_color1, linewidth=lw, linestyle=lnstl)

# lines!(ax, [54, 75], [23.3, 27.5], color=boxes_color2, linewidth=lw, linestyle=lnstl)
# lines!(ax, [99.9, 99.95], [27.5, 23.3], color=boxes_color2, linewidth=lw, linestyle=lnstl)

rowgap!(fig.layout, 1, 20.0)
rowgap!(fig.layout, 2, 0.0)
rowgap!(fig.layout, 3, 25.0)
colgap!(fig.layout, 100)
save("figures/fig14_TC.png", fig)
save("figures/fig14.pdf", fig)
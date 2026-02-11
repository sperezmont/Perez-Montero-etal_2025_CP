include("header.jl")

searchdir(path,key) = filter(x->occursin(key,x), readdir(path))
ks_t(ksmax, ksmin, tend, tinit, t) = ksmax .- (ksmax .- ksmin)  ./ (tend .- tinit) .* (t .- tinit)
calc_bins(n) = 2 * Int(round((n)^(1/3)))    # Rice criterion, k=2⋅(n)^{1/3}

# ===========================================================================================================
# Figure 15. TS
# ===========================================================================================================
df_nosedim01 = NCDataset("data/runs/exp05/NOSEDIM/NOSEDIM01.nc")
params_nosedim01 = JLD2.load_object("data/runs/exp05/NOSEDIM/NOSEDIM01_params.jld2")
dfs = NCDataset.("data/runs/exp05/TS/" .* searchdir("data/runs/exp05/TS/", ".nc"))
params = JLD2.load_object.("data/runs/exp05/TS/" .* searchdir("data/runs/exp05/TS/", ".jld2"))

xticks_time = (xticks_time_2000, convert_strings_to_latex(-1 .* xticks_time_2000))
tend, tinit, dt = params_nosedim01.time_end, params_nosedim01.time_init, params_nosedim01.dt_out
t = tinit:dt:tend
#colors = collect(cgrad([:royalblue4, :steelblue4, :olive, :darkorange, :chocolate], length(dfs), categorical=true))
colors = vcat(collect(cgrad([:royalblue4, :steelblue4, :steelblue, :orange, :darkorange, :chocolate], length(dfs)-1, categorical=true)), :firebrick)

#colors = collect(cgrad([:plum4, :mediumpurple3, :plum3, :thistle, :darkorange,  :chocolate, :darkred], length(dfs), categorical=true))
selected_index = [1, 5, 10, 15, 20, 25, 30]

# Plot
fontsize=28
fig = Figure(resolution=(1500, 800), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2.3

# a) ks
ax = Axis(fig[1, 1], ylabel=L"$k_{\dot{s}}$ ($\mathrm{m~yr^{-1}~K^{-1}}$)", xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks_time
ax.yticks = ([0.02, 0.03, 0.04], convert_strings_to_latex([0.02, 0.03, 0.04]))
text!(ax, -1990, 0.045, text=a_label, align=(:left, :center))
xlims!(ax, (-2e3, 0.0))
hidexdecorations!(ax)

hlines!(ax, params_nosedim01.ks, color=:black, linewidth=3)
for i in eachindex(dfs)
    lines!(ax, dfs[i]["time"] ./ 1e3, ks_t.(params[i].ks_max, params_nosedim01.ks, tend, tinit, t), color=colors[i], linewidth=0.5)
end

for i in eachindex(dfs)
    if i in selected_index
        lines!(ax, dfs[i]["time"] ./ 1e3, ks_t.(params[i].ks_max, params_nosedim01.ks, tend, tinit, t), color=colors[i], linewidth=2)
    end
end

# b) s
ax = Axis(fig[2, 1], ylabel=snowfall_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks_time
ax.yticks = ([0, 0.2, 0.4], convert_strings_to_latex([0, 0.2, 0.4]))
text!(ax, -1990, 0.4, text=b_label, align=(:left, :center))
xlims!(ax, (-2e3, 0.0))
hidexdecorations!(ax)
hidespines!(ax, :b)

lines!(ax, df_nosedim01["time"] ./ 1e3, df_nosedim01["s"], color=:black, linewidth=3)
# for i in eachindex(dfs)
#     lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["s"], color=colors[i], linewidth=0.5)
# end

for i in eachindex(dfs)
    if i in selected_index
        lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["s"], color=colors[i], linewidth=2)
    end
end

# c) H
ax = Axis(fig[3, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks_time
ax.yticks = ([0, 1000, 2000], convert_strings_to_latex([0, 1000, 2000]))
text!(ax, -1990, 2250, text=c_label, align=(:left, :center))
xlims!(ax, (-2e3, 0.0))
ylims!(ax, (-100, 2500))
hidespines!(ax, :t)
hidexdecorations!(ax)

lines!(ax, df_nosedim01["time"] ./ 1e3, df_nosedim01["H"], color=:black, linewidth=3)
# for i in eachindex(dfs)
#     lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["H"], color=colors[i], linewidth=0.5)
# end

for i in eachindex(dfs)
    if i in selected_index
        lines!(ax, dfs[i]["time"] ./ 1e3, dfs[i]["H"], color=colors[i], linewidth=2)
    end
end

# d) P(H)
ax = Axis(fig[4, 1], ylabel=L"$P(H)$ ($\mathrm{kyr}$)", xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))

ylims!(ax, (15, 160))
xlims!(ax, (-2e3, 0.0))

W1, periods1 = create_WV(dfs[end]["time"][:], dfs[end]["H"][:])
cmap = cgrad([:gray99, :firebrick], 15, categorical=true)
opts = (colormap=cmap, levels=0.0:0.01:0.16) #extendlow=:white, extendhigh=:darkred)
cf = contourf!(ax, dfs[end]["time"][:] ./ 1e3, periods1 ./ 1e3, W1; opts...)

Colorbar(fig[4, 2], cf, height=Relative(2 / 3),
    label=L"NSP($H$)", ticklabelsize=fontsize, labelsize=fontsize, vertical=true, #halign=0.0, valign=1.1,
    ticks=([0.0, 0.05, 0.1, 0.15], convert_strings_to_latex([0, 0.05, 0.1, 0.15])))

# W1, periods1 = create_WV(df_nosedim01["time"][:], df_nosedim01["H"][:])
# cmap = cgrad([:gray99, :black], 12, categorical=true)
# opts = (colormap=cmap, levels=0.0:0.02:0.2, linewidth=1.0)
# contour!(ax, dfs[end]["time"][:] ./ 1e3, periods1 ./ 1e3, W1; opts...)

hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)
text!(ax, -1990, 110, text=d_label, align=(:left, :center))

# for i in eachindex(dfs)
#     if i in selected_index
#         W1, periods1 = create_WV(dfs[i]["time"][:], dfs[i]["H"][:])
#         curvemax = [periods1[argmax(W1[i, :])] ./ 1e3 for i in eachindex(dfs[i]["time"])]
#         lines!(ax, dfs[i]["time"] ./ 1e3, curvemax, color=colors[i], linewidth=2)
#     end
# end
# W1, periods1 = create_WV(df_nosedim01["time"][:], df_nosedim01["H"][:])
# curvemax = [periods1[argmax(W1[i, :])] ./ 1e3 for i in eachindex(df_nosedim01["time"][:])]
# lines!(ax, df_nosedim01["time"][:] ./ 1e3, curvemax, color=:black, linewidth=3)

rowgap!(fig.layout, 1, 20.0)
rowgap!(fig.layout, 2, 0.0)
rowgap!(fig.layout, 3, 20.0)

save("figures/fig15_TS.png", fig)
save("figures/fig15.pdf", fig)
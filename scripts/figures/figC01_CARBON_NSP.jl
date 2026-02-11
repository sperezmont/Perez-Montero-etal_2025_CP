include("header.jl")

searchdir(path,key) = filter(x->occursin(key,x), readdir(path))
cref_t(cref, deltaCmax, deltaCmin, tend, tinit, t) = cref + deltaCmax .- (deltaCmax .- deltaCmin)  ./ (tend .- tinit) .* (t .- tinit)
m_cref(deltaCmax, deltaCmin, tend, tinit) = (deltaCmax .- deltaCmin)  ./ (tend .- tinit) 
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
selected_labels = [L"(b)$\,$", L"(c)$\,$", L"(d)$\,$", L"(e)$\,$"]

colors = collect(cgrad([:plum4, :mediumpurple3, :plum3, :thistle, :darkorange,  :chocolate, :darkred], length(dfs), categorical=true))
boxes_color1, boxes_color2 = :grey40, :grey40
# Plot
fontsize=28
fig = Figure(resolution=(1200, 800), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2.3

ax = Axis(fig[1, 1], xgridvisible=false, ygridvisible=false, yaxisposition=:left, yscale=Makie.pseudolog10)
ax.xticks = xticks_time
ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))
hidexdecorations!(ax)
ylims!(ax, (15, 160))
xlims!(ax, (-2e3, 0.0))

t, H = df_nosedim01["time"][:], df_nosedim01["H"][:]
W1, periods1 = create_WV(t, H)
# for i in eachindex(t)
#     if H[i] <= 10
#         W1[i, :] .= 0.0
#     end
# end
cmap = cgrad([:gray99, :black], 15, categorical=true)
opts = (colormap=cmap, levels=0.0:0.01:0.16) #extendlow=:white, extendhigh=:darkred)
cf = contourf!(ax, df_nosedim01["C"]["time"][:] ./ 1e3, periods1 ./ 1e3, W1; opts...)

Colorbar(fig[1, 2], cf, height=Relative(2 / 3),
    ticklabelsize=fontsize, labelsize=fontsize, vertical=true, #halign=0.0, valign=1.1,
    ticks=([0.0, 0.05, 0.1, 0.15], convert_strings_to_latex([0, 0.05, 0.1, 0.15])))

# hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)
text!(ax, -1990, 110, text=a_label, align=(:left, :center))

ax = Axis(fig[1, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
hidespines!(ax, :t)
xlims!(ax, (-2e3, 0.0))
ylims!(ax, (-100, 3500))
hidedecorations!(ax)

lines!(ax, df_nosedim01["time"] ./ 1e3, df_nosedim01["H"], color=:grey80, linewidth=3)

for i in eachindex(selected_index)

    if i+1 == 3
        ax = Axis(fig[i+1, 1], ylabel=L"$P(H)$ ($\mathrm{kyr}$)", xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, yscale=Makie.pseudolog10)
    else
        ax = Axis(fig[i+1, 1], xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left, yscale=Makie.pseudolog10)
    end

    ax.xticks = xticks_time
    ax.yticks = (ticks_periods, convert_strings_to_latex(ticks_periods))

    if i < length(selected_index)
        hidexdecorations!(ax)
    end

    ylims!(ax, (15, 160))
    xlims!(ax, (-2e3, 0.0))

    t, H = dfs[selected_index[i]]["time"][:], dfs[selected_index[i]]["H"][:]
    W1, periods1 = create_WV(t, H)
    display((i, dfs[selected_index[i]]["Cref"][1], dfs[selected_index[i]]["Cref"][end], m_cref(dfs[selected_index[i]]["Cref"][1],
                        dfs[selected_index[i]]["Cref"][end],
                        dfs[selected_index[i]]["time"][1] ./ 1e3,
                        dfs[selected_index[i]]["time"][end] ./ 1e3)))
    # for i in eachindex(t)
    #     if H[i] <= 10
    #         W1[i, :] .= 0.0
    #     end
    # end
    cmap = cgrad([:gray99, colors[selected_index[i]]], 15, categorical=true)
    opts = (colormap=cmap, levels=0.0:0.01:0.16) #extendlow=:white, extendhigh=:darkred)
    cf = contourf!(ax, dfs[selected_index[i]]["time"][:] ./ 1e3, periods1 ./ 1e3, W1; opts...)

    if i+1 == 3
        Colorbar(fig[i+1, 2], cf, height=Relative(2 / 3),
            label=L"NSP($H$)", ticklabelsize=fontsize, labelsize=fontsize, vertical=true, #halign=0.0, valign=1.1,
            ticks=([0.0, 0.05, 0.1, 0.15], convert_strings_to_latex([0, 0.05, 0.1, 0.15])))
    else
        Colorbar(fig[i+1, 2], cf, height=Relative(2 / 3),
            ticklabelsize=fontsize, labelsize=fontsize, vertical=true, #halign=0.0, valign=1.1,
            ticks=([0.0, 0.05, 0.1, 0.15], convert_strings_to_latex([0, 0.05, 0.1, 0.15])))
    end
    # hlines!(ax, [20, 40, 100], linestyle=:dash, color=:black, linewidth=0.5)
    text!(ax, -1990, 110, text=selected_labels[i], align=(:left, :center))

    ax = Axis(fig[i+1, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
    ax.xticks = xticks_time
    ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
    hidespines!(ax, :t)
    xlims!(ax, (-2e3, 0.0))
    ylims!(ax, (-100, 3500))
    hidedecorations!(ax)
    lines!(ax, dfs[selected_index[i]]["time"][:] ./ 1e3, dfs[selected_index[i]]["H"][:], color=:grey80, linewidth=3)

end


save("figures/figC01_CARBON_NSP.png", fig)
save("figures/figC01.pdf", fig)
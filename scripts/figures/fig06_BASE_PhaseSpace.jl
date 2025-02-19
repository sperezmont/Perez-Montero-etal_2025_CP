include("header.jl")

# ===========================================================================================================
# Figure 3. BASE_PS
# ===========================================================================================================
df = NCDataset("data/runs/exp01/BASE/BASE.nc")
params = JLD2.load_object("data/runs/exp01/BASE/BASE_params.jld2")

xticks_time = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))

t, I, H, v, Hsed = cut_run(df["time"], df["time"], -1.5e6),
cut_run(df["time"], df["I"], -1.5e6),
cut_run(df["time"], df["H"], -1.5e6),
cut_run(df["time"], df["v"], -1.5e6),
cut_run(df["time"], df["Hsed"], -1.5e6)

idx40 = 75:105
t40, I40, H40, v40, Hsed40 = t[idx40], I[idx40], H[idx40], v[idx40], Hsed[idx40]

idx100 = 1380:1490
t100, I100, H100, v100, Hsed100 = t[idx100], I[idx100], H[idx100], v[idx100], Hsed[idx100]

# Plotting
fig = Figure(resolution=(750, 600), fonts=(; regular="TeX"), fontsize=28)

# Panel a.
ax = Axis(fig[1, 1:2], xlabel=time_label, xaxisposition=:top, ylabel=icethick_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks_time
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, ylims_ice)
xlims!(ax, xlims_time_short)
text!(ax, -1480, 1900, text=a_label, align=(:left, :center))

lines!(ax, t ./ 1e3, H, color=pacco_color, linewidth=1)
lines!(ax, t40 ./ 1e3, H40, color=:darkorange, linewidth=4)
lines!(ax, t100 ./ 1e3, H100, color=:royalblue, linewidth=4)

# Panel b.
ax = Axis(fig[2, 1], xlabel=ins_label, ylabel=icethick_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, ylims_ice)
text!(ax, 420, 1900, text=b_label, align=(:left, :center))

lines!(ax, I, H, color=pacco_color, linewidth=0.5)
lines!(ax, I40, H40, color=:darkorange, linewidth=4)
lines!(ax, I100, H100, color=:royalblue, linewidth=4)

# Panel c.
ax = Axis(fig[2, 2], xlabel=v_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = ([0, 50, 100], convert_strings_to_latex([0, 50, 100]))
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ylims!(ax, ylims_ice)
hideydecorations!(ax)
text!(ax, 120, 1900, text=c_label, align=(:left, :center))

lines!(ax, v, H, color=pacco_color, linewidth=0.5)
lines!(ax, v40, H40, color=:darkorange, linewidth=4)
lines!(ax, v100, H100, color=:royalblue, linewidth=4)

save("figures/fig06_BASE_PhaseSpace.png", fig)
save("figures/fig06.pdf", fig)


# Plotting
fig = Figure(fonts=(; regular="TeX"), fontsize=28)

# Panel a.
ax = Axis3(fig[1, 1], xlabel=ins_label, ylabel=icethick_label, zlabel=sed_label, xgridvisible=false, ygridvisible=false, zgridvisible=false)
ax.xticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ax.zticks = ([5, 6, 7, 8], convert_strings_to_latex([5, 6, 7, 8]))

lines!(ax, I, H, Hsed, color=pacco_color, linewidth=0.5)
lines!(ax, I40, H40, Hsed40, color=:darkorange, linewidth=4)
lines!(ax, I100, H100, Hsed100, color=:royalblue, linewidth=4)

# save("figures/supp_Hsed_BASE_PhaseSpace.png", fig)

# Plotting
fig = Figure(fonts=(; regular="TeX"), fontsize=28)

# Panel a.
ax = Axis3(fig[1, 1], xlabel=sed_label, zlabel=L"$H$ (km)", ylabel=ins_label, xgridvisible=false, ygridvisible=false, zgridvisible=false, xreversed=true, yreversed=true)
ax.yticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
ax.zticks = ([0, 1000, 2000], convert_strings_to_latex([0, 1, 2]))
ax.xticks = ([5, 6, 7, 8], convert_strings_to_latex([5, 6, 7, 8]))

lines!(ax, Hsed, I, H, color=pacco_color, linewidth=0.5)
lines!(ax, Hsed40, I40, H40, color=:darkorange, linewidth=4)
lines!(ax, Hsed100, I100, H100, color=:royalblue, linewidth=4)

# save("figures/supp_Hsed_BASE_PhaseSpace2.png", fig)

# Plotting
fig = Figure(fonts=(; regular="TeX"), fontsize=28)

# Panel a.
ax = Axis3(fig[1, 1], xlabel=ins_label, ylabel=icethick_label, zlabel=v_label, xgridvisible=false, ygridvisible=false, zgridvisible=false)
ax.xticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ax.zticks = ([0, 50, 100], convert_strings_to_latex([0, 50, 100]))

lines!(ax, I, H, v, color=pacco_color, linewidth=0.5)
lines!(ax, I40, H40, v40, color=:darkorange, linewidth=4)
lines!(ax, I100, H100, v100, color=:royalblue, linewidth=4)

# save("figures/supp_v_BASE_PhaseSpace.png", fig)

# Plotting
fig = Figure(fonts=(; regular="TeX"), fontsize=28)

# Panel a.
ax = Axis3(fig[1, 1], xlabel=v_label, zlabel=icethick_label, ylabel=ins_label, xgridvisible=false, ygridvisible=false, zgridvisible=false, xreversed=false)
ax.yticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
ax.zticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
ax.xticks = ([0, 50, 100], convert_strings_to_latex([0, 50, 100]))

lines!(ax, v, I, H, color=pacco_color, linewidth=0.5)
lines!(ax, v40, I40, H40, color=:darkorange, linewidth=4)
lines!(ax, v100, I100, H100, color=:royalblue, linewidth=4)

# save("figures/supp_v_BASE_PhaseSpace2.png", fig)
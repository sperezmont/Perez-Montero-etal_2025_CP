include("header.jl")

# ===========================================================================================================
# CC runs
# ===========================================================================================================
df_base = NCDataset("data/runs/exp01/BASE/BASE.nc")

df_CC5 = NCDataset("data/runs/exp03/CC/CC5.nc")
df_CC4 = NCDataset("data/runs/exp03/CC/CC4.nc")
df_CC3 = NCDataset("data/runs/exp03/CC/CC3.nc")
df_CC2 = NCDataset("data/runs/exp03/CC/CC2.nc")
df_CC1 = NCDataset("data/runs/exp03/CC/CC1.nc")

anomT_base = df_base["T"] .- df_base["Tref"]
anomT_CC5 = df_CC5["T"] .- df_CC5["Tref"]
anomT_CC4 = df_CC4["T"] .- df_CC4["Tref"]
anomT_CC3 = df_CC3["T"] .- df_CC3["Tref"]
anomT_CC2 = df_CC2["T"] .- df_CC2["Tref"]
anomT_CC1 = df_CC1["T"] .- df_CC1["Tref"]

sed_thr = 6
temp_thr = -5

mpt_base = findfirst(df_base["Hsed"] .<= sed_thr)
mpt_CC5 = findfirst(df_CC5["Hsed"] .<= sed_thr)
mpt_CC4 = findfirst(df_CC4["Hsed"] .<= sed_thr)
mpt_CC3 = findfirst(df_CC3["Hsed"] .<= sed_thr)
mpt_CC2 = findfirst(df_CC2["Hsed"] .<= sed_thr)
mpt_CC1 = findfirst(df_CC1["Hsed"] .<= sed_thr)

colors = [:darkred, :darkorange, :darkgreen, :royalblue, :slateblue4]

fontsize=28
fig = Figure(resolution=(1500, 1300), fonts=(; regular="Tex"), fontsize=fontsize)
xticks = (xticks_time_long, convert_strings_to_latex(-1 .* xticks_time_long))
linewidth = 3
calc_bins(n) = 2 * Int(round((n)^(1/3)))    # Rice criterion, k=2⋅(n)^{1/3}

# Panel a. C
ax = Axis(fig[1, 1], ylabel=carbon_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks
ax.yticks = (yticks_carbon2, convert_strings_to_latex(yticks_carbon2))
xlims!(ax, xlims_time_long)
ylims!(ax, ylims_carbon2)
hidespines!(ax, :b)
hidexdecorations!(ax)
text!(ax, -2.98e3, 450, text=L"(a) $\,$", align=(:left, :center))
lines!(ax, df_base["time"][1:mpt_base] ./ 1e3, df_base["C"][1:mpt_base], color=:grey, linewidth=4, label=L"BASE$\,$")
lines!(ax, df_base["time"][mpt_base+1:end] ./ 1e3, df_base["C"][mpt_base+1:end], color=:lightgray, linewidth=4)

lines!(ax, df_CC5["time"] ./ 1e3, df_CC5["C"], color=:darkred, linewidth=4, label=L"380 ppm$\,$")

lines!(ax, df_CC4["time"][1:mpt_CC4] ./ 1e3, df_CC4["C"][1:mpt_CC4], color=:darkorange, linewidth=4, label=L"300 ppm$\,$")
lines!(ax, df_CC4["time"][mpt_CC4:end] ./ 1e3, df_CC4["C"][mpt_CC4:end], color=:goldenrod1, linewidth=4)

lines!(ax, df_CC3["time"][1:mpt_CC3] ./ 1e3, df_CC3["C"][1:mpt_CC3], color=:darkgreen, linewidth=4, label=L"250 ppm$\,$")
lines!(ax, df_CC3["time"][mpt_CC3:end] ./ 1e3, df_CC3["C"][mpt_CC3:end], color=:olivedrab3, linewidth=4)

lines!(ax, df_CC2["time"][1:mpt_CC2] ./ 1e3, df_CC2["C"][1:mpt_CC2], color=:royalblue, linewidth=4, label=L"200 ppm$\,$")
lines!(ax, df_CC2["time"][mpt_CC2:end] ./ 1e3, df_CC2["C"][mpt_CC2:end], color=:skyblue1, linewidth=4)

lines!(ax, df_CC1["time"][1:mpt_CC1] ./ 1e3, df_CC1["C"][1:mpt_CC1], color=:slateblue4, linewidth=4, label=L"100 ppm$\,$")
lines!(ax, df_CC1["time"][mpt_CC1:end] ./ 1e3, df_CC1["C"][mpt_CC1:end], color=:plum, linewidth=4)

axislegend(ax, framevisible=false, position=(0.1, -1), labelsize=fontsize, nbanks=3)

# Panel b. H 380
ax = Axis(fig[2, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
xlims!(ax, xlims_time_long)
ylims!(ax, ylims_ice2)
hidespines!(ax, :b, :t)
hidexdecorations!(ax)
text!(ax, -2.98e3, 2000, text=L"(b) $\,$", align=(:left, :center))
lines!(ax, df_base["time"][1:mpt_base] ./ 1e3, df_base["H"][1:mpt_base], color=:grey, linewidth=3)
lines!(ax, df_base["time"][mpt_base+1:end] ./ 1e3, df_base["H"][mpt_base+1:end], color=:lightgray, linewidth=3)
lines!(ax, df_CC5["time"] ./ 1e3, df_CC5["H"], color=colors[1], linewidth=3)

# Panel c. H 300
ax = Axis(fig[3, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
xlims!(ax, xlims_time_long)
ylims!(ax, ylims_ice2)
hidespines!(ax, :b, :t)
hidexdecorations!(ax)
text!(ax, -2.98e3, 2000, text=L"(c) $\,$", align=(:left, :center))
lines!(ax, df_base["time"][1:mpt_base] ./ 1e3, df_base["H"][1:mpt_base], color=:grey, linewidth=3)
lines!(ax, df_base["time"][mpt_base+1:end] ./ 1e3, df_base["H"][mpt_base+1:end], color=:lightgray, linewidth=3)
lines!(ax, df_CC4["time"][1:mpt_CC4] ./ 1e3, df_CC4["H"][1:mpt_CC4], color=:darkorange, linewidth=3)
lines!(ax, df_CC4["time"][mpt_CC4:end] ./ 1e3, df_CC4["H"][mpt_CC4:end], color=:goldenrod1, linewidth=3)

# Panel d. H 250
ax = Axis(fig[4, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
xlims!(ax, xlims_time_long)
ylims!(ax, ylims_ice2)
hidespines!(ax, :b, :t)
hidexdecorations!(ax)
text!(ax, -2.98e3, 2000, text=L"(d) $\,$", align=(:left, :center))
lines!(ax, df_base["time"][1:mpt_base] ./ 1e3, df_base["H"][1:mpt_base], color=:grey, linewidth=3)
lines!(ax, df_base["time"][mpt_base+1:end] ./ 1e3, df_base["H"][mpt_base+1:end], color=:lightgray, linewidth=3)
lines!(ax, df_CC3["time"][1:mpt_CC3] ./ 1e3, df_CC3["H"][1:mpt_CC3], color=:darkgreen, linewidth=3)
lines!(ax, df_CC3["time"][mpt_CC3:end] ./ 1e3, df_CC3["H"][mpt_CC3:end], color=:olivedrab3, linewidth=3)

# Panel e. H 200
ax = Axis(fig[5, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
xlims!(ax, xlims_time_long)
ylims!(ax, ylims_ice2)
hidespines!(ax, :b, :t)
hidexdecorations!(ax)
text!(ax, -2.98e3, 2000, text=L"(e) $\,$", align=(:left, :center))
lines!(ax, df_base["time"][1:mpt_base] ./ 1e3, df_base["H"][1:mpt_base], color=:grey, linewidth=3)
lines!(ax, df_base["time"][mpt_base+1:end] ./ 1e3, df_base["H"][mpt_base+1:end], color=:lightgray, linewidth=3)
lines!(ax, df_CC2["time"][1:mpt_CC2] ./ 1e3, df_CC2["H"][1:mpt_CC2], color=:royalblue, linewidth=3)
lines!(ax, df_CC2["time"][mpt_CC2:end] ./ 1e3, df_CC2["H"][mpt_CC2:end], color=:skyblue1, linewidth=3)

# Panel f. H 100
ax = Axis(fig[6, 1], ylabel=icethick_label, xlabel=time_label, xgridvisible=false, ygridvisible=false, yaxisposition=:left)
ax.xticks = xticks
ax.yticks = (yticks_ice, convert_strings_to_latex(yticks_ice))
xlims!(ax, xlims_time_long)
ylims!(ax, ylims_ice2)
hidespines!(ax, :t)
text!(ax, -2.98e3, 2000, text=L"(f) $\,$", align=(:left, :center))
lines!(ax, df_base["time"][1:mpt_base] ./ 1e3, df_base["H"][1:mpt_base], color=:grey, linewidth=3)
lines!(ax, df_base["time"][mpt_base+1:end] ./ 1e3, df_base["H"][mpt_base+1:end], color=:lightgray, linewidth=3)
lines!(ax, df_CC1["time"][1:mpt_CC1] ./ 1e3, df_CC1["H"][1:mpt_CC1], color=:slateblue4, linewidth=3)
lines!(ax, df_CC1["time"][mpt_CC1:end] ./ 1e3, df_CC1["H"][mpt_CC1:end], color=:plum, linewidth=3)

# Panel g. Climate produced
ax = Axis(fig[1:6, 2], xlabel=temp_label, xgridvisible=false, ygridvisible=false, yaxisposition=:right)
ax.xticks = ([-20, -10, 0, 10], convert_strings_to_latex([-20, -10, 0, 10]))
ylims!(ax, (-0.1, 6.0))
hideydecorations!(ax)

norm = :pdf

hist!(ax, anomT_base[1:mpt_base], color=:gray, bins=calc_bins(length(anomT_base[1:mpt_base])), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=5, direction=:y, scale_to=0.8)
hist!(ax, anomT_base[mpt_base+1:end], color=:lightgray, bins=calc_bins(length(anomT_base[mpt_base+1:end])), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=5, direction=:y, scale_to=0.8)

text!(ax, -18, 5.8, text=L"(g) $\,$", align=(:left, :center))

hist!(ax, anomT_CC5, color=:darkred, bins=calc_bins(length(anomT_base)), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=4, direction=:y, scale_to=0.8)
text!(ax, -18, 4.8, text=L"(h) $\,$", align=(:left, :center))

hist!(ax, anomT_CC4[1:mpt_CC4], color=:darkorange, bins=calc_bins(length(anomT_base[1:mpt_CC4])), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=3, direction=:y, scale_to=0.8)
hist!(ax, anomT_CC4[mpt_CC4+1:end], color=:goldenrod1, bins=calc_bins(length(anomT_base[mpt_CC4+1:end])), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=3, direction=:y, scale_to=0.8)
text!(ax, -18, 3.8, text=L"(i) $\,$", align=(:left, :center))

hist!(ax, anomT_CC3[1:mpt_CC3], color=:darkgreen, bins=calc_bins(length(anomT_base[1:mpt_CC3])), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=2, direction=:y, scale_to=0.8)
hist!(ax, anomT_CC3[mpt_CC3+1:end], color=:olivedrab3, bins=calc_bins(length(anomT_base[mpt_CC3+1:end])), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=2, direction=:y, scale_to=0.8)
text!(ax, -18, 2.8, text=L"(j) $\,$", align=(:left, :center))

hist!(ax, anomT_CC2[1:mpt_CC2], color=:royalblue, bins=calc_bins(length(anomT_base[1:mpt_CC2])), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=1, direction=:y, scale_to=0.8)
hist!(ax, anomT_CC2[mpt_CC2+1:end], color=:skyblue1, bins=calc_bins(length(anomT_base[mpt_CC2+1:end])), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=1, direction=:y, scale_to=0.8)
text!(ax, -18, 1.8, text=L"(k) $\,$", align=(:left, :center))

hist!(ax, anomT_CC1[1:mpt_CC1], color=:slateblue4, bins=calc_bins(length(anomT_base[1:mpt_CC1])), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=0, direction=:y, scale_to=0.8)
hist!(ax, anomT_CC1[mpt_CC1+1:end], color=:plum, bins=calc_bins(length(anomT_base[mpt_CC1+1:end])), normalization=norm, strokewidth=0.5, strokecolor=:black, offset=0, direction=:y, scale_to=0.8)
text!(ax, -18, 0.8, text=L"(l) $\,$", align=(:left, :center))

scatter!(ax, median(anomT_base[1:mpt_base]), 5.9, color=:gray, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
scatter!(ax, median(anomT_base[mpt_base+1:end]), 5.9, color=:lightgray, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
# scatter!(ax, mode(anomT_base[1:mpt_base]), 5.0, color=:gray, strokecolor=:black, strokewidth=2, markersize=20)
# scatter!(ax, mode(anomT_base[mpt_base+1:end]), 5.0, color=:lightgray, strokecolor=:black, strokewidth=2, markersize=20)

scatter!(ax, median(anomT_CC5), 4.9, color=:darkred, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
# scatter!(ax, mode(anomT_CC5), 4.0, color=:darkred, strokecolor=:black, strokewidth=2, markersize=20)

scatter!(ax, median(anomT_CC4[1:mpt_CC4]), 3.9, color=:darkorange, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
scatter!(ax, median(anomT_CC4[mpt_CC4+1:end]), 3.9, color=:goldenrod1, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
# scatter!(ax, mode(anomT_CC4[1:mpt_CC4]), 3.0, color=:darkorange, strokecolor=:black, strokewidth=2, markersize=20)
# scatter!(ax, mode(anomT_CC4[mpt_CC4+1:end]), 3.0, color=:goldenrod1, strokecolor=:black, strokewidth=2, markersize=20)

scatter!(ax, median(anomT_CC3[1:mpt_CC3]), 2.9, color=:darkgreen, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
scatter!(ax, median(anomT_CC3[mpt_CC3+1:end]), 2.9, color=:olivedrab3, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
# scatter!(ax, mode(anomT_CC3[1:mpt_CC3]), 2.0, color=:darkgreen, strokecolor=:black, strokewidth=2, markersize=20)
# scatter!(ax, mode(anomT_CC3[mpt_CC3+1:end]), 2.0, color=:olivedrab3, strokecolor=:black, strokewidth=2, markersize=20)

scatter!(ax, median(anomT_CC2[1:mpt_CC2]), 1.9, color=:royalblue, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
scatter!(ax, median(anomT_CC2[mpt_CC2+1:end]), 1.9, color=:skyblue1, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
# scatter!(ax, mode(anomT_CC2[1:mpt_CC2]), 1.0, color=:royalblue, strokecolor=:black, strokewidth=2, markersize=20)
# scatter!(ax, mode(anomT_CC2[mpt_CC2+1:end]), 1.0, color=:skyblue1, strokecolor=:black, strokewidth=2, markersize=20)

scatter!(ax, median(anomT_CC1[1:mpt_CC1]), 0.9, color=:slateblue4, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
scatter!(ax, median(anomT_CC1[mpt_CC1+1:end]), 0.9, color=:plum, strokecolor=:black, strokewidth=0.5, markersize=25, marker=:dtriangle)
# scatter!(ax, mode(anomT_CC1[1:mpt_CC1]), 0.0, color=:slateblue4, strokecolor=:black, strokewidth=2, markersize=20)
# scatter!(ax, mode(anomT_CC1[mpt_CC1+1:end]), 0.0, color=:plum, strokecolor=:black, strokewidth=2, markersize=20)

#vlines!(ax, temp_thr, color=:red, linestyle=:dash, linewidth=2)

colsize!(fig.layout, 2, Relative(1/4))
rowgap!(fig.layout, 0.0)

save("figures/fig10_CC_runs.png", fig)
save("figures/fig10.pdf", fig)

# fig = Figure(resolution=(2000, 500), fonts=(; regular="Tex"), fontsize=fontsize)
# ax = Axis(fig[1, 1], ylabel=temp_label, xlabel=ins_label, xgridvisible=false, ygridvisible=false)
# ax.yticks = (yticks_temp, convert_strings_to_latex(yticks_temp))
# ax.xticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
# ylims!(ax, ylims_temp)
# xlims!(ax, ylims_ins)
# lines!(ax, df_base["I"][1:mpt_base], anomT_base[1:mpt_base], color=:gray, linewidth=1)
# lines!(ax, df_base["I"][mpt_base+1:end], anomT_base[mpt_base+1:end], color=:lightgray, linewidth=1)
# hlines!(ax, temp_thr, color=:red, linestyle=:dash, linewidth=2)

# ax = Axis(fig[1, 2], ylabel=temp_label, xlabel=ins_label, xgridvisible=false, ygridvisible=false)
# hideydecorations!(ax)
# ax.yticks = (yticks_temp, convert_strings_to_latex(yticks_temp))
# ax.xticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
# ylims!(ax, ylims_temp)
# xlims!(ax, ylims_ins)
# lines!(ax, df_CC5["I"], anomT_CC5, color=:darkred, linewidth=1)
# hlines!(ax, temp_thr, color=:red, linestyle=:dash, linewidth=2)

# ax = Axis(fig[1, 3], ylabel=temp_label, xlabel=ins_label, xgridvisible=false, ygridvisible=false)
# hideydecorations!(ax)
# ax.yticks = (yticks_temp, convert_strings_to_latex(yticks_temp))
# ax.xticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
# ylims!(ax, ylims_temp)
# xlims!(ax, ylims_ins)
# lines!(ax, df_CC4["I"][1:mpt_CC4], anomT_CC4[1:mpt_CC4], color=:darkorange, linewidth=1)
# lines!(ax, df_CC4["I"][mpt_CC4+1:end], anomT_CC4[mpt_CC4+1:end], color=:goldenrod1, linewidth=1)
# hlines!(ax, temp_thr, color=:red, linestyle=:dash, linewidth=2)

# ax = Axis(fig[1, 4], ylabel=temp_label, xlabel=ins_label, xgridvisible=false, ygridvisible=false)
# hideydecorations!(ax)
# ax.yticks = (yticks_temp, convert_strings_to_latex(yticks_temp))
# ax.xticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
# ylims!(ax, ylims_temp)
# xlims!(ax, ylims_ins)
# lines!(ax, df_CC3["I"][1:mpt_CC3], anomT_CC3[1:mpt_CC3], color=:darkgreen, linewidth=1)
# lines!(ax, df_CC3["I"][mpt_CC3+1:end], anomT_CC3[mpt_CC3+1:end], color=:olivedrab3, linewidth=1)
# hlines!(ax, temp_thr, color=:red, linestyle=:dash, linewidth=2)

# ax = Axis(fig[1, 5], ylabel=temp_label, xlabel=ins_label, xgridvisible=false, ygridvisible=false)
# hideydecorations!(ax)
# ax.yticks = (yticks_temp, convert_strings_to_latex(yticks_temp))
# ax.xticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
# ylims!(ax, ylims_temp)
# xlims!(ax, ylims_ins)
# lines!(ax, df_CC2["I"][1:mpt_CC2], anomT_CC2[1:mpt_CC2], color=:royalblue, linewidth=1)
# lines!(ax, df_CC2["I"][mpt_CC2+1:end], anomT_CC2[mpt_CC2+1:end], color=:skyblue1, linewidth=1)
# hlines!(ax, temp_thr, color=:red, linestyle=:dash, linewidth=2)

# ax = Axis(fig[1, 6], ylabel=temp_label, xlabel=ins_label, xgridvisible=false, ygridvisible=false)
# hideydecorations!(ax)
# ax.yticks = (yticks_temp, convert_strings_to_latex(yticks_temp))
# ax.xticks = (yticks_insol, convert_strings_to_latex(yticks_insol))
# ylims!(ax, ylims_temp)
# xlims!(ax, ylims_ins)
# lines!(ax, df_CC1["I"][1:mpt_CC1], anomT_CC1[1:mpt_CC1], color=:slateblue4, linewidth=1)
# lines!(ax, df_CC1["I"][mpt_CC1+1:end], anomT_CC1[mpt_CC1+1:end], color=:plum, linewidth=1)
# hlines!(ax, temp_thr, color=:red, linestyle=:dash, linewidth=2)

# save("figures/supp_8_CC_runs_PS.png", fig)

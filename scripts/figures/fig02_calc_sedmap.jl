using Pkg
Pkg.activate(".")
using NCDatasets, JLD2
using CSV, DataFrames, CairoMakie, Statistics, StatsBase, GeoMakie, Interpolations
include("header.jl")
fontsize=25
calc_bins(n) = 2 * Int(round((n)^(1/3)))    # Rice criterion, k=2⋅(n)^{1/3}
calc_bandwith(data, n) = 0.9 .* min(std(data), iqr(data)*(1/sqrt(2))) .* n^(-1/5) # Silverman's rule of thumb

color_pd = :grey60#:red#:firebrick
color_is = :royalblue1 #RGBA{Float64}(0.3, 0.65, 0.9,1.0)

# Read sediments and topography data
path2sedmap = "./data/paleo_records/Sed_ECM1.txt"
d = CSV.read(path2sedmap, DataFrame, delim="\t", header=1)
lon, lat, Hsed = d[!, "Lon"], d[!, "Lat"], d[!, "Sed"] 
nlon, nlat = 360, 180
Lon = reverse(reshape(lon, nlon, nlat), dims=2)
Lat = reverse(reshape(lat, nlon, nlat), dims=2)
S = reverse(reshape(Hsed, nlon, nlat), dims=2)
lon1D = Lon[:, 1]
lat1D = Lat[1, :]
itp = linear_interpolation((lon1D, lat1D), S, extrapolation_bc = (Interpolations.Periodic(), Interpolations.Flat()))

path2icemap = "./data/paleo_records/I7G_NA.VM7_1deg.26.nc"
d_ice = NCDataset(path2icemap)
lon_ice, lat_ice, Ice = d_ice["lon"], d_ice["lat"], d_ice["stgit"]
lon_ice2D = reduce(hcat, [lon_ice[:] for i in eachindex(lat_ice)])
lat_ice2D = reduce(vcat, [lat_ice[:]' for i in eachindex(lon_ice)])

path2pdmap = "./data/paleo_records/I7G_NA.VM7_1deg.0.nc"
d_pd = NCDataset(path2pdmap)
lon_pd, lat_pd, Continents = d_pd["lon"], d_pd["lat"], d_pd["Topo"]
lon_pd2D = reduce(hcat, [lon_pd[:] for i in eachindex(lat_pd)])
lat_pd2D = reduce(vcat, [lat_pd[:]' for i in eachindex(lon_pd)])

# Setup local variables
set_theme!(theme_latexfonts())
threshold = 10.0
sedlevels = log10.([1, 10, 100, 1000, 10000]) 
sedmap = cgrad(:copper, (sedlevels) ./ (4) , rev=true, categorical=true)#, scale=Makie.pseudolog10)
minlat, maxlat = 35, 90

# Interpole sed data to ice coordinates:
Sitp = itp.(lon_ice2D, lat_ice2D)

# Create ice and pd emerged land masks
mask_lgm = copy(Ice)
mask_lgm[mask_lgm .<= threshold] .= 0
mask_lgm[mask_lgm .> threshold] .= 1
mask_lgm[lat_ice2D .< minlat] .= 0
#mask_lgm[Continents .<= 0] .= 0    # present-day river basins! 

mask_pd = copy(Continents)
mask_pd[mask_pd .<= 0] .= 0
mask_pd[mask_pd .> 0] .= 1
mask_pd[mask_lgm .== 1] .= 0
mask_pd[lat_pd2D .< minlat] .= 0
mask_pd[Continents .<= 0] .= 0    # present-day river basins! 

Sitp[lat_ice2D .< minlat] .= -9999

Sitp2 = copy(Sitp)
Sitp2[Sitp .> 1e4] .= NaN
Sitp2[Continents .<= 0] .= NaN    # present-day river basins! 
Sitp[Sitp .< 0.0] .= NaN
Sitp[Continents .<= 0] .= NaN    # present-day river basins! 

# Get filtered data (not arrays)
# z_lgm0, z_lgm, z_pd = copy(Sitp2), copy(Sitp2), copy(Sitp2)
# z_lgm0, z_lgm, z_pd = z_lgm0[mask_lgm0 .== 1], z_lgm[mask_lgm .== 1], z_pd[mask_pd .== 1]
z_lgm, z_pd = copy(Sitp2), copy(Sitp2)
z_lgm, z_pd = z_lgm[mask_lgm .== 1], z_pd[mask_pd .== 1]

# z_lgm0[isinf.(z_lgm0)] .= 0.0
z_lgm[isinf.(z_lgm)] .= 0.0
z_pd[isinf.(z_pd)] .= 0.0

z_pd_hist = log10.(filter(!isnan, filter(!isinf, z_pd)))
z_lgm_hist = log10.(filter(!isinf, filter(!isnan, z_lgm)))

z_pd_hist[isinf.(z_pd_hist)] .= 0.0
z_lgm_hist[isinf.(z_lgm_hist)] .= 0.0

# Plot
fig = Figure(resolution=(650, 900), fonts=(; regular="Makie"), fontsize=fontsize)
ax1 = GeoMakie.GeoAxis(fig[1, 1], dest = "+proj=stere +lat_0=90 +lat_ts=71", aspect = DataAspect())
ax1.xgridvisible=true
ax1.ygridvisible=true
ax1.xminorgridvisible=false
ax1.yminorgridvisible=false
ax1.xticklabelsvisible[] = false
ax1.yticklabelsvisible[] = false

ax1.yticks = minlat:15:maxlat
ax1.xticks = 0:45:360
ax1.xgridstyle = :dash
ax1.ygridstyle = :dash

hm = heatmap!(ax1, lon_ice, lat_ice, log10.(Sitp), colorrange=(sedlevels[1], sedlevels[end]), colormap=sedmap, lowclip=sedmap[1], highclip=sedmap[end], nan_color=:white)
contour!(ax1, lon_pd, lat_pd, mask_pd, levels=[0.5], color=color_pd, linewidth=3)
contour!(ax1, lon_ice, lat_ice, mask_lgm, levels=[0.5], color=color_is, linewidth=2)
xlims!(ax1, (0, 360))
ylims!(ax1, (0.9*minlat, maxlat))

lines!(ax1, [minlat for theta in 0:1:360], color=:black)

text!(ax1, -125, 25, text=L"(a) $\,$", align=(:left, :center))

Colorbar(fig[1, 2], hm, height=Relative(1/3), label=L"Sediment thickness (PD)$\,$",  halign=0.9,
       ticks=([0, 1, 2, 3, 4], convert_strings_to_latex([L"0$\,$", L"10\,m$\,$", L"100\,m$\,$", L"1\,km$\,$", L"10\,km$\,$"])),
        vertical=true, flipaxis = true)

ax = Axis(fig[3, 1:2], xlabel=L"Sediment thickness$\,$", ylabel=L"Frequency (points)$\,$", xgridvisible=false, ygridvisible=false, yaxisposition=:right)
ax.xticks = (log10.([1e0, 1e1, 1e2, 1e3, 1e4]), convert_strings_to_latex([L"1\,m$\,$", L"10\,m$\,$", L"100\,m$\,$", L"1\,km$\,$", L"10\,km$\,$"]))
ax.yticks = ([0, 500, 1000, 1500], convert_strings_to_latex([L"0$\,$", L"500$\,$", L"1000$\,$", L"1500$\,$"]))
hidespines!(ax, :t, :l)
text!(ax, log10(1), 1400, text=L"(b) $\,$", align=(:left, :center))
xlims!(ax, (0, 4))
hist!(ax, z_pd_hist, color=color_pd, bins=calc_bins(length(z_pd_hist)), strokewidth=0.5, strokecolor=:black, direction=:y, label=L"\mathrm{Beyond~LGM~ice~sheets}")
hist!(ax, z_lgm_hist, color=(color_is, 0.0), bins=calc_bins(length(z_lgm_hist)), strokewidth=3, strokecolor=color_is, direction=:y, label=L"\mathrm{Below~LGM~ice~sheets}")

fig[2, 1:2] = Legend(fig, ax, framevisible=false, halign=0.0, labelsize=21, nbanks=2, patchsize=(40, 30), linewidth=6)

# ax = Axis(fig[3, 1:2], xgridvisible=false, ygridvisible=false, yaxisposition=:left)
# hidexdecorations!(ax)
# hideydecorations!(ax)
# hidespines!(ax)
# xlims!(ax, (0, 4))
# density!(z_pd_hist, bandwidth=calc_bandwith(z_pd_hist, length(z_pd_hist)), color=:transparent, strokecolor=color_pd, strokewidth=1, linestyle=:dash)
# density!(z_lgm_hist, bandwidth=calc_bandwith(z_lgm_hist, length(z_lgm_hist)), color=:transparent, strokecolor=color_is, strokewidth=1, linestyle=:dash)

# axislegend(ax, framevisible=false, position=:ct, labelsize=fontsize, nbanks=2)

# text!(ax, 1e4, 1e3, text=L"\mu~=")
# text!(ax, 1e4, 0.5e3, text=L"q_2~=")
# text!(ax, 1e4, 1e2, text=L"mode~=")

rowsize!(fig.layout, 2, Relative(0.05))
rowsize!(fig.layout, 3, Relative(1/3))

colsize!(fig.layout, 2, Relative(1/5))
colgap!(fig.layout, 1, -100)
rowgap!(fig.layout, 1, 0)
# resize_to_layout!(fig)
save("./figures/fig02_sedmap.png", fig)
save("./figures/fig02.pdf", fig)



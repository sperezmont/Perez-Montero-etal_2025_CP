include("header.jl")

# ===========================================================================================================
# fv vs fa (NOTE: fa stands for fp parameter)
# ===========================================================================================================
files = readdir("data/runs/exp02/SEDIM/")
df_base = NCDataset("data/runs/exp01/BASE/BASE.nc")                      # fv = 1.4e-7; fa = 3.0e-5
params_base = JLD2.load_object("data/runs/exp01/BASE/BASE_params.jld2")

sed_thr = 6

quarryings = vcat(5:0.1:9, 10:1:100) .* 1e-8     # 5e-8 to 1e-6
weatherings = vcat(0.1:0.05:0.9, 1:0.5:9, 10:5:90, 100:50:1000) .* 1e-6   # 1e-7 to 1e-3  

ny, nx = length(quarryings), length(weatherings)
y, x = 1:1:ny, 1:1:nx

cmap = [:orangered4, :darkorange4, :orange4, :darkorange3, :darkorange, :orange, :burlywood1,   # colors before MPT
    :darkgreen,                                                     # colors during MPT
    :lightsteelblue, :steelblue3, :royalblue]       
cmap = [RGBA{Float64}(1.0,0.3,0.3,1.0), # colors before MPT
        RGBA{Float64}(1.0,0.4,0.3,1.0),
        RGBA{Float64}(1.0,0.5,0.3,1.0),
        RGBA{Float64}(1.0,0.6,0.3,1.0),
        RGBA{Float64}(1.0,0.7,0.3,1.0),
        RGBA{Float64}(1.0,0.8,0.3,1.0),
        RGBA{Float64}(1.0,1.0,0.3,1.0),
        RGBA{Float64}(0.3,0.6,0.3,1.0),      # colors during MPT
        RGBA{Float64}(0.6, 0.8, 0.9,1.0),   #colors after MPT
        RGBA{Float64}(0.5, 0.75, 0.9,1.0),
        RGBA{Float64}(0.4, 0.7, 0.9,1.0),
        RGBA{Float64}(0.3, 0.65, 0.9,1.0),
        RGBA{Float64}(0.2, 0.6, 0.9,1.0),
        RGBA{Float64}(0.1, 0.55, 0.9,1.0),
        RGBA{Float64}(0.0, 0.5, 0.9,1.0),
        ]       
normalized_position(x) = (-3000.0 .- x) ./ -3000.0
colorpositions = normalized_position([-3000, -2750, -2500, -2250,
        -2000, -1750, -1500, vlines_mpt[1],
        vlines_mpt[2], -600, -500, -400, -300, -200, -100, 0])
colormap = cgrad(cmap,
    colorpositions,
    categorical=true)

mat = Matrix{Float32}(undef, nx, ny)
mpt_mask = zeros(nx, ny)
for i in 1:Int(length(files))
    if files[i][end-2:end] == ".nc"
        df = NCDataset("data/runs/exp02/SEDIM/$(files[i])")
        params = JLD2.load_object("data/runs/exp02/SEDIM/$(files[i][1:end-3])_params.jld2")

        y_idx, x_idx = findmin(abs.(quarryings .- params.quarrying_frac))[2], findmin(abs.(weatherings .- params.weathering_frac))[2]

        if df["Hsed"][end] < df["Hsed"][1]
            mpt_occurs_at = findfirst(df["Hsed"] .<= sed_thr)

            if isnothing(mpt_occurs_at)
                mat[x_idx, y_idx] = df["time"][end] / 1e3 + 100 # to saturate color
            else
                mat[x_idx, y_idx] = df["time"][mpt_occurs_at] / 1e3
            end
        else
            mat[x_idx, y_idx] = NaN32
        end
    end
end

# Plotting
fontsize = 28
fig = Figure(resolution=(750, 750), fonts=(; regular="TeX"), fontsize=fontsize)
linewidth = 2.3

ax = Axis(fig[2, 1], ylabel=L"$f_v$$\,$", xlabel=L"$f_{\dot{p}}$", xgridvisible=false, ygridvisible=false, yaxisposition=:left, yminorticksvisible=true, xminorticksvisible=true, aspect=1)
ax.yticks = (log10.([1e-7, 1e-6]), convert_strings_to_latex(["10^{-7}", "10^{-6}"]))
ax.yminorticks = log10.(vcat(5e-8:1e-8:9e-8, 1e-7:1e-7:1e-6))
ax.xticks = (log10.([1e-7, 1e-6, 1e-5, 1e-4, 1e-3]), convert_strings_to_latex(["10^{-7}", "10^{-6}", "10^{-5}", "10^{-4}", "10^{-3}"]))
ax.xminorticks = log10.(vcat(1e-7:1e-7:9e-7, 1e-6:1e-6:9e-6, 1e-5:1e-5:9e-5, 1e-4:1e-4:1e-3))
hm = heatmap!(ax, log10.(weatherings), log10.(quarryings), mat, colorrange=(-3000, 0), colormap=colormap, highclip=RGBA{Float64}(0.6,0.6,0.95,1.0), nan_color=:grey30)

# for i in weatherings, j in quarryings
#     scatter!(ax, log10.(i), log10.(j), color=:black, strokecolor=:black, strokewidth=0.1, markersize=1)
# end

Colorbar(fig[1, 1], hm, width=Relative(2.3 / 3),
    ticklabelsize=fontsize, labelsize=fontsize,
    label=L"$t_\mathrm{MPT}$ (kyr BP)",
    ticks=([-3000, -2000, -1250, -700, -300, 0], [L"3000$\,$", L"2000$\,$", L"1250$\,$", L"700$\,$", L"300$\,$", L"0$\,$"]),
    vertical=false
)

mpt_occurs_at = findfirst(df_base["Hsed"] .<= sed_thr)
base_mpt = -1 .* (((df_base["time"][mpt_occurs_at] / 1e3) .- (vlines_mpt[1])))
display((df_base["time"][mpt_occurs_at] / 1e3) .- (vlines_mpt[1]))
hlines!(ax, log10.(params_base.quarrying_frac), linestyle=:dash, color=:black, linewidth=3)
vlines!(ax, log10.(params_base.weathering_frac), linestyle=:dash, color=:black, linewidth=3)
base_mpt_color = :black

text!(ax, log10.(params_base.weathering_frac) - 0.05, log10.(params_base.quarrying_frac) + 0.05, text=L"BASE$\,$", align=(:right, :center), fontsize=fontsize)
scatter!(ax, log10.(params_base.weathering_frac), log10.(params_base.quarrying_frac), color=base_mpt_color, strokecolor=:black, strokewidth=2, markersize=12)

resize_to_layout!(fig)
CairoMakie.trim!(fig.layout)
save("figures/fig08_fvVSfa.png", fig)
save("figures/fig08.pdf", fig)

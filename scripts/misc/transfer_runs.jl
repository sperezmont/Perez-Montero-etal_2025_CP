using Pkg
Pkg.activate(".")

locpacco = "/home/sergio/entra/models/pacco_vers/pacco_v0.6/"
locdir = "/home/sergio/entra/proyects/d06_Perez-Montero-etal_2025_CP/"

locexps = "$(locpacco)/output/Perez-Montero-etal_2025_CP/"

function get_runs(exp_path::String, subdirs::Vector)
    runs = []
    for s in subdirs
        push!(runs, readdir("$(exp_path)/$(s)"))
    end
    return runs
end

function format_runs(runs)

    return new_runs, new_params
end

function move_runs!(runs, path2runs::String, path2store::String)
    for r in eachindex(runs)
        run = runs[r]
        cp("$(path2runs)/$(run)/pacco.nc", "$(path2store)/$(run).nc", force=true)
        cp("$(path2runs)/$(run)/params.jld2", "$(path2store)/$(run)_params.jld2", force=true)
    end

    return nothing
end

function transfer_runs_from_pacco!(exp_path::String, subdirs::Vector, path2data::String)
    runs = get_runs(exp_path, subdirs)

    # Check if experiment directory exists
    isdir(path2data) || mkdir(path2data)

    for s in eachindex(subdirs)
        # Create if necessary the subdirectories
        isdir("$(path2data)/$(subdirs[s])/") || mkdir("$(path2data)/$(subdirs[s])/")

        # Move runs from PACCO local folder to the desired directory
        move_runs!(runs[s], "$(exp_path)/$(subdirs[s])/", "$(path2data)/$(subdirs[s])/")
    end

    return nothing
end

# exp01, BASE
transfer_runs_from_pacco!("$(locexps)/exp01/", ["BASE"], "$(locdir)/data/runs/exp01/")

# exp02, SEDIM 
# transfer_runs_from_pacco!("$(locexps)/exp02/", ["SEDIM"], "$(locdir)/data/runs/exp02/")

# exp03, CC 
transfer_runs_from_pacco!("$(locexps)/exp03/", ["CC"], "$(locdir)/data/runs/exp03/")

# exp04, INSOL 
transfer_runs_from_pacco!("$(locexps)/exp04/", ["INSOL"], "$(locdir)/data/runs/exp04/")

# exp05, NOSEDIM, TC, TS 
transfer_runs_from_pacco!("$(locexps)/exp05/", ["NOSEDIM", "TC", "TS"], "$(locdir)/data/runs/exp05/")

# appendix, BASE-CSI
transfer_runs_from_pacco!("$(locexps)/appendix/", ["BASE-CSI"], "$(locdir)/data/runs/appendix/")

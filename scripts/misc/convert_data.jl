using Pkg
Pkg.activate(".")
using NCDatasets, JLD2
include("tools.jl")

## Berends et al., 2020
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/Vol/berends-etal_2020.nc", -8.0e5, 0.0, 1e3)
mv("data/paleo_records/berends-etal_2020.jld2", "data/paleo_records/berends-etal_2020_Vol_800.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/Vol/berends-etal_2020.nc", -1.5e6, 0.0, 1e3)
mv("data/paleo_records/berends-etal_2020.jld2", "data/paleo_records/berends-etal_2020_Vol_1500.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/Vol/berends-etal_2020.nc", -3.0e6, 0.0, 1e3)
mv("data/paleo_records/berends-etal_2020.jld2", "data/paleo_records/berends-etal_2020_Vol_3000.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/C/berends-etal_2020.nc", -8.0e5, 0.0, 1e3)
mv("data/paleo_records/berends-etal_2020.jld2", "data/paleo_records/berends-etal_2020_C_800.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/C/berends-etal_2020.nc", -1.5e6, 0.0, 1e3)
mv("data/paleo_records/berends-etal_2020.jld2", "data/paleo_records/berends-etal_2020_C_1500.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/C/berends-etal_2020.nc", -3.0e6, 0.0, 1e3)
mv("data/paleo_records/berends-etal_2020.jld2", "data/paleo_records/berends-etal_2020_C_3000.jld2", force=true)

## Yamamoto et al., 2022
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/C/yamamoto-etal_2022.nc", -8.0e5, 0.0, 1e3)
mv("data/paleo_records/yamamoto-etal_2022.jld2", "data/paleo_records/yamamoto-etal_C_800.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/C/yamamoto-etal_2022.nc", -1.5e6, 0.0, 1e3)
mv("data/paleo_records/yamamoto-etal_2022.jld2", "data/paleo_records/yamamoto-etal_C_1500.jld2", force=true)

## Lisiecki and Raymo, 2005
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/d18O/lisiecki-raymo_2005.nc", -8.0e5, 0.0, 1e3)
mv("data/paleo_records/lisiecki-raymo_2005.jld2", "data/paleo_records/lisiecki-raymo_2005_d18O_800.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/d18O/lisiecki-raymo_2005.nc", -1.5e6, 0.0, 1e3)
mv("data/paleo_records/lisiecki-raymo_2005.jld2", "data/paleo_records/lisiecki-raymo_2005_d18O_1500.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/d18O/lisiecki-raymo_2005.nc", -5.0e6, 0.0, 1e3)
mv("data/paleo_records/lisiecki-raymo_2005.jld2", "data/paleo_records/lisiecki-raymo_2005_d18O_5000.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/T/lisiecki-raymo_2005.nc", -8.0e5, 0.0, 1e3)
mv("data/paleo_records/lisiecki-raymo_2005.jld2", "data/paleo_records/lisiecki-raymo_2005_T_800.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/T/lisiecki-raymo_2005.nc", -5.0e6, 0.0, 1e3)
mv("data/paleo_records/lisiecki-raymo_2005.jld2", "data/paleo_records/lisiecki-raymo_2005_T_5000.jld2", force=true)

## Bintanja and van de Wal, 2008
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/Vol/bintanja-vandewal_2008.nc", -8.0e5, 0.0, 1e3)
mv("data/paleo_records/bintanja-vandewal_2008.jld2", "data/paleo_records/bintanja-vandewal_2008_800.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/Vol/bintanja-vandewal_2008.nc", -3.0e6, 0.0, 1e3)
mv("data/paleo_records/bintanja-vandewal_2008.jld2", "data/paleo_records/bintanja-vandewal_2008_3000.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/T/bintanja-vandewal_2008.nc", -8.0e5, 0.0, 1e3)
mv("data/paleo_records/bintanja-vandewal_2008.jld2", "data/paleo_records/bintanja-vandewal_2008_T_800.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/T/bintanja-vandewal_2008.nc", -3.0e6, 0.0, 1e3)
mv("data/paleo_records/bintanja-vandewal_2008.jld2", "data/paleo_records/bintanja-vandewal_2008_T_3000.jld2", force=true)

## Lüthi et al., 2008
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/C/luthi-etal_2008.nc", -8.0e5, 0.0, 1e3)

## Barker et al., 2011
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/T/barker-etal_2011.nc", -8.0e5, 0.0, 1e3)

## Spratt and Lisiecki, 2016
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/Vol/spratt-lisiecki_2016.nc", -8.0e5, 0.0, 1e3)

## Ahn et al., 2017
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/d18O/ahn-etal_2017.nc", -8.0e5, 0.0, 1e3)
mv("data/paleo_records/ahn-etal_2017.jld2", "data/paleo_records/ahn-etal_2017_800.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/d18O/ahn-etal_2017.nc", -1.5e6, 0.0, 1e3)
mv("data/paleo_records/ahn-etal_2017.jld2", "data/paleo_records/ahn-etal_2017_1500.jld2", force=true)

## Hodell et al., 2023
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/T/hodell-etal_2023.nc", -8.0e5, 0.0, 1e3)
mv("data/paleo_records/hodell-etal_2023.jld2", "data/paleo_records/hodell-etal_2023_T_800.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/d18O/hodell-etal_2023.nc", -8.0e5, 0.0, 1e3)
mv("data/paleo_records/hodell-etal_2023.jld2", "data/paleo_records/hodell-etal_2023_d18O_800.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/d18O/hodell-etal_2023.nc", -1.40e6, 0.0, 1e3)
mv("data/paleo_records/hodell-etal_2023.jld2", "data/paleo_records/hodell-etal_2023_d18O_1500.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/T/hodell-etal_2023.nc", -1.40e6, 0.0, 1e3)
mv("data/paleo_records/hodell-etal_2023.jld2", "data/paleo_records/hodell-etal_2023_T_1500.jld2", force=true)

## Clark et al., 2024
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/T/clark-etal_2024.nc", -4.5e6, 0.0, 1e3)
mv("data/paleo_records/clark-etal_2024.jld2", "data/paleo_records/clark-etal_2024_T_4500.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/SST/clark-etal_2024_NHextratropics.nc", -4.5e6, 0.0, 1e3)
mv("data/paleo_records/clark-etal_2024_NHextratropics.jld2", "data/paleo_records/clark-etal_2024_sst_4500.jld2", force=true)

## Clark et al., 2025
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/d18O/clark-etal_2025_d18OT.nc", -4.5e6, 0.0, 1e3)
mv("data/paleo_records/clark-etal_2025_d18OT.jld2", "data/paleo_records/clark-etal_2025_d18OT_4500.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/d18O/clark-etal_2025_d18Osw.nc", -4.5e6, 0.0, 1e3)
mv("data/paleo_records/clark-etal_2025_d18Osw.jld2", "data/paleo_records/clark-etal_2025_d18Osw_4500.jld2", force=true)

## Clark et al., 2025b
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/Vol/clark-etal_2025b.nc", -4.5e6, 0.0, 1e3)
mv("data/paleo_records/clark-etal_2025b.jld2", "data/paleo_records/clark-etal_2025b_Vol_4500.jld2", force=true)

## Elderfield et al., 2012
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/d18O/elderfield-etal_2012.nc", -1.6e6, 0.0, 1e3)
mv("data/paleo_records/elderfield-etal_2012.jld2", "data/paleo_records/elderfield-etal_2012_d18O_1500.jld2", force=true)

convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/Vol/elderfield-etal_2012.nc", -1.6e6, 0.0, 1e3)
mv("data/paleo_records/elderfield-etal_2012.jld2", "data/paleo_records/elderfield-etal_2012_Vol_1500.jld2", force=true)

# Herbert et al., 2016
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/SST/herbert-etal_2016.nc", -3.0e6, 0.0, 1e3)
mv("data/paleo_records/herbert-etal_2016.jld2", "data/paleo_records/herbert-etal_2016_sst_3000.jld2", force=true)

# McClymont et al., 2013

## Ruddiman 1989
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/SST/ruddiman-etal_1989sum.nc", -1.6e6, 0.0, 1e3)
mv("data/paleo_records/ruddiman-etal_1989sum.jld2", "data/paleo_records/ruddiman-etal_1989sum_sst_1600.jld2", force=true)
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/SST/ruddiman-etal_1989win.nc", -1.6e6, 0.0, 1e3)
mv("data/paleo_records/ruddiman-etal_1989win.jld2", "data/paleo_records/ruddiman-etal_1989win_sst_1600.jld2", force=true)

## McClymont et al., 2008
convert_nc_to_jld2("/home/sergio/entra/ice_data/dataForPACCO/SST/mcclymont-etal_2008.nc", -1.5e6, 0.0, 1e3)
mv("data/paleo_records/mcclymont-etal_2008.jld2", "data/paleo_records/mcclymont-etal_2008_sst_1500.jld2", force=true)

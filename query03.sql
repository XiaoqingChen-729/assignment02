select
    parcels.address as parcel_address,
    nearest.stop_name,
    round(
        st_distance(parcels.geog, nearest.geog)::numeric,
        2
    ) as distance
from phl.pwd_parcels as parcels
cross join lateral (
    select
        stop_name,
        geog
    from septa.bus_stops
    order by parcels.geog::geometry <-> geog::geometry
    limit 1
) as nearest
order by distance desc

select
    parcels.address as parcel_address,
    nearest.stop_name,
    round(
        st_distance(parcels.geog, nearest.geog)::numeric,
        2
    ) as distance
from phl.pwd_parcels as parcels
cross join
    lateral (
        select
            bs.stop_name,
            bs.geog
        from septa.bus_stops as bs
        order by parcels.geog::geometry <-> bs.geog::geometry
        limit 1
    ) as nearest
order by distance desc

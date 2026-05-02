/*
  How many census block groups does Penn's main campus fully contain?

  Penn's main campus is defined by unioning the PWD parcels owned by the
  "Trustees of the University of Pennsylvania" within 1,500 meters of the
  center of the main campus (approximately 39.952°N, 75.193°W). This spatial
  filter excludes Penn Medicine and other University-owned properties elsewhere
  in the city, keeping only the contiguous West Philadelphia main campus.
*/

with

penn_campus as (
    select st_union(geog::geometry)::geography as geog
    from phl.pwd_parcels
    where
        owner1 ilike '%TRUSTEES OF THE UNIVERSITY OF PENNSYLVANIA%'
        and st_dwithin(
            geog,
            st_makepoint(-75.193, 39.952)::geography,
            1500
        )
)

select count(bg.geoid)::integer as count_block_groups
from census.blockgroups_2020 as bg
cross join penn_campus as pc
where st_covers(pc.geog::geometry, bg.geog::geometry)

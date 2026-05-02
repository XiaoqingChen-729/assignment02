/*
  Find the geo_id of the census block group that contains Meyerson Hall
  (210 S 34th St, Philadelphia, PA).

  Instead of constructing a point with ST_MakePoint, this query finds the
  PWD parcel whose address matches Meyerson Hall, then spatial-joins it with
  the census block groups to find which block group covers that parcel.
*/

select bg.geoid as geo_id
from phl.pwd_parcels as parcels
inner join census.blockgroups_2020 as bg
    on st_covers(bg.geog, parcels.geog)
where parcels.address = '210 S 34TH ST'

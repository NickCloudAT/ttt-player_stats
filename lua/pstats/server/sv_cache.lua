if not SERVER then return end

function PSTATS_DATA:CachePlayer(id64, data)
  local stats = {
    kills = data[1].kills,
    headshots = data[1].headshots,
    deaths = data[1].deaths,
    wins = data[1].wins
  }

  PSTATS_DATA.cache_table[tostring(id64)] = stats
end

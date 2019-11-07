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


function PSTATS_DATA:IsCached(id64)
  return PSTATS_DATA.cache_table[tostring(id64)] ~= nil
end



function PSTATS_DATA:UpdatePlayer(id64)
  if not PSTATS_DATA:IsCached(id64) then return end

  local stats = PSTATS_DATA.cache_table[tostring(id64)]

  if not stats then return end

  local kills = stats.kills
  local headshots = stats.headshots
  local deaths = stats.deaths
  local wins = stats.wins

  PSTATS_DATA.MYSQL:SetKills(id64, kills)
  PSTATS_DATA.MYSQL:SetHeadshots(id64, headshots)
  PSTATS_DATA.MYSQL:SetDeaths(id64, deaths)
  PSTATS_DATA.MYSQL:SetWins(id64, wins)
end


function PSTATS_DATA:UpdateAll()
  for k,v in ipairs(player.GetAll()) do
    if IsValid(v) and v:IsConnected() and PSTATS_DATA:IsCached(v:SteamID64()) and not v:IsBot() then
      PSTATS_DATA:UpdatePlayer(v:SteamID64())
    end
  end
end
timer.Create("PSTATS_TIMER", PSTATS_DATA.config.SaveFrequency, 0, function() PSTATS_DATA:UpdateAll() end)

if not SERVER then return end

util.AddNetworkString("PSTATS_AskOpenStats")
util.AddNetworkString("PSTATS_AskOpenStatsOther")
util.AddNetworkString("PSTATS_AskOpenStatsAll")
util.AddNetworkString("PSTATS_OpenStats")
util.AddNetworkString("PSTATS_OpenStatsAll")


net.Receive("PSTATS_AskOpenStats", function(len, ply)
  if not IsValid(ply) or not PSTATS_DATA:IsCached(ply:SteamID64()) then return end

  net.Start("PSTATS_OpenStats")
  net.WriteTable(PSTATS_DATA.cache_table[tostring(ply:SteamID64())])
  net.Send(ply)
end)

net.Receive("PSTATS_AskOpenStatsOther", function(len, ply)
  if not IsValid(ply) then return end

  local playerFound = net.ReadEntity()

  if not IsValid(playerFound) or not PSTATS_DATA:IsCached(playerFound:SteamID64()) then return end

  net.Start("PSTATS_OpenStats")
  net.WriteTable(PSTATS_DATA.cache_table[tostring(playerFound:SteamID64())])
  net.WriteString(playerFound:Nick())
  net.WriteBool(true)
  net.Send(ply)
end)

net.Receive("PSTATS_AskOpenStatsAll", function(len, ply)
  if not IsValid(ply) then return end

  net.Start("PSTATS_OpenStatsAll")
  net.WriteTable(PSTATS_DATA.cache_table)
  net.Send(ply)
end)

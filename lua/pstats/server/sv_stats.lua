if not SERVER then return end

util.AddNetworkString("PSTATS_AskOpenStats")
util.AddNetworkString("PSTATS_OpenStats")


net.Receive("PSTATS_AskOpenStats", function(len, ply)
  if not IsValid(ply) or not PSTATS_DATA:IsCached(ply:SteamID64()) then return end

  net.Start("PSTATS_OpenStats")
  net.WriteTable(PSTATS_DATA.cache_table[tostring(ply:SteamID64())])
  net.Send(ply)
end)

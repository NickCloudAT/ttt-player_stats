if not SERVER then return end

hook.Add("PlayerDeath", "PSTATS_DEATH", function(ply, inflictor, attacker)
  if GetRoundState() ~= ROUND_ACTIVE or not PSTATS_DATA:EnoughPlayers() then return end

  if not IsValid(ply) or ply:IsBot() or not ply:IsTerror() then return end

  PSTATS_DATA:AddDeaths(ply:SteamID64(), 1)

  if not IsValid(attacker) or not attacker:IsPlayer() then return end

  if not attacker:IsTerror() or attacker == ply then return end

  if(ply:LastHitGroup() == HITGROUP_HEAD) then
    PSTATS_DATA:AddHeadshots(attacker:SteamID64(), 1)
    return
  end

    PSTATS_DATA:AddKills(attacker:SteamID64(), 1)

end)

hook.Add("TTTEndRound", "PSTATS_WIN", function(result)
  if not PSTATS_DATA:EnoughPlayers() then return end
  for k, v in ipairs(player.GetAll()) do
    if v:GetTeam() == result and not v:GetForceSpec() and v:Alive() then
      PSTATS_DATA:AddWins(v:SteamID64(), 1)
    end
  end
  PSTATS_DATA:UpdateAll()
end)

hook.Add("PlayerDisconnected", "PSTATS_HANDLE_QUIT", function(ply)
  if not IsValid(ply) or ply:IsBot() or not PSTATS_DATA:IsCached(ply:SteamID64()) or not ply:IsConnected() then return end

  PSTATS_DATA:UpdatePlayer(ply:SteamID64())

  local index = 0

  for p in pairs(PSTATS_DATA.cache_table) do
    index = index +1
    if p == ply:SteamID64() then break end
  end

  table.remove(PSTATS_DATA.cache_table, index)
end)

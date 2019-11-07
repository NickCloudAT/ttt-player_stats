if not SERVER then return end

hook.Add("PlayerDeath", "PSTATS_DEATH", function(ply, inflictor, attacker)
  if GetRoundState() ~= ROUND_ACTIVE then return end

  if not IsValid(ply) or ply:IsBot() then return end

  PSTATS_DATA:AddDeaths(ply:SteamID64(), 1)

  if not IsValid(attacker) or not attacker:IsPlayer() then return end

  if not attacker:IsTerror() or attacker == ply then return end

  PSTATS_DATA:AddKills(attacker:SteamID64(), 1)

  if(ply:LastHitGroup() == HITGROUP_HEAD) then
    PSTATS_DATA:AddHeadshots(attacker:SteamID64(), 1)
  end

end)

hook.Add("TTTEndRound", "PSTATS_WIN", function(result)
  print("WINRESULT: " .. tostring(result))
end)

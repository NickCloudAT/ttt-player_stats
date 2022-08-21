if SERVER then
  function PSTATS_DATA:EnoughPlayers()
    local count = 0
    for k, v in ipairs(player.GetAll()) do
      if not v:GetForceSpec() then count = count+1 end
    end

    return count >=4
  end
end

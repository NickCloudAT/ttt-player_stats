surface.CreateFont("PSTATS_Page", {
		font = "DermaDefault",
		size = 18
})

local weapon_tbl = {}

local function OpenStats()
  local statsTable = net.ReadTable()
  local otherPlayer = net.ReadString()

  Frame = vgui.Create("DFrame")
  Frame:SetPos(50, 50)
  Frame:SetSize(500, 100)
  Frame:SetTitle(not otherPlayer and "Your statistics" or otherPlayer and otherPlayer.."'s statistics")
  Frame:MakePopup()
  Frame:Center()

  list = vgui.Create("DListView", Frame)
  list:SetSize(500, 75)
  list:SetPos(0, 25)

  list:AddColumn("Kills")
  list:AddColumn("Headshots")
  list:AddColumn("K/D")
  list:AddColumn("Deaths")
  list:AddColumn("Wins")

  list:AddLine(statsTable.kills, statsTable.headshots, math.Round(statsTable.kills/statsTable.deaths, 2), statsTable.deaths, statsTable.wins)

end
net.Receive("PSTATS_OpenStats", OpenStats)


concommand.Add("pstats_stats", function(ply, cmd, args, argStr)

	if args[1] then
		local playerArg = args[1]
		local found = false
		local foundPly

		for k,v in ipairs(player.GetHumans()) do
			if v:Nick() == playerArg then
				found = true
				foundPly = v
				break
			end
		end

		if not found then print("Player not found!") return end

		net.Start("PSTATS_OpenStatsOther")
		net.WriteEntity(foundPly)
		net.SendToServer()
		return
	end

	net.Start("PSTATS_AskOpenStats")
	net.SendToServer()
end, function(cmd, args) return player.GetHumans() end)

hook.Add("Initialize", "PSTATS_KEY_BIND", function()
	bind.Register("pstats_open_stats", function()
		net.Start("PSTATS_AskOpenStats")
		net.SendToServer()
	end, nil, "Other Bindings", "Open PStats", nil)
end)

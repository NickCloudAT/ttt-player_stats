surface.CreateFont("PSTATS_Page", {
		font = "DermaDefault",
		size = 18
})

local weapon_tbl = {}

local function OpenStats()
  local statsTable = net.ReadTable()

  Frame = vgui.Create("DFrame")
  Frame:SetPos(50, 50)
  Frame:SetSize(500, 100)
  Frame:SetTitle("Your statistics")
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


concommand.Add("pstats_stats", function()
	net.Start("PSTATS_AskOpenStats")
	net.SendToServer()
end)

bind.Register("ttt_openstats", function()
	net.Start("PSTATS_AskOpenStats")
	net.SendToServer()
end)

bind.AddSettingsBinding("ttt_openstats", "Open Stats")

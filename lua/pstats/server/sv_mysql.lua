if not SERVER then return end

module( "PSTATS", package.seeall )

require("mysqloo")

local queue = {}

local db = mysqloo.connect(PSTATS_DATA.config.MySQL.HOST, PSTATS_DATA.config.MySQL.USERNAME, PSTATS_DATA.config.MySQL.PASSWORD, PSTATS_DATA.config.MySQL.DATABASE, PSTATS_DATA.config.MySQL.PORT)


local function query( str, callback )
	local q = db:query( str )

	function q:onSuccess( data )
		callback( data )
	end

	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			table.insert( queue, { str, callback } )
			db:connect()
		return end

		print( "PSTATS > Failed to connect to the database!" )
		print( "PSTATS > The error returned was: " .. err )
	end

	q:start()

end

function db:onConnected()
	print( "PSTATS > Sucessfully connected to database!" )

	for k, v in pairs( queue ) do
		query( v[ 1 ], v[ 2 ] )
	end

	queue = {}
end

function db:onConnectionFailed( err )
	print( "PSTATS > Failed to connect to the database!" )
	print( "PSTATS > The error returned was: " .. err )
end

db:connect()

table.insert( queue, { "SHOW TABLES LIKE 'pstats'", function( data )
	if table.Count( data ) < 1 then -- the table doesn't exist
		query( "CREATE TABLE pstats (player VARCHAR(64) UNSIGNED NOT NULL, kills INTEGER UNSIGNED NOT NULL, headshots INTEGER UNSIGNED NOT NULL, deaths INTEGER UNSIGNED NOT NULL, wins INTEGER UNSIGNED NOT NULL, lastname VARCHAR(64) UNSIGNED NOT NULL)", function( data )
			print( "PSTATS > Sucessfully created table!" )
		end )
	end
end } )

function PSTATS_DATA.MYSQL:PlayerJoined(ply)
  local uid = ply:SteamID64()

  query("SELECT kills, headshots, deaths, wins FROM pstats WHERE player = " .. uid, function(data)
    if table.Count( data ) <= 0 then
		  local nick_name = ply:Nick()
		  local pos = string.find(nick_name, "'", 1, true)
		  nick_name = pos ~= nil and "invalid" or nick_name
			query("INSERT into pstats (player, kills, headshots, deaths, wins, lastname) VALUES (" .. uid .. ", 0, 0, 0, 0, '" .. nick_name .. "')", function()
          print("PSTATS > Successfully created player " .. ply:Nick())
        end)
    end

		if IsValid(ply) then
			local nick_name = ply:Nick()
			local pos = string.find(nick_name, "'", 1, true)
			nick_name = pos ~= nil and "invalid" or nick_name
			query("UPDATE pstats SET lastname='" .. nick_name .. "' WHERE player='" .. ply:SteamID64() .. "'", function() end)
			PSTATS_DATA:CachePlayer(ply:SteamID64(), data)
	  end

  end)
end

hook.Add("PlayerInitialSpawn", "PSTATSInitialSpawn", function(ply)
	if not IsValid(ply) or ply:IsBot() then return end
	PSTATS_DATA.MYSQL:PlayerJoined(ply)
end)



function PSTATS_DATA.MYSQL:AddKills(id64, value)
  PSTATS_DATA.MYSQL:SetKills(id64, PSTATS_DATA.MYSQL:GetKills(id64)+value)
end

function PSTATS_DATA.MYSQL:AddHeadshots(id64, value)
  PSTATS_DATA.MYSQL:SetHeadshots(id64, PSTATS_DATA.MYSQL:GetHeadshots(id64)+value)
end

function PSTATS_DATA.MYSQL:AddDeaths(id64, value)
  PSTATS_DATA.MYSQL:SetDeaths(id64, PSTATS_DATA.MYSQL:GetDeaths(id64)+value)
end

function PSTATS_DATA.MYSQL:AddWins(id64, value)
  PSTATS_DATA.MYSQL:SetWins(id64, PSTATS_DATA.MYSQL:GetWins(id64)+value)
end

----


function PSTATS_DATA.MYSQL:SetKills(id64, value)
  query("UPDATE pstats SET kills = " .. value .. " WHERE player = " .. id64 .. ";", function(data)end)
end

function PSTATS_DATA.MYSQL:SetHeadshots(id64, value)
  query("UPDATE pstats SET headshots = " .. value .. " WHERE player = " .. id64 .. ";", function(data)end)
end

function PSTATS_DATA.MYSQL:SetDeaths(id64, value)
  query("UPDATE pstats SET deaths = " .. value .. " WHERE player = " .. id64 .. ";", function(data)end)
end

function PSTATS_DATA.MYSQL:SetWins(id64, value)
  query("UPDATE pstats SET wins = " .. value .. " WHERE player = " .. id64 .. ";", function(data)end)
end

function PSTATS_DATA.MYSQL:RemovePlayer(id64)
	query("DELETE FROM pstats WHERE player = " .. id64 .. ";", function(data)end)
end

function PSTATS_DATA.MYSQL:ClearBanned()
	query("SELECT player FROM pstats", function(data)
		local tableSize = table.Count(data)

		local index = 1
		local removed = 0
		timer.Create("pstats_delete_timer", 0.03, tableSize, function()
			local dataTable = data[index]
			local steamid = dataTable.player
			local isBanned = ULib.isBanned(steamid, true)

			if isBanned then
				PSTATS_DATA.MYSQL:RemovePlayer(steamid)
				removed = removed+1
				print("Removed: " .. tostring(removed))
			end

			index = index+1
		end)
	end)
end


----

net.Receive("PSTATS_AskOpenStatsAll", function(len, ply)
  if not IsValid(ply) then return end

  local co = coroutine.create(function()

		query("SELECT player, kills, headshots, deaths, wins, lastname FROM pstats", function(data)
			local stats_table = {}
			for i=1, #data do
				local p_stats = {
					kills = data[i].kills,
					headshots = data[i].headshots,
					deaths = data[i].deaths,
					wins = data[i].wins,
					lastname = data[i].lastname
				}
				stats_table[tostring(data[i].player)] = p_stats
			end

			net.Start("PSTATS_OpenStatsAll")
			net.WriteTable(stats_table)
			net.Send(ply)
		end)

  end)

  coroutine.resume(co)

end)

if not SERVER then return end

PSTATS_DATA.config.MySQL = {
  HOST = "localhost",
  PORT = "3306",
  USERNAME = "dbuser",
  PASSWORD = "dbpassword",
  DATABASE = "db"
}

PSTATS_DATA.config.SaveFrequency = "120"

if not file.Exists("pstats/config.json", "DATA") then
  file.CreateDir("pstats")
  file.Write("pstats/config.json", util.TableToJSON(PSTATS_DATA.config, true))
else
  local configFile = file.Read("pstats/config.json", "DATA")
  if not configFile then return end

  PSTATS_DATA.config = util.JSONToTable(configFile)
end

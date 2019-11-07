if not SERVER then return end

PSTATS_DATA.config.MySQL = {
  HOST = "localhost",
  PORT = 3306,
  USERNAME = "dbuser",
  PASSWORD = "dbpassword",
  DATABASE = "db"
}

PSTATS_DATA.config.SaveFrequency = 120

PSTATS_DATA = {}
PSTATS_DATA.config = {}
PSTATS_DATA.MYSQL = {}
PSTATS_DATA.cache_table = {}

include("sv_config.lua")
include("sv_mysql.lua")
include("sv_storage.lua")
include("sv_events.lua")
include("sv_cache.lua")
include("sv_stats.lua")

include("pstats/shared/sh_utils.lua")


AddCSLuaFile("pstats/client/cl_stats.lua")

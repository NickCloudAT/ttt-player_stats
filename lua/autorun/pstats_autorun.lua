if SERVER then
  include("pstats/server/sv_init.lua")
  AddCSLuaFile("pstats/client/cl_init.lua")
  AddCSLuaFile("pstats/client/cl_stats.lua")
else
  include("pstats/client/cl_init.lua")
end

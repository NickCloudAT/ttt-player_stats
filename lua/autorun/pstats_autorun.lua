if SERVER then
  include("pstats/server/sv_init.lua")
  AddCSLuaFile("pstats/client/cl_init.lua")
  AddCSLuaFile("pstats/client/cl_stats.lua")
  AddCSLuaFile("pstats/shared/sh_utils.lua")
else
  include("pstats/client/cl_init.lua")
  include("pstats/shared/sh_utils.lua")
end

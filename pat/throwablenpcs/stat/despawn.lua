function init()
  if entity.entityType() ~= "npc" then return end
  effect.modifyDuration(10)
  
  local id = entity.id()
  world.callScriptedEntity(id, "npc.setDeathParticleBurst")
  world.callScriptedEntity(id, "npc.resetLounging")
  effect.setParentDirectives("?multiply=0000")
  effect.addStatModifierGroup({ { stat = "maxHealth", effectiveMultiplier = 0 } })
  mcontroller.setYPosition(-67)
end

function init()
  local id = entity.id()
  if world.entityType(id) ~= "npc" then return end

  world.callScriptedEntity(id, "npc.setDeathParticleBurst")
  mcontroller.setYPosition(-67)
  effect.setParentDirectives("?multiply=0000")
  effect.addStatModifierGroup({ { stat = "maxHealth", effectiveMultiplier = 0 } })
end

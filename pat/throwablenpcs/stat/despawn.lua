function init()
  local t = entity.entityType()
  local id = entity.id()
  if t == "npc" then
    world.callScriptedEntity(id, "npc.setDeathParticleBurst")
    world.callScriptedEntity(id, "npc.resetLounging")
  elseif t == "monster" then
    world.callScriptedEntity(id, "monster.setDeathParticleBurst", "")
    world.callScriptedEntity(id, "monster.setDeathSound", "")
  else
    return effect.expire()
  end

  effect.modifyDuration(1)
  effect.setParentDirectives("?multiply=0000")
  effect.addStatModifierGroup({ { stat = "maxHealth", effectiveMultiplier = 0 } })
  mcontroller.setYPosition(-67)
end

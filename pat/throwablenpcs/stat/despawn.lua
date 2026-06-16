function init()
  if world.entityType(entity.id()) ~= "npc" then return end

  mcontroller.setYPosition(-67)
  effect.setParentDirectives("?multiply=0000")
  effect.addStatModifierGroup({ { stat = "maxHealth", effectiveMultiplier = 0 } })
end

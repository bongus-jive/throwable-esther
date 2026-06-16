local worldId

function init()
  worldId = ("InstanceWorld:pat_throwablenpc:%s:-"):format(sb.makeUuid())
  quest.setWorldId(worldId)
end

function questInteract(id)
  if player.currentQuestWorld() ~= worldId then return end
  if world.entityType(id) ~= "npc" then return end

  giveItem({ npcName = world.entityName(id), npcPortrait = getPortrait(id) })
  world.sendEntityMessage(id, "applyStatusEffect", "pat_throwablenpc_despawn")

  return true
end

function giveItem(params)
  local swap = player.swapSlotItem()
  player.setSwapSlotItem({ "pat_throwablenpc", 1, params })
  if swap then
    world.spawnItem(swap, entity.position(), nil, nil, nil, root.assetJson("/itemdrop.config:throwIntangibleTime"))
  end
end

function getPortrait(id)
  local portrait = {}
  for _, draw in ipairs(world.entityPortrait(id, "fullneutral")) do
    if draw.image and root.nonEmptyRegion(draw.image) then
      portrait[#portrait + 1] = draw
    end
  end
  return portrait
end

local worldId = "InstanceWorld:pat_throwablenpc:-:-"

function init()
  quest.setWorldId(worldId)
end

function questInteract(id)
  if player.currentQuestWorld() ~= worldId then return end
  local t = world.entityType(id)
  if not (t == "npc" or t == "monster") then return end

  local portrait = getPortrait(id)
  if not portrait then return end

  giveItem({ npcName = world.entityName(id), npcPortrait = portrait })
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
  local portrait = world.entityPortrait(id, "full")
  if not portrait then return end

  local filtered = {}
  for _, draw in ipairs(portrait) do
    if draw.image and root.nonEmptyRegion(draw.image) then
      filtered[#filtered + 1] = draw
    end
  end
  return filtered
end

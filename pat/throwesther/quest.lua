function init()
  quest.fail()

  local questGiver = quest.parameters().questGiver

  local giverId = findGiver(questGiver)
  if not giverId then return end

  world.sendEntityMessage(giverId, "applyStatusEffect", "pat_throwesther_despawn")
  giveItem(questGiver.portrait)
end

function findGiver(data)
  if data.uniqueId then return data.uniqueId end

  local ids = world.entityQuery(entity.position(), 10, { order = "nearest" })
  for _, id in ipairs(ids) do
    if data.species == world.entitySpecies(id)
    and data.gender == world.entityGender(id)
    and data.name == world.entityName(id) then
      return id
    end
  end
end

function giveItem(portrait)
  local swap = player.swapSlotItem()
  if swap then
    world.spawnItem(swap, entity.position(), nil, nil, nil, root.assetJson("/itemdrop.config:throwIntangibleTime"))
  end

  local item = { name = "egg", count = 1, parameters = { inventoryIcon = portrait } }
  player.setSwapSlotItem(item)
end

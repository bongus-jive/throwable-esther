local worldId

function init()
  worldId = ("InstanceWorld:pat_throwablenpc:%s:-"):format(sb.makeUuid())
  quest.setWorldId(worldId)
end

function questInteract(id)
  if player.currentQuestWorld() ~= worldId then return end
  if world.entityType(id) ~= "npc" then return end

  local portrait = getPortrait(id)
  local params = getParameters(world.entityName(id), portrait)
  giveItem(params)
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

function getParameters(name, drawables)
  local parts, tgroups = {}, { main = {} }
  local handOffset = {0, 0}

  for i, draw in ipairs(drawables) do
    local props = {}
    local k = tostring(i)
    parts[k], tgroups[k] = { properties = props }, {}

    props.image = draw.image
    props.offset = draw.position
    props.centered = draw.centered or false
    props.fullbright = draw.fullbright or false
    props.transformationGroups = { k, "main" }
    props.rotationGroup = "rotation"

    local t = draw.transformation
    props.transform = { t[1][1], t[1][2], t[2][1], t[2][2], t[1][3] / 8, t[2][3] / 8 }

    local c = draw.color
    local mult = ("?multiply=%02x%02x%02x%02x"):format(c[1], c[2], c[3], c[4] or 255)
    if mult ~= "?multiply=FFFFFFFF" then props.processingDirectives = mult end

    local rect = root.nonEmptyRegion(draw.image)
    if rect then
      local size = root.imageSize(draw.image)
      local x = ((size[1] / 2) - rect[1]) / 8
      if x > handOffset[1] then handOffset[1] = x end
    end
  end

  return {
    shortdescription = config.getParameter("nameTemplate", "%s"):format(name),
    handOffset = handOffset,
    inventoryIcon = drawables,
    animationCustom = {
      animatedParts = { parts = parts },
      transformationGroups = tgroups,
      rotationGroups = { rotation = {} }
    }
  }
end

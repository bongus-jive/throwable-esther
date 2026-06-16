local worldId

function init()
  worldId = ("InstanceWorld:pat_throwablenpc:%s:-"):format(sb.makeUuid())
  quest.setWorldId(worldId)
end

function questInteract(id)
  if player.currentQuestWorld() ~= worldId then return end
  if world.entityType(id) ~= "npc" then return end

  local portrait = getPortrait(id)

  giveItem({
    shortdescription = world.entityName(id),
    inventoryIcon = portrait,
    animationPartCount = #portrait,
    animationCustom = makeAnimationCustom(portrait)
  })

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
      portrait[#portrait+1] = draw
    end
  end
  return portrait
end

function makeAnimationCustom(drawables)
  local parts, tgroups = {}, {}
  local size = { 0, 0 }
  local handOffset = 0

  for i, draw in ipairs(drawables) do
    local props = {}
    local k = tostring(i)
    parts[k], tgroups[k] = { properties = props }, {}

    props.image = draw.image
    props.centered = false
    props.offset = draw.position
    props.fullbright = draw.fullbright
    props.transformation = draw.transformation
    props.transformationGroups = { k, "main" }
    props.rotationGroup = "rotation"

    local mult = ("?multiply=%02x%02x%02x%02x"):format(draw.color[1], draw.color[2], draw.color[3], draw.color[4] or 255)
    if mult ~= "?multiply=FFFFFFFF" then
      props.processingDirectives = mult
    end

    local s = root.imageSize(draw.image)
    if s[1] > size[1] or s[2] > size[2] then size = s end

    local rect = root.nonEmptyRegion(draw.image)
    if rect[1] > handOffset then handOffset = rect[1] end
  end

  local xOffset, yOffset = size[1] / 16, size[2] / 16
  handOffset = (xOffset - (handOffset / 8)) / 2
  for _, part in pairs(parts) do
    local pp = part.properties
    pp.offset[1] = pp.offset[1] + handOffset
    pp.vehicleOffset = {
      pp.offset[1] - xOffset,
      pp.offset[2] - yOffset
    }
  end

  return {
    animatedParts = { parts = parts },
    transformationGroups = tgroups
  }
end

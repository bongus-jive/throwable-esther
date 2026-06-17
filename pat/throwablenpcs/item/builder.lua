function build(_, config, parameters)
  if parameters.npcName then
    config.shortdescription = config.nameTemplate:format(parameters.npcName)
  end

  if parameters.npcPortrait then
    local drawables = parameters.npcPortrait
    config.inventoryIcon = drawables
    config.handOffset[1] = config.handOffset[1] + getHandOffset(drawables)
    config.animationCustom = sb.jsonMerge(config.animationCustom, drawablesToAnimation(drawables))
  end

  return config, parameters
end

function drawablesToAnimation(drawables)
  local parts, tgroups = {}, {}

  for i, draw in ipairs(drawables) do
    local props = {}
    local k = tostring(i)
    parts[k], tgroups[k] = { properties = props }, {}

    props.image = draw.image
    props.offset = { draw.position[1] / 8, draw.position[2] / 8 }
    props.centered = draw.centered or false
    props.fullbright = draw.fullbright or false
    props.transformationGroups = { k }
    props.rotationGroup = "rotation"

    local t = draw.transformation
    props.transform = { t[1][1], t[1][2], t[2][1], t[2][2], t[1][3] / 8, t[2][3] / 8 }

    local c = draw.color
    local mult = ("?multiply=%02x%02x%02x%02x"):format(c[1], c[2], c[3], c[4] or 255)
    if mult ~= "?multiply=ffffffff" then props.processingDirectives = mult end
  end

  return {
    animatedParts = { parts = parts },
    rotationGroups = { rotation = {} },
    transformationGroups = tgroups
  }
end

function getHandOffset(drawables)
  local handX = 0
  for _, draw in ipairs(drawables) do
    local rect = root.nonEmptyRegion(draw.image)
    if rect then
      local size = root.imageSize(draw.image)
      local x = ((size[1] / 2) - rect[1]) * math.abs(draw.transformation[1][1])
      if x > handX then handX = x end
    end
  end
  return handX / 8
end

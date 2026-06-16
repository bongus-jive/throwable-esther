require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/pat/throwablenpcs/transforms.lua"

function init()
  initTransforms()

  self.rotationCenter = config.getParameter("rotationCenter")
  self.fsm = FSM:new()
  reset()
end

function update(dt, fireMode)
  local _, dir = activeItem.aimAngleAndDirection(0.25, activeItem.ownerAimPosition())
  activeItem.setFacingDirection(dir)

  if not self.fsm.state and fireMode == "primary" then
    self.fsm:set(throw)
  end
  self.fsm:update(dt)
end

function throw()
  rotate(0.5, 60, 140, -12, -36)

  util.wait(0.04)
  while activeItem.fireMode() == "primary" do
    coroutine.yield()
  end

  animator.playSound("throw")
  rotate(0.03, 140, 45, -36, 0)
  spawnProjectile()
  item.consume(1)

  rotate(0.2, 45, 60, 0, -12)
  reset()
end

function rotate(duration, armStart, armEnd, rotStart, rotEnd)
  local t = 0
  while t < 1 do
    t = math.min(1, t + (script.updateDt() / duration))

    local arm = math.rad(util.interpolateSigmoid(t, armStart, armEnd))
    local rot = math.rad(util.interpolateSigmoid(t, rotStart, rotEnd))

    activeItem.setArmAngle(arm)
    animator.resetTransformationGroup("main")
    animator.rotateTransformationGroup("main", rot, self.rotationCenter)

    coroutine.yield()
  end
end

function spawnProjectile()
  local offset = {0, 0}--animator.partProperty("esther", "projectileOffset")
  local pos = vec2.add(mcontroller.position(), activeItem.handPosition(offset))
  local angle = activeItem.aimAngle(0.25, activeItem.ownerAimPosition())
  local vec = { math.cos(angle), math.sin(angle) }

  local anim = config.getParameter("animationCustom")
  if anim and anim.animatedParts and anim.animatedParts.parts then
    for _, part in pairs(anim.animatedParts.parts) do
      part.properties.offset = part.properties.vehicleOffset or part.properties.offset
    end
  end

  world.spawnVehicle("pat_thrownnpc", pos, {
    direction = vec,
    startVelocity = mcontroller.velocity(),
    sourceId = activeItem.ownerEntityId(),
    animationCustom = anim
  })
end

function reset()
  self.fsm:set()
  activeItem.setArmAngle(math.rad(60))
  animator.resetTransformationGroup("main")
  animator.rotateTransformationGroup("main", math.rad(-12), self.rotationCenter)
end

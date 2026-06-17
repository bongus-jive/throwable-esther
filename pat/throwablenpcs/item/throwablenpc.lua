require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/pat/throwablenpcs/transforms.lua"

function init()
  local offset = config.getParameter("handOffset")
  initTransforms(offset)

  self.stances = config.getParameter("stances")
  for _, v in pairs(self.stances) do
    v.arm, v.item = math.rad(v.arm), math.rad(v.item)
  end

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
  rotate(self.stances[1], self.stances[2])

  util.wait(0.04)
  while activeItem.fireMode() == "primary" do
    coroutine.yield()
  end

  animator.playSound("throw")
  rotate(self.stances[2], self.stances[3])
  spawnProjectile()
  item.consume(1)

  rotate(self.stances[3], self.stances[1])
  reset()
end

function rotate(from, to)
  local t = 0
  while t < 1 do
    t = math.min(1, t + (script.updateDt() / to.time))

    local arm = util.interpolateSigmoid(t, from.arm, to.arm)
    local rot = util.interpolateSigmoid(t, from.item, to.item)

    activeItem.setArmAngle(arm)
    animator.rotateGroup("rotation", rot)

    coroutine.yield()
  end
end

function spawnProjectile()
  local offset = config.getParameter("projectileOffset")
  local pos = vec2.add(mcontroller.position(), activeItem.handPosition(offset))
  local angle = activeItem.aimAngle(0.25, activeItem.ownerAimPosition())
  local vec = { math.cos(angle), math.sin(angle) }

  world.spawnVehicle("pat_thrownnpc", pos, {
    direction = vec,
    startVelocity = mcontroller.velocity(),
    sourceId = activeItem.ownerEntityId(),
    animationCustom = config.getParameter("animationCustom")
  })
end

function reset()
  self.fsm:set()
  activeItem.setArmAngle(self.stances[1].arm)
  animator.rotateGroup("rotation", self.stances[1].item)
end

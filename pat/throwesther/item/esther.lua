require "/scripts/util.lua"
require "/scripts/vec2.lua"

function init()
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
    animator.resetTransformationGroup("esther")
    animator.rotateTransformationGroup("esther", rot)

    coroutine.yield()
  end
end

function spawnProjectile()
  local offset = animator.partProperty("esther", "projectileOffset")
  local pos = vec2.add(mcontroller.position(), activeItem.handPosition(offset))
  local angle = activeItem.aimAngle(0.25, activeItem.ownerAimPosition())
  local vec = { math.cos(angle), math.sin(angle) }
  world.spawnProjectile("pat_throwesther", pos, activeItem.ownerEntityId(), vec)
end

function reset()
  self.fsm:set()
  activeItem.setArmAngle(math.rad(60))
  animator.resetTransformationGroup("esther")
  animator.rotateTransformationGroup("esther", math.rad(-12))
end

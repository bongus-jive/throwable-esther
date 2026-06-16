require "/scripts/vec2.lua"
require "/pat/throwablenpcs/transforms.lua"

function init()
  initTransforms()

  if not storage.initialized then spawned() end
  self.flippable = config.getParameter("flippable", true)
end

function spawned()
  storage.initialized = true

  local speed = config.getParameter("speed", 50)
  local dir = config.getParameter("direction", {0, 0})
  mcontroller.setVelocity(vec2.mul(dir, speed))
  setRotation(vec2.angle(dir))

  storage.timeToLive = config.getParameter("timeToLive", 5)
end

function update(dt)
  storage.timeToLive = storage.timeToLive - dt
  if storage.timeToLive < 0 then
    destroy()
  end

  if mcontroller.atWorldLimit() then
    destroy()
  end

  if mcontroller.isColliding() then
    if mcontroller.isNullColliding() or not mcontroller.stickingDirection() then
      destroy()
    end
  end

  local vel = mcontroller.velocity()
  setRotation(math.atan(vel[2], vel[1]))
end

function setRotation(angle)
  mcontroller.setRotation(angle)

  if self.flippable then
    local dir
    angle, dir = getAngleSide(angle)
    animator.setFlipped(dir == -1)
  end
  animator.rotateGroup("rotation", angle)
end

function getAngleSide(angle)
  if angle > math.pi / 2 then
    return math.pi - angle, -1
  elseif angle < -math.pi / 2 then
    return -math.pi - angle, -1
  end
  return angle, 1
end

function destroy()
  vehicle.destroy()
  if self.destroyed then return end
  self.destroyed = true
  animator.burstParticleEmitter("explode")
  animator.playSound("explode")
end

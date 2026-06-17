function initTransforms(offset)
  local i, g = 1, "1"
  while animator.hasTransformationGroup(g) do
    local t = animator.partProperty(g, "transform")
    animator.resetTransformationGroup(g)
    animator.transformTransformationGroup(g, table.unpack(t))
    if offset then animator.translateTransformationGroup(g, offset) end
    i = i + 1
    g = tostring(i)
  end
end

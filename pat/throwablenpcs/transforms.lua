function initTransforms()
  local i, g = 1, "1"
  while animator.hasTransformationGroup(g) do
    local t = animator.partProperty(g, "transform")
    animator.resetTransformationGroup(g)
    animator.transformTransformationGroup(g, table.unpack(t))
    i = i + 1
    g = tostring(i)
  end
end

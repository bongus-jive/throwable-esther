function initTransforms()
  local i, g = 1, "1"
  while animator.hasTransformationGroup(g) do
    local t = animator.partProperty(g, "transform")
    animator.resetTransformationGroup(g)
    animator.transformTransformationGroup(g, t[1][1], t[1][2], t[2][1], t[2][2], t[1][3] / 8, t[2][3] / 8)
    i = i + 1
    g = tostring(i)
  end
end

function init()
  script.setUpdateDelta(0)
  if not player.hasActiveQuest("pat_throwablenpc") then
    player.startQuest("pat_throwablenpc")
  end
end

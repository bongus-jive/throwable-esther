local questId = "pat_throwablenpc"

function init()
  if not player.hasActiveQuest(questId) then
    player.startQuest(questId)
  end

  if not input or not player.trackedQuestId or not player.setTrackedQuest then
    script.setUpdateDelta(0)
  end
end

function update()
  if input.bindDown("pat_throwablenpcs", "toggle") then
    local current = player.trackedQuestId()
    if current == questId then
      player.setTrackedQuest(storage.lastQuestId or "")
      storage.lastQuestId = nil
    else
      player.setTrackedQuest(questId)
      storage.lastQuestId = current
    end
  end
end

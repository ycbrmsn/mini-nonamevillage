-- 剧情一
Story1 = MyStory:new()

function Story1:new ()
  local data = {
    title = '第一关',
    name = '无名称',
    desc = '无描述',
    tips = {
      '无事。',
    },
    initPos = MyPosition:new(5.5, 7.5, -4.5)
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end

function Story1:enter (objid)
  -- local mainIndex = StoryHelper:getMainStoryIndex()
  -- local mainProgress = StoryHelper:getMainStoryProgress()
  local player = PlayerHelper:getPlayer(objid)
  if (PlayerHelper:isMainPlayer(objid)) then -- 房主
    player:setPosition(self.initPos)
    PlayerHelper:rotateCamera(objid, 0, 0) -- 看向北方
  else
    local hostPlayer = PlayerHelper:getHostPlayer()
    player:setPosition(hostPlayer:getMyPosition())
  end
end
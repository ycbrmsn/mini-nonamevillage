-- 剧情零
Story0 = MyStory:new()

function Story0:new ()
  local data = {
    title = '序',
    name = '无名称',
    desc = '无描述',
    tips = {
      '无事。',
    },
    initPos = MyPosition:new(5.5, 7.5, -20.5), -- 初始位置
    outVillagePoses = {
      MyPosition:new(5.5, 7.5, 18.5)
    }, -- 前往位置
    inVillagePoses = {
      MyPosition:new(5.5, 7.5, 29.5)
    }
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end

function Story0:enter (objid)
  -- local mainIndex = StoryHelper:getMainStoryIndex()
  -- local mainProgress = StoryHelper:getMainStoryProgress()
  local player = PlayerHelper:getPlayer(objid)
  if (PlayerHelper:isMainPlayer(objid)) then -- 房主
    PlayerHelper:changeVMode(nil)
    player:setPosition(self.initPos)
    PlayerHelper:rotateCamera(objid, 0, 0) -- 看向北方
    local ws = WaitSeconds:new()
    TimeHelper:callFnAfterSecond(function ()
      ChatHelper:sendMsg(objid, '故事简介：\t\t\t\t\t\t\t\t\t\t\t\t\t')
      ChatHelper:sendMsg(objid, '\t\t你学艺有成，下山游历四方……\t\t')
    end, ws:use())
    PlayerHelper:everyPlayerPlayAct(ActorHelper.ACT.STRETCH, ws:get())
    PlayerHelper:everyPlayerSpeakToSelf(ws:use(), '走了这么久，终于发现了一个小村庄。这下好了，不用再露宿野外了。')
    PlayerHelper:everyPlayerSpeakToSelf(ws:use(), '去找个人家借宿一宿。')
    -- PlayerHelper:everyPlayerThinkToSelf(second, ...)
    PlayerHelper:everyPlayerDoSomeThing(function (player)
      if (PlayerHelper:isMainPlayer(player.objid)) then
        player.action:runTo(self.outVillagePoses, function ()
          self:think()
        end)
      else
        player.action:runTo(self.outVillagePoses)
      end
    end, ws:use())
  else
    local hostPlayer = PlayerHelper:getHostPlayer()
    player:setPosition(hostPlayer:getMyPosition())
  end
  BackpackHelper:addItem(objid, MyMap.ITEM.SWORD, 1)
end

function Story0:think ()
  local ws = WaitSeconds:new()
  PlayerHelper:everyPlayerThinkToSelf(ws:use(), '嗯……这种感觉……')
  PlayerHelper:everyPlayerThinkToSelf(ws:use(), '进去看看再说。')
  PlayerHelper:everyPlayerDoSomeThing(function (player)
    player.action:runTo(self.inVillagePoses)
  end, ws:use())
end
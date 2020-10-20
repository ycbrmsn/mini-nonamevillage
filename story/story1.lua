-- 剧情一
Story1 = MyStory:new()

function Story1:new ()
  local data = {
    title = '剧情一',
    name = '无名称',
    desc = '无描述',
    tips = {
      '好累，先去休息一下。',
      '我似乎应该问问主人家这里的事情。',
      '去甄家问问看，不知道剑好不好借。',
      '剑果然不好借，也许我可以问问其他人。'
    },
    aroundBedPos = MyPosition:new(-3.5, 8.5, 41.5), -- 床旁边
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


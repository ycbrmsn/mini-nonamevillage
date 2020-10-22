-- 剧情零
Story0 = MyStory:new()

function Story0:new ()
  local data = {
    title = '序',
    name = '无名称',
    desc = '无描述',
    tips = {
      '发现小村庄。',
      '进入小村庄。',
    },
    initPos = MyPosition:new(5.5, 7.5, -20.5), -- 初始位置
    outVillagePoses = {
      MyPosition:new(5.5, 7.5, 18.5)
    }, -- 前往位置
    inVillagePoses = {
      MyPosition:new(5.5, 7.5, 29.5)
    },
    goOutVillage = {
      MyPosition:new(1, 8, 27),
      MyPosition:new(10, 8, 27),
      MyPosition:new(1, 8, 25),
      MyPosition:new(10, 8, 25),
    },
    sureGoOutArea = -1, -- 确认离开村庄区域
    goOutVillageArea = -1, -- 离开村庄区域
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end

function Story0:init ()
  self.sureGoOutArea = AreaHelper:createAreaRectByRange(self.goOutVillage[1], self.goOutVillage[2])
  self.goOutVillageArea = AreaHelper:createAreaRectByRange(self.goOutVillage[3], self.goOutVillage[4])
end

function Story0:enter (objid)
  -- local mainIndex = StoryHelper:getMainStoryIndex()
  -- local mainProgress = StoryHelper:getMainStoryProgress()
  local player = PlayerHelper:getPlayer(objid)
  -- test begin ---
  StoryHelper:goTo(2, 7)
  TimeHelper:setHour(23)
  player:setPosition(-28, 7, 31)
  if (1 == 1) then
    return
  end
  --- test end ---

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
    PlayerHelper:everyPlayerSpeakToSelf(ws:use(), '走了这么久，终于发现了一个小村庄。这下可以好好休息休息了。')
    PlayerHelper:everyPlayerSpeakToSelf(ws:get(), '先去找个人家借宿一宿。')
    -- PlayerHelper:everyPlayerThinkToSelf(second, ...)
    PlayerHelper:everyPlayerDoSomeThing(function (player)
      if (PlayerHelper:isMainPlayer(player.objid)) then
        player:runTo(self.outVillagePoses, function ()
          self:think()
        end)
      else
        player:runTo(self.outVillagePoses)
      end
    end, ws:use())
  else
    local hostPlayer = PlayerHelper:getHostPlayer()
    player:setPosition(hostPlayer:getMyPosition())
  end
  -- BackpackHelper:addItem(objid, MyMap.ITEM.SWORD, 1)
end

function Story0:think ()
  local ws = WaitSeconds:new()
  PlayerHelper:everyPlayerThinkToSelf(ws:use(), '嗯……这种感觉……')
  PlayerHelper:everyPlayerThinkToSelf(ws:get(), '进去看看再说。')
  PlayerHelper:everyPlayerDoSomeThing(function (player)
    if (PlayerHelper:isMainPlayer(player.objid)) then
      player:runTo(self.inVillagePoses, function ()
        StoryHelper:forward2(1, 1)
      end)
    else
      player:runTo(self.inVillagePoses)
    end
  end, ws:get())
end

function Story0:enterArea (objid, areaid)
  local player = PlayerHelper:getPlayer(objid)
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (areaid == self.sureGoOutArea) then -- 离开村庄确认
    if (mainProgress > 1) then
      if (player:isHostPlayer()) then -- 房主
        player:enableMove(false, true)
        player:thinks(0, '此处不详，我要不要离开呢？')
        TimeHelper:callFnAfterSecond(function ()
          player:enableMove(true, true)
        end, 2)
      end
    end
    return true
  elseif (areaid == self.goOutVillageArea) then -- 离开村庄
    if (mainProgress > 1) then
      player:enableMove(false, true)
      player:thinks(0, '君子不立于危墙之下。我还是暂且离开。')
      local ws = WaitSeconds:new(2)
      TimeHelper:callFnAfterSecond(function ()
        player:enableMove(true, true)
        player:runTo({ self.initPos })
      end, ws:use())
      ChatHelper:waitSpeak('？？？', nil, ws:use(), '他离开了。')
      ChatHelper:waitSpeak('？？？', nil, ws:use(), '嗯，这样最好了。我可不喜欢变数。')
      ChatHelper:waitSpeak('？？？', nil, ws:use(), '俺也一样。')
      TimeHelper:callFnAfterSecond(function ()
        MyGameHelper:setNameAndDesc('善身者', '三十六计走为上计')
        PlayerHelper:setGameWin(objid)
      end, ws:get())
    end
    return true
  end
  return false
end
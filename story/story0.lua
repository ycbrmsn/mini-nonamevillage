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

  -- StoryHelper:goTo(2, 7)
  -- TimeHelper:setHour(23)
  -- player:setPosition(-28, 7, 31)

  -- StoryHelper:goTo(2, 8)
  -- player:setPosition(40, 7, 84)

  TimeHelper:callFnAfterSecond(function ()
    -- meigao.lostBag = true
  end, 2)
  -- TalkHelper:addTask(objid, 2)
  -- TalkHelper:addTask(objid, 7)
  -- TalkHelper:setProgress(objid, 2, 22)
  -- player:setPosition(-8, 7, 32) -- 池末门外
  -- player:setPosition(-28, 7, 84) -- 梁杖门外

  -- player:setPosition(40, 7, 32) -- 莫迟门外
  -- if (1 == 1) then
  --   return
  -- end

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
  PlayerHelper:everyPlayerThinkToSelf(ws:use(), '嗯……这空中……')
  PlayerHelper:everyPlayerThinkToSelf(ws:get(), '似乎很不一般。先进去看看再说。')
  PlayerHelper:everyPlayerDoSomeThing(function (player)
    if (PlayerHelper:isMainPlayer(player.objid)) then
      player:runTo(self.inVillagePoses, function ()
        TalkHelper:addTask(player.objid, 1)
        PlayerHelper:changeVMode(player.objid, VIEWPORTTYPE.MAINVIEW)
      end)
    else
      player:runTo(self.inVillagePoses, function ()
        PlayerHelper:changeVMode(player.objid, VIEWPORTTYPE.MAINVIEW)
      end)
    end
  end, ws:get())
end

function Story0:enterArea (objid, areaid)
  if (areaid == self.sureGoOutArea) then -- 离开村庄
    if (TalkHelper:hasTask(objid, 1)) then -- 进入村庄
      local player = PlayerHelper:getPlayer(objid)
      if (TalkHelper:hasTask(objid, 2) or TalkHelper:hasTask(objid, 3) or TalkHelper:hasTask(objid, 4)) then
        player:enableMove(false, true)
        player:thinks(0, '问题未解决，我不能轻易离开。')
        local ws = WaitSeconds:new(2)
        TimeHelper:callFnAfterSecond(function ()
          player:enableMove(true, true)
          player:runTo(self.inVillagePoses)
        end, ws:get())
      else
        player:enableMove(false, true)
        player:thinks(0, '此处不详，我要不要离开呢？')
        MyOptionHelper:showOptions(player, 'leave')
      end
    end
    return true
  end
  return false
end
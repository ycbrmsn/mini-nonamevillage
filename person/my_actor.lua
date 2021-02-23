-- 我的人物类

-- 池末
Chimo = BaseActor:new(MyMap.ACTOR.CHIMO)

function Chimo:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(-8.5, 9.5, 47.5), -- 床尾位置
      ActorHelper.FACE_YAW.EAST, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(-11.5, 9.5, 41.5), -- 客厅
      MyPosition:new(-5.5, 9.5, 49.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(-6.5, 8.5, 39.5), -- 进门旁
      MyPosition:new(-10.5, 8.5, 45.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      {
        MyPosition:new(-2.5, 8.5, 47.5), -- 门旁
        MyPosition:new(-6.5, 8.5, 48.5), -- 床旁
      },
      {
        MyPosition:new(-6.5, 8.5, 48.5), -- 床旁
        MyPosition:new(-8.5, 8.5, 49.5), -- 铁门旁
      }
    },
    secondFloorAreaPositions = {
      MyPosition:new(-11.5, 13.5, 41.5), -- 二楼对角
      MyPosition:new(-4.5, 13.5, 46.5), -- 二楼对角
    },
    cakePos = MyPosition:new(-13, 9, 41), -- 蛋糕的位置
    aroundCakePos = MyPosition:new(-12.5, 9.5, 42.5), -- 蛋糕旁边
    standAround = MyPosition:new(-10.5, 8.5, 42.5), -- 站在旁边
    talkInfos = chimoTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Chimo:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Chimo:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea({ self.secondFloorAreaPositions })
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Chimo:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Chimo:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Chimo:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      if (TaskHelper:hasTask(playerid, 2)) then -- 任务二
        player:thinkSelf(0, '这么晚了，还是天亮再跟他说好了。')
      else
        player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
      end
    else
      self.action:stopRun()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      TalkHelper:talkWith(playerid, self)
    end
  end
end

function Chimo:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      if (TaskHelper:hasTask(playerid, 2)) then -- 任务二
        self:beat2(player)
      else
        self:beat1(player)
      end
    end
    self.action:stopRun()
    self:wantLookAt(nil, playerid)
  end
end

function Chimo:candleEvent (player, candle)
  
end

function Chimo:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '小子，你想作甚！',
    '我，我不想做什么！',
    '别多说了！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end

function Chimo:beat2 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened2', {
    '！！！',
    '没想到你是这种人！',
    '我……我都没做什么……',
    '你还想做什么！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end

-- 梅膏
Meigao = BaseActor:new(MyMap.ACTOR.MEIGAO)

function Meigao:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(20.5, 9.5, 47.5), -- 床尾位置
      ActorHelper.FACE_YAW.EAST, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(16.5, 9.5, 41.5), -- 客厅
      MyPosition:new(22.5, 9.5, 49.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(21.5, 8.5, 39.5), -- 进门旁
      MyPosition:new(17.5, 8.5, 45.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      {
        MyPosition:new(25.5, 8.5, 47.5), -- 门旁
        MyPosition:new(21.5, 8.5, 48.5), -- 床旁
      },
      {
        MyPosition:new(21.5, 8.5, 48.5), -- 床旁
        MyPosition:new(19.5, 8.5, 49.5), -- 铁门旁
      }
    },
    secondFloorAreaPositions = {
      MyPosition:new(16.5, 13.5, 41.5), -- 二楼对角
      MyPosition:new(23.5, 13.5, 46.5), -- 二楼对角
    },
    talkInfos = meigaoTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Meigao:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Meigao:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea({ self.secondFloorAreaPositions })
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Meigao:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Meigao:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Meigao:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      if (TaskHelper:hasTask(playerid, 2)) then -- 任务二
        local progress = TalkHelper:getProgress(playerid, 2)
        if (progress >= 9) then
          player:enableMove(false, true)
          player:thinkSelf(0, '我要做什么？')
          MyOptionHelper:showOptions(player, 'stealMeigao')
        else
          player:thinkSelf(0, '这么晚了，还是不要惊动她比较好。')
        end
      else
        player:thinkSelf(0, '这么晚了，还是不要惊动她比较好。')
      end
    else
      self.action:stopRun()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      TalkHelper:talkWith(playerid, self)
    end
  end
end

function Meigao:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      local player = PlayerHelper:getPlayer(playerid)
      self:beat1(player)
    end
    self.action:stopRun()
    self:wantLookAt(nil, playerid)
  end
end

function Meigao:candleEvent (player, candle)
  
end

function Meigao:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '可恶，你想干嘛！',
    '我没有干什么！',
    '三更半夜潜入我房里！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end

-- 王毅
Wangyi = BaseActor:new(MyMap.ACTOR.WANGYI)

function Wangyi:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(20.5, 9.5, 99.5), -- 床尾位置
      ActorHelper.FACE_YAW.EAST, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(16.5, 9.5, 93.5), -- 客厅
      MyPosition:new(22.5, 9.5, 101.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(21.5, 8.5, 91.5), -- 进门旁
      MyPosition:new(17.5, 8.5, 97.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      {
        MyPosition:new(25.5, 8.5, 99.5), -- 门旁
        MyPosition:new(21.5, 8.5, 100.5), -- 床旁
      },
      {
        MyPosition:new(21.5, 8.5, 100.5), -- 床旁
        MyPosition:new(19.5, 8.5, 101.5), -- 铁门旁
      }
    },
    secondFloorAreaPositions = {
      MyPosition:new(16.5, 13.5, 93.5), -- 二楼对角
      MyPosition:new(23.5, 13.5, 98.5), -- 二楼对角
    },
    talkInfos = wangyiTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Wangyi:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Wangyi:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea({ self.secondFloorAreaPositions })
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Wangyi:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Wangyi:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Wangyi:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
    else
      self.action:stopRun()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      TalkHelper:talkWith(playerid, self)
    end
  end
end

function Wangyi:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      local player = PlayerHelper:getPlayer(playerid)
      self:beat1(player)
    end
    self.action:stopRun()
    self:wantLookAt(nil, playerid)
  end
end

function Wangyi:candleEvent (player, candle)
  
end

function Wangyi:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '你不怕黑暗吗？',
    '你要做什么！',
    '送你去沉睡！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end

-- 梁杖
Liangzhang = BaseActor:new(MyMap.ACTOR.LIANGZHANG)

function Liangzhang:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(-28.5, 9.5, 99.5), -- 床尾位置
      ActorHelper.FACE_YAW.WEST, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(-24.5, 9.5, 92.5), -- 客厅
      MyPosition:new(-32.5, 9.5, 99.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(-29.5, 8.5, 91.5), -- 进门旁
      MyPosition:new(-25.5, 8.5, 97.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      {
        MyPosition:new(-32.5, 8.5, 101.5), -- 柜子旁
        MyPosition:new(-27.5, 8.5, 100.5), -- 床旁
      },
    },
    secondFloorAreaPositions = {
      MyPosition:new(-25.5, 13.5, 98.5), -- 二楼对角
      MyPosition:new(-31.5, 13.5, 91.5), -- 二楼对角
    },
    -- frontIronDoorPos = MyPosition:new(-27.5, 8.5, 101.5), -- 铁门前
    mirrorPos = MyPosition:new(-33.5, 9.5, 92.5), -- 八卦镜位置
    talkInfos = liangzhangTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Liangzhang:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Liangzhang:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea({ self.secondFloorAreaPositions })
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Liangzhang:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Liangzhang:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Liangzhang:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then -- 在睡觉
      -- if (TaskHelper:hasTask(playerid, 2)) then -- 任务二
      --   local progress = TalkHelper:getProgress(playerid, 2)
      --   if (progress >= 6) then
      --     if (not(self.lostKey)) then -- 有钥匙
      --       local itemid = MyMap.ITEM.KEY5
      --       if (BackpackHelper:gainItem(playerid, itemid, 1)) then
      --         self.lostKey = true
      --         PlayerHelper:showToast(playerid, '获得', ItemHelper:getItemName(itemid))
      --       end
      --     else
      --       player:thinkSelf(0, '他身上似乎没有钥匙了。')
      --     end
      --   else
      --     player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
      --   end
      -- else
        player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
      -- end
    else
      self.action:stopRun()
      -- self.action:playStretch()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      TalkHelper:talkWith(playerid, self)
    end
  end
end

function Liangzhang:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      local player = PlayerHelper:getPlayer(playerid)
      self:beat1(player)
    end
    self.action:stopRun()
    self:wantLookAt(nil, playerid)
  end
end

function Liangzhang:candleEvent (player, candle)
  
end

function Liangzhang:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '你果然不是好人！',
    '啥啥啥！',
    '我要打死你！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end

-- 甄道
Zhendao = BaseActor:new(MyMap.ACTOR.ZHENDAO)

function Zhendao:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(-28.5, 9.5, 47.5), -- 床尾位置
      ActorHelper.FACE_YAW.WEST, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(-24.5, 9.5, 40.5), -- 客厅
      MyPosition:new(-32.5, 9.5, 47.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(-29.5, 8.5, 39.5), -- 进门旁
      MyPosition:new(-25.5, 8.5, 45.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      {
        MyPosition:new(-32.5, 8.5, 49.5), -- 柜子旁
        MyPosition:new(-27.5, 8.5, 48.5), -- 床旁
      },
    },
    secondFloorAreaPositions = {
      MyPosition:new(-25.5, 13.5, 46.5), -- 二楼对角
      MyPosition:new(-31.5, 13.5, 39.5), -- 二楼对角
    },
    frontIronDoorPos = MyPosition:new(-27.5, 8.5, 49.5), -- 铁门前
    talkInfos = zhendaoTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Zhendao:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Zhendao:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea({ self.secondFloorAreaPositions })
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Zhendao:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Zhendao:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Zhendao:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then -- 在睡觉
      if (TaskHelper:hasTask(playerid, 2)) then -- 任务二
        local progress = TalkHelper:getProgress(playerid, 2)
        if (progress >= 6) then
          if (not(self.lostKey)) then -- 有钥匙
            local itemid = MyMap.ITEM.KEY5
            if (BackpackHelper:gainItem(playerid, itemid, 1)) then
              self.lostKey = true
              PlayerHelper:showToast(playerid, '获得', ItemHelper:getItemName(itemid))
            end
          else
            player:thinkSelf(0, '已经拿到钥匙，还是不要再做什么比较好。')
          end
        else
          player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
        end
      else
        player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
      end
    else
      self.action:stopRun()
      -- self.action:playStretch()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      -- 检测玩家手里的东西
      local itemid = PlayerHelper:getCurToolID(playerid)
      if (itemid and itemid == MyMap.ITEM.SWORD1) then -- 拿着甄道的剑
        self:beat2(player)
      else
        TalkHelper:talkWith(playerid, self)
      end
    end
  end
end

function Zhendao:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      -- 检测玩家手里的东西
      local itemid = PlayerHelper:getCurToolID(playerid)
      if (itemid and itemid == MyMap.ITEM.SWORD1) then -- 拿着甄道的剑
        self:beat2(player)
      else
        self:beat1(player)
      end
    else
      self.action:stopRun()
      self:wantLookAt(nil, playerid)
      -- 检测玩家手里的东西
      local itemid = PlayerHelper:getCurToolID(playerid)
      if (itemid and itemid == MyMap.ITEM.SWORD1) then -- 拿着甄道的剑
        self:beat2(player)
      end
    end
  end
end

function Zhendao:candleEvent (player, candle)
  
end

function Zhendao:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '你果然不是好人！',
    '啥啥啥！',
    '我要打死你！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end

-- 手持
function Zhendao:beat2 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened2', {
    '！！！',
    '可恶，你竟敢偷我的剑！',
    '我没有！',
    '还敢狡辩！你手上拿的是什么！受死吧！',
    '真是没想到……',
    '愚蠢者',
    '你倒在了村民的怒火之下',
  })
end

-- 偷剑被发现
function Zhendao:beat3 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened3', {
    '！！！',
    '可恶，你竟敢偷我的剑！',
    '你听我解释……',
    '不需要解释了！受死吧！',
    '真是没想到……',
    '愚蠢者',
    '你倒在了村民的怒火之下',
  })
end

-- 姚羔
Yaogao = BaseActor:new(MyMap.ACTOR.YAOGAO)

function Yaogao:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(-8.5, 9.5, 99.5), -- 床尾位置
      ActorHelper.FACE_YAW.EAST, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(-11.5, 9.5, 93.5), -- 客厅
      MyPosition:new(-5.5, 9.5, 101.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(-6.5, 8.5, 91.5), -- 进门旁
      MyPosition:new(-10.5, 8.5, 97.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      {
        MyPosition:new(-2.5, 8.5, 99.5), -- 门旁
        MyPosition:new(-6.5, 8.5, 100.5), -- 床旁
      },
      {
        MyPosition:new(-6.5, 8.5, 100.5), -- 床旁
        MyPosition:new(-8.5, 8.5, 101.5), -- 铁门旁
      }
    },
    secondFloorAreaPositions = {
      MyPosition:new(-11.5, 13.5, 93.5), -- 二楼对角
      MyPosition:new(-4.5, 13.5, 98.5), -- 二楼对角
    },
    boxPos = MyPosition:new(-12, 8, 100), -- 箱子的位置
    defaultTalkMsg = '我家的床还没修好。',
    talkInfos = yaogaoTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Yaogao:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Yaogao:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea({ self.secondFloorAreaPositions })
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Yaogao:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Yaogao:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Yaogao:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
    else
      self.action:stopRun()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      TalkHelper:talkWith(playerid, self)
    end
  end
end

function Yaogao:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      local player = PlayerHelper:getPlayer(playerid)
      self:beat1(player)
    end
    self.action:stopRun()
    self:wantLookAt(nil, playerid)
  end
end

function Yaogao:candleEvent (player, candle)
  
end

function Yaogao:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '啊，你要做什么！',
    '误会误会！',
    '别解释了！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end

-- 储依
Chuyi = BaseActor:new(MyMap.ACTOR.CHUYI)

function Chuyi:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(39.5, 9.5, 99.5), -- 床尾位置
      ActorHelper.FACE_YAW.WEST, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(44.5, 9.5, 93.5), -- 客厅
      MyPosition:new(35.5, 9.5, 99.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(38.5, 8.5, 91.5), -- 进门旁
      MyPosition:new(42.5, 8.5, 97.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      MyPosition:new(36.5, 8.5, 99.5), -- 门旁
      MyPosition:new(41.5, 9.5, 101.5), -- 铁门上方
    },
    secondFloorAreaPositions = {
      MyPosition:new(36.5, 13.5, 91.5), -- 二楼对角
      MyPosition:new(42.5, 13.5, 98.5), -- 二楼对角
    },
    boxPos = MyPosition:new(43, 8, 100), -- 箱子的位置
    defaultTalkMsg = '我家的床还没修好。',
    talkInfos = chuyiTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Chuyi:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Chuyi:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea({ self.secondFloorAreaPositions })
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Chuyi:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Chuyi:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Chuyi:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      if (TaskHelper:hasTask(playerid, 2)) then -- 任务二
        local progress = TalkHelper:getProgress(playerid, 2)
        if (progress >= 8) then
          player:enableMove(false, true)
          player:thinkSelf(0, '我要做什么？')
          MyOptionHelper:showOptions(player, 'stealChuyi')
        else
          player:thinkSelf(0, '这么晚了，还是不要惊动她比较好。')
        end
      else
        player:thinkSelf(0, '这么晚了，还是不要惊动她比较好。')
      end
    else
      self.action:stopRun()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      -- 检测玩家手里的东西
      local itemid = PlayerHelper:getCurToolID(playerid)
      if (itemid and itemid == MyMap.ITEM.SWORD3 and TaskHelper:hasTask(playerid, 8)) then -- 拿着储依的剑
        self:beat2(player)
      else
        TalkHelper:talkWith(playerid, self)
      end
    end
  end
end

function Chuyi:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      local itemid = PlayerHelper:getCurToolID(playerid)
      if (itemid and itemid == MyMap.ITEM.SWORD3 and TaskHelper:hasTask(playerid, 8)) then -- 拿着储依的剑
        self:beat2(player)
      else
        self:beat1(player)
      end
    else
      self.action:stopRun()
      self:wantLookAt(nil, playerid)
      -- 检测玩家手里的东西
      local itemid = PlayerHelper:getCurToolID(playerid)
      if (itemid and itemid == MyMap.ITEM.SWORD3 and TaskHelper:hasTask(playerid, 8)) then -- 拿着储依的剑
        self:beat2(player)
      end
    end
  end
end

function Chuyi:candleEvent (player, candle)
  
end

function Chuyi:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '啊，你要做什么！',
    '误会误会！',
    '别解释了！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end

-- 手持
function Chuyi:beat2 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened2', {
    '！！！',
    '可恶，你竟敢偷我的剑！',
    '我没有！',
    '还敢狡辩！你手上拿的是什么！受死吧！',
    '真是没想到……',
    '愚蠢者',
    '你倒在了村民的怒火之下',
  })
end

-- 莫迟
Mochi = BaseActor:new(MyMap.ACTOR.MOCHI)

function Mochi:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(39.5, 9.5, 47.5), -- 床尾位置
      ActorHelper.FACE_YAW.WEST, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(44.5, 9.5, 41.5), -- 客厅
      MyPosition:new(35.5, 9.5, 47.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(38.5, 8.5, 39.5), -- 进门旁
      MyPosition:new(42.5, 8.5, 45.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      MyPosition:new(36.5, 8.5, 47.5), -- 门旁
      MyPosition:new(41.5, 9.5, 49.5), -- 铁门上方
    },
    secondFloorAreaPositions = {
      MyPosition:new(36.5, 13.5, 39.5), -- 二楼对角
      MyPosition:new(42.5, 13.5, 46.5), -- 二楼对角
    },
    boxPos = MyPosition:new(43, 8, 48), -- 箱子的位置
    standPos = MyPosition:new(40, 8.5, 43), -- 莫迟站门口的位置
    standLookAtPos = MyPosition:new(40, 8, 37.5), -- 莫迟看着的位置
    standPos2 = MyPosition:new(39, 8.5, 40.5), -- 池末站的位置
    standPos3 = MyPosition:new(41, 8.5, 40.5), -- 房主站的位置
    defaultTalkMsg = '我家的床还没修好。',
    talkInfos = mochiTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Mochi:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Mochi:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea({ self.secondFloorAreaPositions })
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Mochi:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Mochi:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Mochi:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      if (TaskHelper:hasTask(playerid, 2)) then -- 任务二
        local progress = TalkHelper:getProgress(playerid, 2)
        if (progress >= 20) then
          player:enableMove(false, true)
          player:thinkSelf(0, '我要做什么？')
          MyOptionHelper:showOptions(player, 'stealMochi')
        else
          player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
        end
      else
        player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
      end
    else
      self.action:stopRun()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      -- 检测玩家手里的东西
      local itemid = PlayerHelper:getCurToolID(playerid)
      if (itemid and itemid == MyMap.ITEM.SWORD4 and TaskHelper:hasTask(playerid, 9)) then -- 拿着莫迟的剑
        self:beat2(player)
      else
        TalkHelper:talkWith(playerid, self)
      end
    end
  end
end

function Mochi:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      local itemid = PlayerHelper:getCurToolID(playerid)
      if (itemid and itemid == MyMap.ITEM.SWORD4 and TaskHelper:hasTask(playerid, 9)) then -- 拿着莫迟的剑
        self:beat2(player)
      else
        self:beat1(player)
      end
    else
      self.action:stopRun()
      self:wantLookAt(nil, playerid)
      -- 检测玩家手里的东西
      local itemid = PlayerHelper:getCurToolID(playerid)
      if (itemid and itemid == MyMap.ITEM.SWORD4 and TaskHelper:hasTask(playerid, 9)) then -- 拿着莫迟的剑
        self:beat2(player)
      end
    end
  end
end

function Mochi:candleEvent (player, candle)
  
end

function Mochi:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '啊，你要做什么！',
    '误会误会！',
    '别解释了！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end


-- 手持
function Mochi:beat2 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened2', {
    '！！！',
    '可恶，你竟敢偷我的剑！',
    '我没有！',
    '还敢狡辩！你手上拿的是什么！受死吧！',
    '真是没想到……',
    '愚蠢者',
    '你倒在了村民的怒火之下',
  })
end

-- 陆仁
Luren = BaseActor:new(MyMap.ACTOR.LUREN)

function Luren:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(-27.5, 9.5, 73.5), -- 床尾位置
      ActorHelper.FACE_YAW.EAST, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(-31.5, 9.5, 67.5), -- 客厅
      MyPosition:new(-25.5, 9.5, 75.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(-26.5, 8.5, 65.5), -- 进门旁
      MyPosition:new(-30.5, 8.5, 71.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      {
        MyPosition:new(-22.5, 8.5, 73.5), -- 门旁
        MyPosition:new(-26.5, 8.5, 74.5), -- 床旁
      },
      {
        MyPosition:new(-26.5, 8.5, 74.5), -- 床旁
        MyPosition:new(-28.5, 8.5, 75.5), -- 铁门旁
      }
    },
    secondFloorAreaPositions = {
      MyPosition:new(-31.5, 13.5, 67.5), -- 二楼对角
      MyPosition:new(-24.5, 13.5, 72.5), -- 二楼对角
    },
    boxPos = MyPosition:new(-32, 8, 74), -- 箱子的位置
    defaultTalkMsg = '我家的床还没修好。',
    talkInfos = lurenTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Luren:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Luren:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea({ self.secondFloorAreaPositions })
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Luren:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Luren:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Luren:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
    else
      self.action:stopRun()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      TalkHelper:talkWith(playerid, self)
    end
  end
end

function Luren:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      local player = PlayerHelper:getPlayer(playerid)
      self:beat1(player)
    end
    self.action:stopRun()
    self:wantLookAt(nil, playerid)
  end
end

function Luren:candleEvent (player, candle)
  
end

function Luren:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '啊，你竟然！',
    '误会误会！',
    '解释也没用！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end

-- 贾义
Jiayi = BaseActor:new(MyMap.ACTOR.JIAYI)

function Jiayi:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(40.5, 9.5, 73.5), -- 床尾位置
      ActorHelper.FACE_YAW.EAST, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(36.5, 9.5, 67.5), -- 客厅
      MyPosition:new(42.5, 9.5, 75.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(41.5, 8.5, 65.5), -- 进门旁
      MyPosition:new(37.5, 8.5, 71.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      {
        MyPosition:new(45.5, 8.5, 73.5), -- 门旁
        MyPosition:new(41.5, 8.5, 74.5), -- 床旁
      },
      {
        MyPosition:new(41.5, 8.5, 74.5), -- 床旁
        MyPosition:new(39.5, 8.5, 75.5), -- 铁门旁
      }
    },
    secondFloorAreaPositions = {
      MyPosition:new(36.5, 13.5, 67.5), -- 二楼对角
      MyPosition:new(43.5, 13.5, 72.5), -- 二楼对角
    },
    boxPos = MyPosition:new(36, 8, 74), -- 箱子的位置
    defaultTalkMsg = '我家的床还没修好。',
    talkInfos = jiayiTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Jiayi:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Jiayi:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea({ self.secondFloorAreaPositions })
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Jiayi:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Jiayi:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Jiayi:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
    else
      self.action:stopRun()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      TalkHelper:talkWith(playerid, self)
    end
  end
end

function Jiayi:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      local player = PlayerHelper:getPlayer(playerid)
      self:beat1(player)
    end
    self.action:stopRun()
    self:wantLookAt(nil, playerid)
  end
end

function Jiayi:candleEvent (player, candle)
  
end

function Jiayi:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '啊，你要做什么！',
    '误会误会！',
    '别解释了！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end

-- 林隐
Linyin = BaseActor:new(MyMap.ACTOR.LINYIN)

function Linyin:new ()
  local o = {
    objid = self.actorid,
    isSingleton = true,
    unableBeKilled = true,
    bedData = {
      MyPosition:new(-2.5, 9.5, 74.5), -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH, -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(9.5, 9.5, 67.5), -- 客厅
      MyPosition:new(-5.5, 9.5, 71.5), -- 卧室
    },
    hallAreaPositions = {
      MyPosition:new(8.5, 8.5, 65.5), -- 进门旁
      MyPosition:new(2.5, 8.5, 70.5), -- 楼梯旁
    },
    bedroomAreaPositions = {
      {
        MyPosition:new(-4.5, 8.5, 75.5), -- 柜子旁
        MyPosition:new(-3.5, 8.5, 70.5), -- 门旁
      },
    },
    secondFloorAreaPositions = {
      {
        MyPosition:new(1.5, 13.5, 65.5), -- 二楼对角
        MyPosition:new(9.5, 13.5, 67.5), -- 二楼对角
      },
      {
        MyPosition:new(5.5, 13.5, 65.5), -- 窗户
        MyPosition:new(6.5, 13.5, 75.5), -- 楼梯旁窗户
      }
    },
    talkInfos = linyinTalkInfos, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Linyin:defaultWant ()
  self:doItNow()
end

-- 在几点想做什么
function Linyin:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 13) then
    self:wantFreeInArea(self.secondFloorAreaPositions)
  elseif (hour == 15) then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, self.candlePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed(self.candlePositions)
  end
end

function Linyin:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 13) then
    self:wantAtHour(6)
  elseif (hour >= 13 and hour < 15) then
    self:wantAtHour(13)
  elseif (hour >= 15 and hour < 19) then
    self:wantAtHour(15)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Linyin:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Linyin:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    local player = PlayerHelper:getPlayer(playerid)
    if (self.wants and self.wants[1].style == 'sleeping') then
      player:thinkSelf(0, '这么晚了，还是不要惊动他比较好。')
    else
      self.action:stopRun()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      TalkHelper:talkWith(playerid, self)
    end
  end
end

function Linyin:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      local player = PlayerHelper:getPlayer(playerid)
      self:beat1(player)
    end
    self.action:stopRun()
    self:wantLookAt(nil, playerid)
  end
end

function Linyin:candleEvent (player, candle)
  
end

function Linyin:beat1 (player)
  MyTalkHelper:beatTalks(player, self, 'isHappened1', {
    '！！！',
    '没想到，真是居心叵测！',
    '不，不是的！',
    '永别了！受死吧！',
    '真是没想到……',
    '鬼祟者',
    '你倒在了村民的怒火之下',
  })
end
-- 我的人物类
MyActor = {}

-- 池末
Chimo = BaseActor:new(MyMap.ACTOR.CHIMO)

function Chimo:new ()
  local o = {
    objid = 4300067952,
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
    talkInfos = {
      [1] = {
        [0] = {
          TalkInfo:new(1, '你好，外地人。'), -- index -> progress -> 1a说，2a想，3b说，4b想，5选择
          TalkInfo:new(3, '你好。'),
          TalkInfo:new(4, '要不要借宿一宿呢？'),
          TalkInfo:new(5, {
            PlayerTalk:new('要', 1, nil, function (player)
              StoryHelper:goTo(2, 1)
              StoryHelper:resetTalkIndex(player, 0)
            end),
            PlayerTalk:new('不要', 1),
          }),
          TalkInfo:new(3, '我不小心走错门了，抱歉。'),
        },
      },
      [2] = {
        [1] = {
          TalkInfo:new(3, '我想要借宿一宿。'),
          TalkInfo:new(1, '客房正好空着，你自便。'),
        },
        [2] = {
          TalkInfo:new(1, '你有事吗？'),
          TalkInfo:new(3, '我略懂观气之术，见村子上方似乎汇聚了一股邪气。'),
          TalkInfo:new(1, '邪气！'),
          TalkInfo:new(3, '是的。不知最近村子里可有什么事情发生。'),
          TalkInfo:new(1, '嗯，听你这么一说，我也觉得最近有些心绪不宁。不过近期村子里很太平。'),
          TalkInfo:new(1, '对了，我听说村子里有几把极品桃木剑，不知可否用来驱散邪气。'),
          TalkInfo:new(3, '极品桃木剑？如果有三四把，我可以摆出剑阵，驱散邪气，并找出来源。'),
          TalkInfo:new(1, '那太好了。请你一定要帮助我们。'),
          TalkInfo:new(1, '我隔壁的甄家就有一把，不过那似乎是他的传家宝，想要借来可不容易。'),
          TalkInfo:new(3, '甄家吗？那我去试试看。', function (player)
            StoryHelper:forward2(2, 2)
          end),
        },
        [3] = {
          TalkInfo:new(1, '你借来桃木剑了吗？'),
          TalkInfo:new(3, '还没。'),
        },
        [4] = {
          TalkInfo:new(1, '你借来桃木剑了吗？'),
          TalkInfo:new(3, '没有。我刚表露出借的意思他就回绝了。'),
          TalkInfo:new(1, '那这可如何是好？'),
          TalkInfo:new(3, '我再想想办法。'),
        },
        [5] = {
          TalkInfo:new(1, '怎么样了？'),
          TalkInfo:new(3, '还没想到什么办法。对了，听说你们每家都有物品柜？'),
          TalkInfo:new(1, '嗯，没错。是了，甄道一定是把剑放柜子里的。'),
          TalkInfo:new(3, '就算是，那也没有办法。'),
          TalkInfo:new(1, '不，如果我们拿到钥匙……'),
          TalkInfo:new(3, '你这不是偷吗？'),
          TalkInfo:new(1, '事急从权。如果能驱散掉邪气，这不算什么。'),
          TalkInfo:new(1, '而且我们只是借用一下，到时候还会还过去。'),
          TalkInfo:new(3, '这……'),
          TalkInfo:new(1, '这邪气不除，我心难安。请你务必帮助我们消灭邪气。'),
          TalkInfo:new(3, '……那好吧。用完我就把剑还回去。'),
          TalkInfo:new(1, '太感谢了。钥匙可能在他身上。等到夜间，你可以去看看。'),
          TalkInfo:new(3, '晚上我去看看吧。', function (player)
            StoryHelper:forward2(2, 5)
          end),
        },
        [6] = {
          TalkInfo:new(1, '怎么样，“借”到剑了吗？'),
          TalkInfo:new(3, '还没。'),
        }
      }
    }, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Chimo:defaultWant ()
  self:wantDoNothing()
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
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      self.action:playStretch()
    end
    self.action:stopRun()
    self:lookAt(playerid)
    self:wantLookAt(nil, playerid, 60)
    ActorHelper:talkWith(self, playerid)
  end
end

function Chimo:collidePlayer (playerid, isPlayerInFront)
  -- local nickname = PlayerHelper:getNickname(playerid)
  -- self:speakTo(playerid, 0, '你找我可有要事？')
end

function Chimo:candleEvent (player, candle)
  
end

-- 甄道
Zhendao = BaseActor:new(MyMap.ACTOR.ZHENDAO)

function Zhendao:new ()
  local o = {
    objid = self.actorid,
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
    talkInfos = {
      [1] = {
        [0] = {
          TalkInfo:new(1, '你好，外地人。'),
          TalkInfo:new(3, '你好。'),
          TalkInfo:new(4, '要不要借宿一宿呢？'),
          TalkInfo:new(5, {
            PlayerTalk:new('要', 1, nil, function (player)
              StoryHelper:goTo(3, 1)
              StoryHelper:resetTalkIndex(player, 0)
            end),
            PlayerTalk:new('不要', 1),
          }),
          TalkInfo:new(3, '我不小心走错门了，抱歉。'),
        },
      },
      [2] = {
        [3] = {
          TalkInfo:new(1, '你好。'),
          TalkInfo:new(3, '你好。我见你们村上被一股邪气笼罩。'),
          TalkInfo:new(1, '……'),
          TalkInfo:new(1, '你有办法解决吗？'),
          TalkInfo:new(3, '听说你有一把桃木剑。'),
          TalkInfo:new(1, '那又如何？'),
          TalkInfo:new(3, '可否借我一用，待我完成剑阵驱散邪气即可还你。'),
          TalkInfo:new(1, '不可能。'),
          TalkInfo:new(3, '邪气不除，恐生祸端。'),
          TalkInfo:new(1, '再见。不送。', function (player)
            StoryHelper:forward2(2, 3)
          end),
        },
        [4] = {
          TalkInfo:new(1, '再见。不送。', function (player)
            local actor = player:getClickActor()
            if (actor) then
              actor.defaultTalkMsg = '我是不会借剑给你的。'
            end
          end),
        },
      }
    }, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Zhendao:defaultWant ()
  self:wantDoNothing()
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
      local mainIndex = StoryHelper:getMainStoryIndex()
      local mainProgress = StoryHelper:getMainStoryProgress()
      if (mainIndex == 2 and mainProgress >= 6) then
        if (not(self.lostKey)) then -- 有钥匙
          if (BackpackHelper:addItem(playerid, MyMap.ITEM.KEY5, 1)) then
            self.lostKey = true
            PlayerHelper:showToast(playerid, '获得甄道的钥匙')
          end
        else
          player:thinkSelf(0, '他身上似乎没有钥匙了。')
        end
      else
        player:thinkSelf(0, '我想干什么？')
      end
    else
      self.action:stopRun()
      -- self.action:playStretch()
      self:lookAt(playerid)
      self:wantLookAt(nil, playerid, 60)
      -- 检测玩家手里的东西
      local itemid = PlayerHelper:getCurToolID(playerid)
      if (itemid and itemid == MyMap.ITEM.SWORD1) then -- 拿着甄道的剑
        self:beat1(player)
      else
        ActorHelper:talkWith(self, playerid)
      end
    end
  end
end

function Zhendao:collidePlayer (playerid, isPlayerInFront)

end

function Zhendao:candleEvent (player, candle)
  
end

function Zhendao:beat1 (player)
  player:enableMove(false, true)
  self:speakTo(player.objid, 0, '！！！')
  local ws = WaitSeconds:new(2)
  self:speakTo(player.objid, ws:get(), '可恶，你竟敢偷我的剑！')
  self.action:playAngry(ws:use())
  player:speakSelf(ws:use(), '我没有！')
  self:speakTo(player.objid, ws:use(), '还敢狡辩！你手上拿的是什么！受死吧！')
  self.action:playAttack(ws:use(1))
  player.action:playDie(ws:use(1))
  player:thinkSelf(ws:use(), '真是没想到……')
  TimeHelper:callFnAfterSecond(function ()
    GameHelper:doGameEnd()
  end, ws:get())
end

-- 林树树
Linshushu = BaseActor:new(MyMap.ACTOR.LINSHUSHU)

function Linshushu:new ()
  local o = {
    objid = self.actorid,
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
    talkInfos = {
      [1] = {
        [0] = {
          TalkInfo:new(1, '你好，外地人。'),
          TalkInfo:new(3, '你好。'),
          TalkInfo:new(4, '要不要借宿一宿呢？'),
          TalkInfo:new(5, {
            PlayerTalk:new('要', 1, nil, function (player)
              StoryHelper:goTo(3, 1)
              StoryHelper:resetTalkIndex(player, 0)
            end),
            PlayerTalk:new('不要', 1),
          }),
          TalkInfo:new(3, '我不小心走错门了，抱歉。'),
        },
      },
      [2] = {
        [4] = {
          TalkInfo:new(1, '你好，外地人。'),
          TalkInfo:new(3, '你好。'),
          TalkInfo:new(1, '我是这村的村长。你遇到什么麻烦了吗？'),
          TalkInfo:new(4, '是村长。或许我可以问问他。'),
          TalkInfo:new(3, '村长你好。途径贵地，发现你们村子上空弥漫着一股邪气。'),
          TalkInfo:new(1, '此事当真？'),
          TalkInfo:new(4, '……我应该不会看错吧？'),
          TalkInfo:new(3, '千真万确。我需要道具来驱散它。'),
          TalkInfo:new(3, '听闻甄村友有一把桃木剑，我想借来一用。'),
          TalkInfo:new(1, '哦……那似乎是他家祖传的，恐怕借来不易。'),
          TalkInfo:new(3, '不错。'),
          TalkInfo:new(1, '不知邪气可有危害？'),
          TalkInfo:new(3, '我观邪气似乎存在已久，不过不知何故，现在依然还未成气候。'),
          TalkInfo:new(3, '不过终究是一隐患。而若邪气成型，后果恐难以预料。'),
          TalkInfo:new(1, '嗯……我村里人每人都有一个物品柜，重要东西放在其内，外有铁门锁着。'),
          TalkInfo:new(1, '钥匙在每人手中，他若不愿借剑给你，那也没有办法。'),
          TalkInfo:new(4, '？？？'),
          TalkInfo:new(3, '这样啊……', function (player)
            StoryHelper:forward2(2, 4)
          end),
        },
        [5] = {
          TalkInfo:new(1, '希望你能找到别的办法。'),
        },
      }
    }, -- 对话信息
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Linshushu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Linshushu:wantAtHour (hour)
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

function Linshushu:doItNow ()
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
function Linshushu:init ()
  local initSuc = self:initActor()
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Linshushu:defaultPlayerClickEvent (playerid)
  local actorTeam = CreatureHelper:getTeam(self.objid)
  local playerTeam = PlayerHelper:getTeam(playerid)
  if (actorTeam ~= 0 and actorTeam == playerTeam) then -- 有队伍并且同队
    if (self.wants and self.wants[1].style == 'sleeping') then
      self.wants[1].style = 'wake'
      self.action:playStretch()
    end
    self.action:stopRun()
    self:lookAt(playerid)
    self:wantLookAt(nil, playerid, 60)
    ActorHelper:talkWith(self, playerid)
  end
end

function Linshushu:collidePlayer (playerid, isPlayerInFront)
  
end

function Linshushu:candleEvent (player, candle)
  
end
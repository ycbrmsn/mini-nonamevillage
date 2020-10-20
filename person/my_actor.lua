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
    self.action:stopRun()
    self:lookAt(playerid)
    self:wantLookAt(nil, playerid, 60)
    -- self:reply(playerid)
    ActorHelper:talkWith(self, playerid)
  end
end

function Chimo:reply (playerid)
  local mainIndex = StoryHelper:getMainStoryIndex()
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (mainIndex == 1) then
    self:speakTo(playerid, 0, '你点我干嘛？')
  end
end

function Chimo:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '你找我可有要事？')
end

function Chimo:candleEvent (player, candle)
  
end
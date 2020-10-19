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
      MyPosition:new(-5.5, 9.5, 48.5), -- 卧室
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
            PlayerTalk:new('1要'),
            PlayerTalk:new('2不要', 3),
          }),
          TalkInfo:new(3, '我想要借宿一宿。'),
          TalkInfo:new(1, '好的。'),
        },
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
    self:nextWantFreeInArea(self.hallAreaPositions)
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
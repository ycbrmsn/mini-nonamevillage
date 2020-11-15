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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(1, '你好，外地人。'), -- index -> progress -> 1a说，2a想，3b说，4b想，5选择
            TalkSession:new(3, '你好。'),
            TalkSession:new(4, '要不要借宿一宿呢？'),
            TalkSession:new(5, {
              PlayerTalk:new('要', 1, nil, function (player)
                TaskHelper:addTask(player.objid, 2)
                player:resetTalkIndex(0)
              end),
              PlayerTalk:new('不要', 1),
            }),
            TalkSession:new(3, '我不小心走错门了，抱歉。'),
          }
        }
      }),
      TalkInfo:new({
        id = 24,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 }),
          TalkAnt:new({ t = 4, itemid = MyMap.ITEM.SWORD1 }),
          TalkAnt:new({ t = 4, itemid = MyMap.ITEM.SWORD3 }),
          TalkAnt:new({ t = 4, itemid = MyMap.ITEM.SWORD4 }),
        },
        progress = {
          [1] = {
            TalkSession:new(1, '怎么样了。'),
            TalkSession:new(3, '我终于拿到三把剑了。我这就去布置剑阵。'),
            TalkSession:new(1, '太好了……不过不必急于一时。'),
            TalkSession:new(1, '你奔波忙碌了这么久，也饿了吧。吃点东西，有力气了再去做事。'),
            TalkSession:new(3, '听你这么一说，确实有点饿了。也对，磨刀不误砍柴工。'),
            TalkSession:new(1, '嗯，你稍等。', function (player)
              local want = chimo:wantApproach('forceDoNothing', { chimo.cakePos })
              ActorActionHelper:callback(want, function ()
                BlockHelper:placeBlock(830, chimo.cakePos.x, chimo.cakePos.y, chimo.cakePos.z) -- 放置蛋糕
                local want2 = chimo:wantApproach('forceDoNothing', { player:getMyPosition() })
                ActorActionHelper:callback(want2, function ()
                  TalkHelper:setProgress(player.objid, 2, 25)
                  chimo:forceDoNothing()
                  chimo:wantLookAt('forceDoNothing', player, 100)
                  chimo:speakTo(player.objid, 0, '你看看味道怎样。')
                  ChatHelper:showEndSeparate(player.objid)
                  player:resetTalkIndex(1)
                  Story1:comeToEatCake(player)
                end)
              end)
            end),
          },
        },
      }),
      TalkInfo:new({
        id = 14,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 5 }),
          TalkAnt:new({ t = 4, itemid = MyMap.ITEM.SWORD1 }),
          TalkAnt:new({ t = 4, itemid = MyMap.ITEM.SWORD3 }),
        },
        progress = {
          [1] = {
            TalkSession:new(3, '终于又借来一把。'),
            TalkSession:new(1, '真是太好了。'),
            TalkSession:new(3, '我感觉邪气又浓了一些。'),
            TalkSession:new(1, '啊，是吗？还有一把也摆脱你了。在东南方的莫家。'),
            TalkSession:new(3, '事不宜迟，我这就前往。', function (player)
              TaskHelper:addTask(player.objid, 5)
              TalkHelper:setProgress(player.objid, 2, 20)
              TalkHelper:resetProgressContent(chimo, 2, 0, {
                TalkSession:new(1, '怎么样，在莫家借到剑了吗？'),
                TalkSession:new(3, '还没。'),
              })
            end),
          },
        },
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 })
        },
        progress = {
          [1] = {
            TalkSession:new(3, '我想要借宿一宿。'),
            TalkSession:new(1, '客房正好空着，你自便。'),
          },
          [2] = {
            TalkSession:new(1, '你有事吗？'),
            TalkSession:new(3, '我略懂观气之术，见村子上方似乎汇聚了一股邪气。'),
            TalkSession:new(1, '邪气！'),
            TalkSession:new(3, '是的。不知最近村子里可有什么事情发生。'),
            TalkSession:new(1, '嗯，听你这么一说，我也觉得最近有些心绪不宁。不过近期村子里很太平。'),
            TalkSession:new(1, '对了，我听说村子里有几把极品桃木剑，不知可否用来驱散邪气。'),
            TalkSession:new(3, '极品桃木剑？如果有三四把，我可以摆出剑阵，驱散邪气，并找出来源。'),
            TalkSession:new(1, '那太好了。请你一定要帮助我们。'),
            TalkSession:new(1, '我隔壁的甄家就有一把，不过那似乎是他的传家宝，想要借来可不容易。'),
            TalkSession:new(3, '甄家吗？那我去试试看。', function (player)
              TalkHelper:setProgress(player.objid, 2, 3)
            end),
          },
          [3] = {
            TalkSession:new(1, '你去甄家借来桃木剑了吗？'),
            TalkSession:new(3, '还没。'),
          },
          [4] = {
            TalkSession:new(1, '你借来桃木剑了吗？'),
            TalkSession:new(3, '没有。我刚表露出借的意思他就回绝了。'),
            TalkSession:new(1, '那这可如何是好？'),
            TalkSession:new(3, '我再想想办法。'),
          },
          [5] = {
            TalkSession:new(1, '怎么样了？'),
            TalkSession:new(3, '还没想到什么办法。对了，听说你们每家都有物品柜？'),
            TalkSession:new(1, '嗯，没错。是了，甄道一定是把剑放柜子里的。'),
            TalkSession:new(3, '就算是，那也没有办法。'),
            TalkSession:new(1, '不，如果我们拿到钥匙……'),
            TalkSession:new(3, '你这不是偷吗？'),
            TalkSession:new(1, '事急从权。如果能驱散掉邪气，这不算什么。'),
            TalkSession:new(1, '而且我们只是借用一下，到时候还会还过去。'),
            TalkSession:new(3, '这……'),
            TalkSession:new(1, '这邪气不除，我心难安。请你务必帮助我们消灭邪气。'),
            TalkSession:new(3, '……那好吧。仅此一次，下不为例。用完我就把剑还回去。'),
            TalkSession:new(1, '太感谢了。钥匙可能在他身上。等到夜间，你可以去看看。'),
            TalkSession:new(3, '晚上我去看看吧。', function (player)
              TalkHelper:setProgress(player.objid, 2, 6)
            end),
          },
          [6] = {
            TalkSession:new(1, '怎么样，“借”到剑了吗？'),
            TalkSession:new(3, '还没。'),
          },
          [7] = {
            TalkSession:new(1, '怎么样，“借”到剑了吗？'),
            TalkSession:new(3, '总算是“借”到了。'),
            TalkSession:new(3, '不过我感觉邪气似乎重了一些。'),
            TalkSession:new(1, '啊，那得赶紧拿到另外几把剑了。'),
            TalkSession:new(1, '储依家里也有一把。她家在村子的东北方向。'),
            TalkSession:new(3, '我去看看。', function (player)
              TalkHelper:setProgress(player.objid, 2, 8)
              TalkHelper:resetProgressContent(chimo, 2, 0, {
                TalkSession:new(1, '怎么样，去储家借到剑了吗？'),
                TalkSession:new(3, '还没。'),
              })
            end),
          },
          [10] = {
            TalkSession:new(1, '怎么样，借到剑了吗？'),
            TalkSession:new(3, '储依答应借剑，不过需要借来梅膏的包作为交换条件。'),
            TalkSession:new(3, '而要借来梅膏的包，需要答对她的问题。可惜我答错了。'),
            TalkSession:new(1, '梅膏吗？我跟她关系还不错。这样，我休书一封，她看后会借给你的。'),
            TalkSession:new(3, '那真是太好了。'),
            TalkSession:new(1, '你稍等一下。', function (player)
              TalkHelper:setProgress(player.objid, 2, 11)
            end),
          },
          [11] = {
            TalkSession:new(1, '好了，你拿去吧。', function (player)
              local itemid = MyMap.ITEM.LETTER
              if (BackpackHelper:gainItem(player.objid, itemid, 1)) then
                TalkHelper:setProgress(player.objid, 2, 12)
                chimo.lostLetter = true
                PlayerHelper:showToast(player.objid, '获得', ItemHelper:getItemName(itemid))
              end
            end),
          },
          [21] = {
            TalkSession:new(3, '听说村里有四把剑？'),
            TalkSession:new(1, '是的，不过一次搬房子的时候，姚家的剑遗失了。'),
            TalkSession:new(3, '那有可能找到吗？'),
            TalkSession:new(1, '这么多年来都没听说过，要找到不太可能。莫家那里如何？'),
            TalkSession:new(3, '他说需要一件有类似功能的道具作为交换，才能借给我。'),
            TalkSession:new(1, '类似功能的道具？'),
            TalkSession:new(1, '对了，前段时间，我去梁家玩的时候，他说他在房子里找到了一件可以辟邪的道具。'),
            TalkSession:new(3, '真的吗？'),
            TalkSession:new(1, '当时我也没在意，刚刚听你一提，突然想起来了。'),
            TalkSession:new(1, '你可以向他借来。我跟他关系还行，你就说我向他借，应该没问题。'),
            TalkSession:new(3, '如果真是这样，那就太好了。我这就去看看。', function (player)
              TalkHelper:setProgress(player.objid, 2, 22)
              TalkHelper:resetProgressContent(chimo, 2, 0, {
                TalkSession:new(1, '你就说我向他借，应该没问题。'),
                TalkSession:new(3, '我知道了。'),
              })
            end),
          }
        },
      }),
    }, -- 对话信息
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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(3, '你好，我可以借宿一宿吗？'),
            TalkSession:new(1, '我家里不欢迎陌生人。'),
            TalkSession:new(3, '抱歉，我这就离开。'),
          },
        },
      }),
      TalkInfo:new({
        id = 12,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 }),
          TalkAnt:new({ t = 4, itemid = MyMap.ITEM.LETTER }),
        },
        progress = {
          [1] = {
            TalkSession:new(1, '你没答对，包不能借给你。'),
            TalkSession:new(3, '我这里有池末给你的一封信。'),
            TalkSession:new(1, '池末那小子……'),
            TalkSession:new(1, '给我看看。', function (player)
              local itemid = MyMap.ITEM.LETTER
              if (BackpackHelper:removeGridItemByItemID(player.objid, itemid, 1)) then
                TalkHelper:setProgress(player.objid, 2, 13)
                PlayerHelper:showToast(player.objid, '失去', ItemHelper:getItemName(itemid))
              end
            end),
          },
        },
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 }),
        },
        progress = {
          [0] = {
            TalkSession:new(1, '我家里不欢迎陌生人。'),
            TalkSession:new(3, '抱歉，我这就离开。'),
          },
          [9] = {
            TalkSession:new(3, '你好，在下有一事相求。'),
            TalkSession:new(1, '嗯……'),
            TalkSession:new(3, '听闻小姐有一个好看的包包，可否借在下几天？小姐若有要求，也可提出来。'),
            TalkSession:new(1, '……'),
            TalkSession:new(1, '好。问你一个问题，如果你能答对，我就借给你。'),
            TalkSession:new(3, '一言为定。你说吧。'),
            TalkSession:new(1, '我们村子里有几扇铁门？'),
            TalkSession:new(5, {
              PlayerTalk:new('九扇', 1),
              PlayerTalk:new('十扇', 2, 10),
              PlayerTalk:new('十一扇', 2, 11),
              PlayerTalk:new('十二扇', 2, 12),
            }),
            TalkSession:new(3, '有九扇门。', 13),
            TalkSession:new(3, '有十扇门。', 13),
            TalkSession:new(3, '有十一扇门。', 14),
            TalkSession:new(3, '有十二扇门。', 13),
            TalkSession:new(1, '很遗憾，你答错了。包不能借给你了。', -1, function (player)
              TalkHelper:setProgress(player.objid, 2, 10)
              TalkHelper:resetProgressContent(meigao, 2, 0, {
                TalkSession:new(1, '你没答对，包不能借给你。'),
                TalkSession:new(4, '看来只能想其他办法了。'),
              })
            end),
            TalkSession:new(1, '没错。包就借给你几天。', function (player)
              TalkHelper:setProgress(player.objid, 2, 16)
              player:resetTalkIndex(0)
              meigao.lostBag = true
              local itemid = MyMap.ITEM.BAG
              if (BackpackHelper:gainItem(player.objid, itemid, 1)) then
                PlayerHelper:showToast(player.objid, '获得', ItemHelper:getItemName(itemid))
              end
              TalkHelper:resetProgressContent(meigao, 2, 0, {
                TalkSession:new(1, '没想到这么难的问题你都能答上来。'),
                TalkSession:new(3, '侥幸而已。'),
              })
            end),
          },
          [13] = {
            TalkSession:new(1, '嗯，看在池末的份上，包包就借给你几天。', function (player)
              if (meigao.lostBag) then -- 包包不在
                TalkHelper:setProgress(player.objid, 2, 14)
                player:resetTalkIndex(0)
              else
                local itemid = MyMap.ITEM.BAG
                if (BackpackHelper:gainItem(player.objid, itemid, 1)) then
                  PlayerHelper:showToast(player.objid, '获得', ItemHelper:getItemName(itemid))
                  TalkHelper:setProgress(player.objid, 2, 16)
                  player:resetTalkIndex(0)
                  TalkHelper:resetProgressContent(meigao, 2, 0, {
                    TalkSession:new(1, '包就借给你几天。'),
                    TalkSession:new(3, '万分感谢。'),
                  })
                end
              end
            end),
          },
          [14] = {
            TalkSession:new(1, '！！！'),
            TalkSession:new(1, '我包包不见了……'),
            TalkSession:new(3, '……', function (player)
              TalkHelper:setProgress(player.objid, 2, 15)
              player:resetTalkIndex(0)
            end),
          },
          [15] = {
            TalkSession:new(1, '抱歉，我包包不见了，没办法借给你了。'),
            TalkSession:new(3, '……'),
          },
          [16] = {
            TalkSession:new(3, '万分感谢。', function (player)
              TalkHelper:setProgress(player.objid, 2, 17)
            end),
          },
        },
      }),
    }, -- 对话信息
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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(3, '你好，我可以借宿一宿吗？'),
            TalkSession:new(1, '我家里不欢迎陌生人。'),
            TalkSession:new(3, '抱歉，我这就离开。'),
          },
        },
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 }),
        },
        progress = {
          [0] = {
            TalkSession:new(1, '我家里不欢迎陌生人。'),
            TalkSession:new(3, '抱歉，我这就离开。'),
          },
        },
      }),
    }, -- 对话信息
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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(3, '你好，我可以借宿一宿吗？'),
            TalkSession:new(1, '这你得问村长。'),
            TalkSession:new(4, '？？？'),
            TalkSession:new(3, '抱歉，我这就离开。'),
          },
        }
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 })
        },
        progress = {
          [22] = {
            TalkSession:new(3, '你好。冒昧来访，确实是有要事。'),
            TalkSession:new(1, '……'),
            TalkSession:new(1, '是要借宿吗？'),
            TalkSession:new(3, '不是这事。听闻你有一件辟邪的道具。可否……'),
            TalkSession:new(1, '没有。'),
            TalkSession:new(3, '呃……'),
            TalkSession:new(3, '池末说想向你借一件辟邪的道具。'),
            TalkSession:new(1, '哦，那是什么。'),
            TalkSession:new(3, '他说是你在屋子里找到的。'),
            TalkSession:new(1, '……'),
            TalkSession:new(1, '你等等。', function (player)
              local want = liangzhang:wantApproach('forceDoNothing', { liangzhang.mirrorPos })
              ActorActionHelper:callback(want, function ()
                local want2 = liangzhang:wantApproach('forceDoNothing', { player:getMyPosition() })
                ActorActionHelper:callback(want2, function ()
                  local itemid = MyMap.ITEM.MIRROR
                  if (BackpackHelper:gainItem(player.objid, itemid, 1)) then
                    PlayerHelper:showToast(player.objid, '获得', ItemHelper:getItemName(itemid))
                    TalkHelper:setProgress(player.objid, 2, 23)
                    TalkHelper:resetProgressContent(liangzhang, 2, 0, {
                      TalkSession:new(1, '记得还我。'),
                      TalkSession:new(3, '一定。'),
                    })
                    liangzhang.wants = nil
                  liangzhang:speakTo(player.objid, 0, '拿给你了，让他记得还我。')
                  ChatHelper:showEndSeparate(player.objid)
                  player:resetTalkIndex(1)
                  end
                end)
              end)
            end),
          },
        },
      }),
    }, -- 对话信息
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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(1, '你好，外地人。'),
            TalkSession:new(3, '你好。'),
            TalkSession:new(1, '我正忙着，如果没事不要打扰我。'),
            -- TalkSession:new(4, '要不要借宿一宿呢？'),
            -- TalkSession:new(5, {
            --   PlayerTalk:new('要', 1, nil, function (player)
            --     TaskHelper:addTask(player.objid, 3)
            --     player:resetTalkIndex(0)
            --   end),
            --   PlayerTalk:new('不要', 1),
            -- }),
            TalkSession:new(3, '抱歉，我这就离开。'),
          }
        }
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 })
        },
        progress = {
          [3] = {
            TalkSession:new(1, '你好。'),
            TalkSession:new(3, '你好。我见你们村上被一股邪气笼罩。'),
            TalkSession:new(1, '……'),
            TalkSession:new(1, '你有办法解决吗？'),
            TalkSession:new(3, '听说你有一把桃木剑。'),
            TalkSession:new(1, '那又如何？'),
            TalkSession:new(3, '可否借我一用，待我完成剑阵驱散邪气即可还你。'),
            TalkSession:new(1, '不可能。'),
            TalkSession:new(3, '邪气不除，恐生祸端。'),
            TalkSession:new(1, '我自有打算。不送。', function (player)
              TalkHelper:setProgress(player.objid, 2, 4)
              TalkHelper:resetProgressContent(zhendao, 2, 0, {
                TalkSession:new(1, '我是不会借剑给你的。'),
                TalkSession:new(3, '……'),
              })
            end),
          },
          [4] = {
            TalkSession:new(1, '我自有打算。不送。'),
            TalkSession:new(4, '很有主见啊……'),
          },
        },
      }),
    }, -- 对话信息
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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(3, '你好。我想借宿一宿，不知方不方便？'),
            TalkSession:new(1, '这要问村长了。'),
            TalkSession:new(4, '？？？'),
            TalkSession:new(3, '那打扰了。'),
          },
        },
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 })
        },
        progress = {
          [0] = {
            TalkSession:new(1, '我家的床可能短时间内修不好了。'),
          },
        },
      }),
    }, -- 对话信息
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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(3, '你好。我想借宿一宿，不知方不方便？'),
            TalkSession:new(1, '不太方便。'),
            TalkSession:new(3, '这样啊，那打扰了。'),
          },
        },
      }),
      TalkInfo:new({
        id = 13,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 }),
          TalkAnt:new({ t = 4, itemid = MyMap.ITEM.BAG }),
        },
        progress = {
          [1] = {
            TalkSession:new(3, '你看看是这个包吗？', function (player)
              player:takeOutItem(MyMap.ITEM.BAG)
            end),
            TalkSession:new(1, '没错，就是这个呢。', function (player)
              player:takeOutItem(MyMap.ITEM.BAG)
            end),
            TalkSession:new(3, '那给你。', function (player)
              player:takeOutItem(MyMap.ITEM.BAG)
            end),
            TalkSession:new(1, '太好了。你等等，我这就去取剑。', function (player)
              local itemid = MyMap.ITEM.BAG
              if (BackpackHelper:removeGridItemByItemID(player.objid, itemid, 1)) then -- 失去包
                TalkHelper:setProgress(player.objid, 2, 17)
                PlayerHelper:showToast(player.objid, '失去', ItemHelper:getItemName(itemid))
                local want = chuyi:wantApproach('forceDoNothing', { chuyi.boxPos })
                ActorActionHelper:callback(want, function ()
                  local want2 = chuyi:wantApproach('forceDoNothing', { player:getMyPosition() })
                  local itemid = MyMap.ITEM.SWORD3
                  if (not(BackpackHelper:hasItem(player.objid, itemid))) then -- 玩家没有剑
                    WorldContainerHelper:removeStorageItemByID(chuyi.boxPos.x, 
                      chuyi.boxPos.y, chuyi.boxPos.z, itemid, 1) -- 删除箱子里的剑
                    ActorActionHelper:callback(want2, function ()
                      if (BackpackHelper:gainItem(player.objid, itemid, 1)) then
                        PlayerHelper:showToast(player.objid, '获得', ItemHelper:getItemName(itemid))
                        TalkHelper:setProgress(player.objid, 2, 18)
                        TalkHelper:resetProgressContent(chuyi, 2, 0, {
                          TalkSession:new(1, '用完记得还给我。'),
                          TalkSession:new(3, '一定归还。'),
                        })
                        chuyi.wants = nil
                      end
                      chuyi:speakTo(player.objid, 0, '剑借你两天，用完记得还给我。')
                      ChatHelper:showEndSeparate(player.objid)
                      player:resetTalkIndex(1)
                    end)
                  else -- 无剑
                    chuyi:speakAround(nil, 0, '我的剑呢？！！！')
                    TaskHelper:addTask(player.objid, 8)
                    ActorActionHelper:callback(want2, function ()
                      TalkHelper:setProgress(player.objid, 2, 18)
                      TalkHelper:resetProgressContent(chuyi, 2, 0, {
                        TalkSession:new(1, '这可恶的贼！'),
                        TalkSession:new(3, '……'),
                      })
                      chuyi.wants = nil
                      chuyi:speakTo(player.objid, 0, '我的剑不见了，暂时不能借你了。别让我找到这个贼！')
                      TimeHelper:callFnAfterSecond(function ()
                        player:speakSelf(0, '……')
                        ChatHelper:showEndSeparate(player.objid)
                      end)
                      player:resetTalkIndex(1)
                    end)
                  end
                end)
              end
            end),
          },
        },
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 })
        },
        progress = {
          [8] = {
            TalkSession:new(1, '我家的床还没修好。'),
            TalkSession:new(3, '今天不是为了借宿的事情。我发现你们村子被一股邪气笼罩。'),
            TalkSession:new(1, '啊，有吗？'),
            TalkSession:new(3, '不错，我正是为此而来。你可发现今天天空的阴云更浓了。'),
            TalkSession:new(1, '啊，好像是的。'),
            TalkSession:new(3, '那便是受邪气聚集的影响。我需要几把桃木剑，摆出剑阵驱散邪气。'),
            TalkSession:new(3, '听闻祖上有一把桃木剑，特来借剑一用。'),
            TalkSession:new(1, '啊，我家的桃木剑不能随便借的。'),
            TalkSession:new(3, '我只是借用两天，完成剑阵驱散邪气后即可还你。'),
            TalkSession:new(2, '两天应该关系不大吧……'),
            TalkSession:new(1, '要借你也不是不行。我好喜欢梅姐姐的包包，如果你能借来让我背几天，我就借给你。'),
            TalkSession:new(3, '你的梅姐姐？'),
            TalkSession:new(1, '梅姐姐家在村的东南方。如果你借来包包，我就借剑给你。'),
            TalkSession:new(3, '好的，一言为定。', function (player)
              TalkHelper:setProgress(player.objid, 2, 9)
              TalkHelper:resetProgressContent(chuyi, 2, 0, {
                TalkSession:new(1, '如果你借来梅姐姐的包包，我就借剑给你。'),
              })
            end),
          },
          [17] = {
            TalkSession:new(1, '我先去取剑。', function (player)
              chuyi:actionRightNow()
            end),
          },
        },
      }),
    }, -- 对话信息
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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(3, '你好。我想借宿一宿，不知方不方便？'),
            TalkSession:new(1, '真不巧，我正要准备修床。'),
            TalkSession:new(3, '这样啊，那打扰了。'),
          },
        },
      }),
      TalkInfo:new({
        id = 13,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 }),
          TalkAnt:new({ t = 1, taskid = 7 }),
          TalkAnt:new({ t = 4, itemid = MyMap.ITEM.MIRROR }),
        },
        progress = {
          [1] = {
            TalkSession:new(3, '你看这道具行吗？', function (player)
              player:takeOutItem(MyMap.ITEM.MIRROR)
            end),
            TalkSession:new(1, '这是……八卦镜。没想到你能寻得此物。'),
            TalkSession:new(1, '若是与此物作为交换，我倒是可以借给你几天。'),
            TalkSession:new(3, '好，那给你。'),
            TalkSession:new(1, '你稍等。', function (player)
              local itemid = MyMap.ITEM.MIRROR
              if (BackpackHelper:removeGridItemByItemID(player.objid, itemid, 1)) then -- 失去八卦镜
                TalkHelper:setProgress(player.objid, 2, 24)
                PlayerHelper:showToast(player.objid, '失去', ItemHelper:getItemName(itemid))
                local want = mochi:wantApproach('forceDoNothing', { mochi.boxPos })
                ActorActionHelper:callback(want, function ()
                  local want2 = mochi:wantApproach('forceDoNothing', { player:getMyPosition() })
                  local itemid = MyMap.ITEM.SWORD4
                  if (not(BackpackHelper:hasItem(player.objid, itemid))) then -- 玩家没有剑
                    WorldContainerHelper:removeStorageItemByID(mochi.boxPos.x, 
                      mochi.boxPos.y, mochi.boxPos.z, itemid, 1) -- 删除箱子里的剑
                    ActorActionHelper:callback(want2, function ()
                      if (BackpackHelper:gainItem(player.objid, itemid, 1)) then
                        PlayerHelper:showToast(player.objid, '获得', ItemHelper:getItemName(itemid))
                        TalkHelper:resetProgressContent(mochi, 2, 0, {
                          TalkSession:new(1, '记得还给我。'),
                          TalkSession:new(3, '一定归还。'),
                        })
                        mochi.wants = nil
                      end
                      mochi:speakTo(player.objid, 0, '用完记得还给我。')
                      ChatHelper:showEndSeparate(player.objid)
                      player:resetTalkIndex(1)
                    end)
                  else
                    mochi:speakAround(nil, 0, '岂有此理！！！')
                    TaskHelper:addTask(player.objid, 9)
                    ActorActionHelper:callback(want2, function ()
                      TalkHelper:setProgress(player.objid, 2, 18)
                      TalkHelper:resetProgressContent(chuyi, 2, 0, {
                        TalkSession:new(1, '这该如何是好？'),
                        TalkSession:new(3, '……'),
                      })
                      mochi.wants = nil
                      mochi:speakTo(player.objid, 0, '我的剑失踪了，暂时不能借你了。')
                      TimeHelper:callFnAfterSecond(function ()
                        player:speakSelf(0, '……')
                        ChatHelper:showEndSeparate(player.objid)
                      end)
                      player:resetTalkIndex(1)
                    end)
                  end
                end)
              end
            end),
          },
        },
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 })
        },
        progress = {
          [0] = {
            TalkSession:new(3, '你好。我想借宿一宿，不知方不方便？'),
            TalkSession:new(1, '真不巧，我家的床坏了。'),
            TalkSession:new(3, '这样啊，那打扰了。'),
          },
          [20] = {
            TalkSession:new(1, '我家的床还没修好。'),
            TalkSession:new(3, '今天不是为借宿而来。你可知你们村长被邪气笼罩着。'),
            TalkSession:new(1, '略知一二。'),
            TalkSession:new(3, '你知道就最好不过了。我想借你的桃木剑一用，摆出三义剑阵驱散邪气。'),
            TalkSession:new(1, '正是因为知道，所以才不能借给你。'),
            TalkSession:new(3, '？？？'),
            TalkSession:new(1, '我们村因处于特殊的位置，很容易招来四方邪气。'),
            TalkSession:new(1, '为此，村里的先辈们打造出了四把桃木剑，各镇一方，可破诸邪。'),
            TalkSession:new(4, '原来剑有四把。'),
            TalkSession:new(1, '不过因为某些原因，有一把剑遗失了。于是才有了随后的邪气。'),
            TalkSession:new(3, '既然如此，那更应该驱散邪气，并找出根源。请相信我。'),
            TalkSession:new(1, '我说了这么多，你就应该知道，剑不能随便移位。除非你能找到替代品。'),
            TalkSession:new(3, '替代品？'),
            TalkSession:new(1, '不错。就是有类似功能的道具。'),
            TalkSession:new(3, '那我试试吧。'),
            TalkSession:new(1, '在你没有拿来其他替代品之前，我是不会借的。'),
            TalkSession:new(4, '看来只能找到替代品了。', function (player)
              TaskHelper:addTask(player.objid, 7)
              TalkHelper:setProgress(player.objid, 2, 21)
              TalkHelper:resetProgressContent(mochi, 2, 0, {
                TalkSession:new(1, '我是不会随便借的。'),
                TalkSession:new(4, '看来只能找到替代品了。'),
              })
            end),
          },
        },
      }),
    }, -- 对话信息
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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(3, '你好。我想借宿一宿，不知方不方便？'),
            TalkSession:new(1, '真不巧，我家的床塌了。'),
            TalkSession:new(3, '这样啊，那打扰了。'),
          },
        },
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 })
        },
        progress = {
          [0] = {
            TalkSession:new(1, '我家的床可能短时间内修不好了。'),
          },
        },
      }),
    }, -- 对话信息
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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(3, '你好。我想借宿一宿，不知方不方便？'),
            TalkSession:new(1, '真不巧，我家的床烂了。'),
            TalkSession:new(3, '这样啊，那打扰了。'),
          },
        },
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 })
        },
        progress = {
          [0] = {
            TalkSession:new(1, '我家的床可能短时间内修不好了。'),
          },
        },
      }),
    }, -- 对话信息
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
    talkInfos = {
      TalkInfo:new({
        id = 1,
        ants = {
          TalkAnt:new({ t = 2, taskid = 2 }),
          TalkAnt:new({ t = 2, taskid = 3 }),
          TalkAnt:new({ t = 2, taskid = 4 }),
        },
        progress = {
          [0] = {
            TalkSession:new(1, '你好，外地人。'),
            TalkSession:new(3, '你好。'),
            TalkSession:new(1, '我是村里的村长，你有事吗？'),
            -- TalkSession:new(4, '要不要借宿一宿呢？'),
            -- TalkSession:new(5, {
            --   PlayerTalk:new('要', 1, nil, function (player)
            --     TaskHelper:addTask(player.objid, 4)
            --     player:resetTalkIndex(0)
            --   end),
            --   PlayerTalk:new('不要', 1),
            -- }),
            TalkSession:new(3, '我不小心走错门了，抱歉。'),
          }
        }
      }),
      TalkInfo:new({
        id = 2,
        ants = {
          TalkAnt:new({ t = 1, taskid = 2 })
        },
        progress = {
          [0] = {
            TalkSession:new(1, '你好，有事吗？'),
            TalkSession:new(3, '没。'),
          },
          [4] = {
            TalkSession:new(1, '你好，外地人。'),
            TalkSession:new(3, '你好。'),
            TalkSession:new(1, '我是这村的村长。你遇到什么麻烦了吗？'),
            TalkSession:new(4, '是村长。或许我可以问问他。'),
            TalkSession:new(3, '村长你好。途径贵地，发现你们村子上空弥漫着一股邪气。'),
            TalkSession:new(1, '此事当真？'),
            TalkSession:new(4, '……我应该不会看错吧？'),
            TalkSession:new(3, '千真万确。我需要道具来驱散它。'),
            TalkSession:new(3, '听闻甄村友有一把桃木剑，我想借来一用。'),
            TalkSession:new(1, '哦……那似乎是他家祖传的，恐怕借来不易。'),
            TalkSession:new(3, '不错。'),
            TalkSession:new(1, '不知邪气可有危害？'),
            TalkSession:new(3, '我观邪气似乎存在已久，不过不知何故，现在依然还未成气候。'),
            TalkSession:new(3, '不过终究是一隐患。而若邪气成型，后果恐难以预料。'),
            TalkSession:new(1, '嗯……我村里人每家都有一个物品柜，重要东西放在其内，外有铁门锁着。'),
            TalkSession:new(1, '钥匙在每人手中，他若不愿借剑给你，那也没有办法。'),
            TalkSession:new(4, '？？？'),
            TalkSession:new(3, '这样啊……'),
            TalkSession:new(1, '希望你能找到别的办法。'),
            TalkSession:new(3, '嗯，我不会放弃的。', function (player)
              TalkHelper:setProgress(player.objid, 2, 5)
            end),
          },
          [5] = {
            TalkSession:new(1, '希望你能找到别的办法。'),
            TalkSession:new(3, '嗯，我不会放弃的。'),
          },
        },
      }),
    }, -- 对话信息
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
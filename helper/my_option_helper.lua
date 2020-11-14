-- 我的选项工具类
MyOptionHelper = {
  optionMap = {
    sleep = { -- 睡觉选项
      { '不睡觉', function (player)
          player:enableMove(true)
          player:thinks(0, '现在还不想休息。')
        end
      },
      { '睡半个时辰', function (player)
          player:enableMove(true)
          TimeHelper:addHour(1)
          PlayerHelper:showToast(player.objid, '时间过去半个时辰')
          MyOptionHelper:storyForward(player)
        end
      },
      { '睡一个时辰', function (player)
          player:enableMove(true)
          TimeHelper:addHour(2)
          PlayerHelper:showToast(player.objid, '时间过去一个时辰')
          MyOptionHelper:storyForward(player)
          ActorHelper:doItNow()
        end
      },
      { '睡两个时辰', function (player)
          player:enableMove(true)
          TimeHelper:addHour(4)
          PlayerHelper:showToast(player.objid, '时间过去两个时辰')
          MyOptionHelper:storyForward(player)
          ActorHelper:doItNow()
        end
      },
    },
    leave = { -- 离开选项
      { '不离开', function (player) -- 不离开
          local story = StoryHelper:getStory(1)
          player:thinks(0, '既然让我遇上了，不解决怎可轻易离开。')
          local ws = WaitSeconds:new(2)
          TimeHelper:callFnAfterSecond(function ()
            player:enableMove(true, true)
            player:runTo(story.inVillagePoses)
          end, ws:get())
        end
      },
      { '离开', function (player) -- 离开
          PlayerHelper:changeVMode(player.objid)
          local story = StoryHelper:getStory(1)
          player:thinks(0, '君子不立于危墙之下。我还是暂且离开。')
          local ws = WaitSeconds:new(2)
          TimeHelper:callFnAfterSecond(function ()
            player:enableMove(true, true)
            player:runTo({ story.initPos })
          end, ws:use())
          ChatHelper:waitSpeak('？？？', nil, ws:use(), '他离开了。')
          ChatHelper:waitSpeak('？？？', nil, ws:use(), '嗯，这样最好了。我可不喜欢变数。')
          ChatHelper:waitSpeak('？？？', nil, ws:use(), '俺也一样。')
          TimeHelper:callFnAfterSecond(function ()
            MyGameHelper:setNameAndDesc('善身者', '三十六计走为上计')
            PlayerHelper:setGameWin(player.objid)
          end, ws:get())
        end
      },
    },
    stealMeigao = {
      { '看看她身上有什么', function (player)
          player:enableMove(true, true)
          if (not(meigao.lostBag)) then -- 有包包
            local itemid = MyMap.ITEM.BAG
            if (BackpackHelper:gainItem(playerid, itemid, 1)) then
              meigao.lostBag = true
              PlayerHelper:showToast(playerid, '获得', ItemHelper:getItemName(itemid))
              MyOptionHelper:stealThink(player)
            end
          else
            player:thinkSelf(0, '她身上似乎没有什么特别的东西了。')
          end
        end
      },
      { '不做什么', function (player)
          player:enableMove(true, true)
          player:thinkSelf(0, '还是不要做什么比较好。')
        end
      },
    },
    stealChuyi = {
      { '看看她身上有什么', function (player)
          player:enableMove(true, true)
          if (not(chuyi.lostKey)) then -- 有钥匙
            local itemid = MyMap.ITEM.KEY7
            if (BackpackHelper:gainItem(player.objid, itemid, 1)) then
              chuyi.lostKey = true
              PlayerHelper:showToast(player.objid, '获得', ItemHelper:getItemName(itemid))
              MyOptionHelper:stealThink(player)
            end
          else
            player:thinkSelf(0, '她身上似乎没有什么特别的东西了。')
          end
        end
      },
      { '不做什么', function (player)
          player:enableMove(true, true)
          player:thinkSelf(0, '还是不要做什么比较好。')
        end
      },
    },
    stealMochi = {
      { '看看他身上有什么', function (player)
          player:enableMove(true, true)
          if (not(mochi.lostKey)) then -- 有钥匙
            local itemid = MyMap.ITEM.KEY8
            if (BackpackHelper:gainItem(player.objid, itemid, 1)) then
              mochi.lostKey = true
              PlayerHelper:showToast(player.objid, '获得', ItemHelper:getItemName(itemid))
              MyOptionHelper:stealThink(player)
            end
          else
            player:thinkSelf(0, '他身上似乎没有什么特别的东西了。')
          end
        end
      },
      { '不做什么', function (player)
          player:enableMove(true, true)
          player:thinkSelf(0, '还是不要做什么比较好。')
        end
      },
    },
  }
}

-- 剧情前进
function MyOptionHelper:storyForward (player)
  local taskids = { 2, 3, 4 }
  for i, taskid in ipairs(taskids) do
    if (TaskHelper:hasTask(player.objid, taskid)) then
      local progress = TalkHelper:getProgress(player.objid, taskid)
      if (progress == 1) then
        TalkHelper:setProgress(player.objid, taskid, 2)
        player:thinkSelf(1, '睡了一觉，终于有点精神了。或许我可以找主人家问问情况。')
      end
      break
    end
  end
end

-- 显示选项
function MyOptionHelper:showOptions (player, optionname)
  local arr = self.optionMap[optionname]
  ChatHelper:showChooseItems(player.objid, arr, 1)
  player.whichChoose = optionname
end

-- 偷后想
function MyOptionHelper:stealThink (player)
  if (player.stealTimes == 0) then
    player:thinkSelf(1, '我为什么会这么做？')
  elseif (player.stealTimes == 1) then
    player:thinkSelf(1, '难道我也受邪气影响了？')
  else
    player:thinkSelf(1, '为什么我控制不了自己了？')
  end
  player:addStealTimes()
end
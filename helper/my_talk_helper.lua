-- 我的对话工具类
MyTalkHelper = {}

-- 击败的对话
function MyTalkHelper:beatTalks (player, actor, situation, talks)
  if (not(actor[situation])) then
    actor[situation] = true
    player:enableMove(false, true)
    actor:forceDoNothing()
    actor:wantLookAt(nil, player, 10)
    actor:speakTo(player.objid, 0, talks[1])
    actor:speakTo(player.objid, 2, talks[2])
    actor.action:playAngry(2)
    -- 判断是否有迷惑符
    TimeHelper:callFnAfterSecond(function ()
      if (BackpackHelper:hasItem(player.objid, MyMap.ITEM.CONFUSE_CHARM)) then -- 有迷惑符
        player:speakSelf(0, '对了，我有这个。')
        player:takeOutItem(MyMap.ITEM.CONFUSE_CHARM)
        TimeHelper:callFnAfterSecond(function ()
          if (BackpackHelper:hasItem(player.objid, MyMap.ITEM.CONFUSE_CHARM)) then
            ActorHelper:playAndStopBodyEffect(player.objid, BaseConstant.BODY_EFFECT.LIGHT4)
            BackpackHelper:removeGridItemByItemID(player.objid, MyMap.ITEM.CONFUSE_CHARM, 1)
            ActorHelper:playAndStopBodyEffect(actor.objid, BaseConstant.BODY_EFFECT.LIGHT31)
            local ws = WaitSeconds:new(2)
            TimeHelper:callFnAfterSecond(function ()
              player:enableMove(true, true)
            end, ws:get())
            actor:speakAround(nil, ws:get(), '咦，我在干嘛？')
            actor.action:playThink(ws:use())
            actor:speakAround(nil, ws:get(), '算了，不想那么多了。')
            TimeHelper:callFnAfterSecond(function ()
              actor[situation] = false
              actor:wantDoNothing()
              actor:doItNow()
            end, ws:use())
          else
            player:thinkSelf(0, '不小心丢掉了！！！')
            MyTalkHelper:defeat(player, actor, talks)
          end
        end, 2)
      else -- 没有
        MyTalkHelper:defeat(player, actor, talks)
      end
    end, 4)
  end
end

function MyTalkHelper:defeat (player, actor, talks)
  PlayerHelper:changeVMode(player.objid)
  local ws = WaitSeconds:new(2)
  player:speakSelf(0, talks[3])
  actor:speakTo(player.objid, ws:use(), talks[4])
  actor.action:playAttack(ws:use(1))
  player.action:playDie(ws:use(1))
  player:thinkSelf(ws:use(), talks[5])
  TimeHelper:callFnAfterSecond(function ()
    MyGameHelper:setNameAndDesc(talks[6], talks[7])
    GameHelper:doGameEnd()
  end, ws:get())
end
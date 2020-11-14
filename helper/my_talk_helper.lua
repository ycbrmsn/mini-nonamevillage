-- 我的对话工具类
MyTalkHelper = {
  needRemoveTasks = {}
}

-- 显示对话结束分隔
function MyTalkHelper:showEndSeparate (objid)
  TaskHelper:removeTasks(objid, self.needRemoveTasks)
  ChatHelper:showEndSeparate(objid)
end

-- 显示对话中止分隔
function MyTalkHelper:showBreakSeparate (objid)
  TaskHelper:removeTasks(objid, self.needRemoveTasks)
  ChatHelper:showBreakSeparate(objid)
end

-- 击败的对话
function MyTalkHelper:beatTalks (player, actor, situation, talks)
  if (not(actor[situation])) then
    actor[situation] = true
    player:enableMove(false, true)
    PlayerHelper:changeVMode(player.objid)
    actor:speakTo(player.objid, 0, talks[1])
    local ws = WaitSeconds:new(2)
    actor:speakTo(player.objid, ws:get(), talks[2])
    actor.action:playAngry(ws:use())
    player:speakSelf(ws:use(), talks[3])
    actor:speakTo(player.objid, ws:use(), talks[4])
    actor.action:playAttack(ws:use(1))
    player.action:playDie(ws:use(1))
    player:thinkSelf(ws:use(), talks[5])
    TimeHelper:callFnAfterSecond(function ()
      MyGameHelper:setNameAndDesc(talks[6], talks[7])
      GameHelper:doGameEnd()
    end, ws:get())
  end
end
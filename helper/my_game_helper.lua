-- 我的游戏工具类
MyGameHelper = {
  index = 0, -- 帧序数
}

function MyGameHelper:setGBattleUI ()
  local player = PlayerHelper:getHostPlayer()
  if (player) then
    TimerHelper:pauseTimer(self.timerid)
    local teamid = PlayerHelper:getTeam(player.objid)
    local teamScore = TeamHelper:getTeamScore(teamid)
    local time = TimerHelper:getTimerTime(self.timerid)
    local result = PlayerHelper:getGameResults(player.objid)
    local score = math.floor(time / 3) + teamScore -- 剩余时间 + 金币得分
    if (score < teamScore or result == 2) then
      score = teamScore
    end
    local msg
    if (result and result == 1) then
      msg = '成功抵达了终点，得分：'
    else
      msg = '在中途被淘汰，得分：'
    end
    UIHelper:setGBattleUI('left_desc', player:getName() .. msg .. score)
    UIHelper:setGBattleUI('left_little_desc', '获得金币数：' .. player.coinNum)
    UIHelper:setGBattleUI('right_little_desc', '剩余时间：' .. time)
  end
  UIHelper:setGBattleUI('result', false)
end

-- 事件

-- 开始游戏
function MyGameHelper:startGame ()
  LogHelper:debug('开始游戏')
  GameHelper:startGame()
  MyBlockHelper:init()
  MyActorHelper:init()
  MyMonsterHelper:init()
  MyAreaHelper:init()
  MyStoryHelper:init()
  -- body
end

-- 游戏运行时
function MyGameHelper:runGame ()
  GameHelper:runGame()
  self.index = self.index + 1
  -- body
end

-- 结束游戏
function MyGameHelper:endGame ()
  GameHelper:endGame()
  -- body
  MyGameHelper:setGBattleUI()
end

-- 世界时间到[n]点
function MyGameHelper:atHour (hour)
  GameHelper:atHour(hour)
end

-- 世界时间到[n]秒
function MyGameHelper:atSecond (second)
  GameHelper:atSecond(second)
end

-- 任意计时器发生变化
function MyGameHelper:minitimerChange (timerid, timername)
  GameHelper:minitimerChange(timerid, timername)
  -- body
end
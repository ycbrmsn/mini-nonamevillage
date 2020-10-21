-- 我的游戏工具类
MyGameHelper = {
  index = 0, -- 帧序数
  name = '', -- 称号
  desc = '', -- 描述
}

function MyGameHelper:setGBattleUI ()
  local player = PlayerHelper:getHostPlayer()
  if (player) then
    local story = StoryHelper:getStory()
    local result = PlayerHelper:getGameResults(objid)
    -- local msg
    -- if (result == TEAM_RESULTS.TEAM_RESULTS_WIN) then -- 胜利
    --   msg = story.winMsg
    -- else
    --   msg = story.loseMsg
    -- end
    -- UIHelper:setGBattleUI('left_desc', msg)
    -- UIHelper:setGBattleUI('left_little_desc', '获得金币数：' .. player.coinNum)
    -- UIHelper:setGBattleUI('right_little_desc', '剩余时间：' .. time)
    UIHelper:setGBattleUI('left_desc', self.desc)
    UIHelper:setLeftTitle('获得称号：')
    -- UIHelper:setRightTitle(story.name)
    UIHelper:setRightTitle(self.name)
  end
  UIHelper:setGBattleUI('result', false)
end

function MyGameHelper:setNameAndDesc (name, desc)
  self.name = name
  self.desc = desc
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
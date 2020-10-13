-- 我的剧情工具类
MyStoryHelper = {
  index = 1,
  openBoxes = {}, -- 打开的箱子集合
}

function MyStoryHelper:init ()
  if (#StoryHelper:getStorys() == 0) then
    local ss = { Story0 }
    for i, v in ipairs(ss) do
      local s = v:new()
      s:init()
      StoryHelper:addStory(s)
    end
  end
end

-- 下一关
function MyStoryHelper:next ()
  self.index = self.index + 1
  return MyStoryHelper:getStory()
end

-- 当前关卡
function MyStoryHelper:getStory ()
  return StoryHelper:getStory(self.index)
end

-- 事件

-- 世界时间到[n]点
function MyStoryHelper:atHour (hour)
  StoryHelper:atHour(hour)
  -- body
end

-- 玩家进入游戏
function MyStoryHelper:playerEnterGame (objid)
    MyStoryHelper:init()
end

-- 玩家离开游戏
function MyStoryHelper:playerLeaveGame (objid)
  -- body
end

-- 玩家进入区域
function MyStoryHelper:playerEnterArea (objid, areaid)
  -- body
  local story = StoryHelper:getStory()
  if (story:enterArea(objid, areaid)) then
  end
end

-- 玩家离开区域
function MyStoryHelper:playerLeaveArea (objid, areaid)
  -- body
end

-- 玩家点击方块
function MyStoryHelper:playerClickBlock (objid, blockid, x, y, z)
  -- body
end

-- 玩家点击生物
function MyStoryHelper:playerClickActor (objid, toobjid)
  -- body
end

-- 玩家获得道具
function MyStoryHelper:playerAddItem (objid, itemid, itemnum)
  -- body
end

-- 玩家使用道具
function MyStoryHelper:playerUseItem (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家消耗道具
function MyStoryHelper:playerConsumeItem (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家攻击命中
function MyStoryHelper:playerAttackHit (objid, toobjid)
  -- body
end

-- 玩家造成伤害
function MyStoryHelper:playerDamageActor (objid, toobjid, hurtlv)
  -- body
end

-- 玩家击败生物
function MyStoryHelper:playerDefeatActor (playerid, objid)
  -- body
end

-- 玩家受到伤害
function MyStoryHelper:playerBeHurt (objid, toobjid, hurtlv)
  -- body
end

-- 玩家死亡
function MyStoryHelper:playerDie (objid, toobjid)
  -- body
end

-- 玩家复活
function MyStoryHelper:playerRevive (objid, toobjid)
  -- body
end

-- 玩家选择快捷栏
function MyStoryHelper:playerSelectShortcut (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家快捷栏变化
function MyStoryHelper:playerShortcutChange (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家运动状态改变
function MyStoryHelper:playerMotionStateChange (objid, playermotion)
  -- body
end

-- 玩家移动一格
function MyStoryHelper:playerMoveOneBlockSize (objid)
  -- body
end

-- 玩家骑乘
function MyStoryHelper:playerMountActor (objid, toobjid)
  -- body
end

-- 玩家取消骑乘
function MyStoryHelper:playerDismountActor (objid, toobjid)
  -- body
end

-- 聊天输出界面变化
function MyStoryHelper:playerInputContent(objid, content)
  -- body
end

-- 输入字符串
function MyStoryHelper:playerNewInputContent(objid, content)
  -- body
end

-- 按键被按下
function MyStoryHelper:playerInputKeyDown (objid, vkey)
  -- body
end

-- 按键处于按下状态
function MyStoryHelper:playerInputKeyOnPress (objid, vkey)
  -- body
end

-- 按键松开
function MyStoryHelper:playerInputKeyUp (objid, vkey)
  -- body
end

-- 等级发生变化
function MyStoryHelper:playerLevelModelUpgrade (objid, toobjid)
  -- body
end

-- 属性变化
function MyStoryHelper:playerChangeAttr (objid, playerattr)
  -- body
end

-- 生物进入区域
function MyStoryHelper:actorEnterArea (objid, areaid)
  -- body
end

-- 生物离开区域
function MyStoryHelper:actorLeaveArea (objid, areaid)
  -- body
end

-- 生物碰撞
function MyStoryHelper:actorCollide (objid, toobjid)
  -- body
end

-- 生物攻击命中
function MyStoryHelper:actorAttackHit (objid, toobjid)
  -- body
end

-- 生物击败目标
function MyStoryHelper:actorBeat (objid, toobjid)
  -- body
end

-- 生物行为改变
function MyStoryHelper:actorChangeMotion (objid, actormotion)
  -- body
end

-- 生物死亡
function MyStoryHelper:actorDie (objid, toobjid)
  -- body
end

-- 容器内有道具取出
function MyStoryHelper:backpackItemTakeOut (blockid, x, y, z, itemid, itemnum)
  -- body
  local pos = MyPosition:new(x, y, z)
  for i, v in ipairs(MyBackpackHelper.boxInfos) do
    if (itemid == v.itemid) then -- 道具没错
      local distance = MathHelper:getDistance(v.pos, pos)
      if (distance < 1) then -- 位置正确
        LogHelper:debug('这是')
      end
    end
  end
end
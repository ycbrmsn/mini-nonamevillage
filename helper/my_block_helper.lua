-- 我的方块工具类
MyBlockHelper = {
  unableBeoperated = {
    BlockHelper.bedid
  },
  unableDestroyed = {},
  switchPos = MyPosition:new(4, 6, 73),
  vasePos = MyPosition:new(9.5, 8.5, 72.5),
  vaseid = 948, -- 大瓷花盆
  ironDoor = 814, -- 铁门
}

-- 初始化
function MyBlockHelper:init ()
  -- body
  MyBlockHelper:initBlocks()
end

function MyBlockHelper:initBlocks ()
  for i,v in ipairs(self.unableBeoperated) do
    BlockHelper:setBlockSettingAttState(v, BLOCKATTR.ENABLE_BEOPERATED, false) -- 不可操作  
  end
  for i, v in ipairs(self.unableDestroyed) do
    BlockHelper:setBlockSettingAttState(v, BLOCKATTR.ENABLE_DESTROYED, false) -- 不可被破坏
  end
end

-- 点击大花盆
function MyBlockHelper:clickVase (objid, blockid, x, y, z)
  if (blockid == self.vaseid) then
    local pos = MyPosition:new(x, y, z)
    local distance = MathHelper:getDistance(self.vasePos, pos)
    if (distance < 1) then -- 位置正确
      if (PlayerHelper:isMainPlayer(objid)) then -- 房主
        BlockHelper:toggleSwitch(self.switchPos)
      else
        ChatHelper:sendMsg(objid, '你发现你转不动，也许应该让其他人试试')
      end
      return true
    end
  end
  return false
end

function MyBlockHelper:clickBed (objid, blockid, x, y, z)
  LogHelper:debug(blockid)
  if (blockid == BlockHelper.bedid) then
    local player = PlayerHelper:getPlayer(objid)
    if (player:isHostPlayer()) then
      local pos = MyPosition:new(x, y, z)
      local mainIndex = StoryHelper:getMainStoryIndex()
      local mainProgress = StoryHelper:getMainStoryProgress()
      if (mainIndex == 2 and mainProgress == 1) then
        local story = StoryHelper:getStory()
        local distance = MathHelper:getDistance(story.aroundBedPos, pos)
        LogHelper:debug(distance)
        if (distance < 5) then
          player:runTo({ story.aroundBedPos }, function ()
            player:thinkSelf(0, '也许晚点的时候，我可以来探查一番。')
          end)
          return true
        end
      end
    end
  end
  return false
end

-- 事件

-- 方块被破坏
function MyBlockHelper:blockDestroyBy (objid, blockid, x, y, z)
  BlockHelper:blockDestroyBy(objid, blockid, x, y, z)
  -- body
end

-- 完成方块挖掘
function MyBlockHelper:blockDigEnd (objid, blockid, x, y, z)
  BlockHelper:blockDigEnd(objid, blockid, x, y, z)
  -- body
end

-- 方块被放置
function MyBlockHelper:blockPlaceBy (objid, blockid, x, y, z)
  BlockHelper:blockPlaceBy(objid, blockid, x, y, z)
  -- body
end

-- 方块被移除
function MyBlockHelper:blockRemove (blockid, x, y, z)
  BlockHelper:blockRemove(blockid, x, y, z)
  -- body
end

-- 方块被触发
function MyBlockHelper:blockTrigger (objid, blockid, x, y, z)
  BlockHelper:blockTrigger(objid, blockid, x, y, z)
  -- body
end
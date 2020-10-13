-- 我的背包工具类
MyBackpackHelper = {
  boxInfos = {
    { pos = MyPosition:new(-11.5, 8.5, 48.5), itemid = MyMap.ITEM.SKULL }, -- 池末
  }
}

-- 事件

-- 容器内有道具取出
function MyBackpackHelper:backpackItemTakeOut (blockid, x, y, z, itemid, itemnum)
  BackpackHelper:backpackItemTakeOut(blockid, x, y, z, itemid, itemnum)
  MyStoryHelper:backpackItemTakeOut(blockid, x, y, z, itemid, itemnum)
  -- body
end
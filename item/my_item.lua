-- 我的道具类

-- 钥匙类
Key = BaseItem:new()

function Key:new (o)
  o = o or {}
  if (o.id) then
    ItemHelper:register(o)
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function Key:clickBlock (objid, blockid, x, y, z)
  if (blockid == MyBlockHelper.ironDoor) then -- 精铁门
    local pos = MyPosition:new(x, y, z)
    local distance = MathHelper:getDistance(self.doorPos, pos)
    if (distance < 2) then -- 位置正确
      if (PlayerHelper:isMainPlayer(objid)) then -- 房主
        BlockHelper:toggleDoor(self.doorPos.x, self.doorPos.y, self.doorPos.z)
      else
        ChatHelper:sendMsg(objid, '你发现你转不动，也许应该让其他人试试')
      end
    end
  end
end

-- 钥匙
Key1 = Key:new({ 
  id = MyMap.ITEM.KEY1,
  doorPos = MyPosition:new(-9.5, 8.5, 49.5),
})

Key2 = Key:new({ 
  id = MyMap.ITEM.KEY2,
  doorPos = MyPosition:new(18.5, 8.5, 49.5),
})

Key3 = Key:new({ 
  id = MyMap.ITEM.KEY3,
  doorPos = MyPosition:new(18.5, 8.5, 101.5),
})

Key4 = Key:new({ 
  id = MyMap.ITEM.KEY4,
  doorPos = MyPosition:new(-26.5, 8.5, 101.5),
})

Key5 = Key:new({ 
  id = MyMap.ITEM.KEY5,
  doorPos = MyPosition:new(-26.5, 8.5, 49.5),
})

Key6 = Key:new({ 
  id = MyMap.ITEM.KEY6,
  doorPos = MyPosition:new(-9.5, 8.5, 101.5),
})

Key7 = Key:new({ 
  id = MyMap.ITEM.KEY7,
  doorPos = MyPosition:new(41.5, 8.5, 101.5),
})

Key8 = Key:new({ 
  id = MyMap.ITEM.KEY8,
  doorPos = MyPosition:new(41.5, 8.5, 49.5),
})

Key9 = Key:new({ 
  id = MyMap.ITEM.KEY9,
  doorPos = MyPosition:new(7.5, 8.5, 75.5),
})

-- 池末写的信
Letter = BaseItem:new({ id = MyMap.ITEM.LETTER })

function Letter:useItem (objid)
  ChatHelper:sendMsg(objid, '你偷偷拆开了信，发现上面没有文字，画着一幅画：一只鸡划着小船向岸边驶去。天空中没有云朵，只有一个大太阳。')
  local player = PlayerHelper:getPlayer(objid)
  player:thinkSelf(4, '……完全搞不懂。')
end
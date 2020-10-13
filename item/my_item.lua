-- 我的道具类

-- 钥匙
Key1 = BaseItem:new({ 
  id = MyMap.ITEM.KEY1,
  doorPos = MyPosition:new(-9.5, 8.5, 49.5)
})

function Key1:clickBlock (objid, blockid, x, y, z)
  if (blockid == MyBlockHelper.ironDoor) then -- 精铁门
    local pos = MyPosition:new(x, y, z)
    local distance = MathHelper:getDistance(self.doorPos, pos)
    if (distance < 1) then -- 位置正确
      if (PlayerHelper:isMainPlayer(objid)) then -- 房主
        BlockHelper:toggleDoor(x, y, z)
      else
        ChatHelper:sendMsg(objid, '你发现你转不动，也许应该让其他人试试')
      end
    end
  end
end
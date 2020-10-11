-- 我的玩家类
MyPlayer = BasePlayer:new()

function MyPlayer:new (objid)
  local o = {
    objid = objid,
    x = 0,
    y = 0,
    z = 0,
  }
  o.action = BasePlayerAction:new(o)
  o.attr = BasePlayerAttr:new(o)
  o.attr.defeatedExp = 0
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyPlayer:initMyPlayer ()
  PlayerHelper:setJumpPower(self.objid, 95)
end

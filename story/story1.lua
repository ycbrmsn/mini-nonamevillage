-- 剧情一
Story1 = MyStory:new()

function Story1:new ()
  local data = {
    title = '剧情一',
    name = '无名称',
    desc = '无描述',
    tips = {
      '好累，先去休息一下。',
      '我似乎应该问问主人家这里的事情。',
      '去甄家问问看，不知道剑好不好借。',
      '剑果然不好借，也许我可以问问其他人。',
      '剑似乎在柜子里。我回去再跟主人家商量商量。',
      '事急从权。晚上我要做一回梁上君子了。',
      '甄道醒了，赶紧躲好。',
    },
    prepose = {
      ['先去休息'] = 1,
      ['询问故事'] = 2,
      ['前往借剑'] = 3,
      ['借剑失败'] = 4,
      ['柜子信息'] = 5,
      ['梁上君子'] = 6,
      ['隐藏门内'] = 7,
    },
    aroundBedPos = MyPosition:new(-3.5, 8.5, 41.5), -- 床旁边
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end

function Story1:wake (objid)
  zhendao:setPosition(zhendao.bedData[1])
  zhendao:speak(0, '嗯……好像有什么声音……')
  zhendao.action:playStretch()
  local player = PlayerHelper:getPlayer(objid)
  -- 判断玩家是否在卧室区域
  local areaid = AreaHelper:createAreaRectByRange(zhendao.bedroomAreaPositions[1][1],
    Key5.doorPos)
  if (AreaHelper:objInArea(areaid, objid)) then -- 在卧室
    zhendao:beat2(player)
  else -- 没在卧室
    local ws = WaitSeconds:new(2)
    TimeHelper:callFnAfterSecond(function ()
      if (AreaHelper:objInArea(areaid, objid)) then -- 在卧室
        zhendao:beat2(player)
      else -- 不在卧室
        zhendao:wantMove('hear', { zhendao.frontIronDoorPos })
        zhendao:nextWantLookAt(nil, Key5.doorPos, 1)
      end
    end, ws:use())
    TimeHelper:callFnAfterSecond(function ()
      if (AreaHelper:objInArea(areaid, objid)) then -- 在卧室
        zhendao:beat2(player)
      else
        if (BlockHelper:isDoorOpen(Key5.doorPos.x, Key5.doorPos.y, Key5.doorPos.z)) then -- 门开着
          zhendao:wantApproach('angry', { player:getMyPosition() })
          zhendao:beat2(player)
        else -- 门关着
          zhendao:speak(0, '莫非是我听错了？')
          TimeHelper:callFnAfterSecond(function ()
            zhendao:doItNow()
          end, 1)
        end
      end
    end, ws:use())
  end
end


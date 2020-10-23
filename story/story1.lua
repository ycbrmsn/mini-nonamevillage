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
      '储家也有一把剑。不知道好不好借。',
      '看来我需要找到梅家，借来包包。',
      '答错问题了没有借到包包，要不我再到池家问问。',
      '池末说要给我一封信。不知道有没有用。',
      '拿到了池末的信，我去试试看吧。',
    },
    prepose = {
      ['先去休息'] = 1,
      ['询问故事'] = 2,
      ['甄家借剑'] = 3,
      ['甄道不借'] = 4,
      ['柜子信息'] = 5,
      ['梁上君子'] = 6,
      ['拿到一剑'] = 7,
      ['储家借剑'] = 8,
      ['需要借包'] = 9,
      ['借包失败'] = 10,
      ['池末有招'] = 11,
      ['拿信相试'] = 12,
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


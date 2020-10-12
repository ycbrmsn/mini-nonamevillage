-- 地图相关数据
MyMap = {
  BLOCK = {
    
  },
  ITEM = {
    SWORD = 4097, -- 桃木剑
  },
  ACTOR = {
    
  },
  BUFF = {
    CONTINUE = 999, -- 继续探险
    PROTECT = 50000001, -- 缩小保护
  },
  CUSTOM = {
    
  }
}

-- 模板
MyTemplate = {
  GAIN_EXP_MSG = '你获得{exp}点经验', -- exp（获得经验）
  GAIN_DEFEATED_EXP_MSG = '历经生死，你获得{exp}点经验', -- exp（获得经验）
  UPGRADE_MSG = '你升级了', -- exp（获得经验）、level（玩家等级）
  -- UNUPGRADE_MSG = '当前为{level}级。还差{needExp}点经验升级' -- level（玩家等级）、needExp（升级还需要的经验）
  TEAM_MSG = '当前红队有{1}人，蓝队有{2}人，准备玩家有{0}人', -- 0（无队伍人数）、1（红队人数）、2（蓝队人数）
  PRESENT_MSG = '欢迎{name}进入游戏，作者额外送你{present}', -- name、present
}

-- 武器属性
MyWeaponAttr = {}

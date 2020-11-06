-- 地图相关数据
MyMap = {
  BLOCK = {
    
  },
  ITEM = {
    SWORD = 4097, -- 桃木剑
    SKULL = 4098, -- 骷髅头
    KEY1 = 4099, -- 池末
    KEY2 = 4100, -- 梅膏
    KEY3 = 4101, -- 王毅
    KEY4 = 4102, -- 梁杖
    KEY5 = 4103, -- 甄道
    KEY6 = 4104, -- 姚羔
    KEY7 = 4105, -- 储依
    KEY8 = 4106, -- 莫迟
    KEY9 = 4107, -- 林隐
    SWORD1 = 4121, -- 甄道的桃木剑
    SWORD2 = 4122, -- 姚羔的桃木剑
    SWORD3 = 4123, -- 储依的桃木剑
    SWORD4 = 4124, -- 莫迟的桃木剑
    BAG = 4125, -- 梅膏的背包
    LETTER = 4126, -- 池末写的信
  },
  ACTOR = {
    CHIMO = 2, -- 池末
    MEIGAO = 3, -- 梅膏
    WANGYI = 4, -- 王毅
    LIANGZHANG = 5, -- 梁杖
    ZHENDAO = 6, -- 甄道
    YAOGAO = 7, -- 姚羔
    CHUYI = 8, -- 储依
    MOCHI = 9, -- 莫迟
    LUREN = 10, -- 陆仁
    JIAYI = 11, -- 贾义
    LINYIN = 12, -- 林隐
  },
  BUFF = {
    
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

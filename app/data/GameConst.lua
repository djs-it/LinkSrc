--###################GAME CONFIG#######################

--##########GAME_CONST############
--游戏配置常量
--配置
GRID_WIDTH    = 11
GRID_HEIGHT   = 12

GRID_BORDER_WIDTH  = 92
GRID_BORDER_HEIGHT = 110

GAME_BORDER_OFFSETY = display.height/2 - 6.3*GRID_BORDER_HEIGHT


GAME_ALL_LEVEL = 18

-------------------------------
--游戏难度系数
--
RAND_GAMEDATA = {}
RAND_GAMEDATA[1] = 45
RAND_GAMEDATA[2] = 55
RAND_GAMEDATA[3] = 70
RAND_GAMEDATA[4] = 80


-------------------------------
--游戏难度名称
--
RAND_NAME = {}
RAND_NAME[1] = "简单"
RAND_NAME[2] = "中等"
RAND_NAME[3] = "复杂"
RAND_NAME[4] = "随机"


-------------------------------
--随机pattern 对应的数量
--small 1  mid 2  big 3
--
RAND_PATTERN = {}
RAND_PATTERN[1] = 77
RAND_PATTERN[2] = 46
RAND_PATTERN[3] = 26

-------------------------------
--ZORDER对应调整规则
--
ELEMENT_ZORDER = 100


-------------------------------
--TAG 对应调整规则
--

TYPE_OTHER = 100
TAG_EFFECT = 100

TIME_CLOUD_NUM = 2
TIME_CLOUD_NAME = "time_cloud"

TIME_GAMING_NUM = 1
TIME_GAMING_NAME = "gaming_count"

ANIMAL_ALL_NUM = 20

SEARCH_GROUND = {}
SEARCH_GROUND[1] = cc.p(1,0)
SEARCH_GROUND[2] = cc.p(-1,0)
SEARCH_GROUND[3] = cc.p(0,1)
SEARCH_GROUND[4] = cc.p(0,-1)

WAY_TYPE = {}
WAY_TYPE[0] = 0-- 没有
WAY_TYPE[1] = 1--方形右
WAY_TYPE[2] = 2--方向左
WAY_TYPE[3] = 3--方向上
WAY_TYPE[4] = 4--方向下

---------－－－－－－－－－－－－－
--定义元素类型
--
ELEMENT_TYPE = {
    _NUM = 39,
    _0 = 0,
    _1 = 1,
    _2 = 2,
    _3 = 3,
    _4 = 4,
    _5 = 5,
    _6 = 6,
    _7 = 7,
    _8 = 8,
    _9 = 9,
    _10 = 10,
    _11 = 11,
    _12 = 12,
    _13 = 13,
    _14 = 14,
    _15 = 15,
    _16 = 16,

}


----------------------------
--定义data数据表中相应的类型
--
DATA_TYPE ={
    _0 = 0,--空
    _1 = 1,--需要随机
    _2 = 2,--砖块障碍物˘
    _3 = 3,
    _4 = 4,--方向右
    _5 = 5,--方向左
    _6 = 6,--方向上
    _7 = 7,--方向下
    _8 = 8,--冰块不可点击
    _9 = 9,--问号
    _10 = 10,--金钥匙对应的锁链
    _11 = 11,--银钥匙对应的锁链
    _12 = 12,
    _13 = 13,--乌云
    _14 = 14,
    _15 = 15,--圆宝石相对应的砖块障碍物
    _16 = 16,--四角宝石对应的砖块障碍物
    _17 = 17,--六角形宝石对应的砖块障碍物
    _18 = 18,-- 外墙
    _19 = 19,--ice1
    _20 = 20,--ice2
    _21 = 21,--ice3
    _22 = 22,--圆宝石
    _23 = 23,--四角宝石
    _24 = 24,--六角形宝石
    _25 = 25,--金钥匙
    _26 = 26,--银钥匙
    _27 = 27,
    _28 = 28,
    _29 = 29,--1
    _30 = 30,--2
    _31 = 31,--3
    _32 = 32,--4
    _33 = 33,--5
    _34 = 34,--6
    _35 = 35,--7
    _36 = 36,--8
    _37 = 37,--9
    _80 = 80,--金币
}

-----------------------------------
--LEVEL MSG
--EXP 经验   T 星时间 R 星奖励 G 金币 D 钻石 B BOSS
--
LEVEL_MSG = {}
LEVEL_MSG[1] = { EXP = 100, T = {10,20},R = {100,50,1}  }
LEVEL_MSG[2] = { EXP = 100, T = {10,20},R = {100,50,1}  }
LEVEL_MSG[3] = { EXP = 100, T = {10,20},R = {100,50,1}  }
LEVEL_MSG[4] = { EXP = 100, T = {10,20},R = {100,50,1}  }
LEVEL_MSG[5] = { EXP = 100, T = {20,30},R = {100,50,1}  }
LEVEL_MSG[6] = { EXP = 100, T = {30,40},R = {100,50,1}  }
LEVEL_MSG[7] = { EXP = 100, T = {30,40},R = {100,50,1}  }
LEVEL_MSG[8] = { EXP = 100, T = {40,50},R = {100,50,1}  }
LEVEL_MSG[9] = { EXP = 100, T = {40,50},R = {100,50,1}  }
LEVEL_MSG[10] = { EXP = 100, T = {40,50},R = {100,50,1}  }
LEVEL_MSG[11] = { EXP = 100, T = {40,50},R = {100,50,1}  }
LEVEL_MSG[12] = { EXP = 100, T = {40,50},R = {100,50,1}  }
LEVEL_MSG[13] = { EXP = 100, T = {50,60},R = {100,50,1}  }
LEVEL_MSG[14] = { EXP = 100, T = {50,60},R = {100,50,1}  }
LEVEL_MSG[15] = { EXP = 100, T = {60,70},R = {100,50,1}  }
LEVEL_MSG[16] = { EXP = 100, T = {60,70},R = {100,50,1}  }
LEVEL_MSG[17] = { EXP = 100, T = {70,80},R = {100,50,1}  }
LEVEL_MSG[18] = { EXP = 100, T = {70,80},R = {100,50,1}  }
LEVEL_MSG[19] = { EXP = 100, T = {70,80},R = {100,50,1}  }
LEVEL_MSG[20] = { EXP = 100, T = {70,80},R = {100,50,1}  }
LEVEL_MSG[21] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[22] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[23] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[24] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[25] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[26] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[27] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[28] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[29] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[30] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[31] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[32] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[33] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[34] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[35] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[36] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[37] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[38] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[39] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[40] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[41] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[42] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[43] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[44] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[45] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[46] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[47] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[48] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[49] = { EXP = 100, T = {80,90},R = {100,50,1}  }
LEVEL_MSG[50] = { EXP = 100, T = {80,90},R = {100,50,1}  }


------------------------------------------------
--T 消除的块数  N 对应的块数或时间
--
LEVEL_BOSS = {}
LEVEL_BOSS[1] = { T = {16,12} , N = {4,8}}
LEVEL_BOSS[2] = { T = {6,12} , N = {4,8}}
LEVEL_BOSS[3] = { T = {6,12} , N = {4,8}}
LEVEL_BOSS[4] = { T = {6,12} , N = {4,8}}
LEVEL_BOSS[5] = { T = {6,12} , N = {4,8}}
LEVEL_BOSS[6] = { T = {6,12} , N = {4,8}}
LEVEL_BOSS[7] = { T = {6,12} , N = {4,8}}
LEVEL_BOSS[8] = { T = {6,12} , N = {4,8}}
LEVEL_BOSS[9] = { T = {6,12} , N = {4,8}}
LEVEL_BOSS[10] = { T = {10,20,30,40,50,60,70,80} , N = {4,4,4,4,4,4,4,4}}

-----------------------------------
--ANIMAL MSG
--
ANML = {}
ANML[1] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[2] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[3] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[4] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[5] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[6] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[7] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[8] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[9] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[10] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[11] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[12] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[13] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[14] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[15] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[16] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[17] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[18] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[19] = {{50},{20},{},{},{},{},{},{},{},{}}
ANML[20] = {{50},{20},{},{},{},{},{},{},{},{}}


ANM_SAY = {}
ANM_SAY[1] = "每次消除有几率把一对变金币"
ANM_SAY[2] = "经验加成"
ANM_SAY[3] = "金币加成"
ANM_SAY[4] = "每次消除有几率给对方增加块"
ANM_SAY[5] = "每次消除有几率给对方翻转"
ANM_SAY[6] = "每次消除有几率给对方石块"
ANM_SAY[7] = "每次消除有几率提示"
ANM_SAY[8] = "每次消除有几率显示可消块所在区"
ANM_SAY[9] = "每次消除有几率给对方云"
ANM_SAY[10] = "每次消除有几率给对方冰冻"
ANM_SAY[11] = "每次消除有几率给对方冰块"
ANM_SAY[12] = "耗哥还没想好呢"
ANM_SAY[13] = "每次消除有几率自动消除一对"
ANM_SAY[14] = "每次消除有几率给对方黑白"
ANM_SAY[15] = "每次消除有几率给对方问号"
ANM_SAY[16] = "每次消除有几率给对方乌云"
ANM_SAY[17] = "每次消除有几率给对方眩晕"
ANM_SAY[18] = "每次消除有几率消除一个障碍类技能(石块,冰冻，冰块)"
ANM_SAY[19] = "每次消除有几率给对方西红柿"
ANM_SAY[20] = "每次消除有几率消除一个记忆类技能(问号,乌云)"
ANM_SAY[21] = "有一定几率抵抗黑白，云，眩晕和西红柿"



-----------------------------
--Layers
--
LAYERS = {
    main_room = "main_room",
    main_top = "main_top",
    main_bottom = "main_bottom",
    main_bm_btn = "main_bm_btn",

    single_main = "single_main",
    single_map = "single_map",
    single_level_begin = "single_level_begin",
    single_rand_begin = "single_rand_begin",

    room_main = "room_main",
    animal_main= "animal_main",
    pk_main = "pk_main",

    gaming_other = "gaming_other",
    gaming_ctl = "gaming_ctl",
    gaming_bg = "gaming_bg",
    gaming_bg_top = "gaming_bg_top",
    gaming_bg_bm = "gaming_bg_bm",
    gaming_pause = "gaming_pause",
    gaming_over = "gaming_over",
    gaming_wall = "gaming_wall",

}


SLOTER = {
    user_id = "user_id",
    user_name = "user_name",
    user_exp = "user_exp",
    user_level = "user_level",
    user_gem = "user_gem",
    user_gold = "user_gold",

    single_rand_box = "single_rand_box",
    single_level_star = "single_level_star",
    single_level_time = "single_level_time",
    single_level_now = "single_level_now",
    
    animal_have = "animal_have",
    animal_stage = "animal_stage",

    buy = "buy",
    activity = "activity",

}
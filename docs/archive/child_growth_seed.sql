-- 0-3岁儿童生长发育及养育行为指导 SQLite seed SQL
-- Generated from the provided PDF text extraction.
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS checkup_item;
DROP TABLE IF EXISTS vaccine_item;
DROP TABLE IF EXISTS development_item;
DROP TABLE IF EXISTS content_item;
DROP TABLE IF EXISTS growth_metric;
DROP TABLE IF EXISTS stage_raw_text;
DROP TABLE IF EXISTS dimension;
DROP TABLE IF EXISTS age_stage;
DROP TABLE IF EXISTS dataset_meta;

CREATE TABLE dataset_meta (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

CREATE TABLE age_stage (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    display_name TEXT NOT NULL,
    min_days INTEGER NOT NULL,
    max_days INTEGER NOT NULL,
    sort_order INTEGER NOT NULL,
    source_pages TEXT NOT NULL
);

CREATE TABLE dimension (
    dimension_key TEXT PRIMARY KEY,
    dimension_name TEXT NOT NULL,
    dimension_group TEXT NOT NULL,
    unit TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    description TEXT
);

CREATE TABLE stage_raw_text (
    stage_id TEXT PRIMARY KEY,
    raw_text TEXT NOT NULL,
    FOREIGN KEY(stage_id) REFERENCES age_stage(id)
);

CREATE TABLE growth_metric (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    stage_id TEXT NOT NULL,
    metric_key TEXT NOT NULL,
    metric_name TEXT NOT NULL,
    unit TEXT NOT NULL,
    male_min REAL,
    male_max REAL,
    female_min REAL,
    female_max REAL,
    growth_rate TEXT,
    source_text TEXT,
    FOREIGN KEY(stage_id) REFERENCES age_stage(id),
    FOREIGN KEY(metric_key) REFERENCES dimension(dimension_key)
);

CREATE TABLE content_item (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    stage_id TEXT NOT NULL,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    summary TEXT,
    content TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY(stage_id) REFERENCES age_stage(id),
    FOREIGN KEY(category) REFERENCES dimension(dimension_key)
);

CREATE TABLE development_item (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    stage_id TEXT NOT NULL,
    domain TEXT NOT NULL,
    content TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY(stage_id) REFERENCES age_stage(id),
    FOREIGN KEY(domain) REFERENCES dimension(dimension_key)
);

CREATE TABLE vaccine_item (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    stage_id TEXT NOT NULL,
    age_label TEXT NOT NULL,
    vaccine_name TEXT NOT NULL,
    dose TEXT,
    note TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY(stage_id) REFERENCES age_stage(id)
);

CREATE TABLE checkup_item (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    stage_id TEXT NOT NULL,
    age_label TEXT NOT NULL,
    purpose TEXT NOT NULL,
    items TEXT NOT NULL,
    note TEXT,
    FOREIGN KEY(stage_id) REFERENCES age_stage(id)
);

CREATE INDEX idx_age_stage_sort ON age_stage(sort_order);
CREATE INDEX idx_growth_metric_key ON growth_metric(metric_key);
CREATE INDEX idx_growth_metric_stage ON growth_metric(stage_id);
CREATE INDEX idx_content_stage_category ON content_item(stage_id, category);
CREATE INDEX idx_content_category ON content_item(category);
CREATE INDEX idx_development_domain ON development_item(domain);
CREATE INDEX idx_vaccine_stage ON vaccine_item(stage_id);
CREATE INDEX idx_checkup_stage ON checkup_item(stage_id);
BEGIN TRANSACTION;
INSERT INTO dataset_meta (key, value) VALUES ('dataset_name', '0-3岁儿童生长发育及养育行为指导');
INSERT INTO dataset_meta (key, value) VALUES ('version', '1.0.0');
INSERT INTO dataset_meta (key, value) VALUES ('source_pdf', '0~3岁儿童生长发育及养育行为指导.pdf');
INSERT INTO dataset_meta (key, value) VALUES ('source_pages', '20');
INSERT INTO dataset_meta (key, value) VALUES ('generated_at', '2026-04-25');
INSERT INTO dataset_meta (key, value) VALUES ('note', '由PDF文本抽取后结构化为SQLite seed SQL；stage_raw_text保留阶段原文，结构化表用于H5多维查询。');
INSERT INTO age_stage (id, name, display_name, min_days, max_days, sort_order, source_pages) VALUES ('0_42d', '0-42天小婴儿', '0-42天', 0, 42, 1, '[2,3,4]');
INSERT INTO age_stage (id, name, display_name, min_days, max_days, sort_order, source_pages) VALUES ('42d_3m', '42天-3个月婴儿', '42天-3个月', 42, 90, 2, '[4,5,6]');
INSERT INTO age_stage (id, name, display_name, min_days, max_days, sort_order, source_pages) VALUES ('4_6m', '4-6个月婴儿', '4-6个月', 91, 180, 3, '[6,7,8]');
INSERT INTO age_stage (id, name, display_name, min_days, max_days, sort_order, source_pages) VALUES ('7_9m', '7-9个月婴儿', '7-9个月', 181, 270, 4, '[8,9,10,11]');
INSERT INTO age_stage (id, name, display_name, min_days, max_days, sort_order, source_pages) VALUES ('10_12m', '10-12个月婴儿', '10-12个月', 271, 365, 5, '[11,12,13]');
INSERT INTO age_stage (id, name, display_name, min_days, max_days, sort_order, source_pages) VALUES ('13_18m', '13-18个月幼儿', '13-18个月', 366, 545, 6, '[13,14,15]');
INSERT INTO age_stage (id, name, display_name, min_days, max_days, sort_order, source_pages) VALUES ('19_24m', '19-24个月幼儿', '19-24个月', 546, 730, 7, '[15,16,17]');
INSERT INTO age_stage (id, name, display_name, min_days, max_days, sort_order, source_pages) VALUES ('25_30m', '25-30个月幼儿', '25-30个月', 731, 910, 8, '[17,18]');
INSERT INTO age_stage (id, name, display_name, min_days, max_days, sort_order, source_pages) VALUES ('31_36m', '31-36个月幼儿', '31-36个月', 911, 1095, 9, '[18,19,20]');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('weight', '体重', 'growth', 'kg', 1, '各阶段男女儿童体重范围或增长速度');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('height', '身高', 'growth', 'cm', 2, '各阶段男女儿童身高/身长范围或增长速度');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('head_circumference', '头围', 'growth', 'cm', 3, '各阶段男女儿童头围范围或增长速度');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('sleep', '睡眠', 'care', NULL, 10, '各阶段睡眠时长、频率和睡眠行为建议');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('stool', '排便', 'care', NULL, 11, '各阶段排便频率和性状说明');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('milk_feeding', '乳类喂养', 'nutrition', NULL, 20, '母乳、配方奶及饮奶量建议');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('complementary_food', '辅食/主食添加', 'nutrition', NULL, 21, '辅食、主食和家庭食物添加建议');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('supplements', '营养剂添加', 'nutrition', NULL, 22, '维生素D、维生素A、铁剂等补充建议');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('vaccine', '疫苗接种', 'medical', NULL, 30, '各阶段疫苗接种安排');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('checkup', '体检', 'medical', NULL, 31, '各阶段儿童保健体检时间、目的和项目');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('common_issue', '常见问题', 'medical', NULL, 32, '各阶段常见养育或健康问题');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('warning_sign', '警示信号', 'medical', NULL, 33, '需要关注的发育警示信号');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('motor', '动作发展', 'development', NULL, 40, '粗大动作和精细动作发展表现');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('language', '语言发展', 'development', NULL, 41, '听说、发声、理解和表达能力');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('cognition', '认知发展', 'development', NULL, 42, '感知、探索、记忆、分类等认知表现');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('social_emotional', '情感与社会性', 'development', NULL, 43, '依恋、情绪表达、社交互动等表现');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('parenting', '养育指导', 'parenting', NULL, 50, '亲子互动、生活习惯、游戏和训练建议');
INSERT INTO dimension (dimension_key, dimension_name, dimension_group, unit, sort_order, description) VALUES ('activity', '推荐活动', 'parenting', NULL, 51, '适合当前阶段的活动建议');
INSERT INTO stage_raw_text (stage_id, raw_text) VALUES ('0_42d', '（一）0-42 天小婴儿
0 天-42 天科学育儿
体重
足月宝宝正常出生体重在 2500-4000g,出生后 3-4 天
内生理性体重下降（下降值小于出生体重的 10%），
出生后 7 天恢复出生体重， 正常足月儿第一月体重增
加可达 1-1.7kg. 男：2.8-4.2kg，女：2.7-4.1kg，
每月增长 0.8-1.2kg
身高
足月宝宝出生身长平均 50cm,正常长速平均每月 4cm
左右。男：47.6-54.8cm，女：46.8-53.8cm，每月增
长 4cm
宝宝情况
头围
足月宝宝出生头围在 32-36CM,正常长速平均每月
2CM 左右，男：31.7-36.9cm，女：31.4-36.5cm，每
月增长 2cm
睡眠
新生儿睡眠时间平均每日 13-18 小时， 初生宝宝暂时
未有昼夜节律， 缺乏睡眠规律， 除了哺乳和排泄占的
大约 6-8 小时外， 其余时间均处于睡眠状态， 此时宝
宝的睡眠容易受到周围环境的干扰， 母乳喂养的新生
儿每次睡眠时间稍短（2-3 小时），人工喂养新生儿
每次睡眠时间稍长（3-4 小时）
营养及喂养
疫苗接种
常见问题 体检
排便
乳类喂养
营养剂添加
0 月龄 1 月龄 黄疸
体检时间 体检目的
体检项目
足月儿在出生后 24 小时内排胎便，2-3 天排完胎便，
出生４日后， 大多数婴儿每日排便３次或更多， 且排
便时间通常与哺乳时间同步。 到出生后第５日， 大便
应为浅黄色并有颗粒物。
母乳含有更适合宝宝生长发育的全部营养素， 且母乳
含有配方奶无法提供的免疫活性物质，营养价值极
高， 故建议纯母乳喂养， 初生新生儿母乳喂养次数推
荐 8-10 次以上。 对胎龄<34 周、 出生体重<2000 克的
早产儿或体重增长缓慢者， 根据医生指导， 在母乳中
添加母乳强化剂。 若无法母乳喂养， 需要配方奶喂养，
新生儿胃容量小， 此期宝宝喂养量及时间间隔暂无规
律， 需要妈妈感知宝宝饥饿及饱腹信号， 给予顺应性
喂养。
1.足月儿生后数日内开始， 在医生指导下每天补充维
生素 D 400 国际单位，维生素 A1500u/天；2.早产或
低出生体重儿一般生后数日内开始，在医生指导下，
每天补充维生素 D 800～1000 国际单位；出生后 2～
4 周开始，按 2 毫克/（千克·天）补充铁元素，上
述补充量包括配方奶及母乳强化剂中的含量。
乙肝疫苗（第一针），卡介苗；母亲若有乙肝病毒感
染，需要在出生时接种乙肝高效免疫球蛋白
乙肝疫苗（第二针）
出生后超过 80%正常新生儿可出现皮肤黄染问题，但
在出生后 1 周-2 周，宝宝血脑屏障未发育完善，皮
肤黄染若明显， 或进行性加重， 过高的胆红素可能透
过血脑屏障造成脑损伤，故此期的黄疸需要谨慎对
待， 必要时新生儿科就诊。 若宝宝黄疸明显加深， 或
者宝宝伴有排便颜色变浅， 亦是及时医院就诊。 若排
除病理性因素， 且宝宝纯母乳喂养， 考虑母乳性黄疸，
黄疸可能持续到出生 2 个月后，可继续母乳喂养。
42 天
1.了解儿童体格生长趋势情况及一般营养状况， 进行
健康指导；
2.早期发现听力障碍、眼病、先天性及遗传性疾病，
并且对可能存在的先天发育异常早发现、 早诊断、 早
干预，比如先天性髋关节发育异常、先天性心脏病、
听力障碍、眼底疾病等。
1. 基本情况：病史、日常状况、特殊情况等。
2. 全身体格检查：1）一般检查：身高/长、体重、
头围、 前囟、 呼吸、 脉搏； 2)物理检查： a.内科检查：
心、肺、肝、脾；b.外科检查：皮肤、淋巴结、头、
颈、眼睛、耳、鼻、口腔、胸、腹、肛门/外生殖器、
脊柱、四肢、髋关节。
3. 辅助检查：必要时完善心脏、髋关节等超声影像
学检查。
4. 专科检查：神经运动发育筛查、发育迟缓筛查、
语言发育筛查、 眼病及听力筛查。 身高体重头围测量、
体格检查、 早教指导。 若发现其他问题， 需要进一步
检查如眼科、口腔科、耳鼻喉科、彩超等。
1.动作发展
俯卧时会试着抬头， 仰卧时会左右摆头， 能自由地转动颈部。 四肢能笨拙地
活动， 手的动作多于脚， 会蹬腿和踢掉身上东西。 摸到东西能攥住，手可张开或
攥紧，清醒时两手以握拳为主，触碰手心会握紧拳头。
2.语言发展
会发出细小的喉音， 宝宝与妈妈谈话时能注视妈妈面孔。 有人大声说话时会
出现惊跳。
3.认知发展
仰卧时能注意视线内物体， 会注视距眼前约 20-30 厘米远的红球。 对声音和
光线有多种反应。
4.情感与社会性
喜欢被爱抚、 拥抱。 部分宝宝能对妈妈微笑。 会注意到近距离人的面部表情，
喜欢看人脸， 尤其是喂养人的笑脸， 眼睛能跟踪走动的人。 听到人的声音有反应，
母亲喂养人的声音对哭吵的婴儿有安抚作用。
5.养育指导
母婴交流非常重要， 父母尽可能亲自养育， 多与新生儿接触， 如说话、 微笑、
怀抱等。 学会辨识新生婴儿哭声， 及时安抚情绪并满足其需求， 如按需哺乳。新
生儿喂奶 1 小时后可进行俯卧练习，每天可进行 1～2 次婴儿被动操。给新生儿
抚触， 让新生儿看人脸或鲜艳玩具、 听悦耳铃声和音乐等， 促进其感知觉的发展。
推荐活动:
抚触/被动操;按需哺乳;亲子互动。');
INSERT INTO stage_raw_text (stage_id, raw_text) VALUES ('42d_3m', '（二）42 天-3 个月婴儿
42 天-3 月龄科学育儿
体重 男： 3.7-5.6kg， 女： 3.5-5.3kg， 每月增长 0.8-1.2kg
身高 男：49.1-61.2cm，女：48.2-60cm，每月增长 4cm
头围 男：34.6-39.4cm，女：34-38.6cm，每月增长 2cm
宝宝情况
睡眠 13-18 小时，频率：白天小睡次数：6-8 次，每次小
睡的时长：10-15 分钟至 4 小时
排便 每天 1-3 次
乳类喂养 继续母乳喂养， 无法母乳喂养或者母乳不足时， 可选
用婴儿配方奶粉补充；每日 500～800ml。
营养及喂养
营养剂添加 1.足月儿每天补充维生素 D 400 国际单位，维生素
DA 1500 国际单位；2.早产或低出生体重儿，在医生
疫苗接种 常见问题
体检
2 月龄 3 月龄 肠胀气/肠绞痛
吐奶
警示信号 体检时间 体检目的
体检项目
指导下，每天补充维生素 D 800～1000 国际单位；继
续按 2 毫克/（千克·天）补充铁元素，上述补充量
包括配方奶及母乳强化剂中的含量。
脊髓灰质炎疫苗（第 1 针）
脊髓灰质炎疫苗（第 2 针），百白破疫苗（第 1 针）
在儿童功能性胃肠病罗马 IV 标准中婴儿绞痛的诊断
要符合以下 3 点:①一天长时间、反复的、难以安抚
的哭闹>3 小时。②一周超过 3 天。③无生长迟缓、
发热或疾病的证据。 引起婴儿绞痛的原因目前尚未明
确， 表现为婴儿突然大声哭叫， 哭时面部涨红，双手
紧握，腹部紧张，双腿向上蜷起，抱哄、喂奶都不能
缓解， 常常发生在傍晚或夜间， 大多从生后 2 周开始，
可持续到 4 个月左右。 若宝宝出现以上症状， 我们可
以用试试:①包裹，用小被子将婴儿轻轻包裹起来，
让宝宝有一定的安全感， 让宝宝慢慢安静下来。 ②侧
位、 腹位或飞机抱， 这些姿势对孩子的腹部有一定的
压迫， 可以在一定程度上缓解腹部疼痛。 ③按揉肚子，
在手上涂一层婴儿润肤霜或婴儿油， 按顺时针方向轻
轻揉婴儿的小肚子， 有助于排出肠道内的气体。 ④此
外， 有节奏的嘘嘘声或白噪声也可能有一定效果。 但
是若宝宝长时间 （大于半小时） 持续不断的剧烈哭闹，
无法安抚，需要到医院就诊，排除器质性疾病。
这个月龄宝宝胃部多呈水平位，胃部入口处（贲门）
抗反流能力未发育成熟， 多有奶后出现吐奶现象， 当
婴儿出现吐奶时可以采取以下方式预防： ①首先不要
让孩子吃的太急， 母乳喂养可以用一种剪刀式的哺乳
方式， 减缓奶流速度； 人工喂养则需选取奶孔大小合
适的奶嘴，可以少量多餐。②喂奶时，婴儿的头、上
身始终要与水平位保持 45°
。③吃完奶后给婴儿拍
嗝也可以减少吐奶。 吐奶时需要将婴儿的身体侧向一
边， 防止奶汁吸入肺部。 注意若宝宝吐奶伴有体重减
轻或者体重不增，需要到医院就诊排除器质性问题。
3 个月不会对着人笑。
3 月龄
1. 了解儿童体格生长情况及一般营养状况，进行健
康指导；
2. 早期识别并及时纠正可疑佝偻病的表现和体征、
预防贫血的发生；
3.筛查儿童常见眼病和视力不良。
1. 基本情况：病史、日常状况、特殊情况等。
2. 全身体格检查：1) 一般检查：身高/长、体重、
头围、前囟、呼吸、脉搏；2) 物理检查：a.内科检
查：心、肺、肝、脾；b.外科检查：皮肤、淋巴结、
头、颈、眼睛、耳、鼻、口腔、胸、腹、肛门/外生
殖器、脊柱、四肢、髋关节。
3. 辅助检查：骨密度测定。
4. 专科检查：神经运动发育筛查、发育迟缓筛查、
语言发育筛查、眼保健及视力检查。
1.动作发展
逐渐学会从仰卧变为侧卧位。俯卧时能将头抬高至 45 度。被竖直抱时，能
将头竖直， 并张望四周， 头可随着看到的物品或听到的声音转动 180 度， 扶住腋
下保持直立姿势。 手能放开， 会伸手触摸眼前的东西。 上肢能够伸展，两手会在
胸前相互接触，手握着手。
2.语言发展
能辨别不同人说话声音的语调，朝声音的方向扭头，咿呀学语。
哭声逐渐减少并开始会用不同的哭声表达自己的需求， 听到妈妈声音会发出
微笑和笑声。会注意成人的逗引，会发出“咕咕声”和类似 a、o、e 的音。
3.认知发展
能感知色彩。 对对比强烈的图样有反应。 会将声音和形象联系起来， 会试图
找出声音的来源。 喜欢注视自己的手， 能举握物品， 见物后能双臂活动。眼睛能
立刻注意到面前大玩具，其视线还会随着人的走动而移动。
4.情感与社会性
能忍受短暂的喂奶间断， 用目光期待着喂奶。 见到经常接触的人会微笑、 发
声或挥手蹬脚， 表现出快乐的神情。 对成人的逗引会用动嘴巴、 伸舌头、微笑或
摆动身体等表示情绪反应。表现出对喂养人的偏爱。
5.养育指导
注重亲子交流， 在哺喂、 护理过程中多与婴儿带有情感的说话、 逗弄，对婴
儿发声要用微笑、声音或点头应答，注意目光的交流。通过俯卧、竖抱练习、被
动操等， 锻炼婴儿头颈部的运动和控制能力。 给婴儿听悦耳的音乐， 玩带响声的
玩具；用鲜艳的玩具吸引婴儿注视和目光跟踪;让他/她有机会触摸不同质地的物
品。
推荐活动:
玩玩具;亲子互动;俯卧。');
INSERT INTO stage_raw_text (stage_id, raw_text) VALUES ('4_6m', '（三）4-6 个月婴儿
4 月龄-6 月龄科学育儿
体重 平均每月体重增长 0.5-0.6kg
身高 平均每月身长增长约 2cm
头围 平均每月头围增长约 1cm
宝宝情况
睡眠
此期的宝宝睡眠的昼夜节律初步形成， 白天清醒时间
延长，睡眠多集中在夜晚完成，推荐睡眠时长 12-16
小时， 白天会有 3-4 次小睡眠， 时长 0.5-2 小时/次，
夜晚可有 2-3 次的夜醒。 此期需要减少奶睡、 抱睡情
况发生，让宝宝逐步建立自主入睡能力。
营养及喂养
疫苗接种
常见问题 体检
排便 乳类喂养
营养剂添加
4 月龄 5 月龄 6 月龄 厌奶期
警示信号 体检时间 体检目的
体检项目
排便较为规律，1-3 次/日，或者间隔 1-2 日排一次
大便，大便多呈黄色糊状便。
继续母乳喂养， 母乳不足时， 可选用婴儿配方奶粉补
充。白天定时喂养，每 3-4 小时喂一次，约 800ml/
日，逐渐停夜间哺乳（或 4-6 小时以上喂一次），不
宜频繁夜奶
1.每天补充维生素 D 400 国际单位，维生素 A 1500
国际单位； 2.纯母乳喂养的足月儿或以母乳喂养为主
的 足 月 儿 4 ～ 6 月 龄 时 可 根 据 需 要 适 当 补 铁 剂
1-2mg/kg/日；以预防缺铁性贫血的发生；3.早产或
低出生体重儿，继续按 2 毫克/（千克·天）补充铁
元素，上述补充量包括配方奶及母乳强化剂中的含
量。
脊灰减毒活疫苗口服（脊髓灰质炎疫苗第三针） ， 百
白破疫苗（第二针）
百白破疫苗（第三针）
乙肝疫苗（第三针），A 群流脑多糖疫苗（第一针）
宝宝吸吮反射消失，宝宝不会一碰到奶头就会吸吮
了， 前期若宝妈们没有做好顺应性喂养， 存在强迫喂
养或者过度喂养，且夜间频繁夜奶，3 月龄后宝宝开
始逐渐出现厌奶的现象，宝妈们可以做好定时喂养，
3-4 小时喂养一次，
一次喂养时间控制在 20 分钟内，
若宝宝存在停止吸吮， 或者拒绝奶头等情况， 及时停
止喂奶， 允许宝宝出现一过性奶量波动减少， 不强迫
喂养， 同时要减少夜间喂奶次数， 可以帮助宝妈顺利
度过厌奶期。 若宝宝长时间抗拒喝奶， 伴有哭闹不安、
呕吐、腹泻、便秘、体重减轻等情况需要医院就诊。
未建立安全性依恋；缺乏陌生人焦虑。
6 月龄
1. 了解宝宝喂养情况、睡眠情况、生长速度，对生
长发育、 营养状况进行个体化的评价和指导， 评估宝
宝铁储备， 进行辅食添加指导； 早教指导；进行眼病
筛查和视力检查。 了解儿童体格生长情况及一般营养
状况，进行健康指导；
2. 早期识别并及时纠正可疑佝偻病的表现和体征；
3. 发现并及时纠正贫血；防治营养性贫血。
4. 筛查儿童动作及社会交往等发育行为情况。
1. 身高体重头围测量、体格检查、神经心理与行为
发育筛查、眼科检查、血常规检查、早教指导。基本
情况：病史、日常状况、特殊情况等。
2. 全身体格检查：1) 一般检查：身高/长、体重、
头围、前囟、呼吸、脉搏；2) 物理检查：a.内科检
查：心、肺、肝、脾；b.外科检查：皮肤、淋巴结、
头、颈、眼睛、耳、鼻、口腔、胸、腹、肛门/外生
殖器、脊柱、四肢、髋关节。
3. 实验室检查： 1.血常规， 必要时完善血清铁蛋白、
尿常规、肝肾功能、血清酶、血糖；2.骨密度测定。
4. 专科检查：神经运动发育筛查、发育迟缓筛查、
语言发育筛查。
1.动作发展
慢慢能从仰卧翻身到俯卧， 有爬的愿望。 能用两只小手支撑倾坐片刻。 成人
扶腋下能站直，双脚跳跃。会撕纸。喜欢玩手、扒脚。会笨拙的换手接物。能用
双手拿起眼前玩具，喜欢把东西放入口中。
2.语言发展
有明显的发音愿望， 会和成人进行相互模仿的发音游戏。 开始咿呀学语， 发
辅音 d、n、m、b。无意中会发出“爸”或“妈”的音。能和成人一起“啊啊”
、
“呜呜”地聊天。会听成人的语言信号。
3.认知发展
能注视距离眼前 75 厘米远的物体。用较长的时间来看物体或图形。会寻找
手中丢失的东西。喜欢颜色鲜艳的玩具或图卡。听到歌谣和摇篮曲会手舞足蹈。
能根据不同的声音找不同的家人。 听到熟悉物品的名称会用眼注视。 听到自己的
名字会转头看。
4.情感和社会性
会用哭声、面部表情和姿势与人沟通。开始怕羞。辨认生人、熟人，对生人
会注视或躲避等， 对熟人反应愉悦。 对亲切的语言表示愉快， 对严厉的语言表现
出不安或哭泣等反应。 会对着镜中的影像微笑、 发音或伸手拍。 在独处或别人拿
走他小玩具时会表示反对。 对熟悉的人或物有观察意识。 对主要带养人有明显的
依恋。
5.养育指导
父母尽可能陪伴和养育婴儿， 主动识别并及时有效的应答婴儿的生理与心理
需求， 逐渐建立安全的亲子依恋关系。 培养规律的进食、 睡眠等生活习惯，多与
婴儿玩看镜子、 藏猫猫、 寻找声音来源等亲子游戏。 营造丰富的语言环境，多与
婴儿说话、模仿婴儿发声以鼓励婴儿发音，达到“交流应答”的目的。鼓励婴儿
自由翻身、 适当练习扶坐； 让婴儿多伸手抓握不同质地的玩具和物品， 促进手眼
协调能力发展。
推荐活动:
照镜子;练习扶坐;模仿发声。');
INSERT INTO stage_raw_text (stage_id, raw_text) VALUES ('7_9m', '（四）7-9 个月婴儿
7 月龄-9 月龄科学育儿
体重 平均每月体重增长 0.27-0.37kg
身高 平均每月身长增长约 2cm
宝宝情况
头围 平均每月头围增长约 1cm
睡眠 推荐睡眠时长 12-16 小时， 睡眠昼夜节律较稳定， 白
营养及喂养
疫苗接种
常见问题
排便 乳类喂养 辅食添加 营养剂添加 8 月龄 9 月龄 便秘 天小睡眠 2-3 次， 小睡时长 0.5-2 小时， 夜间最长一
次睡眠可达 5-6 小时，夜醒 1-2 次，小于 20 分钟/
次。 此期需要减少奶睡、 抱睡情况发生， 让宝宝建立
自主入睡能力。
排便较为规律，1-3 次/日，或者间隔 1-2 日排一次
大便，大便多呈黄色糊状便或者柔软成形便。
继续母乳喂养， 母乳不足时， 可选用婴儿配方奶粉补
充。 定时喂养， 每餐食物时间间隔仍为 3-4 小时一次，
奶 3-4 次/日，辅食 1-2 次/日，全天奶量 700-900mL
左右
1. 足月儿 6 个月起应添加辅食，早产儿在校正胎龄
4～6 月时应添加辅食。
2. 辅食质地从泥状过渡到碎末状，种类多样，注意
排敏，新的辅食引入需要持续 3-5 天观察是否过敏，
添加 1-2 次泥糊状食物， 逐渐推进稠粥/碎末状辅食。
3. 每餐 2～3 勺逐渐增加到 1/2 碗（250ml 的碗）。
4. 添加辅食种类每日不少于 4 种，并且至少应包括
一种动物性食物、
一种蔬菜和一种谷薯类食物。 吃的
量以宝宝反应为主， 训练宝宝的吞咽和咀嚼能力， 不
宜强迫喂养，不宜着急加量，不宜影响到总奶量。
1. 每天补充维生素 D 400 国际单位，维生素 A 1500
国际单位；
2. 早产或低出生体重儿， 继续按 2 毫克/ （千克·天）
补充铁元素，上述补充量包括配方奶及辅食中的含
量。
麻腮风疫苗（第一针），乙脑减毒活疫苗/乙脑灭活
疫苗（第一针）
A 群流脑多糖疫苗（第二针）
婴儿排便次数每周≤2 次，伴有排便费力、排便痛苦
感、 且大便呈干硬团块状或呈羊大便颗粒状， 可考虑
存在婴儿期便秘，95% 的婴儿便秘属于功能性问题。
1.大部分宝宝是因为肠道蠕动过慢， 或者肛门直肠协
调性差， 造成排便时间间隔延长， 排便费力， 可给婴
儿做腹部按摩： 右手四指并拢， 在婴儿的脐部按顺时
针方向适当强度推揉、按摩，揉腹部能增加肠蠕动。
亦可增加宝宝俯卧爬行等运动，促进肠蠕动。
2.部分宝宝存在食物结构不合理， 添加过多高蛋白食
物， 膳食纤维、 水分摄入不足引起， 可减少食物中蛋
白成分，增加膳食纤维及水分摄入可改善便秘。
3.排便痛苦感， 会让宝宝克制排便， 让宝宝尽力避免
排便， 让肠道大便变得更加干硬， 引起便秘的恶性循
环， 故需要定时训练排便， 必要时添加乳果糖等药物
软化大便， 训练定时排便， 减少排便痛苦感。 若宝宝
便秘持续时间长， 伴有腹胀、 呕吐、 哭闹不安等情况
需要及时医院就诊。
睡眠倒退期 此期的宝宝大动作发育迅速，部分宝宝学会了爬行；
白天的外出活动过久， 宝宝过于疲惫； 睡前过度兴奋；
不恰当的哄睡方式（抱睡、 奶睡）等原因会造成宝宝
夜醒次数频繁，或者夜醒后难易安抚入睡。
睡眠指导：1.白天适当 1-2 小时户外活动，不激烈，
不让宝宝过于疲惫。 2.睡眠环境舒适安静。 3.婴儿可
与父母同屋不同床睡觉。 4.规律作息， 固定就寝时间，
晚上 7：30-8：30 就寝合适，
一般不晚于 21：00，
但也不提倡过早上床。5.安排固定 3-4 项睡前活动，
如洗漱、抚触、调暗灯光，听轻音乐等，活动结束后
尽量让宝宝处于安静状态。 6.晚上睡前保持 3-4 小时
的清醒时间。 7.在宝宝快睡着但未睡着时就单独放置
小床睡着，不宜抱睡、奶睡、摇睡（白天睡眠亦是如
此）。8.宝宝夜醒开始哭闹时候，先尝试轻拍、发出
轻柔的哼哼声或摇篮曲， 不急着抱起。 若宝宝长时间
夜醒频繁、 哭闹不安， 白天亦是精神不佳，需要医院
就诊。
警示信号 听到声音无应答； 不会区分生人和熟人； 双手间不会
传递玩具；不会独坐
体检时间 9 月龄
体检目的 1. 了解儿童体格生长情况及一般营养状况，进行健
康指导；
2. 早期识别并及时纠正可疑佝偻病的表现和体征；
3. 筛查儿童常见眼病和视力不良。
体检项目 体检
1. 身高体重头围测量、体格检查、神经心理与行为
发育筛查、口腔保健、早教指导。基本情况：病史、
日常状况、特殊情况等。
2. 全身体格检查：1) 一般检查：身高/长、体重、
头围、前囟、呼吸、脉搏；2) 物理检查：a.内科检
查：心、肺、肝、脾；b.外科检查：皮肤、淋巴结、
头、颈、眼睛、耳、鼻、口腔、胸、腹、肛门/外生
殖器、脊柱、四肢、髋关节。
3. 实验室检查： 1) 血常规， 必要时完善血清铁蛋白
（6 月龄未查儿童需完善，6 月龄已查正常儿童无需
做此项检查） ； 2) 骨密度测定； 3) 必要时完善乙肝
两对半。
4. 专科检查：神经运动发育筛查、发育迟缓筛查、
语言发育筛查。
1.动作发展
能独坐，会自己坐起躺下。扶握双腕能站，站立时腰、髋、膝关节能伸直。
开始学会爬。 能用小手拨弄桌上的小东西或摇有声响的小物品。 会用拇指、 食指
配合抓起玩具。能换手传递玩具，能用一个玩具敲打另一个玩具。
2.语言发展
能听懂成人对自己的叫唤。开始发“ma-ma” “ba-ba”等音节，能重复发出
某些元音和辅音。 试着模仿成人声音。 发音越来越像正真的语言。 开始懂得一些
常用词语的意思，会用简单的动作表示。会用自己的语音来表达不同的情绪。
3.认知发展
会关注有吸引力的物体， 并反复观察其特点和变化。 注意观察大人行动， 模
仿大人动作。 能挑选自己喜欢的玩具。 将玩具当着婴儿的面藏起来， 婴儿会尝试
寻找隐藏的玩具。 喜欢熟悉的环境， 到陌生的环境婴儿会表现出哭闹、 不安或好
奇。
4.情感与社会性
对带养人表示出依恋和喜爱， 对陌生人会有害怕、 拒绝等情绪反应。 对成人
表示肯定或否定的面部表情有不同的反应。喜欢玩交际游戏，如拍手、躲猫猫。
喜欢看镜中自己的影像。 会挥手再见、 招手欢迎， 玩拍手游戏。听到表扬会高兴
地重复刚才的动作。
5.养育指导
父母多陪伴和关注婴儿， 在保证婴儿安全的情况下扩大活动范围， 鼓励与外
界环境和人接触。 经常叫婴儿名字， 说家中物品名称， 培养婴儿对语言的理解能
力。引导婴儿发“ba ba”
、
“ma ma”等语音，提高其对发音的兴趣。帮助婴儿
练习独坐和匍匐爬行， 扶腋下蹦跳； 练习伸手够远处玩具、 双手传递玩具、撕纸
等双手配合和手指抓捏动作，提高手眼协调能力。
推荐活动:
说家中物品名；练习匍匐爬、伸手够；多接触外界环境。');
INSERT INTO stage_raw_text (stage_id, raw_text) VALUES ('10_12m', '（五）10-12 个月婴儿
10 月龄-12 月龄科学育儿
体重 男： 7.7-11.5kg， 女： 7.2-10.8kg， 每月增长 0.2-0.3kg
身高 男：68.3-77.8cm，女：66.8-76.1cm，每月增长 1cm
头围 男： 42.7-47.7cm， 女： 41.6-46.5cm， 每月增长 0.5cm
宝宝情况
睡眠 12-16 小时，频率：白天小睡次数：2 次，每次小睡
的时长：1-2 小时
排便 每天 1-2 次
乳类喂养 继续母乳喂养， 母乳不足时， 可选用婴儿配方奶粉补
充。每天 2～4 次，共 500～700ml。
营养及喂养
辅食添加
1. 逐渐推进（半）固体食物（切碎的家庭食物/手指
食物/条状食物）摄入到 2～3 次。
2. 每餐 1/2 碗（250ml 的碗）。
3. 注意膳食品种多样化， 提倡自然食品、 均衡膳食，
每天应摄入 15～50 鸡蛋（至少一个蛋黄）、25～50
克动物性食物、 20～50 克谷物、 25～100 克蔬菜、 25～
100 克水果、0～10 克植物油。
营养剂添加 1. 每天补充维生素 D 400 国际单位，维生素 A 1500
国际单位；
2. 早产或低出生体重儿， 继续按 2 毫克/ （千克·天）
补充铁元素，上述补充量包括配方奶及辅食中的含
量。
疫苗接种 10-12 月龄
暂无一类疫苗接种， 若前期疫苗接种延迟， 可顺延至
10-12 月龄进行补种，除国家免疫规划疫苗外，可根
据家长需求、流行季节特点等进行补充免疫。
常见问题 辅食喂养困难
辅食喂养困难发生原因： 1.未定时喂养， 奶和辅食时
间间隔太短，宝宝饥饿感不明显。2.长期强迫喂养，
让宝宝产生恐惧感。 3.夜间未停夜奶， 白天食欲下降。
4.辅食添加种类太单一
， 宝宝存在厌新情况。 5.辅食
太精细，宝宝吞咽咀嚼能力训练不足。6 喂养者过度
焦虑。
改善办法： 1.拉长喂养时间间隔， 可奶后 3-4 小时添
加辅食。 2.辅食喂养时间小于 20 分钟。 3.停止夜奶，
特别是母乳喂养亦需要停夜奶。 3.若宝宝拒绝某一新
的食物， 可少量多次添加 10-15 次。 4.给宝宝营造轻
松舒适的进食环境， 特定位置进餐， 不依赖玩具电子
产品， 辅食的进食量多少由宝宝决定， 尽量鼓励并表
扬宝宝积极的进食状态。 若宝宝长期喂养困难， 伴体
重不增、呕吐、腹胀、便秘等情况，及时医院就诊。
警示信号 缺乏好奇心；缺乏模仿。
体检时间 12 月龄
体检目的
1. 了解儿童体格生长情况及一般营养状况，查看预
防接种情况，进行健康指导；
2. 早期识别并及时纠正可疑佝偻病的表现和体征；
3.筛查儿童常见眼病和视力不良。
体检
体检项目
1. 基本情况：病史、日常状况、特殊情况等。
2. 全身体格检查：1) 一般检查：身高/长、体重、
头围、前囟、呼吸、脉搏；2) 物理检查：a.内科检
查：心、肺、肝、脾；b.外科检查：皮肤、淋巴结、
头、颈、眼睛、耳、鼻、口腔、胸、腹、肛门/外生
殖器、脊柱、四肢、髋关节。
3. 实验室检查：骨密度测定。
4. 专科检查：神经运动发育筛查、发育迟缓筛查、
语言发育筛查、视力筛查。
1.动作发展
可以腹部不贴地面地用四肢爬行。 能自己扶栏杆站立、 坐下及蹲下取物。 能
独自站稳一会儿，扶物会走，能独走几步。会将物体从大罐子中取出、放入。喜
欢随地扔东西。会将大圆圈套在木棍上。
2.语言发展
能听懂一些与自己有关的日常生活指令。 会用点头摇头等动作表达自己的意
愿。能说出几个词，如“爸爸”“妈妈”等。会自创一些词语来指称事物。
3.认知发展
会分辨甜、苦、咸等味道和香、臭等气味。能指认耳朵、眼睛、鼻子和经常
接触的物品。 喜欢看图画。 会注意到比较细小的物品， 喜欢摆弄、观察玩具及实
物。开始学习使用工具够物，如：玩具掉到沙发底下了，宝宝会拿小棍子够取。
4.情感与社会性
理解成人的肯定或否定态度。 会表达愤怒、 害怕、 焦急等不同情绪。喜爱熟
悉的人，会伸手要抱，对陌生人表现出忧虑、退缩、拒绝等行为。喜欢情感交流
活动， 会注视、 伸手去触摸同伴。 当言行得到认可时会高兴地重复表现。会用动
作等方式向成人索取感兴趣的东西， 初步具有保护自己物品的意识。 爱尝试、 喜
欢自己探索。喜欢重复玩交往游戏。
5.养育指导
帮助婴儿识别他人的不同表情； 当婴儿出现生气、 厌烦、 不愉快等负性情绪
时， 转移其注意力； 受到挫折时给予鼓励和支持。 丰富婴儿语言环境，经常同婴
儿讲话、 看图画。 让婴儿按指令做出动作和表情， 如叫名字有应答， 懂得挥手 “再
见”
。 帮助婴儿多练习手-膝爬行， 学习扶着物品站立和行走；给婴儿提供杯子、
积木、 球等安全玩具玩耍， 发展手眼协调和相对准确的操作能力。 与婴儿玩模仿
游戏，如拍手“欢迎”
、捏有响声的玩具、拍娃娃、拖动毯子取得玩具等。
推荐活动:
模仿“再见”
；多与婴儿说话/看图画；手-膝爬。');
INSERT INTO stage_raw_text (stage_id, raw_text) VALUES ('13_18m', '（六）13-18 个月幼儿
13 月龄-18 月龄科学育儿
体重 男：8.3-12.3kg，女：7.7-11.6kg，正常长速：每 3
月增长 0.5kg
身高 男：71.7-81.6cm，女：70.4-80.1cm，每月增长 1cm
宝宝情况
头围 男：43.7-48.4cm，女：42.7-47.6cm，正常长速: 1
岁～2 岁增加 2cm
睡眠 11-14 小时，频率：白天小睡次数：1-2 次，每次小
睡的时长：1-3 小时
排便 每天 1-2 次
乳类喂养 继续母乳喂养，母乳不足时，可选用配方奶粉补充。
每天 2～3 次，共 400～600ml。
营养及喂养
主食添加
1.条块、球块状的家庭食物，每天摄入到 2～3 次。
每餐 3/4 碗 （250ml 的碗） 。 2.每天应摄入 1 个鸡蛋、
50 克动物性食物、 50～100 克谷物、 50～150 克蔬菜、
50～150 克水果、5～15 克植物油；3.1 岁以后宜引
导而不强迫幼儿进食， 鼓励自主进食。 每次进餐时间
控制在 20 分钟左右， 最长不宜超过 30 分钟， 并逐渐
养成定时进餐和良好的饮食习惯。
营养剂添加 每天补充维生素 D 600 国际单位，维生素 A 2000 国
际单位；
疫苗接种 18 月龄
麻腮风疫苗（第 2 针），百白破疫苗（第 4 针），甲
肝减毒活疫苗或甲肝灭活疫苗（2 选 1）
（注： 甲肝活疫苗仅需接种 1 针， 甲肝灭活疫苗需接
种第 2 针）
分离焦虑 与家人或亲人分开时， 哭很长时间； 恳求亲人不要离
开；分离时只想亲人回到身边
常见问题
偏食挑食， 吃饭
慢
不肯吃硬食物该现象往往由于父母的溺爱和纵容， 以
及缺乏科学的喂养方式所致。
警示信号 不能听从简单指令；对周围小朋友不感兴趣。
体检时间 18 月龄
体检目的
3. 了解儿童体格生长情况及一般营养状况，进行健
康指导；
4. 早期识别并及时纠正可疑佝偻病的表现和体征；
5. 发现并及时纠正贫血；
筛查儿童常见眼病和视力不良。
体检
体检项目
1. 基本情况：病史、日常状况、特殊情况等。
2. 全身体格检查：1) 一般检查：身高/长、体重、
头围、前囟、呼吸、脉搏；2) 物理检查：a.内科检
查：心、肺、肝、脾；b.外科检查：皮肤、淋巴结、
头、颈、眼睛、耳、鼻、口腔、胸、腹、肛门/外生
殖器、脊柱、四肢、髋关节。
3. 实验室检查： 1) 血常规， 必要时完善血清铁蛋白、
尿常规、粪常规、肝肾功能、血清酶、血糖、重金属
筛查；2) 骨密度测定。
4. 专科检查：神经运动发育筛查、发育迟缓筛查、
语言发育筛查、口腔检查、眼保健及视力检查。
1.动作发展
开始独立行走，喜欢走路时推、拉、拿着玩具。会跑，但不稳。不用扶物能
蹲下、站起。在成人的帮助下会上楼梯。会做简单的手势。会将球滚来滚去，没
有方向地随意扔球； 会将两三块积木垒高， 把小丸捏起放入容器中。 会抓住蜡笔
涂鸦。会用水杯喝水。
2.语言发展
对语言的理解能力超过语言的表达能力。 会用表情、 手势代替语言进行交流。
能听懂成人说的简单指令， 如可依照指令模仿常见动物的叫声。 开始知道书的概
念， 喜欢模仿翻书页。 会说自己的名字、 熟悉的人名或物品的名字。会使用生活
中常见的动词，如“抱”“吃”等。
3.认知发展
会指认某些身体部位。 喜欢用嘴、 手试探各种东西。 开始理解简单的因果关
系。 会长时间观察感兴趣的事物， 能用手势和声音表示不同的反应。 能根据感知
方面的突出特征对熟悉的物品进行简单的分类。会模仿一些简单的动作或声音，
开始自发地玩模仿性游戏，如：用玩具电话玩打电话游戏。
4.情感与社会性
对陌生人表示新奇， 会害怕陌生的环境和人。 开始理解并遵从成人简单的行
为准则和规范。 在很短的时间内表现出丰富的情绪变化。 能感觉到常规的改变或
环境的变迁。 自我意识开始萌芽。 能认出镜子里的自己。 喜欢单独玩或观看别人
游戏活动。开始对别的小孩感兴趣，能共同玩一会儿。
5.养育指导
给予幼儿探索环境、表达愿望和情绪的机会。经常带幼儿玩亲子互动游戏，
如相互滚球、 爬行比赛等； 引导幼儿玩功能性游戏， 如模仿给娃娃喂饭、拍睡觉
等。 多给幼儿讲故事、 说儿歌， 教幼儿指认书中图画和身体部位，引导幼儿将语
言与实物联系起来， 鼓励幼儿有意识的用语言表达。 给幼儿提供安全的活动场所，
通过练习独立行走、扔球、踢球、拉着玩具走等活动，提高控制平衡的能力。鼓
励幼儿多做翻书页、 盖瓶盖、 用笔涂鸦、 垒积木等游戏，提高认知及手眼协调能
力。
推荐活动:
练习走路；涂鸦；亲子阅读。');
INSERT INTO stage_raw_text (stage_id, raw_text) VALUES ('19_24m', '（七）19-24 个月幼儿
19 月龄-24 月龄科学育儿
体重 男 9.3-13.8kg：，女：8.8-13.2kg，正常长速:每 3
月增长 0.5kg
身高 男：77.7-88.5cm，女：76.5-87.2cm，每月增长 1cm
宝宝情况
头围 男：44.9-50cm，女：43.9-49cm，正常长速: 1 岁～2
岁增加 2cm
睡眠 11-14 小时，频率：白天小睡次数：1 次，每次小睡
的时长：1.5-2.5 小时
排便 每天 1-2 次
乳类喂养 继续母乳喂养，母乳不足时，可选用配方奶粉补充。
每天 2～3 次，共 400～600ml。
营养及喂养
主食添加
1.条块、 球块状的家庭食物， 每天摄入 3 次。 2.每餐
3/4 碗到 1 整碗（250ml 的碗）。②每天应摄入 1 个
鸡蛋、 50～75 克动物性食物、 50～100 克谷物、 100～
150 克蔬菜、50～150 克水果、10～15 克植物油。3.
幼儿逐步过渡到独立进食，引导而不强迫幼儿进食，
鼓励自主进食。每次进餐时间控制在 20 分钟左右，
最长不宜超过 30 分钟，并养成定时进餐和良好的饮
食习惯。
营养剂添加 每天补充维生素 D 600 国际单位，维生素 A 2000 国
际单位；
疫苗接种 24 月龄
乙脑减毒活疫苗 （第 2 针） 或乙脑灭活疫苗 （第 3 针） ，
甲肝灭活疫苗（第 2 针）
（注： 已接种甲肝减毒活疫苗者无需再接种甲肝灭活
疫苗第 2 针）
常见问题
跌倒外伤等意
外伤害
随着年龄的增长，孩子独立行走活动范围逐步扩大，
家长应增强安全防范意识， 防止幼儿期意外伤害的发
生
警示信号 不能听从简单指令；对周围小朋友不感兴趣。
体检时间 24 月龄
体检目的
6. 了解儿童体格生长情况及一般营养状况，进行健
康指导；
7. 早期识别并及时纠正可疑佝偻病的表现和体征；
3.筛查儿童常见眼病和视力不良。
体检
体检项目
1. 基本情况：病史、日常状况、特殊情况等。
2. 全身体格检查：1) 一般检查：身高/长、体重、
头围、前囟、呼吸、脉搏；2) 物理检查：a.内科检
查：心、肺、肝、脾；b.外科检查：皮肤、淋巴结、
头、颈、眼睛、耳、鼻、口腔、胸、腹、肛门/外生
殖器、脊柱、四肢、髋关节。
3. 实验室检查：骨密度测定。
4. 专科检查：神经运动发育筛查、发育迟缓筛查、
语言发育筛查、口腔检查、眼保健及视听力筛查。
1.动作发展
会自如地向前走、 向后走。 能连续跑 3-4 米， 但不稳。会自己扶栏杆能走几
步楼梯。能蹲着玩。能够弯腰捡玩具。能举手过肩扔球。能踢大球。会用五六块
积木叠搭起来。 会穿串珠。 会随意折纸。 能够根据音乐的节奏做动作。绘画开始
进入圆形涂鸦期。自己能够用汤匙吃东西。
2.语言发展
开始用名字称呼自己,开始会用“我”
。会说出常用东西的名称和用途。词
汇增加， 能说 3-5 个字的简单短句表达一定意思和个人需要。 喜欢跟着大人学说
话、 念童谣， 爱重复结尾的句子。 喜欢看图书、 指认书中物品， 说出熟悉的事物。
3.认知发展
喜欢探索周围的世界。 开始理解事件发生的前后顺序。 能记住一些简单的事，
熟悉的生活内容。 知道家庭成员以及经常一起玩的伙伴名字。 对声音的反应开始
越来越强烈，喜欢听声音的重复。能短暂的集中注意看图片、看电视、玩玩具、
听故事等。认识红色。能感知、区分方形、三角形和圆形。
4.情感与社会性
对主要带养者表现出较强的依恋。 会较长地延续某种情绪状态。 会对某些东
西或环境感到害怕， 需要时间适应新环境。 自我意识逐步增强， 喜欢自己独立完
成某一动作， 出现独立行为倾向。 开始意识到自己是女孩还是男孩， 交往能力增
加， 会与其他小孩共同参与游戏活动。 能按指示完成简单的任务， 喜欢模仿成人
动作，如擦桌子、拖地、学收拾玩具等。
5.养育指导
家长对待幼儿的养育态度和行为要一致。 在保证安全的前提下， 给幼儿自主做事
情的机会， 对幼儿每一次的努力都给予鼓励和赞扬， 培养其独立性和自信心。 与
幼儿玩“给娃娃喂饭、 拍睡觉”等装扮性游戏。 学习更多词汇， 说出身边物品名称、
短语， 鼓励用语言表达需求和简单对话； 学习区分大小， 匹配形状和颜色等。提
高幼儿身体动作协调能力，学习扶着栏杆上下楼梯、踢皮球、踮着脚尖走和跑，
握笔模仿画线， 积木叠高等。 培养幼儿生活自理能力， 如用匙进食、 用杯子喝水，
学习脱袜子、脱鞋；固定大小便场所，练习有大小便时向家长示意。
推荐活动:
玩装扮性游戏；练习踮脚尖走；练习自己吃饭。');
INSERT INTO stage_raw_text (stage_id, raw_text) VALUES ('25_30m', '（八）25-30 个月幼儿
25 月龄-30 月龄科学育儿
体重 男：10.4-15.4kg，女：9.8-14.8kg，正常长速: 每
3 月增长 0.5kg
身高 男： 82.4-94cm， 女： 81.2-92.8cm， 每月增长 0.5-0.7cm
头围 宝宝情况
男：45.9-51cm，女：44.8-51cm，正常长速: 2 岁～
3 岁增加 2cm
睡眠 11-14 小时，频率：白天小睡次数：1 次，每次小睡
的时长：1.5-2.5 小时
排便 每天 1-2 次
乳类喂养 每日饮奶，350-500 克
主食添加 营养及喂养
1.注意膳食品种多样化，提倡自然食品、均衡膳食，
每天应摄入 1 个鸡蛋、 50 克动物性食物、 75～125 克
谷物、100～200 克蔬菜、100～200 克水果、10～20
克植物油。 2.幼儿应进食体积适宜、 质地稍软、 少盐
易消化的家常食物， 避免给幼儿吃油炸食品， 少吃快
餐， 少喝甜饮料， 包括乳酸饮料。 3.幼儿应自主进食。
每次进餐时间控制在 20 分钟左右，最长不宜超过 30
分钟，并养成定时进餐和良好的饮食习惯。
营养剂添加 每天补充维生素 D 600 国际单位，维生素 A 2000 国
际单位；
疫苗接种 25-30 月龄 除国家免疫规划疫苗外， 可根据家长需求、 流行季节
特点等进行补充免疫。
常见问题 警示信号 缺乏基本情绪表达；缺乏想象性游戏。
体检时间 30 月龄
体检目的 体检
1. 了解儿童体格生长情况及一般营养状况，进行健
康指导；
2.筛查儿童常见眼病和视力不良。
体检项目 1. 基本情况：病史、日常状况、特殊情况等。
2. 全身体格检查：1) 一般检查：身高/长、体重、
头围、前囟、呼吸、脉搏；2) 物理检查：a.内科检
查：心、肺、肝、脾；b.外科检查：皮肤、淋巴结、
头、颈、眼睛、耳、鼻、口腔、胸、腹、肛门/外生
殖器、脊柱、四肢、髋关节。
3. 实验室检查： 1) 血常规， 必要时完善血清铁蛋白、
尿常规、粪常规、肝肾功能、25OHD3、血糖、重金属
筛查；2) 骨密度测定。
4. 专科检查：神经运动发育筛查、发育迟缓筛查、
语言发育筛查、口腔检查、眼保健及视力筛查。
1.动作发展
能双脚交替走楼梯。 能后退、 侧着走和奔跑。 能双脚离地跳。会迈过低矮的
障碍物。 能轻松地立定蹲下。 能手脚基本协调地进行攀爬。 会骑三轮车和其他大
轮的玩具车。能用积木搭桥、火车等简单的物体。会滚球、扔球，举起手臂有方
向地投掷。 会一页一页五指抓翻书页。 会转动把手开门、 旋开瓶盖取物。会自己
洗手、擦脸。
2.语言发展
咿呀学语声基本消失。 会用日常生活中一些常用的形容词， 如“热” “冷”
。
开始用“你”等代名词。会说完整的短句和简单的复合句。会念简单的童谣。能
区分书中的图画和文字。愿意独自看简单的图画书。
3.认知发展
对周围事物或现象感兴趣，爱提问题。能感知物体软、硬、冷、热等属性。
感知比较差异明显的“大”“小”“多”“少”“上”“下”
。能基于形状、大
小、 颜色等做简单的分类。 能跟着数数。 能重复一些简单的韵律和歌曲。游戏时
能用物体或自己的身体部位代表其他物体。
4.情感与社会性
开始能表达自己的情感。 受到挫折会发脾气。 开始意识到他人的情感。 萌发
初步的同情感。 有简单的是非观念。 喜欢参与同伴的活动， 能和同伴一起玩简单
的角色游戏，会相互模仿，有模糊的角色装扮意识。
5.养育指导
鼓励自己做力所能及的事， 提高克服困难的意识和能力。 鼓励幼儿帮助家长
做一些简单的家务活动， 如收拾玩具、 扫地、 帮忙拿东西等， 促进自信心的发展，
激发参与热情。 当幼儿企图做危险的活动时， 应当及时制止； 出现无理哭闹等不
适宜的行为时，可采用不予理睬或转移等方法，让幼儿懂得日常行为的对与错，
逐步养成良好的行为习惯。 教幼儿说出自己的姓名、 性别、 身体部位以及一些短
句和歌谣。学习执行指令，用较准确的语言表达需求；培养幼儿理解“里外”
、
“上下”
、
“前后”等空间概念。学习独自上下楼梯、单腿站，提高身体协调及
大运动能力；通过搭积木、串珠子、系扣子、画画等游戏，提高精细动作能力。
推荐活动:
收拾玩具;自己上下楼梯;搭积木。');
INSERT INTO stage_raw_text (stage_id, raw_text) VALUES ('31_36m', '（九）31-36 个月幼儿
31 月龄-36 月龄科学育儿
体重 男：11.2-16.7kg，女：10.7-17.2kg，正常长速; 每
3 月增长 0.5kg
身高 男： 87-99.4cm， 女： 85.7-98.1cm， 每月增长 0.5-0.7cm
头围 宝宝情况
男：46.4-51.6cm，女：45.4-50.6cm，正常长速: 2
岁～3 岁增加 2cm
睡眠 11-14 小时，频率：白天小睡次数：1 次，每次小睡
的时长：1.5-2.5 小时
排便 每天 1-2 次
乳类喂养 每日饮奶，350-500 克
主食添加 营养及喂养
1.注意膳食品种多样化，提倡自然食品、均衡膳食，
每天应摄入 1 个鸡蛋、50～75 克动物性食物、75～
125 克谷物、150～200 克蔬菜、100～200 克水果、
10～20 克植物油。2.幼儿应进食体积适宜、少盐易
消化的家常食物， 避免给幼儿吃油炸食品， 少吃快餐，
少喝甜饮料， 包括乳酸饮料。 3.幼儿应自主进食。 每
次进餐时间控制在 20 分钟左右， 最长不宜超过 30 分
钟，并养成定时进餐和良好的饮食习惯。
营养剂添加 每天补充维生素 D 600 国际单位，维生素 A 2000 国
际单位；
疫苗接种 36 月龄 A 群 C 群流脑多糖疫苗
常见问题 警示信号 不能和小朋友玩耍；不能识别照养者的基本情绪。
体检时间 36 月龄
体检目的 2. 了解儿童体格生长情况及一般营养状况，进行健
康指导；
2.筛查儿童常见眼病和视力不良。
体检项目 体检
1. 基本情况：病史、日常状况、特殊情况等。
2. 全身体格检查：1) 一般检查：身高/长、体重、
头围、前囟、呼吸、脉搏；2) 物理检查：a.内科检
查：心、肺、肝、脾；b.外科检查：皮肤、淋巴结、
头、颈、眼睛、耳、鼻、口腔、胸、腹、肛门/外生
殖器、脊柱、四肢、髋关节。
3. 实验室检查：1) 血细胞分析、铁代谢、25OHD3、
乙肝两对半、肝肾功能，等；2) 骨密度测定。
4. 专科检查：神经运动发育筛查、发育迟缓筛查、
语言发育筛查、口腔检查、视听力检查。
1.动作发展
能双脚交替灵活走楼梯。 能走直线。 能跨越一条短的平衡木。 双脚离地连续
跳跃 2—3 次。单脚站（约 3-5 秒）。手脚基本协调地攀登。将球扔出 2-3 米。
随口令做简单的操。会用积木（积塑）搭（或插）成较形象的物体。会穿鞋袜和
简单的外衣外裤。
2.语言发展
能回答简单问题，喜欢问“这（那）是什么？”等问句。词汇量增多，能说
出有 5 个字以上的复杂句子。 能说出物体及其图片的名称。 理解简单故事的主要
情节。会“念”熟悉的图画书给自己或家人听。知道一些礼貌用语，并知道何时
使用这些礼貌用语。
3.认知发展
能区别红、黄、蓝、绿等常见颜色。尝试画代表一定意思的涂鸦画，能记忆
和唱简单的歌。能口数 1-10。知道数字代表数量。会区分大小、多少、长短、
上下、里外，能给物体归类。知道家里主要成员的简单情况。
4.情感与社会性
能较好地调节情绪， 发脾气时间减少， 有时会隐瞒自己的感情。 会用 “快乐、
生气” 等词来谈论自己和他人的情感。 对成功表现出积极的情感， 对失败表现出
消极的情感。会表现出“骄傲、羞愧、嫉妒”等复杂的自我意识。知道自己是男
孩还是女孩， 能正确使用性别短语， 更喜欢玩属于自己性别的玩具， 如“女孩喜
欢娃娃， 男孩喜欢车” 参加属于自己性别群体的活动。 能和同龄小朋友分享玩具，
知道等待、轮流，有时不耐心。会自己整理玩具，能自己上床睡觉。
5.养育指导
提供与小朋友玩耍的机会， 鼓励幼儿发展同伴关系， 学习轮流、 等待、 合作、
互助与分享，培养爱心、同情心和自我控制能力。通过与小朋友玩“开火车”
、
“骑竹竿”
、
“过家家”等想象性和角色扮演游戏，保护和培养幼儿的兴趣和想
象力。经常给幼儿讲故事，并鼓励幼儿复述简单故事，教幼儿说歌谣、唱儿歌、
讲述图画， 不断地丰富词汇， 提高语言表达能力。 练习双脚交替上楼梯、 走脚印、
跳远等，提高身体协调能力。通过画水平线、画圆形、扣扣子、穿鞋子等，提高
精细动作能力。逐步培养规律的生活习惯，学习自己洗手、进食、穿衣、大小便
等生活技能。帮助幼儿学会适应新环境，做好入园准备。
推荐活动:
唱儿歌；自己洗手；参与同伴玩耍。');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('0_42d', 'weight', '体重', 'kg', 2.8, 4.2, 2.7, 4.1, '每月增长0.8-1.2kg', '足月宝宝正常出生体重在2500-4000g，出生后7天恢复出生体重。男：2.8-4.2kg，女：2.7-4.1kg，每月增长0.8-1.2kg');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('0_42d', 'height', '身高', 'cm', 47.6, 54.8, 46.8, 53.8, '每月增长4cm', '足月宝宝出生身长平均50cm。男：47.6-54.8cm，女：46.8-53.8cm，每月增长4cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('0_42d', 'head_circumference', '头围', 'cm', 31.7, 36.9, 31.4, 36.5, '每月增长2cm', '足月宝宝出生头围在32-36cm。男：31.7-36.9cm，女：31.4-36.5cm，每月增长2cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('42d_3m', 'weight', '体重', 'kg', 3.7, 5.6, 3.5, 5.3, '每月增长0.8-1.2kg', '男：3.7-5.6kg，女：3.5-5.3kg，每月增长0.8-1.2kg');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('42d_3m', 'height', '身高', 'cm', 49.1, 61.2, 48.2, 60.0, '每月增长4cm', '男：49.1-61.2cm，女：48.2-60cm，每月增长4cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('42d_3m', 'head_circumference', '头围', 'cm', 34.6, 39.4, 34.0, 38.6, '每月增长2cm', '男：34.6-39.4cm，女：34-38.6cm，每月增长2cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('4_6m', 'weight', '体重', 'kg', NULL, NULL, NULL, NULL, '平均每月体重增长0.5-0.6kg', '平均每月体重增长0.5-0.6kg');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('4_6m', 'height', '身高', 'cm', NULL, NULL, NULL, NULL, '平均每月身长增长约2cm', '平均每月身长增长约2cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('4_6m', 'head_circumference', '头围', 'cm', NULL, NULL, NULL, NULL, '平均每月头围增长约1cm', '平均每月头围增长约1cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('7_9m', 'weight', '体重', 'kg', NULL, NULL, NULL, NULL, '平均每月体重增长0.27-0.37kg', '平均每月体重增长0.27-0.37kg');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('7_9m', 'height', '身高', 'cm', NULL, NULL, NULL, NULL, '平均每月身长增长约2cm', '平均每月身长增长约2cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('7_9m', 'head_circumference', '头围', 'cm', NULL, NULL, NULL, NULL, '平均每月头围增长约1cm', '平均每月头围增长约1cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('10_12m', 'weight', '体重', 'kg', 7.7, 11.5, 7.2, 10.8, '每月增长0.2-0.3kg', '男：7.7-11.5kg，女：7.2-10.8kg，每月增长0.2-0.3kg');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('10_12m', 'height', '身高', 'cm', 68.3, 77.8, 66.8, 76.1, '每月增长1cm', '男：68.3-77.8cm，女：66.8-76.1cm，每月增长1cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('10_12m', 'head_circumference', '头围', 'cm', 42.7, 47.7, 41.6, 46.5, '每月增长0.5cm', '男：42.7-47.7cm，女：41.6-46.5cm，每月增长0.5cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('13_18m', 'weight', '体重', 'kg', 8.3, 12.3, 7.7, 11.6, '每3月增长0.5kg', '男：8.3-12.3kg，女：7.7-11.6kg，正常长速：每3月增长0.5kg');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('13_18m', 'height', '身高', 'cm', 71.7, 81.6, 70.4, 80.1, '每月增长1cm', '男：71.7-81.6cm，女：70.4-80.1cm，每月增长1cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('13_18m', 'head_circumference', '头围', 'cm', 43.7, 48.4, 42.7, 47.6, '1岁-2岁增加2cm', '男：43.7-48.4cm，女：42.7-47.6cm，正常长速：1岁-2岁增加2cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('19_24m', 'weight', '体重', 'kg', 9.3, 13.8, 8.8, 13.2, '每3月增长0.5kg', '男：9.3-13.8kg，女：8.8-13.2kg，正常长速：每3月增长0.5kg');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('19_24m', 'height', '身高', 'cm', 77.7, 88.5, 76.5, 87.2, '每月增长1cm', '男：77.7-88.5cm，女：76.5-87.2cm，每月增长1cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('19_24m', 'head_circumference', '头围', 'cm', 44.9, 50.0, 43.9, 49.0, '1岁-2岁增加2cm', '男：44.9-50cm，女：43.9-49cm，正常长速：1岁-2岁增加2cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('25_30m', 'weight', '体重', 'kg', 10.4, 15.4, 9.8, 14.8, '每3月增长0.5kg', '男：10.4-15.4kg，女：9.8-14.8kg，正常长速：每3月增长0.5kg');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('25_30m', 'height', '身高', 'cm', 82.4, 94.0, 81.2, 92.8, '每月增长0.5-0.7cm', '男：82.4-94cm，女：81.2-92.8cm，每月增长0.5-0.7cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('25_30m', 'head_circumference', '头围', 'cm', 45.9, 51.0, 44.8, 51.0, '2岁-3岁增加2cm', '男：45.9-51cm，女：44.8-51cm，正常长速：2岁-3岁增加2cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('31_36m', 'weight', '体重', 'kg', 11.2, 16.7, 10.7, 17.2, '每3月增长0.5kg', '男：11.2-16.7kg，女：10.7-17.2kg，正常长速：每3月增长0.5kg');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('31_36m', 'height', '身高', 'cm', 87.0, 99.4, 85.7, 98.1, '每月增长0.5-0.7cm', '男：87-99.4cm，女：85.7-98.1cm，每月增长0.5-0.7cm');
INSERT INTO growth_metric (stage_id, metric_key, metric_name, unit, male_min, male_max, female_min, female_max, growth_rate, source_text) VALUES ('31_36m', 'head_circumference', '头围', 'cm', 46.4, 51.6, 45.4, 50.6, '2岁-3岁增加2cm', '男：46.4-51.6cm，女：45.4-50.6cm，正常长速：2岁-3岁增加2cm');
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('0_42d', 'sleep', '睡眠', '新生儿睡眠时间平均每日13-18小时，初生宝宝暂时未有昼夜节律，缺乏睡眠规律；母乳喂养的新生儿每次睡眠时间稍短（2-3小时），人工喂养新生儿每次睡眠时间稍长（3-4小时）。', '新生儿睡眠时间平均每日13-18小时，初生宝宝暂时未有昼夜节律，缺乏睡眠规律；母乳喂养的新生儿每次睡眠时间稍短（2-3小时），人工喂养新生儿每次睡眠时间稍长（3-4小时）。', 1);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('0_42d', 'stool', '排便', '足月儿在出生后24小时内排胎便，2-3天排完胎便；出生4日后大多数婴儿每日排便3次或更多，到出生后第5日大便应为浅黄色并有颗粒物。', '足月儿在出生后24小时内排胎便，2-3天排完胎便；出生4日后大多数婴儿每日排便3次或更多，到出生后第5日大便应为浅黄色并有颗粒物。', 2);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('0_42d', 'milk_feeding', '乳类喂养', '建议纯母乳喂养，初生新生儿母乳喂养次数推荐8-10次以上。无法母乳喂养时需要配方奶喂养，此期喂养量及时间间隔暂无规律，需要顺应性喂养。', '建议纯母乳喂养，初生新生儿母乳喂养次数推荐8-10次以上。无法母乳喂养时需要配方奶喂养，此期喂养量及时间间隔暂无规律，需要顺应性喂养。', 3);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('0_42d', 'supplements', '营养剂添加', '足月儿生后数日内在医生指导下每天补充维生素D 400国际单位、维生素A 1500u/天；早产或低出生体重儿按医生指导补充维生素D和铁元素。', '足月儿生后数日内在医生指导下每天补充维生素D 400国际单位、维生素A 1500u/天；早产或低出生体重儿按医生指导补充维生素D和铁元素。', 4);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('0_42d', 'common_issue', '黄疸', '出生后超过80%正常新生儿可出现皮肤黄染。若黄疸明显、进行性加重或伴排便颜色变浅，应及时就诊；排除病理性因素且纯母乳喂养时可考虑母乳性黄疸。', '出生后超过80%正常新生儿可出现皮肤黄染。若黄疸明显、进行性加重或伴排便颜色变浅，应及时就诊；排除病理性因素且纯母乳喂养时可考虑母乳性黄疸。', 5);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('42d_3m', 'sleep', '睡眠', '13-18小时；白天小睡6-8次，每次10-15分钟至4小时。', '13-18小时；白天小睡6-8次，每次10-15分钟至4小时。', 1);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('42d_3m', 'stool', '排便', '每天1-3次。', '每天1-3次。', 2);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('42d_3m', 'milk_feeding', '乳类喂养', '继续母乳喂养；无法母乳喂养或者母乳不足时可选用婴儿配方奶粉补充，每日500-800ml。', '继续母乳喂养；无法母乳喂养或者母乳不足时可选用婴儿配方奶粉补充，每日500-800ml。', 3);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('42d_3m', 'supplements', '营养剂添加', '足月儿每天补充维生素D 400国际单位、维生素A 1500国际单位；早产或低出生体重儿按医生指导补充维生素D和铁元素。', '足月儿每天补充维生素D 400国际单位、维生素A 1500国际单位；早产或低出生体重儿按医生指导补充维生素D和铁元素。', 4);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('42d_3m', 'common_issue', '肠胀气/肠绞痛', '婴儿绞痛表现为长时间反复难以安抚的哭闹。可尝试包裹、侧位/腹位/飞机抱、顺时针揉腹、白噪声等；若长时间剧烈哭闹无法安抚需就诊。', '婴儿绞痛表现为长时间反复难以安抚的哭闹。可尝试包裹、侧位/腹位/飞机抱、顺时针揉腹、白噪声等；若长时间剧烈哭闹无法安抚需就诊。', 5);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('42d_3m', 'common_issue', '吐奶', '此月龄胃部入口抗反流能力未成熟，常见奶后吐奶。可减缓奶流、少量多餐、喂奶时上身保持约45度、奶后拍嗝；若伴体重减轻或体重不增需就诊。', '此月龄胃部入口抗反流能力未成熟，常见奶后吐奶。可减缓奶流、少量多餐、喂奶时上身保持约45度、奶后拍嗝；若伴体重减轻或体重不增需就诊。', 6);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('42d_3m', 'warning_sign', '警示信号', '3个月不会对着人笑。', '3个月不会对着人笑。', 7);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('4_6m', 'sleep', '睡眠', '睡眠昼夜节律初步形成，推荐睡眠时长12-16小时；白天3-4次小睡，每次0.5-2小时，夜晚可有2-3次夜醒。需要减少奶睡、抱睡，逐步建立自主入睡能力。', '睡眠昼夜节律初步形成，推荐睡眠时长12-16小时；白天3-4次小睡，每次0.5-2小时，夜晚可有2-3次夜醒。需要减少奶睡、抱睡，逐步建立自主入睡能力。', 1);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('4_6m', 'stool', '排便', '排便较为规律，1-3次/日，或者间隔1-2日排一次大便，大便多呈黄色糊状便。', '排便较为规律，1-3次/日，或者间隔1-2日排一次大便，大便多呈黄色糊状便。', 2);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('4_6m', 'milk_feeding', '乳类喂养', '继续母乳喂养，母乳不足时可选用婴儿配方奶粉补充。白天定时喂养，每3-4小时一次，约800ml/日，逐渐停夜间哺乳，不宜频繁夜奶。', '继续母乳喂养，母乳不足时可选用婴儿配方奶粉补充。白天定时喂养，每3-4小时一次，约800ml/日，逐渐停夜间哺乳，不宜频繁夜奶。', 3);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('4_6m', 'supplements', '营养剂添加', '每天补充维生素D 400国际单位、维生素A 1500国际单位；纯母乳或以母乳为主的足月儿4-6月龄时可根据需要补铁剂1-2mg/kg/日；早产或低出生体重儿继续补铁。', '每天补充维生素D 400国际单位、维生素A 1500国际单位；纯母乳或以母乳为主的足月儿4-6月龄时可根据需要补铁剂1-2mg/kg/日；早产或低出生体重儿继续补铁。', 4);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('4_6m', 'common_issue', '厌奶期', '3月龄后宝宝可能逐渐出现厌奶。建议定时喂养，3-4小时一次，每次控制在20分钟内，不强迫喂养，减少夜间喂奶。若长期抗拒喝奶并伴哭闹、呕吐、腹泻、便秘、体重减轻等需就诊。', '3月龄后宝宝可能逐渐出现厌奶。建议定时喂养，3-4小时一次，每次控制在20分钟内，不强迫喂养，减少夜间喂奶。若长期抗拒喝奶并伴哭闹、呕吐、腹泻、便秘、体重减轻等需就诊。', 5);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('4_6m', 'warning_sign', '警示信号', '未建立安全性依恋；缺乏陌生人焦虑。', '未建立安全性依恋；缺乏陌生人焦虑。', 6);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('7_9m', 'sleep', '睡眠', '推荐睡眠时长12-16小时，昼夜节律较稳定；白天小睡2-3次，小睡0.5-2小时，夜间最长一次睡眠可达5-6小时，夜醒1-2次。', '推荐睡眠时长12-16小时，昼夜节律较稳定；白天小睡2-3次，小睡0.5-2小时，夜间最长一次睡眠可达5-6小时，夜醒1-2次。', 1);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('7_9m', 'stool', '排便', '排便较为规律，1-3次/日，或者间隔1-2日排一次，大便多呈黄色糊状便或者柔软成形便。', '排便较为规律，1-3次/日，或者间隔1-2日排一次，大便多呈黄色糊状便或者柔软成形便。', 2);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('7_9m', 'milk_feeding', '乳类喂养', '继续母乳喂养，母乳不足时可补充配方奶。定时喂养，每餐间隔3-4小时，奶3-4次/日，辅食1-2次/日，全天奶量700-900ml左右。', '继续母乳喂养，母乳不足时可补充配方奶。定时喂养，每餐间隔3-4小时，奶3-4次/日，辅食1-2次/日，全天奶量700-900ml左右。', 3);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('7_9m', 'complementary_food', '辅食添加', '足月儿6个月起添加辅食，早产儿校正胎龄4-6月添加。辅食质地从泥状过渡到碎末状，种类多样，注意排敏；每餐2-3勺逐渐增加到1/2碗，种类每日不少于4种。', '足月儿6个月起添加辅食，早产儿校正胎龄4-6月添加。辅食质地从泥状过渡到碎末状，种类多样，注意排敏；每餐2-3勺逐渐增加到1/2碗，种类每日不少于4种。', 4);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('7_9m', 'supplements', '营养剂添加', '每天补充维生素D 400国际单位、维生素A 1500国际单位；早产或低出生体重儿继续按2毫克/千克/天补充铁元素。', '每天补充维生素D 400国际单位、维生素A 1500国际单位；早产或低出生体重儿继续按2毫克/千克/天补充铁元素。', 5);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('7_9m', 'common_issue', '便秘', '婴儿排便次数每周≤2次，伴排便费力、痛苦且大便干硬时可考虑便秘。可腹部按摩、增加俯卧爬行、调整食物结构、训练定时排便；持续时间长或伴腹胀呕吐等需就诊。', '婴儿排便次数每周≤2次，伴排便费力、痛苦且大便干硬时可考虑便秘。可腹部按摩、增加俯卧爬行、调整食物结构、训练定时排便；持续时间长或伴腹胀呕吐等需就诊。', 6);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('7_9m', 'common_issue', '睡眠倒退期', '大动作发育、白天活动过久、睡前兴奋、抱睡奶睡等可造成夜醒频繁。建议白天适度户外活动、固定就寝时间、固定睡前活动、减少抱睡奶睡。', '大动作发育、白天活动过久、睡前兴奋、抱睡奶睡等可造成夜醒频繁。建议白天适度户外活动、固定就寝时间、固定睡前活动、减少抱睡奶睡。', 7);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('7_9m', 'warning_sign', '警示信号', '听到声音无应答；不会区分生人和熟人；双手间不会传递玩具；不会独坐。', '听到声音无应答；不会区分生人和熟人；双手间不会传递玩具；不会独坐。', 8);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('10_12m', 'sleep', '睡眠', '12-16小时；白天小睡2次，每次1-2小时。', '12-16小时；白天小睡2次，每次1-2小时。', 1);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('10_12m', 'stool', '排便', '每天1-2次。', '每天1-2次。', 2);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('10_12m', 'milk_feeding', '乳类喂养', '继续母乳喂养，母乳不足时可选用婴儿配方奶粉补充。每天2-4次，共500-700ml。', '继续母乳喂养，母乳不足时可选用婴儿配方奶粉补充。每天2-4次，共500-700ml。', 3);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('10_12m', 'complementary_food', '辅食添加', '逐渐推进半固体食物、切碎的家庭食物、手指食物、条状食物到2-3次；每餐1/2碗；注意膳食品种多样化。', '逐渐推进半固体食物、切碎的家庭食物、手指食物、条状食物到2-3次；每餐1/2碗；注意膳食品种多样化。', 4);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('10_12m', 'supplements', '营养剂添加', '每天补充维生素D 400国际单位、维生素A 1500国际单位；早产或低出生体重儿继续补铁。', '每天补充维生素D 400国际单位、维生素A 1500国际单位；早产或低出生体重儿继续补铁。', 5);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('10_12m', 'common_issue', '辅食喂养困难', '原因可能包括未定时喂养、强迫喂养、夜奶未停、辅食种类单一、辅食过精细、喂养者焦虑等。建议拉长喂养间隔、辅食喂养小于20分钟、停止夜奶、少量多次尝试新食物。', '原因可能包括未定时喂养、强迫喂养、夜奶未停、辅食种类单一、辅食过精细、喂养者焦虑等。建议拉长喂养间隔、辅食喂养小于20分钟、停止夜奶、少量多次尝试新食物。', 6);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('10_12m', 'warning_sign', '警示信号', '缺乏好奇心；缺乏模仿。', '缺乏好奇心；缺乏模仿。', 7);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('13_18m', 'sleep', '睡眠', '11-14小时；白天小睡1-2次，每次1-3小时。', '11-14小时；白天小睡1-2次，每次1-3小时。', 1);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('13_18m', 'stool', '排便', '每天1-2次。', '每天1-2次。', 2);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('13_18m', 'milk_feeding', '乳类喂养', '继续母乳喂养，母乳不足时可选用配方奶粉补充。每天2-3次，共400-600ml。', '继续母乳喂养，母乳不足时可选用配方奶粉补充。每天2-3次，共400-600ml。', 3);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('13_18m', 'complementary_food', '主食添加', '条块、球块状家庭食物每天2-3次，每餐约3/4碗；每天摄入鸡蛋、动物性食物、谷物、蔬菜、水果和植物油；1岁以后引导但不强迫进食，鼓励自主进食。', '条块、球块状家庭食物每天2-3次，每餐约3/4碗；每天摄入鸡蛋、动物性食物、谷物、蔬菜、水果和植物油；1岁以后引导但不强迫进食，鼓励自主进食。', 4);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('13_18m', 'supplements', '营养剂添加', '每天补充维生素D 600国际单位，维生素A 2000国际单位。', '每天补充维生素D 600国际单位，维生素A 2000国际单位。', 5);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('13_18m', 'common_issue', '分离焦虑', '与家人或亲人分开时哭很长时间，恳求亲人不要离开，分离时只想亲人回到身边。', '与家人或亲人分开时哭很长时间，恳求亲人不要离开，分离时只想亲人回到身边。', 6);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('13_18m', 'common_issue', '偏食挑食、吃饭慢、不肯吃硬食物', '该现象往往由于父母溺爱和纵容，以及缺乏科学喂养方式所致。', '该现象往往由于父母溺爱和纵容，以及缺乏科学喂养方式所致。', 7);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('13_18m', 'warning_sign', '警示信号', '不能听从简单指令；对周围小朋友不感兴趣。', '不能听从简单指令；对周围小朋友不感兴趣。', 8);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('19_24m', 'sleep', '睡眠', '11-14小时；白天小睡1次，每次1.5-2.5小时。', '11-14小时；白天小睡1次，每次1.5-2.5小时。', 1);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('19_24m', 'stool', '排便', '每天1-2次。', '每天1-2次。', 2);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('19_24m', 'milk_feeding', '乳类喂养', '继续母乳喂养，母乳不足时可选用配方奶粉补充。每天2-3次，共400-600ml。', '继续母乳喂养，母乳不足时可选用配方奶粉补充。每天2-3次，共400-600ml。', 3);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('19_24m', 'complementary_food', '主食添加', '条块、球块状家庭食物每天3次；每餐3/4碗到1整碗；每天摄入鸡蛋、动物性食物、谷物、蔬菜、水果和植物油；逐步过渡到独立进食。', '条块、球块状家庭食物每天3次；每餐3/4碗到1整碗；每天摄入鸡蛋、动物性食物、谷物、蔬菜、水果和植物油；逐步过渡到独立进食。', 4);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('19_24m', 'supplements', '营养剂添加', '每天补充维生素D 600国际单位，维生素A 2000国际单位。', '每天补充维生素D 600国际单位，维生素A 2000国际单位。', 5);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('19_24m', 'common_issue', '跌倒外伤等意外伤害', '随着年龄增长，孩子独立行走活动范围扩大，家长应增强安全防范意识，防止幼儿期意外伤害。', '随着年龄增长，孩子独立行走活动范围扩大，家长应增强安全防范意识，防止幼儿期意外伤害。', 6);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('19_24m', 'warning_sign', '警示信号', '不能听从简单指令；对周围小朋友不感兴趣。', '不能听从简单指令；对周围小朋友不感兴趣。', 7);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('25_30m', 'sleep', '睡眠', '11-14小时；白天小睡1次，每次1.5-2.5小时。', '11-14小时；白天小睡1次，每次1.5-2.5小时。', 1);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('25_30m', 'stool', '排便', '每天1-2次。', '每天1-2次。', 2);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('25_30m', 'milk_feeding', '乳类喂养', '每日饮奶350-500克。', '每日饮奶350-500克。', 3);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('25_30m', 'complementary_food', '主食添加', '注意膳食品种多样化，提倡自然食品、均衡膳食；每天摄入鸡蛋、动物性食物、谷物、蔬菜、水果和植物油；进食质地稍软、少盐易消化的家常食物，避免油炸食品、快餐和甜饮料。', '注意膳食品种多样化，提倡自然食品、均衡膳食；每天摄入鸡蛋、动物性食物、谷物、蔬菜、水果和植物油；进食质地稍软、少盐易消化的家常食物，避免油炸食品、快餐和甜饮料。', 4);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('25_30m', 'supplements', '营养剂添加', '每天补充维生素D 600国际单位，维生素A 2000国际单位。', '每天补充维生素D 600国际单位，维生素A 2000国际单位。', 5);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('25_30m', 'warning_sign', '警示信号', '缺乏基本情绪表达；缺乏想象性游戏。', '缺乏基本情绪表达；缺乏想象性游戏。', 6);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('31_36m', 'sleep', '睡眠', '11-14小时；白天小睡1次，每次1.5-2.5小时。', '11-14小时；白天小睡1次，每次1.5-2.5小时。', 1);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('31_36m', 'stool', '排便', '每天1-2次。', '每天1-2次。', 2);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('31_36m', 'milk_feeding', '乳类喂养', '每日饮奶350-500克。', '每日饮奶350-500克。', 3);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('31_36m', 'complementary_food', '主食添加', '注意膳食品种多样化，提倡自然食品、均衡膳食；每天摄入鸡蛋、动物性食物、谷物、蔬菜、水果和植物油；幼儿应自主进食，每次进餐时间控制在20分钟左右，最长不宜超过30分钟。', '注意膳食品种多样化，提倡自然食品、均衡膳食；每天摄入鸡蛋、动物性食物、谷物、蔬菜、水果和植物油；幼儿应自主进食，每次进餐时间控制在20分钟左右，最长不宜超过30分钟。', 4);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('31_36m', 'supplements', '营养剂添加', '每天补充维生素D 600国际单位，维生素A 2000国际单位。', '每天补充维生素D 600国际单位，维生素A 2000国际单位。', 5);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('31_36m', 'warning_sign', '警示信号', '不能和小朋友玩耍；不能识别照养者的基本情绪。', '不能和小朋友玩耍；不能识别照养者的基本情绪。', 6);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('0_42d', 'parenting', '养育指导', '母婴交流非常重要， 父母尽可能亲自养育， 多与新生儿接触， 如说话、 微笑、 怀抱等。 学会辨识新生婴儿哭声， 及时安抚情绪并满足其需求， 如按需哺乳。新 生儿喂奶 1 小时后可进行俯卧练习，每天可进行 1～2 次婴儿被动操。给新生儿 抚触', '母婴交流非常重要， 父母尽可能亲自养育， 多与新生儿接触， 如说话、 微笑、 怀抱等。 学会辨识新生婴儿哭声， 及时安抚情绪并满足其需求， 如按需哺乳。新 生儿喂奶 1 小时后可进行俯卧练习，每天可进行 1～2 次婴儿被动操。给新生儿 抚触， 让新生儿看人脸或鲜艳玩具、 听悦耳铃声和音乐等， 促进其感知觉的发展。', 90);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('0_42d', 'activity', '推荐活动', '抚触/被动操;按需哺乳;亲子互动。', '抚触/被动操;按需哺乳;亲子互动。', 91);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('42d_3m', 'parenting', '养育指导', '注重亲子交流， 在哺喂、 护理过程中多与婴儿带有情感的说话、 逗弄，对婴 儿发声要用微笑、声音或点头应答，注意目光的交流。通过俯卧、竖抱练习、被 动操等， 锻炼婴儿头颈部的运动和控制能力。 给婴儿听悦耳的音乐， 玩带响声的 玩具；用鲜艳的玩', '注重亲子交流， 在哺喂、 护理过程中多与婴儿带有情感的说话、 逗弄，对婴 儿发声要用微笑、声音或点头应答，注意目光的交流。通过俯卧、竖抱练习、被 动操等， 锻炼婴儿头颈部的运动和控制能力。 给婴儿听悦耳的音乐， 玩带响声的 玩具；用鲜艳的玩具吸引婴儿注视和目光跟踪;让他/她有机会触摸不同质地的物 品。', 90);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('42d_3m', 'activity', '推荐活动', '玩玩具;亲子互动;俯卧。', '玩玩具;亲子互动;俯卧。', 91);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('4_6m', 'parenting', '养育指导', '父母尽可能陪伴和养育婴儿， 主动识别并及时有效的应答婴儿的生理与心理 需求， 逐渐建立安全的亲子依恋关系。 培养规律的进食、 睡眠等生活习惯，多与 婴儿玩看镜子、 藏猫猫、 寻找声音来源等亲子游戏。 营造丰富的语言环境，多与 婴儿说话、模仿', '父母尽可能陪伴和养育婴儿， 主动识别并及时有效的应答婴儿的生理与心理 需求， 逐渐建立安全的亲子依恋关系。 培养规律的进食、 睡眠等生活习惯，多与 婴儿玩看镜子、 藏猫猫、 寻找声音来源等亲子游戏。 营造丰富的语言环境，多与 婴儿说话、模仿婴儿发声以鼓励婴儿发音，达到“交流应答”的目的。鼓励婴儿 自由翻身、 适当练习扶坐； 让婴儿多伸手抓握不同质地的玩具和物品， 促进手眼 协调能力发展。', 90);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('4_6m', 'activity', '推荐活动', '照镜子;练习扶坐;模仿发声。', '照镜子;练习扶坐;模仿发声。', 91);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('7_9m', 'parenting', '养育指导', '父母多陪伴和关注婴儿， 在保证婴儿安全的情况下扩大活动范围， 鼓励与外 界环境和人接触。 经常叫婴儿名字， 说家中物品名称， 培养婴儿对语言的理解能 力。引导婴儿发“ba ba” 、 “ma ma”等语音，提高其对发音的兴趣。帮助婴儿 练习', '父母多陪伴和关注婴儿， 在保证婴儿安全的情况下扩大活动范围， 鼓励与外 界环境和人接触。 经常叫婴儿名字， 说家中物品名称， 培养婴儿对语言的理解能 力。引导婴儿发“ba ba” 、 “ma ma”等语音，提高其对发音的兴趣。帮助婴儿 练习独坐和匍匐爬行， 扶腋下蹦跳； 练习伸手够远处玩具、 双手传递玩具、撕纸 等双手配合和手指抓捏动作，提高手眼协调能力。', 90);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('7_9m', 'activity', '推荐活动', '说家中物品名；练习匍匐爬、伸手够；多接触外界环境。', '说家中物品名；练习匍匐爬、伸手够；多接触外界环境。', 91);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('10_12m', 'parenting', '养育指导', '帮助婴儿识别他人的不同表情； 当婴儿出现生气、 厌烦、 不愉快等负性情绪 时， 转移其注意力； 受到挫折时给予鼓励和支持。 丰富婴儿语言环境，经常同婴 儿讲话、 看图画。 让婴儿按指令做出动作和表情， 如叫名字有应答， 懂得挥手 “再 见”', '帮助婴儿识别他人的不同表情； 当婴儿出现生气、 厌烦、 不愉快等负性情绪 时， 转移其注意力； 受到挫折时给予鼓励和支持。 丰富婴儿语言环境，经常同婴 儿讲话、 看图画。 让婴儿按指令做出动作和表情， 如叫名字有应答， 懂得挥手 “再 见” 。 帮助婴儿多练习手-膝爬行， 学习扶着物品站立和行走；给婴儿提供杯子、 积木、 球等安全玩具玩耍， 发展手眼协调和相对准确的操作能力。 与婴儿玩模仿 游戏，如拍手“欢迎” 、捏有响声的玩具、拍娃娃、拖动毯子取得玩具等。', 90);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('10_12m', 'activity', '推荐活动', '模仿“再见” ；多与婴儿说话/看图画；手-膝爬。', '模仿“再见” ；多与婴儿说话/看图画；手-膝爬。', 91);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('13_18m', 'parenting', '养育指导', '给予幼儿探索环境、表达愿望和情绪的机会。经常带幼儿玩亲子互动游戏， 如相互滚球、 爬行比赛等； 引导幼儿玩功能性游戏， 如模仿给娃娃喂饭、拍睡觉 等。 多给幼儿讲故事、 说儿歌， 教幼儿指认书中图画和身体部位，引导幼儿将语 言与实物联系起来', '给予幼儿探索环境、表达愿望和情绪的机会。经常带幼儿玩亲子互动游戏， 如相互滚球、 爬行比赛等； 引导幼儿玩功能性游戏， 如模仿给娃娃喂饭、拍睡觉 等。 多给幼儿讲故事、 说儿歌， 教幼儿指认书中图画和身体部位，引导幼儿将语 言与实物联系起来， 鼓励幼儿有意识的用语言表达。 给幼儿提供安全的活动场所， 通过练习独立行走、扔球、踢球、拉着玩具走等活动，提高控制平衡的能力。鼓 励幼儿多做翻书页、 盖瓶盖、 用笔涂鸦、 垒积木等游戏，提高认知及手眼协调能 力。', 90);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('13_18m', 'activity', '推荐活动', '练习走路；涂鸦；亲子阅读。', '练习走路；涂鸦；亲子阅读。', 91);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('19_24m', 'parenting', '养育指导', '家长对待幼儿的养育态度和行为要一致。 在保证安全的前提下， 给幼儿自主做事 情的机会， 对幼儿每一次的努力都给予鼓励和赞扬， 培养其独立性和自信心。 与 幼儿玩“给娃娃喂饭、 拍睡觉”等装扮性游戏。 学习更多词汇， 说出身边物品名称、 短语', '家长对待幼儿的养育态度和行为要一致。 在保证安全的前提下， 给幼儿自主做事 情的机会， 对幼儿每一次的努力都给予鼓励和赞扬， 培养其独立性和自信心。 与 幼儿玩“给娃娃喂饭、 拍睡觉”等装扮性游戏。 学习更多词汇， 说出身边物品名称、 短语， 鼓励用语言表达需求和简单对话； 学习区分大小， 匹配形状和颜色等。提 高幼儿身体动作协调能力，学习扶着栏杆上下楼梯、踢皮球、踮着脚尖走和跑， 握笔模仿画线， 积木叠高等。 培养幼儿生活自理能力， 如用匙进食、 用杯子喝水， 学习脱袜子、脱鞋；固定大小便场所，练习有大小便时向家长示意。', 90);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('19_24m', 'activity', '推荐活动', '玩装扮性游戏；练习踮脚尖走；练习自己吃饭。', '玩装扮性游戏；练习踮脚尖走；练习自己吃饭。', 91);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('25_30m', 'parenting', '养育指导', '鼓励自己做力所能及的事， 提高克服困难的意识和能力。 鼓励幼儿帮助家长 做一些简单的家务活动， 如收拾玩具、 扫地、 帮忙拿东西等， 促进自信心的发展， 激发参与热情。 当幼儿企图做危险的活动时， 应当及时制止； 出现无理哭闹等不 适宜的行', '鼓励自己做力所能及的事， 提高克服困难的意识和能力。 鼓励幼儿帮助家长 做一些简单的家务活动， 如收拾玩具、 扫地、 帮忙拿东西等， 促进自信心的发展， 激发参与热情。 当幼儿企图做危险的活动时， 应当及时制止； 出现无理哭闹等不 适宜的行为时，可采用不予理睬或转移等方法，让幼儿懂得日常行为的对与错， 逐步养成良好的行为习惯。 教幼儿说出自己的姓名、 性别、 身体部位以及一些短 句和歌谣。学习执行指令，用较准确的语言表达需求；培养幼儿理解“里外” 、 “上下” 、 “前后”等空间概念。学习独自上下楼梯、单腿站，提高身体协调及 大运动能力；通过搭积木、串珠子、系扣子、画画等游戏，提高精细动作能力。', 90);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('25_30m', 'activity', '推荐活动', '收拾玩具;自己上下楼梯;搭积木。', '收拾玩具;自己上下楼梯;搭积木。', 91);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('31_36m', 'parenting', '养育指导', '提供与小朋友玩耍的机会， 鼓励幼儿发展同伴关系， 学习轮流、 等待、 合作、 互助与分享，培养爱心、同情心和自我控制能力。通过与小朋友玩“开火车” 、 “骑竹竿” 、 “过家家”等想象性和角色扮演游戏，保护和培养幼儿的兴趣和想 象力。经常给', '提供与小朋友玩耍的机会， 鼓励幼儿发展同伴关系， 学习轮流、 等待、 合作、 互助与分享，培养爱心、同情心和自我控制能力。通过与小朋友玩“开火车” 、 “骑竹竿” 、 “过家家”等想象性和角色扮演游戏，保护和培养幼儿的兴趣和想 象力。经常给幼儿讲故事，并鼓励幼儿复述简单故事，教幼儿说歌谣、唱儿歌、 讲述图画， 不断地丰富词汇， 提高语言表达能力。 练习双脚交替上楼梯、 走脚印、 跳远等，提高身体协调能力。通过画水平线、画圆形、扣扣子、穿鞋子等，提高 精细动作能力。逐步培养规律的生活习惯，学习自己洗手、进食、穿衣、大小便 等生活技能。帮助幼儿学会适应新环境，做好入园准备。', 90);
INSERT INTO content_item (stage_id, category, title, summary, content, sort_order) VALUES ('31_36m', 'activity', '推荐活动', '唱儿歌；自己洗手；参与同伴玩耍。', '唱儿歌；自己洗手；参与同伴玩耍。', 91);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('0_42d', 'motor', '俯卧时会试着抬头， 仰卧时会左右摆头， 能自由地转动颈部。 四肢能笨拙地 活动， 手的动作多于脚， 会蹬腿和踢掉身上东西。 摸到东西能攥住，手可张开或 攥紧，清醒时两手以握拳为主，触碰手心会握紧拳头。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('0_42d', 'language', '会发出细小的喉音， 宝宝与妈妈谈话时能注视妈妈面孔。 有人大声说话时会 出现惊跳。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('0_42d', 'cognition', '仰卧时能注意视线内物体， 会注视距眼前约 20-30 厘米远的红球。 对声音和 光线有多种反应。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('0_42d', 'social_emotional', '喜欢被爱抚、 拥抱。 部分宝宝能对妈妈微笑。 会注意到近距离人的面部表情， 喜欢看人脸， 尤其是喂养人的笑脸， 眼睛能跟踪走动的人。 听到人的声音有反应， 母亲喂养人的声音对哭吵的婴儿有安抚作用。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('42d_3m', 'motor', '逐渐学会从仰卧变为侧卧位。俯卧时能将头抬高至 45 度。被竖直抱时，能 将头竖直， 并张望四周， 头可随着看到的物品或听到的声音转动 180 度， 扶住腋 下保持直立姿势。 手能放开， 会伸手触摸眼前的东西。 上肢能够伸展，两手会在 胸前相互接触，手握着手。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('42d_3m', 'language', '能辨别不同人说话声音的语调，朝声音的方向扭头，咿呀学语。 哭声逐渐减少并开始会用不同的哭声表达自己的需求， 听到妈妈声音会发出 微笑和笑声。会注意成人的逗引，会发出“咕咕声”和类似 a、o、e 的音。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('42d_3m', 'cognition', '能感知色彩。 对对比强烈的图样有反应。 会将声音和形象联系起来， 会试图 找出声音的来源。 喜欢注视自己的手， 能举握物品， 见物后能双臂活动。眼睛能 立刻注意到面前大玩具，其视线还会随着人的走动而移动。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('42d_3m', 'social_emotional', '能忍受短暂的喂奶间断， 用目光期待着喂奶。 见到经常接触的人会微笑、 发 声或挥手蹬脚， 表现出快乐的神情。 对成人的逗引会用动嘴巴、 伸舌头、微笑或 摆动身体等表示情绪反应。表现出对喂养人的偏爱。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('4_6m', 'motor', '慢慢能从仰卧翻身到俯卧， 有爬的愿望。 能用两只小手支撑倾坐片刻。 成人 扶腋下能站直，双脚跳跃。会撕纸。喜欢玩手、扒脚。会笨拙的换手接物。能用 双手拿起眼前玩具，喜欢把东西放入口中。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('4_6m', 'language', '有明显的发音愿望， 会和成人进行相互模仿的发音游戏。 开始咿呀学语， 发 辅音 d、n、m、b。无意中会发出“爸”或“妈”的音。能和成人一起“啊啊” 、 “呜呜”地聊天。会听成人的语言信号。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('4_6m', 'cognition', '能注视距离眼前 75 厘米远的物体。用较长的时间来看物体或图形。会寻找 手中丢失的东西。喜欢颜色鲜艳的玩具或图卡。听到歌谣和摇篮曲会手舞足蹈。 能根据不同的声音找不同的家人。 听到熟悉物品的名称会用眼注视。 听到自己的 名字会转头看。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('4_6m', 'social_emotional', '会用哭声、面部表情和姿势与人沟通。开始怕羞。辨认生人、熟人，对生人 会注视或躲避等， 对熟人反应愉悦。 对亲切的语言表示愉快， 对严厉的语言表现 出不安或哭泣等反应。 会对着镜中的影像微笑、 发音或伸手拍。 在独处或别人拿 走他小玩具时会表示反对。 对熟悉的人或物有观察意识。 对主要带养人有明显的 依恋。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('7_9m', 'motor', '能独坐，会自己坐起躺下。扶握双腕能站，站立时腰、髋、膝关节能伸直。 开始学会爬。 能用小手拨弄桌上的小东西或摇有声响的小物品。 会用拇指、 食指 配合抓起玩具。能换手传递玩具，能用一个玩具敲打另一个玩具。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('7_9m', 'language', '能听懂成人对自己的叫唤。开始发“ma-ma” “ba-ba”等音节，能重复发出 某些元音和辅音。 试着模仿成人声音。 发音越来越像正真的语言。 开始懂得一些 常用词语的意思，会用简单的动作表示。会用自己的语音来表达不同的情绪。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('7_9m', 'cognition', '会关注有吸引力的物体， 并反复观察其特点和变化。 注意观察大人行动， 模 仿大人动作。 能挑选自己喜欢的玩具。 将玩具当着婴儿的面藏起来， 婴儿会尝试 寻找隐藏的玩具。 喜欢熟悉的环境， 到陌生的环境婴儿会表现出哭闹、 不安或好 奇。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('7_9m', 'social_emotional', '对带养人表示出依恋和喜爱， 对陌生人会有害怕、 拒绝等情绪反应。 对成人 表示肯定或否定的面部表情有不同的反应。喜欢玩交际游戏，如拍手、躲猫猫。 喜欢看镜中自己的影像。 会挥手再见、 招手欢迎， 玩拍手游戏。听到表扬会高兴 地重复刚才的动作。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('10_12m', 'motor', '可以腹部不贴地面地用四肢爬行。 能自己扶栏杆站立、 坐下及蹲下取物。 能 独自站稳一会儿，扶物会走，能独走几步。会将物体从大罐子中取出、放入。喜 欢随地扔东西。会将大圆圈套在木棍上。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('10_12m', 'language', '能听懂一些与自己有关的日常生活指令。 会用点头摇头等动作表达自己的意 愿。能说出几个词，如“爸爸”“妈妈”等。会自创一些词语来指称事物。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('10_12m', 'cognition', '会分辨甜、苦、咸等味道和香、臭等气味。能指认耳朵、眼睛、鼻子和经常 接触的物品。 喜欢看图画。 会注意到比较细小的物品， 喜欢摆弄、观察玩具及实 物。开始学习使用工具够物，如：玩具掉到沙发底下了，宝宝会拿小棍子够取。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('10_12m', 'social_emotional', '理解成人的肯定或否定态度。 会表达愤怒、 害怕、 焦急等不同情绪。喜爱熟 悉的人，会伸手要抱，对陌生人表现出忧虑、退缩、拒绝等行为。喜欢情感交流 活动， 会注视、 伸手去触摸同伴。 当言行得到认可时会高兴地重复表现。会用动 作等方式向成人索取感兴趣的东西， 初步具有保护自己物品的意识。 爱尝试、 喜 欢自己探索。喜欢重复玩交往游戏。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('13_18m', 'motor', '开始独立行走，喜欢走路时推、拉、拿着玩具。会跑，但不稳。不用扶物能 蹲下、站起。在成人的帮助下会上楼梯。会做简单的手势。会将球滚来滚去，没 有方向地随意扔球； 会将两三块积木垒高， 把小丸捏起放入容器中。 会抓住蜡笔 涂鸦。会用水杯喝水。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('13_18m', 'language', '对语言的理解能力超过语言的表达能力。 会用表情、 手势代替语言进行交流。 能听懂成人说的简单指令， 如可依照指令模仿常见动物的叫声。 开始知道书的概 念， 喜欢模仿翻书页。 会说自己的名字、 熟悉的人名或物品的名字。会使用生活 中常见的动词，如“抱”“吃”等。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('13_18m', 'cognition', '会指认某些身体部位。 喜欢用嘴、 手试探各种东西。 开始理解简单的因果关 系。 会长时间观察感兴趣的事物， 能用手势和声音表示不同的反应。 能根据感知 方面的突出特征对熟悉的物品进行简单的分类。会模仿一些简单的动作或声音， 开始自发地玩模仿性游戏，如：用玩具电话玩打电话游戏。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('13_18m', 'social_emotional', '对陌生人表示新奇， 会害怕陌生的环境和人。 开始理解并遵从成人简单的行 为准则和规范。 在很短的时间内表现出丰富的情绪变化。 能感觉到常规的改变或 环境的变迁。 自我意识开始萌芽。 能认出镜子里的自己。 喜欢单独玩或观看别人 游戏活动。开始对别的小孩感兴趣，能共同玩一会儿。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('19_24m', 'motor', '会自如地向前走、 向后走。 能连续跑 3-4 米， 但不稳。会自己扶栏杆能走几 步楼梯。能蹲着玩。能够弯腰捡玩具。能举手过肩扔球。能踢大球。会用五六块 积木叠搭起来。 会穿串珠。 会随意折纸。 能够根据音乐的节奏做动作。绘画开始 进入圆形涂鸦期。自己能够用汤匙吃东西。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('19_24m', 'language', '开始用名字称呼自己,开始会用“我” 。会说出常用东西的名称和用途。词 汇增加， 能说 3-5 个字的简单短句表达一定意思和个人需要。 喜欢跟着大人学说 话、 念童谣， 爱重复结尾的句子。 喜欢看图书、 指认书中物品， 说出熟悉的事物。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('19_24m', 'cognition', '喜欢探索周围的世界。 开始理解事件发生的前后顺序。 能记住一些简单的事， 熟悉的生活内容。 知道家庭成员以及经常一起玩的伙伴名字。 对声音的反应开始 越来越强烈，喜欢听声音的重复。能短暂的集中注意看图片、看电视、玩玩具、 听故事等。认识红色。能感知、区分方形、三角形和圆形。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('19_24m', 'social_emotional', '对主要带养者表现出较强的依恋。 会较长地延续某种情绪状态。 会对某些东 西或环境感到害怕， 需要时间适应新环境。 自我意识逐步增强， 喜欢自己独立完 成某一动作， 出现独立行为倾向。 开始意识到自己是女孩还是男孩， 交往能力增 加， 会与其他小孩共同参与游戏活动。 能按指示完成简单的任务， 喜欢模仿成人 动作，如擦桌子、拖地、学收拾玩具等。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('25_30m', 'motor', '能双脚交替走楼梯。 能后退、 侧着走和奔跑。 能双脚离地跳。会迈过低矮的 障碍物。 能轻松地立定蹲下。 能手脚基本协调地进行攀爬。 会骑三轮车和其他大 轮的玩具车。能用积木搭桥、火车等简单的物体。会滚球、扔球，举起手臂有方 向地投掷。 会一页一页五指抓翻书页。 会转动把手开门、 旋开瓶盖取物。会自己 洗手、擦脸。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('25_30m', 'language', '咿呀学语声基本消失。 会用日常生活中一些常用的形容词， 如“热” “冷” 。 开始用“你”等代名词。会说完整的短句和简单的复合句。会念简单的童谣。能 区分书中的图画和文字。愿意独自看简单的图画书。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('25_30m', 'cognition', '对周围事物或现象感兴趣，爱提问题。能感知物体软、硬、冷、热等属性。 感知比较差异明显的“大”“小”“多”“少”“上”“下” 。能基于形状、大 小、 颜色等做简单的分类。 能跟着数数。 能重复一些简单的韵律和歌曲。游戏时 能用物体或自己的身体部位代表其他物体。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('25_30m', 'social_emotional', '开始能表达自己的情感。 受到挫折会发脾气。 开始意识到他人的情感。 萌发 初步的同情感。 有简单的是非观念。 喜欢参与同伴的活动， 能和同伴一起玩简单 的角色游戏，会相互模仿，有模糊的角色装扮意识。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('31_36m', 'motor', '能双脚交替灵活走楼梯。 能走直线。 能跨越一条短的平衡木。 双脚离地连续 跳跃 2—3 次。单脚站（约 3-5 秒）。手脚基本协调地攀登。将球扔出 2-3 米。 随口令做简单的操。会用积木（积塑）搭（或插）成较形象的物体。会穿鞋袜和 简单的外衣外裤。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('31_36m', 'language', '能回答简单问题，喜欢问“这（那）是什么？”等问句。词汇量增多，能说 出有 5 个字以上的复杂句子。 能说出物体及其图片的名称。 理解简单故事的主要 情节。会“念”熟悉的图画书给自己或家人听。知道一些礼貌用语，并知道何时 使用这些礼貌用语。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('31_36m', 'cognition', '能区别红、黄、蓝、绿等常见颜色。尝试画代表一定意思的涂鸦画，能记忆 和唱简单的歌。能口数 1-10。知道数字代表数量。会区分大小、多少、长短、 上下、里外，能给物体归类。知道家里主要成员的简单情况。', 1);
INSERT INTO development_item (stage_id, domain, content, sort_order) VALUES ('31_36m', 'social_emotional', '能较好地调节情绪， 发脾气时间减少， 有时会隐瞒自己的感情。 会用 “快乐、 生气” 等词来谈论自己和他人的情感。 对成功表现出积极的情感， 对失败表现出 消极的情感。会表现出“骄傲、羞愧、嫉妒”等复杂的自我意识。知道自己是男 孩还是女孩， 能正确使用性别短语， 更喜欢玩属于自己性别的玩具， 如“女孩喜 欢娃娃， 男孩喜欢车” 参加属于自己性别群体的活动。 能和同龄小朋友分享玩具， 知道等待、轮流，有时不耐心。会自己整理玩具，能自己上床睡觉。', 1);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('0_42d', '0月龄', '乙肝疫苗', '第一针', NULL, 1);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('0_42d', '0月龄', '卡介苗', NULL, NULL, 2);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('0_42d', '出生时', '乙肝高效免疫球蛋白', NULL, '母亲若有乙肝病毒感染，需要在出生时接种', 3);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('0_42d', '1月龄', '乙肝疫苗', '第二针', NULL, 4);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('42d_3m', '2月龄', '脊髓灰质炎疫苗', '第1针', NULL, 1);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('42d_3m', '3月龄', '脊髓灰质炎疫苗', '第2针', NULL, 2);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('42d_3m', '3月龄', '百白破疫苗', '第1针', NULL, 3);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('4_6m', '4月龄', '脊灰减毒活疫苗口服/脊髓灰质炎疫苗', '第三针', NULL, 1);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('4_6m', '4月龄', '百白破疫苗', '第二针', NULL, 2);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('4_6m', '5月龄', '百白破疫苗', '第三针', NULL, 3);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('4_6m', '6月龄', '乙肝疫苗', '第三针', NULL, 4);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('4_6m', '6月龄', 'A群流脑多糖疫苗', '第一针', NULL, 5);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('7_9m', '8月龄', '麻腮风疫苗', '第一针', NULL, 1);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('7_9m', '8月龄', '乙脑减毒活疫苗/乙脑灭活疫苗', '第一针', NULL, 2);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('7_9m', '9月龄', 'A群流脑多糖疫苗', '第二针', NULL, 3);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('10_12m', '10-12月龄', '暂无一类疫苗接种', NULL, '若前期疫苗接种延迟，可顺延至10-12月龄补种；也可按需求和流行季节补充免疫。', 1);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('13_18m', '18月龄', '麻腮风疫苗', '第二针', NULL, 1);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('13_18m', '18月龄', '百白破疫苗', '第四针', NULL, 2);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('13_18m', '18月龄', '甲肝减毒活疫苗或甲肝灭活疫苗', '2选1', '甲肝活疫苗仅需1针，甲肝灭活疫苗需接种第2针。', 3);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('19_24m', '24月龄', '乙脑减毒活疫苗或乙脑灭活疫苗', '第2针/第3针', NULL, 1);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('19_24m', '24月龄', '甲肝灭活疫苗', '第2针', '已接种甲肝减毒活疫苗者无需再接种甲肝灭活疫苗第2针。', 2);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('25_30m', '25-30月龄', '补充免疫', NULL, '除国家免疫规划疫苗外，可根据家长需求、流行季节特点等进行补充免疫。', 1);
INSERT INTO vaccine_item (stage_id, age_label, vaccine_name, dose, note, sort_order) VALUES ('31_36m', '36月龄', 'A群C群流脑多糖疫苗', NULL, NULL, 1);
INSERT INTO checkup_item (stage_id, age_label, purpose, items, note) VALUES ('0_42d', '42天', '了解儿童体格生长趋势及一般营养状况，早期发现听力障碍、眼病、先天性及遗传性疾病等。', '基本情况、身高/长、体重、头围、前囟、呼吸、脉搏、内科检查、外科检查、神经运动发育筛查、发育迟缓筛查、语言发育筛查。必要时完善心脏、髋关节等超声影像学检查；眼病及听力筛查。', NULL);
INSERT INTO checkup_item (stage_id, age_label, purpose, items, note) VALUES ('42d_3m', '3月龄', '了解儿童体格生长情况及一般营养状况；早期识别可疑佝偻病，预防贫血；筛查儿童常见眼病和视力不良。', '基本情况、身高/长、体重、头围、前囟、呼吸、脉搏、内科检查、外科检查、神经运动发育筛查、发育迟缓筛查、语言发育筛查。骨密度测定，眼保健及视力检查。', NULL);
INSERT INTO checkup_item (stage_id, age_label, purpose, items, note) VALUES ('4_6m', '6月龄', '评价喂养、睡眠、生长速度和营养状况；评估铁储备，进行辅食添加和早教指导；筛查眼病、动作及社会交往等发育行为情况。', '身高体重头围测量、体格检查、神经心理与行为发育筛查、眼科检查、血常规检查、早教指导；必要时完善血清铁蛋白、尿常规、肝肾功能、血清酶、血糖；骨密度测定。', NULL);
INSERT INTO checkup_item (stage_id, age_label, purpose, items, note) VALUES ('7_9m', '9月龄', '了解儿童体格生长情况及一般营养状况；早期识别并纠正可疑佝偻病；筛查眼病和视力不良。', '身高体重头围测量、体格检查、神经心理与行为发育筛查、口腔保健、早教指导；血常规、必要时血清铁蛋白和乙肝两对半；骨密度测定。', NULL);
INSERT INTO checkup_item (stage_id, age_label, purpose, items, note) VALUES ('10_12m', '12月龄', '了解儿童体格生长情况及一般营养状况，查看预防接种情况；早期识别可疑佝偻病；筛查儿童常见眼病和视力不良。', '基本情况、身高/长、体重、头围、前囟、呼吸、脉搏、内科检查、外科检查、神经运动发育筛查、发育迟缓筛查、语言发育筛查。骨密度测定，视力筛查。', NULL);
INSERT INTO checkup_item (stage_id, age_label, purpose, items, note) VALUES ('13_18m', '18月龄', '了解儿童体格生长情况及一般营养状况；早期识别可疑佝偻病；发现并纠正贫血；筛查眼病和视力不良。', '基本情况、身高/长、体重、头围、前囟、呼吸、脉搏、内科检查、外科检查、神经运动发育筛查、发育迟缓筛查、语言发育筛查。血常规，必要时血清铁蛋白、尿常规、粪常规、肝肾功能、血清酶、血糖、重金属筛查；骨密度测定；口腔检查、眼保健及视力检查。', NULL);
INSERT INTO checkup_item (stage_id, age_label, purpose, items, note) VALUES ('19_24m', '24月龄', '了解儿童体格生长情况及一般营养状况；早期识别可疑佝偻病；筛查儿童常见眼病和视力不良。', '基本情况、身高/长、体重、头围、前囟、呼吸、脉搏、内科检查、外科检查、神经运动发育筛查、发育迟缓筛查、语言发育筛查。骨密度测定；口腔检查、眼保健及视听力筛查。', NULL);
INSERT INTO checkup_item (stage_id, age_label, purpose, items, note) VALUES ('25_30m', '30月龄', '了解儿童体格生长情况及一般营养状况；筛查儿童常见眼病和视力不良。', '基本情况、身高/长、体重、头围、前囟、呼吸、脉搏、内科检查、外科检查、神经运动发育筛查、发育迟缓筛查、语言发育筛查。血常规，必要时血清铁蛋白、尿常规、粪常规、肝肾功能、25OHD3、血糖、重金属筛查；骨密度测定；口腔检查、眼保健及视力筛查。', NULL);
INSERT INTO checkup_item (stage_id, age_label, purpose, items, note) VALUES ('31_36m', '36月龄', '了解儿童体格生长情况及一般营养状况；筛查儿童常见眼病和视力不良。', '基本情况、身高/长、体重、头围、前囟、呼吸、脉搏、内科检查、外科检查、神经运动发育筛查、发育迟缓筛查、语言发育筛查。血细胞分析、铁代谢、25OHD3、乙肝两对半、肝肾功能等；骨密度测定；口腔检查、视听力检查。', NULL);
COMMIT;

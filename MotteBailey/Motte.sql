UPDATE ArtDefine_Landmarks
SET Scale= '0.80'
WHERE ImprovementType = 'ART_DEF_IMPROVEMENT_MOTTE_BAILEY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

UPDATE Improvements
SET DefenseModifier = '20'
WHERE Type = 'IMPROVEMENT_MAB' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

UPDATE Improvements
SET MakesPassable = '1'
WHERE Type = 'IMPROVEMENT_MAB' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

UPDATE Improvements
SET BuildableOnResources = '0'
WHERE Type = 'IMPROVEMENT_MAB' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

UPDATE Improvements
SET DestroyedWhenPillaged = '0'
WHERE Type = 'IMPROVEMENT_MAB' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

UPDATE Improvements
SET OutsideBorders = '0'
WHERE Type = 'IMPROVEMENT_MAB' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

UPDATE Improvements
SET NoTwoAdjacent = '1'
WHERE Type = 'IMPROVEMENT_MAB' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

DELETE FROM BuildFeatures
WHERE BuildType = 'BUILD_MAB' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

INSERT INTO BuildFeatures (BuildType, FeatureType, PrereqTech, Time, Production, Cost, Remove, ObsoleteTech)
SELECT DISTINCT 'BUILD_MAB', FeatureType, PrereqTech, Time, Production, Cost, Remove, ObsoleteTech FROM BuildFeatures
WHERE BuildType = 'BUILD_FORT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

INSERT INTO Improvement_Yields (ImprovementType, YieldType, Yield)
SELECT 'IMPROVEMENT_MAB', YieldType, Yield FROM Improvement_Yields
WHERE ImprovementType = 'IMPROVEMENT_FORT'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

INSERT INTO Improvement_TechYieldChanges (ImprovementType, TechType, YieldType, Yield)
SELECT 'IMPROVEMENT_MAB', 'TECH_CHIVALRY', 'YIELD_PRODUCTION', 1
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1) UNION ALL
SELECT 'IMPROVEMENT_MAB', 'TECH_ARCHITECTURE', 'YIELD_CULTURE', 1
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1) UNION ALL
SELECT 'IMPROVEMENT_MAB', 'TECH_MILITARY_SCIENCE', y.Type, 1 FROM Yields y
WHERE y.Type IN ('YIELD_SCIENCE', 'YIELD_CULTURE_LOCAL')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1) UNION ALL
SELECT 'IMPROVEMENT_MAB', 'TECH_BALLISTICS', y.Type, 1 FROM Yields y
WHERE y.Type IN ('YIELD_PRODUCTION', 'YIELD_CULTURE_LOCAL')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1) UNION ALL
SELECT 'IMPROVEMENT_MAB', 'TECH_ELECTRONICS', y.Type, 2 FROM Yields y
WHERE y.Type IN ('YIELD_PRODUCTION', 'YIELD_CULTURE_LOCAL')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1) UNION ALL
SELECT 'IMPROVEMENT_MAB', 'TECH_STEALTH', y.Type, 2 FROM Yields y
WHERE y.Type IN ('YIELD_SCIENCE', 'YIELD_CULTURE_LOCAL')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

INSERT INTO Improvement_RouteYieldChanges (ImprovementType, RouteType, YieldType, Yield)
SELECT 'IMPROVEMENT_MAB', 'ROUTE_ROAD', 'YIELD_GOLD', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1) UNION ALL
SELECT 'IMPROVEMENT_MAB', 'ROUTE_RAILROAD', 'YIELD_GOLD', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

INSERT INTO Policy_ImprovementYieldChanges (PolicyType, ImprovementType, YieldType, Yield)
SELECT DISTINCT PolicyType, 'IMPROVEMENT_MAB', YieldType, Yield FROM Policy_ImprovementYieldChanges
WHERE PolicyType = 'POLICY_NAVAL_TRADITION' AND ImprovementType = 'IMPROVEMENT_FORT'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1) UNION ALL
SELECT DISTINCT PolicyType, 'IMPROVEMENT_MAB', YieldType, Yield FROM Policy_ImprovementYieldChanges
WHERE PolicyType = 'POLICY_MOBILIZATION' AND ImprovementType = 'IMPROVEMENT_FORT'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

INSERT INTO Building_ImprovementYieldChanges (BuildingType, ImprovementType, YieldType, Yield)
SELECT DISTINCT BuildingType, 'IMPROVEMENT_MAB', YieldType, Yield FROM Building_ImprovementYieldChanges
WHERE ImprovementType = 'IMPROVEMENT_FORT'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

INSERT INTO Building_ImprovementYieldChangesGlobal (BuildingType, ImprovementType, YieldType, Yield)
SELECT DISTINCT BuildingType, 'IMPROVEMENT_MAB', YieldType, Yield FROM Building_ImprovementYieldChangesGlobal
WHERE ImprovementType = 'IMPROVEMENT_FORT'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

UPDATE Language_en_US
SET Text = 'The {TXT_KEY_IMPROVEMENT_MAB} provides +20% [ICON_STRENGTH] Defensive Strength for any Unit stationed in this Tile. Any enemy Unit which ends its turn next to the {TXT_KEY_IMPROVEMENT_MAB} takes 10 damage.'
WHERE Tag = 'TXT_KEY_CIV5_IMPROVEMENTS_MAB_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

UPDATE Language_en_US
SET Text = '+20% [ICON_STRENGTH] Defensive Strength for any Unit stationed in this Tile. Any enemy Unit which ends its turn next to the {TXT_KEY_IMPROVEMENT_MAB} takes 10 damage. {TXT_KEY_IMPROVEMENT_MAB} gain +1 [ICON_GOLD] Gold if built on top of Road or Railroad.'
WHERE Tag = 'TXT_KEY_BUILD_MAB_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

UPDATE Language_en_US
SET Text = 'It will improve the [ICON_STRENGTH] Defense of any Unit stationed in this tile and cause damage to enemy Units that end their turn adjacent.'
WHERE Tag = 'TXT_KEY_BUILD_MMAB_REC' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);

UPDATE Language_en_US
SET Text = 'A motte-and-bailey fort is a fortification with a wooden or stone keep situated on a raised earthwork called a motte, accompanied by an enclosed courtyard, or bailey, surrounded by a protective ditch and palisade. Relatively easy to build with unskilled, often forced labour, but still militarily formidable, these forts were built across northern Europe from the 10th century onwards, spreading from Normandy and Anjou in France, into the Holy Roman Empire in the 11th century. The Normans introduced the design into England and Wales following their invasion in 1066. Motte-and-bailey forts were adopted in Scotland, Ireland, the Low Countries and Denmark in the 12th and 13th centuries. Motte-and-bailey earthworks were put to various uses over later years; in some cases, reused as military defences during the Second World War.'
WHERE Tag = 'TXT_KEY_CIV5_IMPROVEMENTS_MAB_TEXT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOTTE' AND Value= 1);
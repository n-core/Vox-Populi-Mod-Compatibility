-- Textile Mill
UPDATE Buildings SET
DistressFlatReduction = 1,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_FACTORY') - 3,
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_FACTORY')
WHERE Type = 'BUILDING_TEXTILE_MILL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldFromYieldPercent (BuildingType, YieldIn, YieldOut, Value)
SELECT 'BUILDING_TEXTILE_MILL', 'YIELD_PRODUCTION', 'YIELD_GOLD', 5
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = '5% of the City''s [ICON_PRODUCTION] Production converted into [ICON_GOLD] Gold every turn.[NEWLINE]
[NEWLINE]-1 [ICON_HAPPINESS_3] Unhappiness from [ICON_FOOD] and [ICON_PRODUCTION] Distress.[NEWLINE]
[NEWLINE]Nearby [ICON_RES_SHEEP] Sheep: +1 [ICON_PRODUCTION] Production.[NEWLINE]Nearby [ICON_RES_SILK] Silk: +1 [ICON_PRODUCTION] Production.[NEWLINE]Nearby [ICON_RES_COTTON] Cotton: +1 [ICON_PRODUCTION] Production.[NEWLINE]Nearby [ICON_RES_DYE] Dye: +2 [ICON_GOLD] Gold.'
WHERE Tag = 'TXT_KEY_BUILDING_TEXTILE_MILL_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

-- Ranch
UPDATE Buildings SET
PrereqTech = 'TECH_ECONOMICS',
NeverCapture = (SELECT NeverCapture FROM Buildings WHERE Type = 'BUILDING_STABLE'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_WINDMILL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_WINDMILL'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_WINDMILL')
WHERE Type = 'BUILDING_RANCH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_LocalResourceOrs (BuildingType, ResourceType)
SELECT  'BUILDING_RANCH', Type FROM Resources
WHERE Type IN ('RESOURCE_COW', 'RESOURCE_HORSE', 'RESOURCE_SHEEP', 'RESOURCE_BISON')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_UnitCombatProductionModifiers
SELECT 'BUILDING_RANCH', Type, 10 FROM UnitCombatInfos
WHERE Type IN ('UNITCOMBAT_SETTLER', 'UNITCOMBAT_WORKER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldFromInternalTR (BuildingType, YieldType, Yield)
SELECT 'BUILDING_RANCH', Type, 1 FROM Yields
WHERE Type IN ('YIELD_FOOD', 'YIELD_PRODUCTION')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldFromBirth (BuildingType, YieldType, Yield)
SELECT 'BUILDING_RANCH', 'YIELD_PRODUCTION', 5
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_ResourceYieldChanges (BuildingType, ResourceType, YieldType, Yield)
SELECT 'BUILDING_RANCH', 'RESOURCE_BISON', Type, 1 FROM Yields
WHERE Type IN ('YIELD_GOLD', 'YIELD_FOOD')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Building_Flavors
SET Flavor = 20
WHERE BuildingType = 'BUILDING_RANCH' AND FlavorType IN ('FLAVOR_GOLD', 'FLAVOR_PRODUCTION')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_RANCH', 'FLAVOR_EXPANSION', 20
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1) UNION ALL
SELECT 'BUILDING_RANCH', 'FLAVOR_MOBILE', 5
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = '+10% [ICON_PRODUCTION] Production when building Worker and Settler units.[NEWLINE]
[NEWLINE]Gain 5 [ICON_PRODUCTION] Production whenever a [ICON_CITIZEN] Citizen is born in the City, scaling with Era.[NEWLINE]
[NEWLINE]Internal [ICON_PRODUCTION] Production [ICON_INTERNATIONAL_TRADE] Trade Routes from this City generate +1 [ICON_FOOD] Food and [ICON_PRODUCTION] Production.[NEWLINE]
[NEWLINE]Nearby [ICON_RES_HORSE] Horse: +1 [ICON_FOOD] Food, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_SHEEP] Sheep: +1 [ICON_FOOD] Food, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_COW] Cow: +1 [ICON_FOOD] Food, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_BISON] Bison: +1 [ICON_FOOD] Food, +1 [ICON_GOLD] Gold.'
WHERE Tag = 'TXT_KEY_BUILDING_RANCH_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

-- Update Homestead (America's UB) from More Unique Components for VP
-- Now replaces Ranch instead of Stable, but way earlier to unlock and does not require a Stable.
UPDATE Buildings SET
BuildingClass = 'BUILDINGCLASS_RANCH', PrereqTech = 'TECH_GUILDS',
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_WINDMILL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_WINDMILL')
WHERE Type = 'BUILDING_AMERICA_RANCH'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Civilization_BuildingClassOverrides SET
BuildingClassType = 'BUILDINGCLASS_RANCH'
WHERE BuildingType = 'BUILDING_AMERICA_RANCH'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Building_YieldFromInternalTR SET
Yield = 1
WHERE BuildingType = 'BUILDING_AMERICA_RANCH'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldFromInternalTR (BuildingType, YieldType, Yield)
SELECT 'BUILDING_AMERICA_RANCH', 'YIELD_FOOD', 1
WHERE EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

DELETE FROM Building_UnitCombatProductionModifiers
WHERE BuildingType = 'BUILDING_AMERICA_RANCH' AND UnitCombatType = 'UNITCOMBAT_MOUNTED'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE  Language_en_US SET
Text = REPLACE(Text, 'The Homestead boosts Bison in addition to all the resources normally boosted by a Stable, and all boosted resources gain additional food.', 'The {TXT_KEY_BUILDING_AMERICA_RANCH} gives additional Production boosts to all the resources normally boosted by a {TXT_KEY_BUILDING_RANCH}, and all boosted resources gain additional yields. Increases Military Units supplied by this City''s population by 10%. ')
WHERE Tag = 'TXT_KEY_BUILDING_AMERICA_RANCH_STRATEGY'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE  Language_en_US SET
Text = REPLACE(Text, '. In addition to the regular abilities', ' which unlocked at a full era earlier than {TXT_KEY_BUILDING_RANCH} and does not require a {TXT_KEY_BUILDING_STABLE} to be constructed. In addition to the regular abilities')
WHERE Tag = 'TXT_KEY_BUILDING_AMERICA_RANCH_STRATEGY'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE  Language_en_US SET
Text = REPLACE(Text, 'The Homestead boosts the production of workers and settler units', 'The {TXT_KEY_BUILDING_AMERICA_RANCH} also gives additional boosts to the production of workers and settler units')
WHERE Tag = 'TXT_KEY_BUILDING_AMERICA_RANCH_STRATEGY'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE  Language_en_US SET
Text = REPLACE(Text, 'Homestead', '{TXT_KEY_BUILDING_AMERICA_RANCH}')
WHERE Tag = 'TXT_KEY_BUILDING_AMERICA_RANCH_STRATEGY'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE  Language_en_US SET
Text = REPLACE(Text, 'Stable', '{TXT_KEY_BUILDING_RANCH}')
WHERE Tag = 'TXT_KEY_BUILDING_AMERICA_RANCH_STRATEGY'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE  Language_en_US SET
Text = REPLACE(Text, '+33% [ICON_PRODUCTION] Production when building Mounted Units and ', '')
WHERE Tag = 'TXT_KEY_BUILDING_AMERICA_RANCH_HELP'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE  Language_en_US SET
Text = REPLACE(Text, 'Trade Routes from this City generate +2 [ICON_PRODUCTION] Production', 'Trade Routes from this City generate +1 [ICON_FOOD] Food and [ICON_PRODUCTION] Production')
WHERE Tag = 'TXT_KEY_BUILDING_AMERICA_RANCH_HELP'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_AMERICA_RANCH')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

-- Chemist
UPDATE Buildings SET
IlliteracyFlatReduction = 1, Strategy = 'TXT_KEY_BUILDING_CHEMIST_STRATEGY',
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_FACTORY')
WHERE Type = 'BUILDING_CHEMIST'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldFromBirth (BuildingType, YieldType, Yield)
SELECT 'BUILDING_CHEMIST', 'YIELD_SCIENCE', 10
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

DELETE FROM Building_YieldModifiers
WHERE BuildingType = 'BUILDING_CHEMIST' AND YieldType = 'YIELD_SCIENCE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldChangesPerPop (BuildingType, YieldType, Yield)
SELECT 'BUILDING_CHEMIST', 'YIELD_SCIENCE', 20
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = '+2 [ICON_RESEARCH] Science. Gain 10 [ICON_RESEARCH] Science whenever a [ICON_CITIZEN] Citizen is born in the City, scaling with Era. +1 [ICON_RESEARCH] Science for every 5 [ICON_CITIZEN] Citizens in the City.[NEWLINE]
[NEWLINE]-1 [ICON_HAPPINESS_3] Unhappiness from [ICON_RESEARCH] Illiteracy.'
WHERE Tag = 'TXT_KEY_BUILDING_CHEMIST_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Language_en_US (Text, Tag)
SELECT 'The Chemist is a Industrial-era building which provides [ICON_RESEARCH] Science based on the size and growth of a City. The City must already posess a Public School before a Chemist can be constructed.',
'TXT_KEY_BUILDING_CHEMIST_STRATEGY'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_BuildingClassYieldChanges
SELECT DISTINCT BuildingType, 'BUILDINGCLASS_CHEMIST', YieldType, YieldChange FROM Building_BuildingClassYieldChanges
WHERE BuildingType = 'BUILDING_LABORATORY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE  Language_en_US SET
Text = REPLACE(Text, 'Hospitals', 'Chemists, Hospitals')
WHERE Tag = 'TXT_KEY_BUILDING_LABORATORY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

-- General Store
UPDATE Buildings SET
Happiness = 0, PovertyFlatReduction = 1, FreeStartEra = 'ERA_FUTURE',
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HOSPITAL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_HOSPITAL'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HOSPITAL')
WHERE Type = 'BUILDING_TCS_GROCER'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Building_ClassesNeededInCity
SET BuildingClassType = 'BUILDINGCLASS_GROCER'
WHERE BuildingType = 'BUILDING_TCS_GROCER'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

DELETE FROM Building_YieldModifiers
WHERE BuildingType = 'BUILDING_TCS_GROCER'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldChangesPerPop (BuildingType, YieldType, Yield)
SELECT 'BUILDING_TCS_GROCER', 'YIELD_FOOD', 10 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1) UNION ALL
SELECT 'BUILDING_TCS_GROCER', 'YIELD_GOLD', 20 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldFromYieldPercent (BuildingType, YieldIn, YieldOut, Value)
SELECT 'BUILDING_TCS_GROCER', 'YIELD_FOOD', 'YIELD_GOLD', 10
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_TCS_GROCER'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_TCS_GROCER', 'FLAVOR_GROWTH', 30 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1) UNION ALL
SELECT 'BUILDING_TCS_GROCER', 'FLAVOR_GOLD', 20 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'General Store'
WHERE Tag = 'TXT_KEY_BUILDING_TCS_GROCER'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = '+2 [ICON_FOOD] Food. +1 [ICON_FOOD] Food and +2 [ICON_GOLD] Gold for every 10 [ICON_CITIZEN] Citizens in the City. 10% of the City''s [ICON_FOOD] Food converted into [ICON_GOLD] Gold every turn.[NEWLINE]
[NEWLINE]-1 [ICON_HAPPINESS_3] Unhappiness from [ICON_GOLD] Poverty.'
WHERE Tag = 'TXT_KEY_BUILDING_TCS_GROCER_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

-- Industrial Mine, now without limit but requires a Mountain nearby
UPDATE BuildingClasses
SET MaxPlayerInstances = 0
WHERE Type = 'BUILDINGCLASS_INDUSTRIAL_MINE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Buildings SET
NationalPopRequired = 15,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_FACTORY')
WHERE Type = 'BUILDING_INDUSTRIAL_MINE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Building_ResourceQuantity
SET Quantity = 1
WHERE BuildingType = 'BUILDING_INDUSTRIAL_MINE' AND ResourceType = 'RESOURCE_COAL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_ResourceQuantity (BuildingType, ResourceType, Quantity)
SELECT 'BUILDING_INDUSTRIAL_MINE', 'RESOURCE_IRON', 1
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldPerXTerrainTimes100 (BuildingType, TerrainType, YieldType, Yield)
SELECT 'BUILDING_INDUSTRIAL_MINE', 'TERRAIN_MOUNTAIN', 'YIELD_PRODUCTION', 100
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = '+3 [ICON_RESEARCH] Science. City gains +1 [ICON_PRODUCTION] Production for every Mountain within the workable tiles.[NEWLINE]
[NEWLINE]Provides +1 [ICON_RES_COAL] Coal and [ICON_RES_IRON] Iron.[NEWLINE]
[NEWLINE]Can only be constructed in a City nearby to a Mountain.'
WHERE Tag = 'TXT_KEY_BUILDING_INDUSTRIAL_MINE_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Buildings SET
Defense = 500, ExtraCityHitPoints = 100, CitySupplyFlat = 1, HealRateChange = 5, CitySupplyModifier = 10, AllowsRangeStrike = 1,
PrereqTech = (SELECT PrereqTech FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_FORTRESS')
WHERE Type = 'BUILDING_COASTAL_BATTERY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Building_ClassesNeededInCity
SET BuildingClassType = 'BUILDINGCLASS_HARBOR'
WHERE BuildingType = 'BUILDING_COASTAL_BATTERY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'Increases [ICON_SILVER_FIST] Military Unit Supply Cap by 1, and Military Units Supplied by this City''s population increased by 10%. Garrisoned Units receive an additional 5 Health when healing in this City. Increases City Hit Points by 100.[NEWLINE][NEWLINE]Can only be constructed in a Coastal City.'
WHERE Tag = 'TXT_KEY_BUILDING_COASTAL_BATTERY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

-- Harbor (-100 HP, -1 Supply Cap)
UPDATE  Buildings SET
ExtraCityHitPoints = ExtraCityHitPoints - 100,
CitySupplyFlat = CitySupplyFlat - 1
WHERE BuildingClass = 'BUILDINGCLASS_HARBOR'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE  Language_en_US SET
Text = REPLACE(Text, 'Supply Cap by 2, and City Hit Points by 150', 'Supply Cap by 1, and City Hit Points by 50')
WHERE Tag = 'TXT_KEY_BUILDING_HARBOR_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

-- Add Coastal Battery to Military-Industrial Complex (Autocracy) tenet
INSERT  INTO Policy_BuildingClassYieldChanges
(PolicyType, BuildingClassType, YieldType, YieldChange)
SELECT DISTINCT bcyc.PolicyType, bc.Type, bcyc.YieldType, bcyc.YieldChange
FROM BuildingClasses bc, Policy_BuildingClassYieldChanges bcyc
WHERE bc.Type = 'BUILDINGCLASS_COASTAL_BATTERY'
AND bcyc.PolicyType = 'POLICY_MOBILIZATION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_INDUSTRIAL' AND Value= 1);

-- Add Coastal Battery to Defender of Faith belief
-- +1 Faith and +2 Culture for all of these buildings.
INSERT  INTO Belief_BuildingClassYieldChanges
(BeliefType, BuildingClassType, YieldType, YieldChange)
SELECT DISTINCT bcyc.BeliefType, bc.Type, bcyc.YieldType, bcyc.YieldChange
FROM BuildingClasses bc, Belief_BuildingClassYieldChanges bcyc
WHERE bc.Type = 'BUILDINGCLASS_COASTAL_BATTERY'
AND bcyc.BeliefType = 'BELIEF_DEFENDER_FAITH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_INDUSTRIAL' AND Value= 1);

-- Add Coastal Battery to Oda Nobunaga's Ubique Ability (Japan)
-- +1 Faith and Culture for all of these buildings.
INSERT  INTO Trait_BuildingClassYieldChanges
(TraitType, BuildingClassType, YieldType, YieldChange)
SELECT DISTINCT bcyc.TraitType, bc.Type, bcyc.YieldType, bcyc.YieldChange
FROM BuildingClasses bc, Trait_BuildingClassYieldChanges bcyc
WHERE bc.Type = 'BUILDINGCLASS_COASTAL_BATTERY'
AND bcyc.TraitType = 'TRAIT_FIGHT_WELL_DAMAGED'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_INDUSTRIAL' AND Value= 1);
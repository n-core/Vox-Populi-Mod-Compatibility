UPDATE Buildings SET
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_FACTORY')
WHERE Type = 'BUILDING_TEXTILE_MILL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Buildings SET
Defense = 500, ExtraCityHitPoints = 50,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HOTEL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_HOTEL'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HOTEL')
WHERE Type = 'BUILDING_COASTAL_BATTERY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Buildings SET
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_FACTORY')
WHERE Type = 'BUILDING_CHEMIST' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Buildings SET
NationalPopRequired = 30,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_FACTORY')
WHERE Type = 'BUILDING_INDUSTRIAL_MINE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Buildings SET
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HOTEL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_HOTEL'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HOTEL')
WHERE Type = 'BUILDING_RANCH' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Buildings SET
Happiness = 0,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HOSPITAL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_HOSPITAL'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HOSPITAL')
WHERE Type = 'BUILDING_TCS_GROCER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Building_YieldModifiers
SET Yield = '0'
WHERE BuildingType = 'BUILDING_TCS_GROCER' AND YieldType = 'YIELD_FOOD' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Building_YieldModifiers
SET Yield = '0'
WHERE BuildingType = 'BUILDING_CHEMIST' AND YieldType = 'YIELD_SCIENCE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Building_ResourceQuantity
SET Quantity = 2
WHERE BuildingType = 'BUILDING_INDUSTRIAL_MINE' AND ResourceType = 'RESOURCE_COAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'General Store'
WHERE Tag = 'TXT_KEY_BUILDING_TCS_GROCER' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'City must have an improved source of [ICON_RES_SHEEP] Sheep, [ICON_RES_SHEEP] Silk, or [ICON_RES_COTTON] Cotton.[NEWLINE][NEWLINE]Nearby [ICON_RES_SHEEP] Sheep: +1 [ICON_PRODUCTION] Production.[NEWLINE]Nearby [ICON_RES_SILK] Silk: +1 [ICON_PRODUCTION] Production.[NEWLINE]Nearby [ICON_RES_COTTON] Cotton: +1 [ICON_PRODUCTION] Production.[NEWLINE]Nearby [ICON_RES_DYE] Dye: +2 [ICON_GOLD] Gold.'
WHERE Tag = 'TXT_KEY_BUILDING_TEXTILE_MILL_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = '+2 [ICON_FOOD] Food, +1 [ICON_FOOD] Food for every 10 [ICON_CITIZEN] Population, and +1 [ICON_FOOD] Food on Bananas and Citrus.[NEWLINE][NEWLINE]City must have a Market.'
WHERE Tag = 'TXT_KEY_BUILDING_TCS_GROCER_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = '+2 [ICON_RESEARCH] Science. +25% of the [ICON_RESEARCH] Research of the City is added to the current [ICON_RESEARCH] Research total every time the city gains a [ICON_CITIZEN] Citizen. [NEWLINE][NEWLINE]City must have a University.'
WHERE Tag = 'TXT_KEY_BUILDING_CHEMIST_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'City must have a Stable.[NEWLINE][NEWLINE]Nearby [ICON_RES_SHEEP] Sheep: +1 [ICON_FOOD] Food and [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_COW] Cow: +1 [ICON_FOOD] Food and [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_HORSE] Horse: +1 [ICON_FOOD] Food and +1 [ICON_GOLD] Gold.'
WHERE Tag = 'TXT_KEY_BUILDING_RANCH_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = '+3 [ICON_RESEARCH] Science, +2 [ICON_RES_COAL] Coal and +1 [ICON_RES_IRON] Iron. Maximum of 3 may be built. All mountains provides +3 [ICON_PRODUCTION] Production. [NEWLINE][NEWLINE]City must have a nearby Mountain.'
WHERE Tag = 'TXT_KEY_BUILDING_INDUSTRIAL_MINE_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'City must have a {TXT_KEY_BUILDING_FORTRESS}.'
WHERE Tag = 'TXT_KEY_BUILDING_COASTAL_BATTERY_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_ResourceQuantity (BuildingType, ResourceType, Quantity)
SELECT 'BUILDING_INDUSTRIAL_MINE', 'RESOURCE_IRON', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldChangesPerPop (BuildingType, YieldType, Yield)
SELECT 'BUILDING_TCS_GROCER', 'YIELD_FOOD', 15 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_GrowthExtraYield (BuildingType, YieldType, Yield)
SELECT 'BUILDING_CHEMIST', 'YIELD_SCIENCE', 25 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_TerrainYieldChanges (BuildingType, TerrainType, YieldType, Yield)
SELECT 'BUILDING_INDUSTRIAL_MINE', 'TERRAIN_MOUNTAIN', 'YIELD_PRODUCTION', 3
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

INSERT INTO Building_LocalResourceOrs (BuildingType, ResourceType)
SELECT  'BUILDING_RANCH', Type FROM Resources
WHERE Type IN('RESOURCE_COW', 'RESOURCE_HORSE', 'RESOURCE_SHEEP')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_INDUSTRIAL' AND Value= 1);

UPDATE Building_ClassesNeededInCity
SET BuildingClassType = 'BUILDINGCLASS_FORTRESS'
WHERE BuildingType = 'BUILDING_COASTAL_BATTERY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

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
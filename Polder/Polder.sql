UPDATE Improvements
SET SpecificCivRequired = 0, CivilizationType = NULL
WHERE Type LIKE '%POLDER%' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

DELETE FROM Trait_BuildsUnitClasses
WHERE BuildType LIKE '%POLDER%' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT OR REPLACE INTO Unit_Builds (UnitType, BuildType)
SELECT 'UNIT_WORKER', Type FROM Builds
WHERE Type LIKE '%POLDER%'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

UPDATE Buildings SET
BuildingProductionModifier = 20, Flat = 0,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_WINDMILL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_WINDMILL'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_WINDMILL')
WHERE Type = 'BUILDING_WIMMEN' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

UPDATE Building_YieldChanges
SET Yield = '3'
WHERE BuildingType = 'BUILDING_WIMMEN' AND YieldType = 'YIELD_PRODUCTION' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_WIMMEN' AND YieldType = 'YIELD_FOOD' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'Unique {TXT_KEY_CIV_NETHERLANDS_ADJECTIVE} replacement for the {TXT_KEY_BUILDING_WINDMILL}. The {TXT_KEY_BUILDING_WIMMEN} is a Renaissance-era building which increases the [ICON_PRODUCTION] Production output of a city when constructing buildings, and provides [ICON_GOLD] Gold and [ICON_CULTURE] Culture whenever a building is constructed in the City. It also gives [ICON_FOOD] Food and [ICON_CULTURE] Culture to Polders.'
WHERE Tag = 'TXT_KEY_BUILDING_WIMMEN_STRATEGY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

UPDATE Language_EN_US
SET Text = '+20% [ICON_PRODUCTION] Production when constructing Buildings. +5 [ICON_GOLD] Gold and [ICON_CULTURE] Culture when you construct a building in this City. Grocer and Granary in the City produce +1 [ICON_FOOD] Food, and all owned {TXT_KEY_BUILDING_WIMMEN}s gain +1 [ICON_CULTURE] Culture. Nearby Marshes and Lakes produce +2 [ICON_PRODUCTION] Production and [ICON_GOLD] Gold. +1 [ICON_FOOD] Food and [ICON_CULTURE] Culture to Polders.'
WHERE Tag = 'TXT_KEY_BUILDING_WIMMEN_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT  INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT  'BUILDING_WIMMEN', 'FLAVOR_CULTURE', 10 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1) UNION ALL
SELECT  'BUILDING_WIMMEN', 'FLAVOR_GOLD', 5 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_ImprovementYieldChanges (BuildingType, ImprovementType, YieldType, Yield)
SELECT 'BUILDING_WIMMEN', i.Type, y.Type, 1 FROM Improvements i, Yields y
WHERE i.Type IN ('IMPROVEMENT_POLDER', 'IMPROVEMENT_POLDER_WATER')
AND y.Type IN ('YIELD_FOOD', 'YIELD_CULTURE')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_YieldFromConstruction (BuildingType, YieldType, Yield)
SELECT 'BUILDING_WIMMEN', 'YIELD_CULTURE', 5 AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1)UNION ALL
SELECT 'BUILDING_WIMMEN', 'YIELD_GOLD', 5 AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_FeatureYieldChanges (BuildingType, FeatureType, YieldType, Yield)
SELECT 'BUILDING_WIMMEN', 'FEATURE_MARSH', 'YIELD_PRODUCTION', 2 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1) UNION ALL
SELECT 'BUILDING_WIMMEN', 'FEATURE_MARSH', 'YIELD_GOLD', 2 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_LakePlotYieldChanges (BuildingType, YieldType, Yield)
SELECT 'BUILDING_WIMMEN', 'YIELD_PRODUCTION', 2 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1) UNION ALL
SELECT 'BUILDING_WIMMEN', 'YIELD_GOLD', 2 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_BuildingClassYieldChanges (BuildingType, BuildingClassType, YieldType, YieldChange)
SELECT 'BUILDING_WIMMEN', 'BUILDINGCLASS_WINDMILL', 'YIELD_CULTURE', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_BuildingClassLocalYieldChanges (BuildingType, BuildingClassType, YieldType, YieldChange)
SELECT 'BUILDING_WIMMEN', 'BUILDINGCLASS_GROCER', 'YIELD_FOOD', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1) UNION ALL
SELECT 'BUILDING_WIMMEN', 'BUILDINGCLASS_GRANARY', 'YIELD_FOOD', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);
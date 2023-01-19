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
BuildingProductionModifier = (SELECT BuildingProductionModifier FROM Buildings WHERE Type = 'BUILDING_WINDMILL') + 10,
Flat = (SELECT Flat FROM Buildings WHERE Type = 'BUILDING_WINDMILL'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_WINDMILL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_WINDMILL'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_WINDMILL')
WHERE Type = 'BUILDING_WIMMEN' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_WIMMEN'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield)
SELECT 'BUILDING_WIMMEN', YieldType, Yield FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_WINDMILL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1 );

INSERT  INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT  'BUILDING_WIMMEN', 'FLAVOR_CULTURE', 10 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1) UNION ALL
SELECT  'BUILDING_WIMMEN', 'FLAVOR_GOLD', 5 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_ImprovementYieldChanges (BuildingType, ImprovementType, YieldType, Yield)
SELECT 'BUILDING_WIMMEN', i.Type, y.Type, 1 FROM Improvements i, Yields y
WHERE i.Type LIKE '%POLDER%'
AND y.Type IN ('YIELD_FOOD', 'YIELD_CULTURE')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_YieldFromConstruction (BuildingType, YieldType, Yield)
SELECT 'BUILDING_WIMMEN', 'YIELD_CULTURE', 10 AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1) UNION ALL
SELECT 'BUILDING_WIMMEN', 'YIELD_GOLD', 10 AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_FeatureYieldChanges (BuildingType, FeatureType, YieldType, Yield)
SELECT 'BUILDING_WIMMEN', FeatureType, YieldType, Yield FROM Building_FeatureYieldChanges
WHERE BuildingType = 'BUILDING_WINDMILL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_LakePlotYieldChanges (BuildingType, YieldType, Yield)
SELECT 'BUILDING_WIMMEN', YieldType, Yield FROM Building_LakePlotYieldChanges
WHERE BuildingType = 'BUILDING_WINDMILL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_BuildingClassYieldChanges (BuildingType, BuildingClassType, YieldType, YieldChange)
SELECT 'BUILDING_WIMMEN', 'BUILDINGCLASS_WINDMILL', 'YIELD_CULTURE', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

INSERT INTO Building_BuildingClassLocalYieldChanges (BuildingType, BuildingClassType, YieldType, YieldChange)
SELECT 'BUILDING_WIMMEN', BuildingClassType, YieldType, YieldChange FROM Building_BuildingClassLocalYieldChanges
WHERE BuildingType = 'BUILDING_WINDMILL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'Unique {TXT_KEY_CIV_NETHERLANDS_ADJECTIVE} replacement for the {TXT_KEY_BUILDING_WINDMILL}. The {TXT_KEY_BUILDING_WIMMEN} is a Renaissance-era building which increases the [ICON_PRODUCTION] Production output of a city when constructing buildings, and provides [ICON_GOLD] Gold and [ICON_CULTURE] Culture whenever a building is constructed in the City. It also gives [ICON_FOOD] Food and [ICON_CULTURE] Culture to Polders.'
WHERE Tag = 'TXT_KEY_BUILDING_WIMMEN_STRATEGY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

UPDATE Language_EN_US
SET Text = '+10 [ICON_GOLD] Gold and [ICON_CULTURE] Culture when you construct a Building in this City, scaling with Era. +1 [ICON_FOOD] Food and [ICON_CULTURE] Culture to Polders.[NEWLINE]
[NEWLINE]+25% [ICON_PRODUCTION] Production when constructing Buildings. {TXT_KEY_BUILDING_GROCER} and {TXT_KEY_BUILDING_GRANARY} in the City produce +1 [ICON_FOOD] Food, and all owned {TXT_KEY_BUILDING_WIMMEN}s gain +1 [ICON_CULTURE] Culture. Nearby Marshes and Lakes produce +2 [ICON_PRODUCTION] Production and [ICON_GOLD] Gold.'
WHERE Tag = 'TXT_KEY_BUILDING_WIMMEN_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_POLDER' AND Value= 1);

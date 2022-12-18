UPDATE Buildings SET
ReligiousUnrestFlatReduction = 1, BoredomFlatReduction = 1, ReligiousPressureModifier = 25, Happiness = 0, Help = 'TXT_KEY_BUILDING_MARA_HELP',
GreatWorkSlotType = (SELECT GreatWorkSlotType FROM Buildings WHERE Type = 'BUILDING_TEMPLE'),
GreatWorkCount = (SELECT GreatWorkCount FROM Buildings WHERE Type = 'BUILDING_TEMPLE'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_TEMPLE'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_TEMPLE'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_TEMPLE')
WHERE Type = 'BUILDING_MARA' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

UPDATE Building_Flavors
SET Flavor = 30
WHERE BuildingType = 'BUILDING_MARA' AND FlavorType = 'FLAVOR_CULTURE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield)
SELECT 'BUILDING_MARA', 'YIELD_CULTURE', 2
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

INSERT INTO Building_ResourceYieldChanges (BuildingType, ResourceType, YieldType, Yield)
SELECT 'BUILDING_MARA', ResourceType, YieldType, Yield FROM Building_ResourceYieldChanges
WHERE BuildingType = 'BUILDING_TEMPLE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1 );

INSERT INTO Building_ResourceYieldChanges (BuildingType, ResourceType, YieldType, Yield)
SELECT 'BUILDING_MARA', 'RESOURCE_FISH', 'YIELD_FAITH', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

INSERT INTO Building_ImprovementYieldChanges (BuildingType, ImprovementType, YieldType, Yield)
SELECT 'BUILDING_MARA', 'IMPROVEMENT_MOAI', 'YIELD_CULTURE', 1
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

DELETE FROM Building_SeaPlotYieldChanges
WHERE BuildingType = 'BUILDING_MARA'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

INSERT INTO Building_TerrainYieldChanges (BuildingType, TerrainType, YieldType, Yield)
SELECT 'BUILDING_MARA', 'TERRAIN_COAST', 'YIELD_CULTURE', 1
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

INSERT INTO Building_FeatureYieldChanges (BuildingType, FeatureType, YieldType, Yield)
SELECT 'BUILDING_MARA', 'FEATURE_ATOLL', 'YIELD_CULTURE', 1
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

INSERT INTO Building_YieldFromBirth (BuildingType, YieldType, Yield)
SELECT 'BUILDING_MARA', 'YIELD_CULTURE', 10
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

INSERT INTO Language_en_US (Text, Tag)
SELECT 'Gain 10 [ICON_CULTURE] Culture whenever a [ICON_CITIZEN] Citizen is born in the City, scaling with Era. +1 [ICON_CULTURE] Culture from Moais worked by the City.[NEWLINE]
[NEWLINE]Generates +25% Religious Pressure. Contains 1 slot for a [ICON_GREAT_WORK] Great Work of Music.[NEWLINE]
[NEWLINE]-1 [ICON_HAPPINESS_3] Unhappiness from [ICON_RELIGION] Religious Unrest and [ICON_CULTURE] Boredom.[NEWLINE]
[NEWLINE]Nearby Coast: +1 [ICON_CULTURE] Culture.[NEWLINE]Nearby Atolls: +1 [ICON_CULTURE] Culture.[NEWLINE]Nearby [ICON_RES_FISH] Fish: +1 [ICON_PEACE] Faith.[NEWLINE]Nearby [ICON_RES_INCENSE] Incense: +1 [ICON_CULTURE] Culture, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_WINE] Wine: +1 [ICON_CULTURE] Culture, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_AMBER] Amber: +1 [ICON_CULTURE] Culture, +1 [ICON_GOLD] Gold.',
'TXT_KEY_BUILDING_MARA_HELP'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'Unique {TXT_KEY_CIV_POLYNESIA_ADJECTIVE} replacement for the {TXT_KEY_BUILDING_TEMPLE}. {TXT_KEY_BUILDING_MARA_DESC} gives additional [ICON_CULTURE] Culture every time a Citizen is born in the City. Helps reduce [ICON_HAPPINESS_3] Religious Unrest and Boredom, and generates +25% Religious Pressure. It also provides [ICON_CULTURE] Culture bonus to every Coast tiles and Atolls worked by the city. The City must have a {TXT_KEY_BUILDING_SHRINE} before the {TXT_KEY_BUILDING_MARA_DESC} can be constructed.'
WHERE Tag = 'TXT_KEY_BUILDING_MARA_STRATEGY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'Malea'
WHERE Tag = 'TXT_KEY_BUILDING_POLYNESIA_MARAE'
AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_POLYNESIA_MARAE')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOAI' AND Value= 1);

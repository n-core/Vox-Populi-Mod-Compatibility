UPDATE Buildings SET
ReligiousUnrestFlatReduction = 1, ReligiousPressureModifier = 25, Help = 'TXT_KEY_BUILDING_STEMPLES_HELP',
GreatWorkSlotType = (SELECT GreatWorkSlotType FROM Buildings WHERE Type = 'BUILDING_TEMPLE'),
GreatWorkCount = (SELECT GreatWorkCount FROM Buildings WHERE Type = 'BUILDING_TEMPLE'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_TEMPLE'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_TEMPLE'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_TEMPLE')
WHERE Type = 'BUILDING_STEMPLES' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_TERRACE_FARM' AND Value= 1 );

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_STEMPLES' AND YieldType = 'YIELD_GOLD'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_TERRACE_FARM' AND Value= 1 );

UPDATE Building_YieldChanges
SET Yield = 3
WHERE BuildingType = 'BUILDING_STEMPLES'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_TERRACE_FARM' AND Value= 1 );

INSERT INTO Building_ResourceYieldChanges (BuildingType, ResourceType, YieldType, Yield)
SELECT 'BUILDING_STEMPLES', ResourceType, YieldType, Yield FROM Building_ResourceYieldChanges
WHERE BuildingType = 'BUILDING_TEMPLE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_TERRACE_FARM' AND Value= 1 );

INSERT INTO Building_ImprovementYieldChanges
SELECT 'BUILDING_STEMPLES', 'IMPROVEMENT_TERRACE_FARM', 'YIELD_FAITH', 1
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_TERRACE_FARM' AND Value= 1 );

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_STEMPLES', 'FLAVOR_CULTURE', 25
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_TERRACE_FARM' AND Value= 1 );

INSERT INTO Building_PlotYieldChanges
SELECT 'BUILDING_STEMPLES', 'PLOT_MOUNTAIN', 'YIELD_FAITH', 1
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_TERRACE_FARM' AND Value = 1);

INSERT INTO Building_YieldFromYieldPercent (BuildingType, YieldIn, YieldOut, Value)
SELECT 'BUILDING_STEMPLES', 'YIELD_FAITH', 'YIELD_CULTURE', 15
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_TERRACE_FARM' AND Value= 1);

INSERT INTO Building_YieldPerXTerrainTimes100 (BuildingType, TerrainType, YieldType, Yield)
SELECT 'BUILDING_STEMPLES', 'TERRAIN_MOUNTAIN', 'YIELD_FAITH', 34
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_TERRACE_FARM' AND Value= 1 );

INSERT INTO Language_en_US (Tag, Text)
SELECT 'TXT_KEY_BUILDING_STEMPLES_HELP',
'15% of the City''s [ICON_PEACE] Faith converted into [ICON_CULTURE] Culture every turn. +1 [ICON_PEACE] Faith from Terrace Farms. +1 [ICON_PEACE] Faith for every 3 Mountains within the workable plot.[NEWLINE]
[NEWLINE]Generates +25% Religious Pressure. Contains 1 slot for a [ICON_GREAT_WORK] Great Work of Music.[NEWLINE]
[NEWLINE]-1 [ICON_HAPPINESS_3] Unhappiness from [ICON_RELIGION] Religious Unrest.[NEWLINE]
[NEWLINE]Nearby Mountains: +1 [ICON_PEACE] Faith.[NEWLINE]Nearby [ICON_RES_INCENSE] Incense: +1 [ICON_CULTURE] Culture, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_WINE] Wine: +1 [ICON_CULTURE] Culture, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_AMBER] Amber: +1 [ICON_CULTURE] Culture, +1 [ICON_GOLD] Gold.'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_TERRACE_FARM' AND Value= 1 );

UPDATE Language_en_US
SET Text = 'Unique {TXT_KEY_CIV_INCA_ADJECTIVE} replacement for the {TXT_KEY_BUILDING_TEMPLE}. {TXT_KEY_BUILDING_STEMPLES_DESC} converts small portion of [ICON_PEACE] Faith into [ICON_CULTURE] Culture, and increases [ICON_PEACE] Faith and [ICON_CULTURE] Culture of a city. Additional [ICON_PEACE] Faith from nearby Terrace Farms and Mountains.'
WHERE Tag = 'TXT_KEY_BUILDING_STEMPLES_STRATEGY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_TERRACE_FARM' AND Value= 1 );
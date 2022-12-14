UPDATE Improvements SET
NoTwoAdjacent = 0, Help = 'TXT_KEY_CIV5_IMPROVEMENTS_KASBAH_HELP'
WHERE Type = 'IMPROVEMENT_KASBAH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

UPDATE Buildings SET
BuildingClass = 'BUILDINGCLASS_FORTRESS', Help = 'TXT_KEY_BUILDING_RIAD_HELP',
Happiness = 0, GreatPeopleRateModifier = 0, TradeRouteRecipientBonus = 1, TradeRouteTargetBonus = 1,
Defense = (SELECT Defense FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
ExtraCityHitPoints = (SELECT ExtraCityHitPoints FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
HealRateChange = (SELECT HealRateChange FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
CityIndirectFire = (SELECT CityIndirectFire FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
CitySupplyModifier = (SELECT CitySupplyModifier FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
EmpireSizeModifierReduction = (SELECT EmpireSizeModifierReduction FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
PrereqTech = (SELECT PrereqTech FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_FORTRESS'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_FORTRESS')
WHERE Type = 'BUILDING_RIAD' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

UPDATE Civilization_BuildingClassOverrides SET
BuildingClassType = 'BUILDINGCLASS_FORTRESS'
WHERE BuildingType = 'BUILDING_RIAD'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_RIAD'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_RIAD', 'FLAVOR_CITY_DEFENSE', 40 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1) UNION ALL
SELECT 'BUILDING_RIAD', 'FLAVOR_RELIGION', 30 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1) UNION ALL
SELECT 'BUILDING_RIAD', 'FLAVOR_CULTURE', 20 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1) UNION ALL
SELECT 'BUILDING_RIAD', 'FLAVOR_GOLD', 10 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

DELETE FROM Building_ResourceYieldChanges
WHERE BuildingType = 'BUILDING_RIAD'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield)
SELECT 'BUILDING_RIAD', 'YIELD_FAITH', 3
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

INSERT INTO Building_ImprovementYieldChanges
SELECT 'BUILDING_RIAD', 'IMPROVEMENT_KASBAH', Type, 1 FROM Yields
WHERE Type IN ('YIELD_FAITH', 'YIELD_CULTURE')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1 );

INSERT INTO Building_YieldPerXTerrainTimes100 (BuildingType, TerrainType, YieldType, Yield)
SELECT 'BUILDING_RIAD', 'TERRAIN_DESERT', 'YIELD_FAITH', 50
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1 );

INSERT INTO Building_YieldFromYieldPercent (BuildingType, YieldIn, YieldOut, Value)
SELECT 'BUILDING_RIAD', 'YIELD_FAITH', Type, 5 FROM Yields
WHERE Type IN ('YIELD_GOLD', 'YIELD_CULTURE')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

INSERT INTO Language_en_US (Text, Tag)
SELECT '+3 [ICON_PEACE] Faith. 5% of the City''s [ICON_PEACE] Faith converted into [ICON_GOLD] Gold and [ICON_CULTURE] Culture every turn. +1 [ICON_PEACE] Faith every 2 Desert tiles worked by the City. +1 [ICON_PEACE] Faith and [ICON_CULTURE] Culture from Kasbahs.[NEWLINE]
[NEWLINE]Incoming [ICON_INTERNATIONAL_TRADE] Trade Routes generate +1 [ICON_GOLD] Gold for the City, and +1 [ICON_GOLD] Gold for [ICON_INTERNATIONAL_TRADE] Trade Route owner.[NEWLINE]
[NEWLINE][ICON_SILVER_FIST] Military Units Supplied by this City''s population increased by 10%. Allows the City''s [ICON_RANGE_STRENGTH] Ranged Strike to ignore Line of Sight.[NEWLINE][NEWLINE]Garrisoned Units receive an additional 5 Health when healing in this City.[NEWLINE]
[NEWLINE][ICON_CITY_STATE] Empire Size Modifier is reduced by 5% in this City.' , 'TXT_KEY_BUILDING_RIAD_HELP'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'Ribat'
WHERE Tag = 'TXT_KEY_BUILDING_RIAD_DESC' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'Unique {TXT_KEY_CIV_MOROCCO_ADJECTIVE} replacement for the {TXT_KEY_BUILDING_FORTRESS}. '||
'In addition to the regular abilities of a {TXT_KEY_BUILDING_FORTRESS}, The {TXT_KEY_BUILDING_RIAD_DESC} provides [ICON_PEACE] Faith and converts small percentage of it into [ICON_GOLD] Gold and [ICON_CULTURE] Culture every turn. '||
'It also greatly boosts the value of Trade Routes that target the City. Provides [ICON_PEACE] Faith and [ICON_CULTURE] Culture bonus to Kasbahs.'
WHERE Tag = 'TXT_KEY_BUILDING_RIAD_STRATEGY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

UPDATE Language_EN_US
SET Text = 'A ribat is an Arabic term for a small fortification built along a frontier during the first years of the Muslim conquest of the Maghreb to house military volunteers, called murabitun, and shortly after they also appeared along the Byzantine frontier, where they attracted converts from Greater Khorasan, an area that would become known as al-''Awasim in the ninth century CE.[NEWLINE]
[NEWLINE]These fortifications later served to protect commercial routes, as caravanserais, and as centers for isolated Muslim communities as well as serving as places of piety. '
WHERE Tag = 'TXT_KEY_CIV5_BUILDINGS_RIAD_TEXT' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_KASBAH' AND Value= 1);

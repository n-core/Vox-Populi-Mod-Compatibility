INSERT  INTO Buildings
        (Type,                      BuildingClass,          Description,                        Help,
        Cost, FaithCost, GreatWorkCount, NeverCapture, ConquestProb, HurryCostModifier,
        IconAtlas, PortraitIndex, IsDummy, ShowInPedia, FreeBuildingThisCity, MutuallyExclusiveGroup, UnlockedByBelief)
SELECT  'BUILDING_D_FOR_JCHURCH',   'BUILDINGCLASS_CHURCH', 'TXT_KEY_BUILDING_D_FOR_CHURCH',    'TXT_KEY_BUILDING_D_FOR_CHURCH_HELP',
        -1, 200, -1, 1, 0, -20,
        'COMMUNITY_ATLAS', 3, 0, 0, 'BUILDINGCLASS_GARDEN', 361, 1
WHERE   EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Civilization_BuildingClassOverrides (CivilizationType, BuildingClassType, BuildingType)
SELECT 'CIVILIZATION_BRAZIL', 'BUILDINGCLASS_CHURCH', 'BUILDING_D_FOR_JCHURCH'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_D_FOR_JCHURCH', 'FLAVOR_GREAT_PEOPLE', 30 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 ) UNION ALL
SELECT 'BUILDING_D_FOR_JCHURCH', 'FLAVOR_RELIGION', 30 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 ) UNION ALL
SELECT 'BUILDING_D_FOR_JCHURCH', 'FLAVOR_CULTURE', 10 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

UPDATE Building_Flavors
SET Flavor = 30
WHERE BuildingType = 'BUILDING_JCHURCH' AND FlavorType = 'FLAVOR_RELIGION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_BuildingClassLocalYieldChanges
SELECT DISTINCT 'BUILDING_D_FOR_JCHURCH', 'BUILDINGCLASS_GARDEN', Type, 2 FROM Yields
WHERE Type IN ('YIELD_FAITH', 'YIELD_CULTURE')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Language_en_US (Text, Tag)
SELECT 'Jesuit Church [COLOR:220:230:255:255]([ICON_PEACE] Purchase)[ENDCOLOR]',
'TXT_KEY_BUILDING_D_FOR_CHURCH'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Language_en_US (Text, Tag)
SELECT '+2 [ICON_PEACE] Faith and [ICON_CULTURE] Culture to {TXT_KEY_BUILDING_JCHURCH_DESC} in the City.[NEWLINE][NEWLINE]Use this in order to purchase {TXT_KEY_BUILDING_JCHURCH_DESC} using [ICON_PEACE] Faith',
'TXT_KEY_BUILDING_D_FOR_CHURCH_HELP'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

UPDATE Buildings SET
Help = 'TXT_KEY_BUILDING_JCHURCH_HELP',
-- Inherit Church ability
WLTKDTurns = (SELECT WLTKDTurns FROM Buildings WHERE Type = 'BUILDING_CHURCH'),
GreatWorkCount = (SELECT GreatWorkCount FROM Buildings WHERE Type = 'BUILDING_CHURCH'),
GreatWorkSlotType = (SELECT GreatWorkSlotType FROM Buildings WHERE Type = 'BUILDING_CHURCH'),
ConversionModifier = (SELECT ConversionModifier FROM Buildings WHERE Type = 'BUILDING_CHURCH'),
BoredomFlatReduction = (SELECT BoredomFlatReduction FROM Buildings WHERE Type = 'BUILDING_CHURCH'),
ReligiousPressureModifier = (SELECT ReligiousPressureModifier FROM Buildings WHERE Type = 'BUILDING_CHURCH'),
IconAtlas = (SELECT IconAtlas FROM Buildings WHERE Type = 'BUILDING_CHURCH'),
PortraitIndex = (SELECT PortraitIndex FROM Buildings WHERE Type = 'BUILDING_CHURCH'),
-- Inherit Garden ability
FreshWater = (SELECT FreshWater FROM Buildings WHERE Type = 'BUILDING_GARDEN'),
GreatPeopleRateModifier = (SELECT GreatPeopleRateModifier FROM Buildings WHERE Type = 'BUILDING_GARDEN'),
NoUnhappfromXSpecialists = (SELECT NoUnhappfromXSpecialists FROM Buildings WHERE Type = 'BUILDING_GARDEN'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_GARDEN'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_GARDEN'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_GARDEN')
WHERE Type = 'BUILDING_JCHURCH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_JCHURCH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield)
SELECT 'BUILDING_JCHURCH', YieldType, Yield FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_CHURCH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_GreatWorkYieldChangesLocal (BuildingType, YieldType, Yield)
SELECT 'BUILDING_JCHURCH', YieldType, Yield FROM Building_GreatWorkYieldChangesLocal
WHERE BuildingType = 'BUILDING_CHURCH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_ResourceYieldChanges (BuildingType, ResourceType, YieldType, Yield)
SELECT 'BUILDING_JCHURCH', ResourceType, YieldType, Yield FROM Building_ResourceYieldChanges
WHERE BuildingType = 'BUILDING_GARDEN' AND ResourceType <> 'RESOURCE_POPPY' -- Don't include Poppy added from Even More Resources to prevent duplicated yield
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_ResourceYieldChanges (BuildingType, ResourceType, YieldType, Yield)
SELECT 'BUILDING_JCHURCH', 'RESOURCE_BRAZILWOOD', 'YIELD_CULTURE', 2
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

DELETE FROM Building_FeatureYieldChanges
WHERE BuildingType = 'BUILDING_JCHURCH' AND FeatureType = 'FEATURE_JUNGLE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_YieldPerXFeatureTimes100 (BuildingType, FeatureType, YieldType, Yield)
SELECT 'BUILDING_JCHURCH', Type, 'YIELD_CULTURE', 34 FROM Features
WHERE Type IN ('FEATURE_JUNGLE', 'FEATURE_FOREST')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_FeatureYieldChanges (BuildingType, FeatureType, YieldType, Yield)
SELECT 'BUILDING_JCHURCH', FeatureType, YieldType, Yield FROM Building_FeatureYieldChanges
WHERE BuildingType = 'BUILDING_GARDEN'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

DELETE FROM Language_en_US
WHERE Tag = 'TXT_BUILDING_JCHURCH_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Language_en_US (Text, Tag)
SELECT '+1 [ICON_CULTURE] Culture for every 3 Jungle or 3 Forest tiles worked by the City.[NEWLINE]
[NEWLINE]15 turns of "Carnival" in the City when constructed. All [ICON_GREAT_WORK] Great Works in the City generate +1 [ICON_PEACE] Faith. Contains 1 slot for a [ICON_GREAT_WORK] Great Work of Music. Boosts Pressure of [ICON_RELIGION] Religious Majority emanating from this City by 40%.[NEWLINE]
[NEWLINE]+25% [ICON_GREAT_PEOPLE] Great People generation in this City.[NEWLINE]
[NEWLINE]-1 [ICON_HAPPINESS_3] Unhappiness from [ICON_CULTURE] Boredom.
[NEWLINE]1 Specialist in this City no longer produces [ICON_HAPPINESS_3] Unhappiness from [ICON_URBANIZATION] Urbanization.[NEWLINE]
[NEWLINE]Nearby Oases: +2 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_BRAZILWOOD] Brazilwood: +2 [ICON_CULTURE] Culture.[NEWLINE]Nearby [ICON_RES_CITRUS] Citrus: +1 [ICON_FOOD] Food, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_COCOA] Cocoa: +1 [ICON_FOOD] Food, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_CLOVES] Cloves: +1 [ICON_PEACE] Faith, +1 [ICON_CULTURE] Culture.[NEWLINE]Nearby [ICON_RES_PEPPER] Pepper: +1 [ICON_PEACE] Faith, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_NUTMEG] Nutmeg: +1 [ICON_CULTURE] Culture, +1 [ICON_PRODUCTION] Production.',
'TXT_KEY_BUILDING_JCHURCH_HELP'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

UPDATE Language_en_US
SET Text = 'Unique {TXT_KEY_CIV_BRAZIL_ADJECTIVE} replacement for the {TXT_KEY_BUILDING_GARDEN} and {TXT_KEY_BUILDING_CHURCH}. '||
'In addition to the regular abilities of a {TXT_KEY_BUILDING_GARDEN} and a {TXT_KEY_BUILDING_CHURCH} combined, the {TXT_KEY_BUILDING_JCHURCH_DESC} provides a [ICON_CULTURE] Culture bonus on [ICON_RES_BRAZILWOOD] Brazilwood, also for Jungle and Forest tiles worked by the City. '||
'This building is free of [ICON_GOLD] Gold Maintenance, and gain additional [ICON_PEACE] Faith and [ICON_CULTURE] Culture bonus if you use [ICON_PEACE] Faith to purchase this building with [COLOR:220:230:255:255]{TXT_KEY_BELIEF_SWORD_PLOWSHARES_SHORT}[ENDCOLOR] belief. '||
'Unlike the {TXT_KEY_BUILDING_GARDEN}, the {TXT_KEY_BUILDING_JCHURCH_DESC} does not require an {TXT_KEY_BUILDING_AQUEDUCT} in the City in order to be built.'
WHERE Tag = 'TXT_KEY_BUILDING_JCHURCH_STRATEGY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

UPDATE Language_en_US SET
Text = REPLACE(Text, '[NEWLINE][NEWLINE]]The first Jesuits', '[NEWLINE][NEWLINE]The first Jesuits')
WHERE Tag = 'TXT_KEY_CIV5_BUILDINGS_JCHURCH_TEXT'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

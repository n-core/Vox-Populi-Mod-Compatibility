DELETE FROM Language_en_US
WHERE Tag = 'TXT_BUILDING_JCHURCH_HELP' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Language_en_US (Text, Tag)
SELECT '+1 [ICON_PEACE] Faith for every 6 [ICON_CITIZEN] Citizens in the City. +1 [ICON_CULTURE] Culture from Jungle. Increases the City''s resistance to conversion by 10%.[NEWLINE]
[NEWLINE]+25% [ICON_GREAT_PEOPLE] Great People generation in this City.[NEWLINE]
[NEWLINE]1 Specialist in this City no longer produces [ICON_HAPPINESS_3] Unhappiness from Urbanization.[NEWLINE]
[NEWLINE]Nearby Oases: +2 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_CITRUS] Citrus: +1 [ICON_FOOD] Food, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_COCOA] Cocoa: +1 [ICON_FOOD] Food, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_CLOVES] Cloves: +1 [ICON_PEACE] Faith, +1 [ICON_CULTURE] Culture.[NEWLINE]Nearby [ICON_RES_PEPPER] Pepper: +1 [ICON_PEACE] Faith, +1 [ICON_GOLD] Gold.[NEWLINE]Nearby [ICON_RES_NUTMEG] Nutmeg: +1 [ICON_CULTURE] Culture, +1 [ICON_PRODUCTION] Production.[NEWLINE]Nearby [ICON_RES_BRAZILWOOD] Brazilwood: +1 [ICON_CULTURE] Culture, +1 [ICON_GOLD] Gold.',
'TXT_KEY_BUILDING_JCHURCH_HELP'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

UPDATE Language_en_US
SET Text = 'The Jesuit Church increases the speed at which [ICON_GREAT_PEOPLE] Great People are generated in the City by 25%, buffs the food output of Oases, increases [ICON_PEACE] Faith in the City and also provide a [ICON_CULTURE] Culture bonus on Jungle tiles. Unlike the Garden, the Jesuit Church does not require an {TXT_KEY_BUILDING_AQUEDUCT} in the City in order to be built.'
WHERE Tag = 'TXT_KEY_BUILDING_JCHURCH_STRATEGY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

UPDATE Buildings SET
ConversionModifier = -10, NoUnhappfromXSpecialists = 1, Help = 'TXT_KEY_BUILDING_JCHURCH_HELP',
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_GARDEN'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_GARDEN'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_GARDEN')
WHERE Type = 'BUILDING_JCHURCH' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

UPDATE Building_YieldChanges
SET Yield = '0'
WHERE BuildingType = 'BUILDING_JCHURCH' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_ResourceYieldChanges (BuildingType, ResourceType, YieldType, Yield)
SELECT 'BUILDING_JCHURCH', ResourceType, YieldType, Yield FROM Building_ResourceYieldChanges
WHERE BuildingType = 'BUILDING_GARDEN' AND ResourceType <> 'RESOURCE_POPPY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_ResourceYieldChanges (BuildingType, ResourceType, YieldType, Yield)
SELECT 'BUILDING_JCHURCH', 'RESOURCE_BRAZILWOOD', 'YIELD_CULTURE', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 ) UNION ALL
SELECT 'BUILDING_JCHURCH', 'RESOURCE_BRAZILWOOD', 'YIELD_GOLD', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

INSERT INTO Building_FeatureYieldChanges (BuildingType, FeatureType, YieldType, Yield)
SELECT 'BUILDING_JCHURCH', FeatureType, YieldType, Yield FROM Building_ResourceYieldChanges
WHERE BuildingType = 'BUILDING_GARDEN'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_BRAZILWOOD_CAMP' AND Value= 1 );

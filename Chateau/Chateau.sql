INSERT INTO Buildings (
		Type, 				BuildingClass, Cost,		PrereqTech, FreeStartEra,
		Help, Description, Civilopedia, Strategy,
		ArtDefineTag, MinAreaSize, AllowsRangeStrike, Defense,			ExtraCityHitPoints, HurryCostModifier,
		IconAtlas, NeverCapture, PortraitIndex, ArtInfoCulturalVariation, DisplayPosition,
		GreatWorkSlotType, GreatWorkCount, CitySupplyModifier, DistressFlatReduction, EmpireSizeModifierReduction)
SELECT	'BUILDING_PALAIS',	BuildingClass, Cost - 50,	PrereqTech, FreeStartEra,
		'TXT_KEY_BUILDING_PALAIS_HELP', 'TXT_KEY_BUILDING_PALAIS', 'TXT_KEY_BUILDING_PALAIS_PEDIA', 'TXT_KEY_BUILDING_PALAIS_STRATEGY',
		ArtDefineTag, MinAreaSize, AllowsRangeStrike, Defense + 200,	ExtraCityHitPoints, HurryCostModifier,
		'EXPANSION_SCEN_BUILDING_ATLAS', 1, 1, 1, 1,
		GreatWorkSlotType, GreatWorkCount, CitySupplyModifier, DistressFlatReduction, EmpireSizeModifierReduction FROM Buildings
WHERE Type = 'BUILDING_CASTLE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1);

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_PALAIS', 'FLAVOR_CITY_DEFENSE', 50 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1) UNION ALL
SELECT 'BUILDING_PALAIS', 'FLAVOR_CULTURE', 20 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1) UNION ALL
SELECT 'BUILDING_PALAIS', 'FLAVOR_GROWTH', 10 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1);

INSERT INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT 'BUILDING_PALAIS', 'BUILDINGCLASS_WALLS'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1);

INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield)
SELECT 'BUILDING_PALAIS', 'YIELD_CULTURE', 3
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1);

INSERT INTO Building_ImprovementYieldChanges
SELECT 'BUILDING_PALAIS', ImprovementType, YieldType, Yield FROM Building_ImprovementYieldChanges
WHERE BuildingType = 'BUILDING_CASTLE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1 ) UNION ALL
SELECT 'BUILDING_PALAIS', 'IMPROVEMENT_CHATEAU', 'YIELD_CULTURE', 1
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1 );

INSERT INTO Civilization_BuildingClassOverrides (CivilizationType, BuildingClassType, BuildingType)
SELECT 'CIVILIZATION_FRANCE', 'BUILDINGCLASS_CASTLE', 'BUILDING_PALAIS'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1);

INSERT INTO Building_YieldChangesPerPop (BuildingType, YieldType, Yield)
SELECT 'BUILDING_PALAIS', 'YIELD_FOOD', 20 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1) UNION ALL
SELECT 'BUILDING_PALAIS', 'YIELD_GOLD', 20 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1);

UPDATE Improvements
SET SpecificCivRequired = NULL, CivilizationType = NULL
WHERE Type = 'IMPROVEMENT_CHATEAU' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_CHATEAU' AND Value= 1);

INSERT INTO LocalizedText (Language, Tag, Text)
VALUES
('en_US', 'TXT_KEY_BUILDING_PALAIS', 'Palais'),
('en_US', 'TXT_KEY_BUILDING_PALAIS_HELP', '+3 [ICON_CULTURE] Culture and has no [ICON_GOLD] Gold Maintenance. Grants +1 [ICON_FOOD] Food and [ICON_GOLD] Gold for every 5 [ICON_CITIZEN] Citizens in the City.[NEWLINE][NEWLINE]+1 [ICON_PRODUCTION] Production for Quarries worked by this City. +1 [ICON_CULTURE] Culture for Chateaus worked by this City. [ICON_SILVER_FIST] Military Units Supplied by this City''s population increased by 10%. Contains 1 slot for a [ICON_GREAT_WORK] Great Work of Art or Artifact.[NEWLINE][NEWLINE][ICON_CITY_STATE] Empire Size Modifier is reduced by 5% in this City.'),
('en_US', 'TXT_KEY_BUILDING_PALAIS_STRATEGY', 'Unique {TXT_KEY_CIV_FRANCE_ADJECTIVE} replacement for the {TXT_KEY_BUILDING_CASTLE}. It is cheaper than the {TXT_KEY_BUILDING_CASTLE} and has no [ICON_GOLD] Gold Maintenance while being a strong supporter for City''s infrastructure. Increases Military Units supplied by this City''s population by 10%, and increases Production for all nearby Quarries by 1. Also helps with managing the Empire Size Modifier in this City. The city must possess {TXT_KEY_BUILDING_WALLS} before a {TXT_KEY_BUILDING_PALAIS} can be constructed.'),
('en_US', 'TXT_KEY_BUILDING_PALAIS_PEDIA', 'A Palais resembles a Chateau in many features, but is mostly referred to in urban environments.');
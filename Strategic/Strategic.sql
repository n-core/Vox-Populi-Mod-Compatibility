DELETE FROM Building_ResourceQuantityRequirements
WHERE BuildingType = 'BUILDING_IRONWORKS' AND ResourceType = 'RESOURCE_IRON'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

DELETE FROM Building_ResourceYieldChanges
WHERE BuildingType = 'BUILDING_IRONWORKS' AND ResourceType = 'RESOURCE_IRON'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE Language_en_US SET
Text = 'Provides 2 [ICON_RES_IRON] Iron. +25 [ICON_RESEARCH] Science when you construct a Building in this City. Bonus scales with Era.[NEWLINE]
[NEWLINE]The [ICON_PRODUCTION] Production Cost and [ICON_CITIZEN] Population Requirements increase based on the number of Cities you own.'
WHERE Tag = 'TXT_KEY_BUILDING_IRONWORKS_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE Buildings SET
Cost = 125, NumCityCostMod = 10, NationalPopRequired = 40, PrereqTech = 'TECH_ARCHAEOLOGY'
WHERE Type = 'BUILDING_SCHOOL_OF_EQUESTRIAN_ART'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

INSERT INTO Building_BuildingClassYieldChanges
SELECT  DISTINCT Type, 'BUILDINGCLASS_EQUESTRIANART', 'YIELD_CULTURE', 1 FROM Buildings
        WHERE BuildingClass = 'BUILDINGCLASS_STABLE'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

CREATE TRIGGER VPMC_EQUESTRIANARTCompatibility
AFTER INSERT ON Civilization_BuildingClassOverrides
WHEN NEW.BuildingClassType = 'BUILDINGCLASS_STABLE'
AND NEW.BuildingType IS NOT NULL
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1)
BEGIN
        INSERT INTO Building_BuildingClassYieldChanges
        SELECT DISTINCT NEW.BuildingType, 'BUILDINGCLASS_EQUESTRIANART', 'YIELD_CULTURE', 1;
END;

UPDATE Language_en_US SET
Text = '+2 [ICON_CULTURE] Culture. +1 [ICON_HAPPINESS_1] Happiness and [ICON_CULTURE] Culture to all owned {TXT_KEY_BUILDING_STABLE}. +1 [ICON_CULTURE] Culture from all owned {TXT_KEY_BUILDING_STABLE}. +2 [ICON_TOURISM] Tourism when you researched [COLOR_CYAN]{TXT_KEY_TECH_ECOLOGY_TITLE}[ENDCOLOR].[NEWLINE]
[NEWLINE]Requires 1 [ICON_RES_HORSE] Horse.[NEWLINE]
[NEWLINE]The [ICON_PRODUCTION] Production Cost and [ICON_CITIZEN] Population Requirements increase based on the number of Cities you own.'
WHERE Tag = 'TXT_KEY_BUILDING_EQUESTRIANART_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE Buildings SET
Happiness = 1, BoredomFlatReduction = 1,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HOSPITAL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_HOSPITAL'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HOSPITAL')
WHERE Type = 'BUILDING_RACING_COURSE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_RACING_COURSE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE Language_en_US SET
Text = '+1 [ICON_HAPPINESS_1]Happiness, and -1 [ICON_HAPPINESS_3] Unhappiness from [ICON_CULTURE] Boredom.[NEWLINE]
[NEWLINE]Requires 2 [ICON_RES_HORSE] Horses.[NEWLINE]
[NEWLINE]Nearby [ICON_RES_HORSE] Horse: +1 [ICON_GOLD] Gold.'
WHERE Tag = 'TXT_KEY_BUILDING_RACING_COURSE_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE BuildingClasses
SET MaxPlayerInstances = 5
WHERE Type = 'BUILDINGCLASS_STEELMILL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE Buildings SET
ConquestProb = 0, NeverCapture = 1, NumCityCostMod = 2,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_FACTORY')
WHERE Type = 'BUILDING_STEELMILL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

INSERT INTO Building_ClassesNeededInCity
SELECT  'BUILDING_STEELMILL', 'BUILDINGCLASS_WORKSHOP'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

INSERT INTO Building_BuildingClassYieldChanges
SELECT  'BUILDING_STEELMILL', 'BUILDINGCLASS_STEELMILL', 'YIELD_PRODUCTION', 2
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

INSERT INTO Building_GlobalYieldModifiers
SELECT  'BUILDING_STEELMILL', 'YIELD_PRODUCTION', 2
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE Building_YieldChanges SET
Yield = 5
WHERE BuildingType = 'BUILDING_STEELMILL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

DELETE FROM Building_ResourceYieldChanges
WHERE BuildingType = 'BUILDING_STEELMILL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE Building_ResourceQuantityRequirements SET
Cost = 1
WHERE BuildingType = 'BUILDING_STEELMILL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE Language_en_US SET
Text = '+2% [ICON_PRODUCTION] Production for all Cities. +5 [ICON_PRODUCTION] Production, and +2 [ICON_PRODUCTION] Production from each owned {TXT_KEY_BUILDING_STEELMILL} in the Empire.[NEWLINE]
[NEWLINE]Requires 1 [ICON_RES_IRON] Iron.[NEWLINE]
[NEWLINE]The [ICON_PRODUCTION] Production Cost increase based on the number of cities you own.[NEWLINE]
[NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_STEELMILL') || ' of these buildings in your Empire.'
WHERE Tag = 'TXT_KEY_BUILDING_STEELMILL_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE Language_en_US SET
Text = 'The {TXT_KEY_BUILDING_STEELMILL} provides an Empire-wide [ICON_PRODUCTION] Production boost, and also an additional [ICON_PRODUCTION] Production bonus from each owned {TXT_KEY_BUILDING_STEELMILL} in the Empire. Each {TXT_KEY_BUILDING_STEELMILL} only give +1% [ICON_PRODUCTION] Production boost in all Cities, so this building is insignificant if only built one inside the Empire. With a maximum up to ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_STEELMILL') || ' of these buildings in your Empire, make sure you build these in your Cities to gain the stacking benefits.'
WHERE Tag = 'TXT_KEY_BUILDING_STEELMILL_STRATEGY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

INSERT INTO Policy_BuildingClassYieldModifiers
SELECT  DISTINCT pol.PolicyType, bc.Type, pol.YieldType, pol.YieldMod
        FROM BuildingClasses bc, Policy_BuildingClassYieldModifiers pol
        WHERE bc.Type = 'BUILDINGCLASS_STEELMILL'
        AND pol.BuildingClassType = 'BUILDINGCLASS_FORGE'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

UPDATE Language_en_US SET
Text = REPLACE(Text, 'Forges', 'Forges, Steel Mills')
WHERE Tag = 'TXT_KEY_POLICY_TRADE_UNIONS_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_STRATEGIC' AND Value= 1);

DELETE FROM Building_YieldModifiers
WHERE BuildingType IN ('BUILDING_APOTHECARY', 'BUILDING_BLACKSMITH', 'BUILDING_PRINTER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

-- Blacksmith
DELETE FROM Building_ResourceQuantityRequirements
WHERE BuildingType = 'BUILDING_BLACKSMITH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1 );

DELETE FROM Building_UnitCombatProductionModifiers
WHERE BuildingType = 'BUILDING_BLACKSMITH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1 );

UPDATE Buildings SET
LocalPopRequired = 6, MaxStartEra = 'ERA_INDUSTRIAL', Strategy = 'TXT_KEY_BUILDING_BLACKSMITH_STRATEGY',
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_AQUEDUCT'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_AQUEDUCT'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_AQUEDUCT')
WHERE Type = 'BUILDING_BLACKSMITH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_BLACKSMITH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1 );

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_BLACKSMITH', 'FLAVOR_MILITARY_TRAINING', 25
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_UnitCombatProductionModifiers
SELECT 'BUILDING_BLACKSMITH', Type, 15 FROM UnitCombatInfos
WHERE Type IN ('UNITCOMBAT_MELEE', 'UNITCOMBAT_MOUNTED')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_YieldFromUnitProduction
SELECT 'BUILDING_BLACKSMITH', 'YIELD_GOLD', 5
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_YieldChangesPerPop (BuildingType, YieldType, Yield)
SELECT 'BUILDING_BLACKSMITH', 'YIELD_PRODUCTION', 17
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT 'BUILDING_BLACKSMITH', 'BUILDINGCLASS_FORGE'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Language_en_US
SET Text = '+1 [ICON_PRODUCTION] Production for every 6 [ICON_CITIZEN] Citizens.[NEWLINE]
[NEWLINE]+15% [ICON_PRODUCTION] Production of Pre-Gunpowder Melee Units and Mounted Units.[NEWLINE]
[NEWLINE]When you construct a Unit in this City, gain [ICON_GOLD] Gold equal to 5% of the Unit''s [ICON_PRODUCTION] Production cost.[NEWLINE]
[NEWLINE]Can only be constructed in a City that has more 6 [ICON_CITIZEN] Citizens.'
WHERE Tag = 'TXT_KEY_BUILDING_BLACKSMITH_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT OR REPLACE INTO Language_en_US (Text, Tag)
SELECT 'The {TXT_KEY_BUILDING_BLACKSMITH} is a Classical-era building that increases the speed at which the City produces Pre-Gunpowder Melee Units and Mounted Units, and also generates [ICON_PRODUCTION] Production based on the size of a City. '||
'Whenever the City has trained a Unit, a small amount of the [ICON_PRODUCTION] Production cost of that Unit will given to the City as [ICON_GOLD] Gold. '||
'The City must have at least 6 [ICON_CITIZEN] Citizens, and already posess a {TXT_KEY_BUILDING_FORGE} before a {TXT_KEY_BUILDING_BLACKSMITH} can be constructed.',
'TXT_KEY_BUILDING_BLACKSMITH_STRATEGY'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

-- Dispensary (rename from Apothecary, to prevent name conflict with other mod)
-- Hospital now requires Dispensary
-- Medical line: Herbalist -> Dispensary -> Hospital -> Medical Lab
UPDATE Buildings SET
NoUnhappfromXSpecialists = 1, PrereqTech = 'TECH_CHEMISTRY', FreeStartEra = 'ERA_POSTMODERN', Strategy = 'TXT_KEY_BUILDING_APOTHECARY_STRATEGY',
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_GROCER'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_GROCER'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_GROCER')
WHERE Type = 'BUILDING_APOTHECARY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT 'BUILDING_APOTHECARY', 'BUILDINGCLASS_HERBALIST'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_GrowthExtraYield (BuildingType, YieldType, Yield)
SELECT 'BUILDING_APOTHECARY', 'YIELD_FOOD', 25
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_YieldFromYieldPercent (BuildingType, YieldIn, YieldOut, Value)
SELECT 'BUILDING_APOTHECARY', 'YIELD_FOOD', 'YIELD_SCIENCE', 5
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Language_en_US
SET Text = 'Dispensary'
WHERE Tag = 'TXT_KEY_BUILDING_APOTHECARY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Language_en_US
SET Text = '+1 [ICON_RESEARCH] Science for every 20 [ICON_FOOD] Food generated by the City. '||
'Gain 25% of the [ICON_FOOD] Food output of the City as an instant boost to the City''s [ICON_FOOD] Food total when a [ICON_CITIZEN] Citizen is born in this City.[NEWLINE]
[NEWLINE]1 Specialist in this City no longer produces [ICON_HAPPINESS_3] Unhappiness from [ICON_URBANIZATION] Urbanization.'
WHERE Tag = 'TXT_KEY_BUILDING_APOTHECARY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT OR REPLACE INTO Language_en_US (Text, Tag)
SELECT 'The {TXT_KEY_BUILDING_APOTHECARY} is a Renaissance-era building that generates [ICON_RESEARCH] Science based on a small amount of the City''s current [ICON_FOOD] Food output. '||
'Whenever a [ICON_CITIZEN] Citizen is born in the City, {TXT_KEY_BUILDING_APOTHECARY} gives an instant boost to the City''s [ICON_FOOD] Food total from a quarter amount of the City''s current [ICON_FOOD] Food output. '||
'The City must already posess a {TXT_KEY_BUILDING_HERBALIST} before a {TXT_KEY_BUILDING_APOTHECARY} can be constructed.',
'TXT_KEY_BUILDING_APOTHECARY_STRATEGY'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Language_en_US
SET Text = 'The word "dispensary" is in common use today to describe a place or room where drugs are stored, made up according to prescriptions, and dispensed. '||
'While it always had this meaning, it was also used to describe "a charitable institution where medicines are dispensed and medical advice given gratis or for a small charge." '||
'These institutions provided care on an outpatient basis, including home visiting, and, in their general economy, they resembled in many ways the health centers of today.'
WHERE Tag = 'TXT_KEY_BUILDING_APOTHECARY_PEDIA'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Building_ClassesNeededInCity
SET BuildingClassType = 'BUILDINGCLASS_APOTHECARY'
WHERE BuildingType = 'BUILDING_HOSPITAL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Language_en_US SET
Text = REPLACE(Text, '5% of the City''s [ICON_FOOD] Food is converted into [ICON_RESEARCH] Science every turn.', '+1 [ICON_RESEARCH] Science for every 20 [ICON_FOOD] Food generated by the City.')
WHERE Tag = 'TXT_KEY_BUILDING_HOSPITAL_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

-- Include Dispensary to Food of Thought reformation belief from Bare Necessities
UPDATE Buildings SET
UnlockedByBelief = (SELECT UnlockedByBelief FROM Buildings WHERE Type = 'BUILDING_GROCER'),
FaithCost = (SELECT FaithCost FROM Buildings WHERE Type = 'BUILDING_GROCER')
WHERE Type = 'BUILDING_APOTHECARY'
AND EXISTS (SELECT * FROM Beliefs WHERE Type='BELIEF_FOT')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Belief_BuildingClassYieldChanges (BeliefType, BuildingClassType, YieldType, YieldChange)
SELECT DISTINCT bcyc.BeliefType, bc.Type, bcyc.YieldType, bcyc.YieldChange
FROM BuildingClasses bc, Belief_BuildingClassYieldChanges bcyc
WHERE bc.Type = 'BUILDINGCLASS_APOTHECARY'
AND bcyc.BeliefType = 'BELIEF_FOT'
AND EXISTS (SELECT * FROM Beliefs WHERE Type='BELIEF_FOT')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Belief_BuildingClassFaithPurchase (BeliefType, BuildingClassType)
SELECT 'BELIEF_FOT', 'BUILDINGCLASS_APOTHECARY'
WHERE EXISTS (SELECT * FROM Beliefs WHERE Type='BELIEF_FOT')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Language_en_US SET
Text = REPLACE(Text, 'Hospitals', 'Dispensaries, Hospitals')
WHERE Tag = 'TXT_KEY_BELIEF_FOT'
AND EXISTS (SELECT * FROM Beliefs WHERE Type='BELIEF_FOT')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

-- Alchemist
UPDATE Buildings SET
LocalPopRequired = 8, ReligiousUnrestFlatReduction = 1, Strategy = 'TXT_KEY_BUILDING_ALCHEMIST_STRATEGY',
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_UNIVERSITY'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_UNIVERSITY'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_UNIVERSITY')
WHERE Type = 'BUILDING_ALCHEMIST'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_YieldFromYieldPercent (BuildingType, YieldIn, YieldOut, Value)
SELECT 'BUILDING_ALCHEMIST', 'YIELD_SCIENCE', 'YIELD_FAITH', 5
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT 'BUILDING_ALCHEMIST', 'BUILDINGCLASS_TEMPLE'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Building_ResourceYieldChanges
SET Yield = 1
WHERE BuildingType = 'BUILDING_ALCHEMIST' AND ResourceType = 'RESOURCE_GOLD'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_ResourceYieldChanges (BuildingType, ResourceType, YieldType, Yield)
SELECT 'BUILDING_ALCHEMIST', 'RESOURCE_AMBER',  'YIELD_SCIENCE', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1) UNION ALL
SELECT 'BUILDING_ALCHEMIST', 'RESOURCE_JADE',   'YIELD_SCIENCE', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1) UNION ALL
SELECT 'BUILDING_ALCHEMIST', 'RESOURCE_LAPIS',  'YIELD_SCIENCE', 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

DELETE FROM Building_LocalResourceOrs
WHERE BuildingType = 'BUILDING_ALCHEMIST'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_ALCHEMIST' AND FlavorType = 'FLAVOR_GROWTH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Building_Flavors SET
Flavor = 20
WHERE BuildingType = 'BUILDING_ALCHEMIST' AND FlavorType = 'FLAVOR_SCIENCE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_ALCHEMIST', 'FLAVOR_RELIGION', 25
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Language_en_US
SET Text = '+1 [ICON_PEACE] Faith for every 20 [ICON_RESEARCH] Science generated by the City.[NEWLINE]
[NEWLINE]-1 [ICON_HAPPINESS_3] Unhappiness from [ICON_RELIGION] Religious Unrest.[NEWLINE]
[NEWLINE]Can only be constructed in a City that has more 8 [ICON_CITIZEN] Citizens.[NEWLINE]
[NEWLINE]Nearby [ICON_RES_GEMS] Gems: +1 [ICON_RESEARCH] Science.[NEWLINE]Nearby [ICON_RES_GOLD] Gold: +1 [ICON_RESEARCH] Science.[NEWLINE]Nearby [ICON_RES_SILVER] Silver: +1 [ICON_RESEARCH] Science.[NEWLINE]Nearby [ICON_RES_AMBER] Amber: +1 [ICON_RESEARCH] Science.[NEWLINE]Nearby [ICON_RES_JADE] Jade: +1 [ICON_RESEARCH] Science.[NEWLINE]Nearby [ICON_RES_LAPIS] Lapis Lazuli: +1 [ICON_RESEARCH] Science.'
WHERE Tag = 'TXT_KEY_BUILDING_ALCHEMIST_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT OR REPLACE INTO Language_en_US (Text, Tag)
SELECT 'The {TXT_KEY_BUILDING_ALCHEMIST} is a Renaissance-era building that generates [ICON_PEACE] Faith from a small amount of the City''s [ICON_RESEARCH] Science output, and also reduces [ICON_HAPPINESS_3] Religious Unrest. ' ||
'The City must have at least 8 [ICON_CITIZEN] Citizens, and already posess a {TXT_KEY_BUILDING_TEMPLE} before a {TXT_KEY_BUILDING_ALCHEMIST} can be constructed.',
'TXT_KEY_BUILDING_ALCHEMIST_STRATEGY'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

-- Sewer System
UPDATE Buildings SET
Happiness = 0, FoodKept = 0, ExtraCityHitPoints = 0, PrereqTech = 'TECH_DYNAMITE',
LocalPopRequired = 12, NoUnhappfromXSpecialists = 1, FreeStartEra = 'ERA_FUTURE', Strategy = 'TXT_KEY_BUILDING_SEWER_SYSTEM_STRATEGY',
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_FACTORY'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_FACTORY')
WHERE Type = 'BUILDING_SEWER_SYSTEM'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_GrowthExtraYield (BuildingType, YieldType, Yield)
SELECT 'BUILDING_SEWER_SYSTEM', 'YIELD_PRODUCTION', 25
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_YieldFromBirth (BuildingType, YieldType, Yield)
SELECT 'BUILDING_SEWER_SYSTEM', 'YIELD_FOOD', 20
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_YieldChangesPerPop (BuildingType, YieldType, Yield)
SELECT 'BUILDING_SEWER_SYSTEM', 'YIELD_GOLDEN_AGE_POINTS', 9
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT 'BUILDING_SEWER_SYSTEM', 'BUILDINGCLASS_AQUEDUCT'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Building_Flavors
SET Flavor = 10, FlavorType ='FLAVOR_INFRASTRUCTURE'
WHERE BuildingType = 'BUILDING_SEWER_SYSTEM' AND FlavorType = 'FLAVOR_HAPPINESS'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_SEWER_SYSTEM' AND FlavorType = 'FLAVOR_CITY_DEFENSE'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Language_en_US
SET Text = '+1 [ICON_GOLDEN_AGE] Golden Age Point for every 12 [ICON_CITIZEN] Citizens. '||
'Gain 20 [ICON_FOOD] Food whenever a [ICON_CITIZEN] Citizen is born in the City, scaling with Era, and +25% of the [ICON_PRODUCTION] Production output of the City is added to City''s current [ICON_PRODUCTION] Production.[NEWLINE]
[NEWLINE]1 Specialist in this City no longer produces [ICON_HAPPINESS_3] Unhappiness from [ICON_URBANIZATION] Urbanization.[NEWLINE]
[NEWLINE]Can only be constructed in a City that has more 12 [ICON_CITIZEN] Citizens.'
WHERE Tag = 'TXT_KEY_BUILDING_SEWER_SYSTEM_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT OR REPLACE INTO Language_en_US (Text, Tag)
SELECT 'The {TXT_KEY_BUILDING_SEWER_SYSTEM} is an Industrial-era building that gives instant boost to the City''s [ICON_FOOD] Food and [ICON_PRODUCTION] Production whenever a [ICON_CITIZEN] Citizen is born in the City. '||
'It also helps your Empire reach the [ICON_GOLDEN_AGE] Golden Age by having a City with large [ICON_CITIZEN] Population. '||
'The City must have at least 12 [ICON_CITIZEN] Citizens, and possess an {TXT_KEY_BUILDING_AQUEDUCT} before a {TXT_KEY_BUILDING_SEWER_SYSTEM} can be constructed.',
'TXT_KEY_BUILDING_SEWER_SYSTEM_STRATEGY'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

-- Printer
UPDATE Buildings SET
SpecialistCount = 0, SpecialistType = NULL,
LocalPopRequired = 10, GreatPeopleRateModifier = 5, FreeStartEra = 'ERA_POSTMODERN', Strategy = 'TXT_KEY_BUILDING_PRINTER_STRATEGY',
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_GROCER'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_GROCER'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_GROCER')
WHERE Type = 'BUILDING_PRINTER'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Building_ClassesNeededInCity SET
BuildingClassType = 'BUILDINGCLASS_CHANCERY'
WHERE BuildingType = 'BUILDING_PRINTER'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_YieldChangesPerPop (BuildingType, YieldType, Yield)
SELECT 'BUILDING_PRINTER', 'YIELD_SCIENCE', 10 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1) UNION ALL
SELECT 'BUILDING_PRINTER', 'YIELD_TOURISM', 10 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1) UNION ALL
SELECT 'BUILDING_PRINTER', 'YIELD_CULTURE', 10 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_UnitCombatProductionModifiers
SELECT 'BUILDING_PRINTER', 'UNITCOMBAT_DIPLOMACY', 10
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_PRINTER' AND FlavorType = 'FLAVOR_GROWTH'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Building_Flavors SET
Flavor = 20
WHERE BuildingType = 'BUILDING_PRINTER'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_PRINTER', 'FLAVOR_DIPLOMACY', 20
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

UPDATE Language_en_US
SET Text = '+5% [ICON_GREAT_PEOPLE] Great People generation, and +10% [ICON_PRODUCTION] Production when training Diplomatic Units in this City. '||
'+1 [ICON_RESEARCH] Science, [ICON_CULTURE] Culture, and [ICON_TOURISM] Tourism for every 10 [ICON_CITIZEN] Citizens.[NEWLINE]'||
'[NEWLINE]Can only be constructed in a City that has more than 10 [ICON_CITIZEN] Citizens.'
WHERE Tag = 'TXT_KEY_BUILDING_PRINTER_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

INSERT OR REPLACE INTO Language_en_US (Text, Tag)
SELECT 'The {TXT_KEY_BUILDING_PRINTER} is a Renaissance-era building which increases the speed at which [ICON_GREAT_PEOPLE] Great People are generated in the City, and boosts [ICON_PRODUCTION] Production towards training Diplomatic Units. '||
'It also generates [ICON_RESEARCH] Science, [ICON_CULTURE] Culture, and [ICON_TOURISM] Tourism to the City which increases based on the City''s [ICON_CITIZEN] Population. '||
'The City must have at least 10 [ICON_CITIZEN] Citizens, and already possess a {TXT_KEY_BUILDING_CHANCERY} before a {TXT_KEY_BUILDING_PRINTER} can be constructed.',
'TXT_KEY_BUILDING_PRINTER_STRATEGY'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MEDIRENA' AND Value= 1);

-- Remove "--Wikipedia" from pedia texts
UPDATE Language_en_US SET
Text = REPLACE(Text, '[NEWLINE][NEWLINE]--Wikipedia', '')
WHERE Tag IN (  'TXT_KEY_BUILDING_BLACKSMITH_PEDIA',
                'TXT_KEY_BUILDING_ALCHEMIST_PEDIA',
                'TXT_KEY_BUILDING_SEWER_SYSTEM_PEDIA',
                'TXT_KEY_BUILDING_PRINTER_PEDIA')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_INDUSTRIAL' AND Value= 1);

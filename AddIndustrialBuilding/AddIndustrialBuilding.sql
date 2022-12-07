UPDATE Buildings SET
ConquestProb = 0, NeverCapture = 1,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HOSPITAL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_HOSPITAL'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HOSPITAL')
WHERE Type IN ('BUILDING_OIL_REFINERY', 'BUILDING_SYNTHFUEL_PLANT', 'BUILDING_WEAPONS_FACTORY', 'BUILDING_MUNITIONS_FACTORY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE BuildingClasses
SET MaxPlayerInstances = 3
WHERE Type IN ('BUILDINGCLASS_OIL_REFINERY', 'BUILDINGCLASS_SYNTHFUEL_PLANT', 'BUILDINGCLASS_WEAPONS_FACTORY', 'BUILDINGCLASS_MUNITIONS_FACTORY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

DELETE FROM Building_ResourceYieldChanges
WHERE BuildingType IN ('BUILDING_OIL_REFINERY', 'BUILDING_SYNTHFUEL_PLANT', 'BUILDING_WEAPONS_FACTORY', 'BUILDING_MUNITIONS_FACTORY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_BuildingClassYieldChanges
SELECT  b.Type, bc.Type, 'YIELD_PRODUCTION', 2 FROM Buildings b, BuildingClasses bc
        WHERE b.Type IN ('BUILDING_WEAPONS_FACTORY', 'BUILDING_MUNITIONS_FACTORY')
        AND bc.Type IN ('BUILDINGCLASS_WEAPONS_FACTORY', 'BUILDINGCLASS_MUNITIONS_FACTORY')
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1) UNION ALL
SELECT  'BUILDING_OIL_REFINERY', 'BUILDINGCLASS_OIL_REFINERY', 'YIELD_PRODUCTION', 4
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1) UNION ALL
SELECT  'BUILDING_SYNTHFUEL_PLANT', 'BUILDINGCLASS_SYNTHFUEL_PLANT', 'YIELD_PRODUCTION', 4
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

--=====================================================================================================--
-- Oil Refinery and Synthetic Fuel Manufactory now are mutually exclusive buildings
-- and both gives 1 slot of Engineer specialist.
UPDATE Buildings SET
SpecialistCount = '1', SpecialistType = 'SPECIALIST_ENGINEER',
MutuallyExclusiveGroup = 710, PrereqTech = 'TECH_BIOLOGY'
WHERE Type IN ('BUILDING_OIL_REFINERY', 'BUILDING_SYNTHFUEL_PLANT')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Building_YieldChanges
SET Yield = 3
WHERE BuildingType IN ('BUILDING_OIL_REFINERY', 'BUILDING_SYNTHFUEL_PLANT')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_ResourceQuantityRequirements
SELECT  'BUILDING_OIL_REFINERY', 'RESOURCE_OIL', 1
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US SET
Text = '+3 [ICON_PRODUCTION] Production, and +4 [ICON_PRODUCTION] Production from each owned {TXT_KEY_BUILDING_OIL_REFINERY} in the Empire. [NEWLINE]
[NEWLINE]Converts 1 [ICON_RES_OIL] Oil into 2 [ICON_RES_OIL] Oil.[NEWLINE]
[NEWLINE]The city must have an improved source of [ICON_RES_OIL] Oil, and cannot have a [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_SYNTHFUEL_PLANT}[ENDCOLOR] already built.[NEWLINE]
[NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_OIL_REFINERY') || ' of these buildings in your Empire.'
WHERE Tag = 'TXT_KEY_BUILDING_OIL_REFINERY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_LocalResourceOrs
SELECT  'BUILDING_SYNTHFUEL_PLANT', 'RESOURCE_COAL'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

DELETE FROM Building_ClassesNeededInCity
WHERE BuildingType = 'BUILDING_SYNTHFUEL_PLANT'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US SET
Text = '+3 [ICON_PRODUCTION] Production, and +4 [ICON_PRODUCTION] Production from each owned {TXT_KEY_BUILDING_SYNTHFUEL_PLANT} in the Empire. [NEWLINE]
[NEWLINE]Converts 1 [ICON_RES_COAL] Coal into 2 [ICON_RES_OIL] Oil.[NEWLINE]
[NEWLINE]The city must have an improved source of [ICON_RES_COAL] Coal, and cannot have an [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_OIL_REFINERY}[ENDCOLOR] already built.[NEWLINE]
[NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_SYNTHFUEL_PLANT') || ' of these buildings in your Empire.'
WHERE Tag = 'TXT_KEY_BUILDING_SYNTHFUEL_PLANT_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

--=====================================================================================================--
-- Weapons Factory and Munition Factory now both act as a building focused
-- solely on military unit creation with only limited amount of it in the Empire.
--=====================================================================================================--
-- Weapons Factory and Munition Factory now requires Factory instead of Workshop
-- (Both of them are *Factory*!)
UPDATE Building_ClassesNeededInCity
SET BuildingClassType = 'BUILDINGCLASS_FACTORY'
WHERE BuildingType IN ('BUILDING_WEAPONS_FACTORY', 'BUILDING_MUNITIONS_FACTORY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

-- Weapons Factory and Munition Factory now are mutually exclusive buildings
UPDATE Buildings SET
CitySupplyFlat = 1,
MutuallyExclusiveGroup = 711, PrereqTech = 'TECH_COMBUSTION'
WHERE Type IN ('BUILDING_WEAPONS_FACTORY', 'BUILDING_MUNITIONS_FACTORY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_LocalResourceOrs
SELECT  'BUILDING_WEAPONS_FACTORY', 'RESOURCE_IRON'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_LocalResourceOrs
SELECT  'BUILDING_MUNITIONS_FACTORY', 'RESOURCE_ALUMINUM'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_YieldFromUnitProduction
SELECT  Type, 'YIELD_PRODUCTION', 20 FROM Buildings
        WHERE Type IN ('BUILDING_WEAPONS_FACTORY', 'BUILDING_MUNITIONS_FACTORY')
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

DELETE FROM Building_DomainProductionModifiers
WHERE BuildingType = 'BUILDING_WEAPONS_FACTORY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

DELETE FROM Building_UnitCombatProductionModifiers
WHERE BuildingType = 'BUILDING_MUNITIONS_FACTORY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_UnitCombatProductionModifiers
SELECT  'BUILDING_WEAPONS_FACTORY', Type, 10 FROM UnitCombatInfos
        WHERE Type IN ( 'UNITCOMBAT_RECON',
                        'UNITCOMBAT_MOUNTED',
                        'UNITCOMBAT_MELEE',
                        'UNITCOMBAT_GUN',
                        'UNITCOMBAT_ARMOR',
                        'UNITCOMBAT_HELICOPTER',
                        'UNITCOMBAT_NAVALMELEE',
                        'UNITCOMBAT_CARRIER',
                        'UNITCOMBAT_FIGHTER')
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1) UNION ALL
SELECT  'BUILDING_MUNITIONS_FACTORY', Type, 10 FROM UnitCombatInfos
        WHERE Type IN ( 'UNITCOMBAT_ARCHER',
                        'UNITCOMBAT_SIEGE',
                        'UNITCOMBAT_NAVALRANGED',
                        'UNITCOMBAT_SUBMARINE',
                        'UNITCOMBAT_BOMBER')
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Building_YieldChanges
SET Yield = 3
WHERE BuildingType IN ('BUILDING_WEAPONS_FACTORY', 'BUILDING_MUNITIONS_FACTORY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US SET
Text = '+3 [ICON_PRODUCTION] Production, and +2 [ICON_PRODUCTION] Production from each owned {TXT_KEY_BUILDING_WEAPONS_FACTORY} and {TXT_KEY_BUILDING_MUNITIONS_FACTORY} in the Empire. +10% [ICON_PRODUCTION] Production towards Melee Units and Fighter Units. Increases the Military Unit Supply Cap by 1.[NEWLINE]
[NEWLINE]When you construct a Unit in this City, gain [ICON_PRODUCTION] Production equal to 20% of the Unit''s [ICON_PRODUCTION] Production cost.[NEWLINE]
[NEWLINE]The city must already possess a {TXT_KEY_BUILDING_FACTORY} before {TXT_KEY_BUILDING_WEAPONS_FACTORY} can be constructed, have an improved source of [ICON_RES_IRON] Iron, and cannot have a [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_MUNITIONS_FACTORY}[ENDCOLOR] already built.[NEWLINE]
[NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_WEAPONS_FACTORY') || ' of these buildings in your Empire.'
WHERE Tag = 'TXT_KEY_BUILDING_WEAPONS_FACTORY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US SET
Text = '+3 [ICON_PRODUCTION] Production, and +2 [ICON_PRODUCTION] Production from each owned {TXT_KEY_BUILDING_MUNITIONS_FACTORY} and {TXT_KEY_BUILDING_WEAPONS_FACTORY} in the Empire. +10% [ICON_PRODUCTION] Production towards Ranged Units and Bomber Units. Increases the Military Unit Supply Cap by 1.[NEWLINE]
[NEWLINE]When you construct a Unit in this City, gain [ICON_PRODUCTION] Production equal to 20% of the Unit''s [ICON_PRODUCTION] Production cost.[NEWLINE]
[NEWLINE]The city must already possess a {TXT_KEY_BUILDING_FACTORY} before {TXT_KEY_BUILDING_MUNITIONS_FACTORY} can be constructed, have an improved source of [ICON_RES_ALUMINUM] Aluminum, and cannot have a [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_WEAPONS_FACTORY}[ENDCOLOR] already built.[NEWLINE]
[NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_MUNITIONS_FACTORY') || ' of these buildings in your Empire.'
WHERE Tag = 'TXT_KEY_BUILDING_MUNITIONS_FACTORY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Policy_BuildingClassProductionModifiers
SELECT  DISTINCT 'POLICY_MOBILIZATION', bc.Type, 100
        FROM BuildingClasses bc
        WHERE bc.Type IN ('BUILDINGCLASS_WEAPONS_FACTORY', 'BUILDINGCLASS_MUNITIONS_FACTORY')
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Policy_BuildingClassYieldChanges
SELECT  DISTINCT pol.PolicyType, bc.Type, pol.YieldType, pol.YieldChange
        FROM BuildingClasses bc, Policy_BuildingClassYieldChanges pol
        WHERE bc.Type IN ('BUILDINGCLASS_WEAPONS_FACTORY', 'BUILDINGCLASS_MUNITIONS_FACTORY')
        AND pol.PolicyType = 'POLICY_MOBILIZATION'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Policy_BuildingClassYieldModifiers
SELECT  DISTINCT pol.PolicyType, bc.Type, pol.YieldType, pol.YieldMod
        FROM BuildingClasses bc, Policy_BuildingClassYieldModifiers pol
        WHERE bc.Type IN ('BUILDINGCLASS_OIL_REFINERY', 'BUILDINGCLASS_SYNTHFUEL_PLANT', 'BUILDINGCLASS_WEAPONS_FACTORY', 'BUILDINGCLASS_MUNITIONS_FACTORY')
        AND pol.BuildingClassType = 'BUILDINGCLASS_FORGE'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US SET
Text = REPLACE(Text, 'Defense Buildings', 'Defense Buildings, Weapons Factories, Munition Factories')
WHERE Tag = 'TXT_KEY_POLICY_MOBILIZATION_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US SET
Text = REPLACE(Text, '-33%', '+100% [ICON_PRODUCTION] Production towards Weapons Factories and Munition Factories. -33%')
WHERE Tag = 'TXT_KEY_POLICY_MOBILIZATION_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US SET
Text = REPLACE(Text, 'Factories', 'Factories, Weapons Factories, Munition Factories, Oil Refineries, Synthetic Fuel Manufactories')
WHERE Tag = 'TXT_KEY_POLICY_TRADE_UNIONS_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

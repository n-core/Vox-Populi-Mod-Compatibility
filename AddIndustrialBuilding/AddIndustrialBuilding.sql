UPDATE Buildings SET
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HOSPITAL'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_HOSPITAL'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HOSPITAL')
WHERE Type IN ('BUILDING_OIL_REFINERY', 'BUILDING_SYNTHFUEL_PLANT', 'BUILDING_WEAPONS_FACTORY', 'BUILDING_MUNITIONS_FACTORY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE BuildingClasses
SET MaxPlayerInstances = 5
WHERE Type IN ('BUILDINGCLASS_OIL_REFINERY', 'BUILDINGCLASS_SYNTHFUEL_PLANT', 'BUILDINGCLASS_WEAPONS_FACTORY', 'BUILDINGCLASS_MUNITIONS_FACTORY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

-- Oil Refinery and Synthetic Fuel Manufactory now are mutually exclusive buildings
UPDATE Buildings
SET MutuallyExclusiveGroup = 710, PrereqTech = 'TECH_BIOLOGY'
WHERE Type IN ('BUILDING_OIL_REFINERY', 'BUILDING_SYNTHFUEL_PLANT')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US
SET Text = '+2 [ICON_PRODUCTION] Production. +1 [ICON_PRODUCTION] Production for each [ICON_RES_OIL] Oil worked by the city.[NEWLINE][NEWLINE]Produces +2 [ICON_RES_OIL] Oil.[NEWLINE][NEWLINE]City must have an improved source of [ICON_RES_OIL] Oil, and cannot have a [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_SYNTHFUEL_PLANT}[ENDCOLOR] in the City.[NEWLINE][NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_OIL_REFINERY') || ' of these buildings in your empire.'
WHERE Tag = 'TXT_KEY_BUILDING_OIL_REFINERY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_LocalResourceOrs
SELECT 'BUILDING_SYNTHFUEL_PLANT', 'RESOURCE_COAL'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

DELETE FROM Building_ClassesNeededInCity
WHERE BuildingType = 'BUILDING_SYNTHFUEL_PLANT'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US
SET Text = '+2 [ICON_PRODUCTION] Production. +1 [ICON_PRODUCTION] Production for each [ICON_RES_COAL] Coal worked by the city.[NEWLINE]Converts 1 [ICON_RES_COAL] Coal into 2 [ICON_RES_OIL] Oil.[NEWLINE][NEWLINE]City must have an improved source of [ICON_RES_COAL] Coal, and cannot have a [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_OIL_REFINERY}[ENDCOLOR] in the City.[NEWLINE][NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_SYNTHFUEL_PLANT') || ' of these buildings in your empire.'
WHERE Tag = 'TXT_KEY_BUILDING_SYNTHFUEL_PLANT_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

-- Weapons Factory and Munition Factory now requires Factory instead of Workshop
-- (Both of them are *Factory*!)
UPDATE Building_ClassesNeededInCity
SET BuildingClassType = 'BUILDINGCLASS_FACTORY'
WHERE BuildingType IN ('BUILDING_WEAPONS_FACTORY', 'BUILDING_MUNITIONS_FACTORY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

-- Weapons Factory and Munition Factory now are mutually exclusive buildings
UPDATE Buildings
SET MutuallyExclusiveGroup = 711, PrereqTech = 'TECH_COMBUSTION'
WHERE Type IN ('BUILDING_WEAPONS_FACTORY', 'BUILDING_MUNITIONS_FACTORY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_LocalResourceOrs
SELECT 'BUILDING_WEAPONS_FACTORY', 'RESOURCE_IRON'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

INSERT INTO Building_LocalResourceOrs
SELECT 'BUILDING_MUNITIONS_FACTORY', 'RESOURCE_ALUMINUM'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Building_DomainProductionModifiers
SET Modifier = 5
WHERE BuildingType = 'BUILDING_WEAPONS_FACTORY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US
SET Text = '+1 [ICON_PRODUCTION] Production. +5% [ICON_PRODUCTION] Production towards Military Units.[NEWLINE]+1 [ICON_PRODUCTION] Production for each source of [ICON_RES_IRON] Iron worked by the city.[NEWLINE][NEWLINE]The city must already possess a {TXT_KEY_BUILDING_FACTORY} before {TXT_KEY_BUILDING_WEAPONS_FACTORY} can be constructed, have an improved source of [ICON_RES_IRON] Iron, and cannot have a [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_MUNITIONS_FACTORY}[ENDCOLOR] in the City.[NEWLINE][NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_WEAPONS_FACTORY') || ' of these buildings in your empire.'
WHERE Tag = 'TXT_KEY_BUILDING_WEAPONS_FACTORY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);

UPDATE Language_en_US
SET Text = '+1 [ICON_PRODUCTION] Production. +10% [ICON_PRODUCTION] Production towards Military Units that use munitions (Siege, Gunpowder, Armor and Bomber Units).[NEWLINE]+1 [ICON_PRODUCTION] Production for each source of [ICON_RES_ALUMINUM] Aluminum worked by the city.[NEWLINE][NEWLINE]The city must already possess a {TXT_KEY_BUILDING_FACTORY} before {TXT_KEY_BUILDING_MUNITIONS_FACTORY} can be constructed, have an improved source of [ICON_RES_ALUMINUM] Aluminum, and cannot have a [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_WEAPONS_FACTORY}[ENDCOLOR] in the City.[NEWLINE][NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_MUNITIONS_FACTORY') || ' of these buildings in your empire.'
WHERE Tag = 'TXT_KEY_BUILDING_MUNITIONS_FACTORY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_MOREINDUSTRIAL' AND Value= 1);
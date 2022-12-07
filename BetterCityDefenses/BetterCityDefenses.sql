INSERT  INTO IconTextureAtlases (Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn)
SELECT  'BCDMOD_ICON_ATLAS', 256, 'BCDmodIconAtlas256.dds', 4, 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'BCDMOD_ICON_ATLAS', 128, 'BCDmodIconAtlas128.dds', 4, 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'BCDMOD_ICON_ATLAS', 64, 'BCDmodIconAtlas64.dds', 4, 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'BCDMOD_ICON_ATLAS', 45, 'BCDmodIconAtlas45.dds', 4, 1 WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

CREATE  TABLE IF NOT EXISTS BCDBuildings (BCDType TEXT NOT NULL);

INSERT  INTO BCDBuildings
SELECT  'PALISADES' WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'WEAPONS_DEPOT' WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'DEFENSE_SATELLITE' WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'SATELLITE_NETWORK' WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

INSERT  INTO BuildingClasses (Type, DefaultBuilding, Description)
SELECT  'BUILDINGCLASS_' || BCDType,
        'BUILDING_' || BCDType,
        'TXT_KEY_BUILDING_' || BCDType
        FROM BCDBuildings
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

INSERT  INTO Buildings (Type, BuildingClass, Description, Help, Strategy, Civilopedia)
SELECT  'BUILDING_' || BCDType,
        'BUILDINGCLASS_' || BCDType,
        'TXT_KEY_BUILDING_' || BCDType,
        'TXT_KEY_BUILDING_' || BCDType || '_HELP',
        'TXT_KEY_BUILDING_' || BCDType || '_STRATEGY',
        'TXT_KEY_CIV5_BUILDINGS_' || BCDType || '_TEXT'
        FROM BCDBuildings
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);


-- Palisades
UPDATE  Buildings SET
        -- Important bit
        Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_MONUMENT'),
        HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_MONUMENT'),
        Defense = 400,
        ExtraCityHitPoints = 50,
        CitySupplyModifier = 5,

        -- Not so important bit
        PrereqTech = 'TECH_AGRICULTURE',
        FreeStartEra = 'ERA_MEDIEVAL',
        NeverCapture = 1,
        ArtDefineTag = NULL,
        IconAtlas = 'BW_ATLAS_1',
        PortraitIndex = 32
        WHERE Type = 'BUILDING_PALISADES'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

UPDATE  Buildings SET
        IconAtlas = 'BCDMOD_ICON_ATLAS',
        PortraitIndex = 0
        WHERE Type = 'BUILDING_WALLS'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

DELETE  FROM Building_ClassesNeededInCity
        WHERE BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WALLS')
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_DEFENSES' AND Value = 1);

INSERT  INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
        SELECT DISTINCT Type, 'BUILDINGCLASS_PALISADES' FROM Buildings
        WHERE Type IN (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WALLS')
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_DEFENSES' AND Value = 1);

INSERT  OR REPLACE INTO Language_en_US (Tag, Text)
SELECT  'TXT_KEY_BUILDING_PALISADES',
        'Palisades'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_BUILDING_PALISADES_HELP',
        'Military Units Supplied by this City''s population increased by 5%.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_BUILDING_PALISADES_STRATEGY',
        '{TXT_KEY_BUILDING_PALISADES} increase City''s Defense Strength and Hit Points, making the City harder to capture on early-game. Also Increases Military Units supplied by this City''s population by 5%.[NEWLINE]'||
        '[NEWLINE]{TXT_KEY_BUILDING_PALISADES} are the first step in building a City''s defense along a civilization''s frontier.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_CIV5_BUILDINGS_PALISADES_TEXT',
        'A palisade—sometimes called a stakewall or a paling—is typically a fence or wall made from wooden stakes or tree trunks and used as a defensive structure or enclosure.[NEWLINE]'||
        '[NEWLINE]Typical construction consisted of small or mid-sized tree trunks aligned vertically, with no free space in between. '||
        'The trunks were sharpened or pointed at the top, and were driven into the ground and sometimes reinforced with additional construction. '||
        'The height of a palisade ranged from a few feet to nearly ten feet. As a defensive structure, palisades were often used in conjunction with earthworks.[NEWLINE]'||
        '[NEWLINE]Palisades were an excellent option for small forts or other hastily constructed fortifications. '||
        'Since they were made of wood, they could often be quickly and easily built from readily available materials. '||
        'They proved to be effective protection for short-term conflicts and were an effective deterrent against small forces. However, because they were wooden constructions they were also vulnerable to fire and siege weapons.[NEWLINE]'||
        '[NEWLINE]Often, a palisade would be constructed around a castle as a temporary wall until a permanent stone wall could be erected. They were frequently used in New France.[NEWLINE]'||
        '[NEWLINE]Both the Greeks and Romans created palisades to protect their military camps. The Roman historian Livy describes the Greek method as being inferior to that of the Romans during the Second Macedonian War. '||
        'The Greek stakes were too large to be easily carried and were spaced too far apart. This made it easy for enemies to uproot them and create a large enough gap in which to enter. '||
        'In contrast, the Romans used smaller and easier to carry stakes which were placed closer together, making them more difficult to uproot.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);
/*
UPDATE  Language_en_US
        SET Text = 'City Walls'
        WHERE Tag = 'TXT_KEY_BUILDING_WALLS'
        AND Tag IN (SELECT Strategy FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WALLS');
*/
UPDATE  Language_en_US
        SET Text = Text || ' The city must possess {TXT_KEY_BUILDING_PALISADES} before {TXT_KEY_BUILDING_WALLS} can be constructed.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1 )
        AND Tag IN (SELECT Strategy FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WALLS');

-- Weapons Depot
UPDATE  Buildings SET
        -- Important bit
        Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_MILITARY_BASE'),
        GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_MILITARY_BASE'),
        HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_MILITARY_BASE'),
        Defense = 1100,
        ExtraCityHitPoints = 100,
        CitySupplyModifier = 50,
        CityAirStrikeDefense = 10,
        AllowsRangeStrike = 1,

        -- Not so important bit
        PrereqTech = 'TECH_COMBINED_ARMS',
        NeverCapture = 1,
        ArtDefineTag = NULL,
        IconAtlas = 'BW_ATLAS_1',
        PortraitIndex = 9
        WHERE Type = 'BUILDING_WEAPONS_DEPOT'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

UPDATE  Buildings SET
        IconAtlas = 'BCDMOD_ICON_ATLAS',
        PortraitIndex = 1
        WHERE Type = 'BUILDING_ARSENAL'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

INSERT  INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT  'BUILDING_WEAPONS_DEPOT', 'BUILDINGCLASS_ARSENAL'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

INSERT  OR REPLACE INTO Language_en_US (Tag, Text)
SELECT  'TXT_KEY_BUILDING_WEAPONS_DEPOT',
        'Weapons Depot'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_BUILDING_WEAPONS_DEPOT_HELP',
        '+10[ICON_STRENGTH] Damage to Air Units during Air Strikes on City. Military Units Supplied by this City''s population increased by 50%.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_BUILDING_WEAPONS_DEPOT_STRATEGY',
        'The {TXT_KEY_BUILDING_WEAPONS_DEPOT} is a building which increase City''s Defensive Strength and Hit Points. +10[ICON_STRENGTH] Damage to Air Units during Air Strikes on City. '||
        'Increases Military Units supplied by this City''s population by 50%. The city must possess an {TXT_KEY_BUILDING_ARSENAL} before a {TXT_KEY_BUILDING_WEAPONS_DEPOT} can be constructed.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_CIV5_BUILDINGS_WEAPONS_DEPOT_TEXT',
        'A {TXT_KEY_BUILDING_WEAPONS_DEPOT} is a larger and more extensive armory, containing an army''s bigger and more dangerous weapons systems - tanks, artillery, high-explosive ammunition, and so forth. '||
        'Weapon Depots are even more heavily-guarded than armories, since nobody wants anybody stealing a tank or an 88-mm explosive shell.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

-- Defense Satellites
UPDATE  Buildings SET
        -- Important bit
        Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_SPACESHIP_FACTORY'),
        GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_SPACESHIP_FACTORY') + 2,
        HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_SPACESHIP_FACTORY'),
        Defense = 1000,
        RangedStrikeModifier = 15,
        CityAirStrikeDefense = 20,
        CityRangedStrikeRange = 2,
        CityIndirectFire = 1,
        NukeInterceptionChance = 20,
        AllowsRangeStrike = 1,

        -- Not so important bit
        PrereqTech = 'TECH_SATELLITES',
        NeverCapture = 1,
        ArtDefineTag = NULL,
        IconAtlas = 'BCDMOD_ICON_ATLAS',
        PortraitIndex = 2
        WHERE Type = 'BUILDING_DEFENSE_SATELLITE'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

UPDATE  BuildingClasses SET MaxPlayerInstances = 5
        WHERE Type = 'BUILDINGCLASS_DEFENSE_SATELLITE'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

INSERT  INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT  'BUILDING_DEFENSE_SATELLITE', 'BUILDINGCLASS_MILITARY_BASE'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

INSERT  INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType, Cost)
SELECT  'BUILDING_DEFENSE_SATELLITE', 'RESOURCE_ALUMINUM', 1
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

INSERT  OR REPLACE INTO Language_en_US (Tag, Text)
SELECT  'TXT_KEY_BUILDING_DEFENSE_SATELLITE',
        'Defense Satellites'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_BUILDING_DEFENSE_SATELLITE_HELP',
        '+20[ICON_STRENGTH] Damage to Air Units during Air Strikes on City. Increase City''s [ICON_RANGE_STRENGTH] Ranged Strike Range by 2 and [ICON_RANGE_STRENGTH] Ranged Strike Damage by 15%.[NEWLINE]'||
        '[NEWLINE]20% chance to detonate nuclear weapons [COLOR_POSITIVE_TEXT]early[ENDCOLOR]. Early detonations destroy Atomic Bombs outright and make Nuclear Missiles only as effective as Atomic Bombs.[NEWLINE]'||
        '[NEWLINE]Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_DEFENSE_SATELLITE') || ' of these buildings in your empire.[NEWLINE]'||
        '[NEWLINE]Requires 1 [ICON_RES_ALUMINUM] Aluminum.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_BUILDING_DEFENSE_SATELLITE_STRATEGY',
        '{TXT_KEY_BUILDING_DEFENSE_SATELLITE} is a late-game building which increase a City''s Defense Strength and has the ability to defend against air units effectively. '||
        'Increases the City''s [ICON_RANGE_STRENGTH] Ranged Strike Range by 2 and Damage by 15%, so it covers the whole 5-tile radius around the City, and also inflicts extra damage to the enemy. '||
        'Also have a 20% chance to detonate nuclear weapons early, which destroys Atomic Bombs outright and makes Nuclear Missiles only as effective as Atomic Bombs (with total of 70% chance when stacked with {TXT_KEY_BUILDING_BOMB_SHELTER}). '||
        'The city must possess a {TXT_KEY_BUILDING_MILITARY_BASE} before {TXT_KEY_BUILDING_DEFENSE_SATELLITE} can be constructed. '||
        'Maximum of ' || (SELECT MaxPlayerInstances FROM BuildingClasses WHERE Type = 'BUILDINGCLASS_DEFENSE_SATELLITE') || ' of these buildings in your empire, so make sure to place these buildings in strategic cities.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_CIV5_BUILDINGS_DEFENSE_SATELLITE_TEXT',
        '{TXT_KEY_BUILDING_DEFENSE_SATELLITE} are a type of military reconnaissance satellite designed to help safeguard cities by providing real-time data on the position of nearby enemy forces and their tactical capability. '||
        'They provide detailed intelligence and dramatically decrease the response time of a City''s defense force, which can change the outcome of a siege.[NEWLINE]'||
        '[NEWLINE]The first military use of satellites was for reconnaissance. In the United States the first formal military satellite programs, Weapon System 117L, was developed in the mid 1950s. '||
        'Within this program a number of sub-programs were developed including Corona. Satellites within the Corona program carried different code names. The first launches were code named Discoverer. '||
        'This mission was a series of reconnaissance satellites, designed to enter orbit, take high-resolution photographs and then return the payload to Earth via parachute. '||
        'Discoverer 1, the first mission, was launched on 28 February 1959 although it didn''t carry a payload being intended as a test flight to prove the technology. The Corona program continued until 25 May 1972. '||
        'Corona was followed by other programs including Canyon (seven launches between 1968 and 1977), Aquacade and Orion (stated by US Government sources to be extremely large). '||
        'There have also been a number of subsequent programs including Magnum and Trumpet, but these remain classified and therefore many details remain speculative.[NEWLINE]'||
        '[NEWLINE]The Soviet Union began the Almaz program in the early 1960s. This program involved placing space stations in Earth orbit as an alternative to satellites. '||
        'Three stations were launched between 1973 and 1976: Salyut 2, Salyut 3 and Salyut 5. '||
        'Following Salyut 5, the Soviet Ministry of Defence judged in 1978 that the time consumed by station maintenance outweighed the benefits relative to automatic reconnaissance satellites.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

-- Satellite Network Headquarters
UPDATE  Buildings SET
        -- Important bit
        Cost = 400,
        NumCityCostMod = 30,
        GlobalDefenseMod = 10,
        NationalPopRequired = 70,

        -- Not so important bit
        PrereqTech = 'TECH_SATELLITES',
        NeverCapture = 1,
        IconAtlas = 'BCDMOD_ICON_ATLAS',
        PortraitIndex = 3
        WHERE Type = 'BUILDING_SATELLITE_NETWORK'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

UPDATE  BuildingClasses SET MaxPlayerInstances = 1
        WHERE Type = 'BUILDINGCLASS_SATELLITE_NETWORK'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

INSERT  INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
SELECT  'BUILDING_SATELLITE_NETWORK', 'BUILDINGCLASS_DEFENSE_SATELLITE'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

INSERT  OR REPLACE INTO Language_en_US (Tag, Text)
SELECT  'TXT_KEY_BUILDING_SATELLITE_NETWORK',
        'Satellite Network Headquarters'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_BUILDING_SATELLITE_NETWORK_HELP',
        'Defensive buildings in all cities are 10% more effective.[NEWLINE]'||
        '[NEWLINE]The [ICON_PRODUCTION] Production Cost and [ICON_CITIZEN] Population Requirements increase based on the number of cities you own.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_BUILDING_SATELLITE_NETWORK_STRATEGY',
        'With its large boost to City defenses, the {TXT_KEY_BUILDING_SATELLITE_NETWORK} is a great choice to help secure your cities when dealing with militaristic neighbors. '||
        'This can indirectly aide in any type of victory. Build it in your heartland where it will likely be safe.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1) UNION ALL
SELECT  'TXT_KEY_CIV5_BUILDINGS_SATELLITE_NETWORK_TEXT',
        'A Satellite Network Headquarters coordinates a state''s {TXT_KEY_BUILDING_DEFENSE_SATELLITE} to maximize their capabilities, allowing high level decisions to be made quickly to aide in a City''s defense. '||
        'They contain the latest computer and satellite uplink technology, so that the decision makers on the ground can receive current information from the {TXT_KEY_BUILDING_DEFENSE_SATELLITE} and quickly issue orders in how to use the one on site to help protect a City. '||
        'The facility is sometimes built underground for safety but its radio dishes are hard to disguise.'
        WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_DEFENSES' AND Value= 1);

CREATE TRIGGER BCD_ClassesNeededInCity
AFTER INSERT ON Civilization_BuildingClassOverrides
WHEN EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_DEFENSES' AND Value= 1)
AND NEW.BuildingClassType = 'BUILDINGCLASS_WALLS'
AND NEW.BuildingType IS NOT NULL
BEGIN
        INSERT  OR REPLACE INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
        SELECT  DISTINCT NEW.BuildingType, 'BUILDINGCLASS_PALISADES';
END;

/* -- It's not working
CREATE TRIGGER BCD_RequirePalisadesText_AfterInsert
AFTER INSERT ON Language_en_US
WHEN EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_DEFENSES' AND Value= 1)
AND NEW.Tag = (
        SELECT Strategy
        FROM Buildings
        WHERE BuildingClass = (
                        SELECT BuildingClassType
                        FROM Civilization_BuildingClassOverrides
                        WHERE BuildingClassType = 'BUILDINGCLASS_WALLS'
                                AND BuildingType IS NOT NULL
                        )
                )
BEGIN
        UPDATE  LocalizedText
                SET Text = Text || '[NEWLINE][NEWLINE]The city must possess {TXT_KEY_BUILDING_PALISADES} before {TXT_KEY_BUILDING_WALLS} can be constructed.'
                WHERE Language = 'en_US' AND Tag = NEW.Tag;
END;*/

-- Add additional defense buildings to Military-Industrial Complex (Autocracy) tenet
INSERT  INTO Policy_BuildingClassYieldChanges
	(PolicyType, BuildingClassType, YieldType, YieldChange)
        SELECT DISTINCT bcyc.PolicyType, bc.Type, bcyc.YieldType, bcyc.YieldChange
        FROM BuildingClasses bc, Policy_BuildingClassYieldChanges bcyc
        WHERE bc.Type IN ('BUILDINGCLASS_PALISADES', 'BUILDINGCLASS_WEAPONS_DEPOT', 'BUILDINGCLASS_DEFENSE_SATELLITE')
        AND bcyc.PolicyType = 'POLICY_MOBILIZATION'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_DEFENSES' AND Value= 1);

-- Add additional defense buildings to Defender of Faith belief
-- +1 Faith and +2 Culture for all of these buildings.
INSERT  INTO Belief_BuildingClassYieldChanges
        (BeliefType, BuildingClassType, YieldType, YieldChange)
        SELECT DISTINCT bcyc.BeliefType, bc.Type, bcyc.YieldType, bcyc.YieldChange
        FROM BuildingClasses bc, Belief_BuildingClassYieldChanges bcyc
        WHERE bc.Type IN ('BUILDINGCLASS_PALISADES', 'BUILDINGCLASS_WEAPONS_DEPOT', 'BUILDINGCLASS_DEFENSE_SATELLITE')
        AND bcyc.BeliefType = 'BELIEF_DEFENDER_FAITH'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_DEFENSES' AND Value= 1);

-- Add additional defense buildings to Oda Nobunaga's Ubique Ability (Japan)
-- +1 Faith and Culture for all of these buildings.
INSERT  INTO Trait_BuildingClassYieldChanges
        (TraitType, BuildingClassType, YieldType, YieldChange)
        SELECT DISTINCT bcyc.TraitType, bc.Type, bcyc.YieldType, bcyc.YieldChange
        FROM BuildingClasses bc, Trait_BuildingClassYieldChanges bcyc
        WHERE bc.Type IN ('BUILDINGCLASS_PALISADES', 'BUILDINGCLASS_WEAPONS_DEPOT', 'BUILDINGCLASS_DEFENSE_SATELLITE')
        AND bcyc.TraitType = 'TRAIT_FIGHT_WELL_DAMAGED'
        AND EXISTS (SELECT * FROM COMMUNITY WHERE Type = 'CBPMC_DEFENSES' AND Value= 1);

DROP TABLE BCDBuildings;
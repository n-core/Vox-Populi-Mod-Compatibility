--=====================================================================================================--
-- National Military Academy, National Naval Academy, National Air Force Academy are mutually exclusives
--=====================================================================================================--
UPDATE Buildings SET
MutuallyExclusiveGroup = 86
WHERE Type IN ('BUILDING_FA_WAR_ACADEMY', 'BUILDING_FA_SEA_ACADEMY', 'BUILDING_FA_AIR_ACADEMY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

--=====================================================================================================--
-- New Promotion: Skilled Soldier, Skilled Sailor, Skilled Pilot
--=====================================================================================================--
INSERT OR REPLACE INTO UnitPromotions (Type, PortraitIndex, IconAtlas, PediaType)
SELECT 'PROMOTION_FA_WAR_ACADEMY', 58, 'ABILITY_ATLAS', 'PEDIA_SHARED'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1) UNION ALL
SELECT 'PROMOTION_FA_SEA_ACADEMY', 58, 'ABILITY_ATLAS', 'PEDIA_NAVAL'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1) UNION ALL
SELECT 'PROMOTION_FA_AIR_ACADEMY', 58, 'ABILITY_ATLAS', 'PEDIA_AIR'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE UnitPromotions SET
CannotBeChosen = 1, Description = 'TXT_KEY_'||Type, Help = 'TXT_KEY_'||Type||'_HELP', Sound = 'AS2D_IF_LEVELUP', PediaEntry = 'TXT_KEY_'||Type
WHERE Type IN ('PROMOTION_FA_WAR_ACADEMY', 'PROMOTION_FA_SEA_ACADEMY', 'PROMOTION_FA_AIR_ACADEMY')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO UnitPromotions_UnitCombats  (PromotionType, UnitCombatType)
SELECT 'PROMOTION_FA_WAR_ACADEMY', uci.Type FROM UnitCombatInfos uci
WHERE uci.Type IN (
        'UNITCOMBAT_MELEE',
        'UNITCOMBAT_GUN',
        'UNITCOMBAT_MOUNTED',
        'UNITCOMBAT_ARMOR',
        'UNITCOMBAT_ARCHER',
        'UNITCOMBAT_SIEGE',
        'UNITCOMBAT_RECON',
        'UNITCOMBAT_HELICOPTER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);
/*
INSERT INTO UnitPromotions_UnitCombats  (PromotionType, UnitCombatType)
SELECT 'PROMOTION_FA_SEA_ACADEMY', uci.Type FROM UnitCombatInfos uci
WHERE uci.Type IN (
		'UNITCOMBAT_NAVALMELEE',
		'UNITCOMBAT_NAVALRANGED',
		'UNITCOMBAT_SUBMARINE',
		'UNITCOMBAT_CARRIER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);
*/
INSERT INTO UnitPromotions_UnitCombats  (PromotionType, UnitCombatType)
SELECT 'PROMOTION_FA_AIR_ACADEMY', uci.Type FROM UnitCombatInfos uci
WHERE uci.Type IN (
		'UNITCOMBAT_FIGHTER',
		'UNITCOMBAT_BOMBER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO UnitPromotions_UnitCombats  (PromotionType, UnitCombatType)
SELECT 'PROMOTION_FA_AIR_ACADEMY', 'UNITCOMBAT_AIRSHIP'
WHERE EXISTS (SELECT * FROM UnitCombatInfos WHERE Type='UNITCOMBAT_AIRSHIP')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

-- Compatibility with PDan's Airship mod (in case if it loads after this mod)
CREATE TRIGGER SkilledPilot_IncludesPDanAirship
AFTER INSERT ON UnitCombatInfos
WHEN NEW.Type = 'UNITCOMBAT_AIRSHIP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1)
BEGIN
		INSERT INTO UnitPromotions_UnitCombats  (PromotionType, UnitCombatType)
		SELECT 'PROMOTION_FA_AIR_ACADEMY', NEW.Type;
END;

UPDATE UnitPromotions SET ExperiencePercent = 50 WHERE Type IN ('PROMOTION_FA_WAR_ACADEMY', 'PROMOTION_FA_SEA_ACADEMY', 'PROMOTION_FA_AIR_ACADEMY');

DELETE FROM UnitPromotions_Domains
WHERE PromotionType = 'PROMOTION_FA_SEA_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM UnitPromotions_Terrains
WHERE PromotionType = 'PROMOTION_FA_SEA_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM UnitPromotions_UnitCombats
WHERE PromotionType = 'PROMOTION_FA_SEA_ACADEMY' AND UnitCombatType = 'UNITCOMBAT_NAVAL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT OR REPLACE INTO Language_en_US (Text, Tag)
SELECT 'Skilled Soldier', 'TXT_KEY_PROMOTION_FA_WAR_ACADEMY'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1) UNION ALL
SELECT 'Skilled Pilot', 'TXT_KEY_PROMOTION_FA_AIR_ACADEMY'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1) UNION ALL
SELECT 'Earns experience toward promotions 50% faster.', 'TXT_KEY_PROMOTION_FA_WAR_ACADEMY_HELP'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1) UNION ALL
SELECT 'Earns experience toward promotions 50% faster.', 'TXT_KEY_PROMOTION_FA_AIR_ACADEMY_HELP'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'Skilled Sailor'
WHERE Tag = 'TXT_KEY_PROMOTION_FA_SEA_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'Earns experience toward promotions 50% faster.'
WHERE Tag = 'TXT_KEY_PROMOTION_FA_SEA_ACADEMY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

--=====================================================================================================--
-- National Military Academy -> National Army Academy
--=====================================================================================================--
UPDATE Buildings SET
FreePromotion = 'PROMOTION_FA_WAR_ACADEMY', GreatGeneralRateModifier = 0, FreeBuildingThisCity = NULL,
PrereqTech = 'TECH_REPLACEABLE_PARTS',
NumCityCostMod = (SELECT NumCityCostMod FROM Buildings WHERE Type = 'BUILDING_HERMITAGE'),
NationalPopRequired = 55,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HERMITAGE'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HERMITAGE')
WHERE Type = 'BUILDING_FA_WAR_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_FA_WAR_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield)
SELECT 'BUILDING_FA_WAR_ACADEMY', 'YIELD_GREAT_GENERAL_POINTS', 4
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_DomainProductionModifiers
WHERE BuildingType = 'BUILDING_FA_WAR_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

INSERT INTO Building_DomainFreeExperiencesGlobal (BuildingType, DomainType, Experience)
SELECT 'BUILDING_FA_WAR_ACADEMY', 'DOMAIN_LAND', 10
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Building_ClassesNeededInCity
SET BuildingClassType = 'BUILDINGCLASS_MILITARY_ACADEMY'
WHERE BuildingType = 'BUILDING_FA_WAR_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

DELETE FROM Building_PrereqBuildingClasses
WHERE BuildingType = 'BUILDING_FA_WAR_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_FA_WAR_ACADEMY' AND FlavorType IN ('FLAVOR_PRODUCTION', 'FLAVOR_CITY_DEFENSE', 'FLAVOR_WONDER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

UPDATE Language_en_US SET
Text = 'National Army Academy'
WHERE Tag = 'TXT_KEY_BUILDING_FA_WAR_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = '+25 [ICON_WAR] XP for all Land Units trained in this City, and +10 [ICON_WAR] XP elsewhere. All Land Units may receive the [COLOR_POSITIVE_TEXT]{TXT_KEY_PROMOTION_FA_WAR_ACADEMY}[ENDCOLOR] promotion.[NEWLINE]
[NEWLINE]Cannot have the [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_FA_SEA_ACADEMY}[ENDCOLOR] or the [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_FA_AIR_ACADEMY}[ENDCOLOR] already built in the City.[NEWLINE]
[NEWLINE]The [ICON_PRODUCTION] Production Cost and [ICON_CITIZEN] Population Requirements increase based on the number of cities you own.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_WAR_ACADEMY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'Build the {TXT_KEY_BUILDING_FA_WAR_ACADEMY} when pursuing a ground war, as it makes your Land Units have faster experience learning rate. It also speeds the appearance of Great Generals. The City must have a {TXT_KEY_BUILDING_MILITARY_ACADEMY} before it can construct the {TXT_KEY_BUILDING_FA_WAR_ACADEMY}.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_WAR_ACADEMY_STRATEGY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

--=====================================================================================================--
-- National Naval Academy
--=====================================================================================================--
UPDATE Buildings SET
FreePromotion = 'PROMOTION_FA_SEA_ACADEMY', TrainedFreePromotion = NULL,
PrereqTech = 'TECH_REPLACEABLE_PARTS',
NumCityCostMod = (SELECT NumCityCostMod FROM Buildings WHERE Type = 'BUILDING_HERMITAGE'),
NationalPopRequired = 55,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HERMITAGE'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HERMITAGE')
WHERE Type = 'BUILDING_FA_SEA_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_FA_SEA_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield)
SELECT 'BUILDING_FA_SEA_ACADEMY', 'YIELD_GREAT_ADMIRAL_POINTS', 4
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_DomainProductionModifiers
WHERE BuildingType = 'BUILDING_FA_SEA_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

INSERT INTO Building_DomainFreeExperiencesGlobal (BuildingType, DomainType, Experience)
SELECT 'BUILDING_FA_SEA_ACADEMY', 'DOMAIN_SEA', 10
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Building_ClassesNeededInCity
SET BuildingClassType = 'BUILDINGCLASS_MILITARY_ACADEMY'
WHERE BuildingType = 'BUILDING_FA_SEA_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_FreeUnits
WHERE BuildingType = 'BUILDING_FA_SEA_ACADEMY' AND UnitType = 'UNIT_GREAT_ADMIRAL'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_FA_SEA_ACADEMY' AND FlavorType IN ('FLAVOR_PRODUCTION', 'FLAVOR_WONDER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

UPDATE Language_en_US SET
Text = '+25 [ICON_WAR] XP for all Sea Units trained in this City, and +10 [ICON_WAR] XP elsewhere. All Naval Units may receive the [COLOR_POSITIVE_TEXT]{TXT_KEY_PROMOTION_FA_SEA_ACADEMY}[ENDCOLOR] Promotion.[NEWLINE]
[NEWLINE]Cannot have the [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_FA_WAR_ACADEMY}[ENDCOLOR] or the [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_FA_AIR_ACADEMY}[ENDCOLOR] already built in the City.[NEWLINE]
[NEWLINE]The [ICON_PRODUCTION] Production Cost and [ICON_CITIZEN] Population Requirements increase based on the number of cities you own.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_SEA_ACADEMY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'Build the {TXT_KEY_BUILDING_FA_SEA_ACADEMY} when pursuing a war at sea, as it makes your Sea Units have faster experience learning rate. It also speeds the appearance of Great Admirals. The City must have a {TXT_KEY_BUILDING_MILITARY_ACADEMY} before it can construct the {TXT_KEY_BUILDING_FA_SEA_ACADEMY}.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_SEA_ACADEMY_STRATEGY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

--=====================================================================================================--
-- National Air Force Academy
--=====================================================================================================--
UPDATE Buildings SET
FreePromotion = 'PROMOTION_FA_AIR_ACADEMY',
NumCityCostMod = (SELECT NumCityCostMod FROM Buildings WHERE Type = 'BUILDING_HERMITAGE'),
NationalPopRequired = 60,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HERMITAGE'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HERMITAGE')
WHERE Type = 'BUILDING_FA_AIR_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_FA_AIR_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_DomainProductionModifiers
WHERE BuildingType = 'BUILDING_FA_AIR_ACADEMY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

INSERT INTO Building_DomainFreeExperiencesGlobal (BuildingType, DomainType, Experience)
SELECT 'BUILDING_FA_AIR_ACADEMY', 'DOMAIN_AIR', 10
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO Building_DomainFreeExperiences (BuildingType, DomainType, Experience)
SELECT 'BUILDING_FA_AIR_ACADEMY', 'DOMAIN_AIR', 15
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_FA_AIR_ACADEMY' AND FlavorType IN ('FLAVOR_PRODUCTION', 'FLAVOR_WONDER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

UPDATE Language_en_US SET
Text = '+25 [ICON_WAR] XP for all Air Units trained in this City, and +10 [ICON_WAR] XP elsewhere. All Air Units may receive the [COLOR_POSITIVE_TEXT]{TXT_KEY_PROMOTION_FA_AIR_ACADEMY}[ENDCOLOR] promotion.[NEWLINE]
[NEWLINE]Cannot have the [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_FA_WAR_ACADEMY}[ENDCOLOR] or the [COLOR_NEGATIVE_TEXT]{TXT_KEY_BUILDING_FA_SEA_ACADEMY}[ENDCOLOR] already built in the City.[NEWLINE]
[NEWLINE]The [ICON_PRODUCTION] Production Cost and [ICON_CITIZEN] Population Requirements increase based on the number of Cities you own.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_AIR_ACADEMY_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'Build the {TXT_KEY_BUILDING_FA_AIR_ACADEMY} when pursuing a war in the skies, as it makes your Air Units have faster experience learning rate. The City must have a {TXT_KEY_BUILDING_MILITARY_ACADEMY} before it can construct the {TXT_KEY_BUILDING_FA_AIR_ACADEMY}.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_AIR_ACADEMY_STRATEGY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

--=====================================================================================================--
-- Central Bank
--=====================================================================================================--
UPDATE Buildings SET
NumCityCostMod = (SELECT NumCityCostMod FROM Buildings WHERE Type = 'BUILDING_HERMITAGE'),
NationalPopRequired = 50,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HERMITAGE'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HERMITAGE')
WHERE Type = 'BUILDING_FA_CENTRAL_BANK'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_FA_CENTRAL_BANK'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO Building_YieldFromYieldPercentGlobal (BuildingType, YieldIn, YieldOut, Value)
SELECT 'BUILDING_FA_CENTRAL_BANK', 'YIELD_GOLD', y.Type, 2 FROM Yields y
WHERE y.Type IN ('YIELD_FOOD', 'YIELD_PRODUCTION','YIELD_SCIENCE')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO Building_SpecialistYieldChanges (BuildingType, SpecialistType, YieldType, Yield)
SELECT 'BUILDING_FA_CENTRAL_BANK', 'SPECIALIST_MERCHANT', y.Type, 1 FROM Yields y
WHERE y.Type IN ('YIELD_GOLD', 'YIELD_SCIENCE')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO Building_BuildingClassYieldChanges
SELECT DISTINCT b.Type, 'BUILDINGCLASS_FA_CENTRAL_BANK', 'YIELD_GOLD', 1 FROM Buildings b
WHERE b.BuildingClass = 'BUILDINGCLASS_BANK'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

CREATE TRIGGER VPMC_FA_CENTRAL_BANK_BankCompatibility
AFTER INSERT ON Civilization_BuildingClassOverrides
WHEN NEW.BuildingClassType = 'BUILDINGCLASS_BANK'
AND NEW.BuildingType IS NOT NULL
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1)
BEGIN
        INSERT INTO Building_BuildingClassLocalYieldChanges
        SELECT DISTINCT NEW.BuildingType, 'BUILDINGCLASS_FA_CENTRAL_BANK', 'YIELD_GOLD', 1;
END;

INSERT INTO Building_ClassesNeededInCity
SELECT 'BUILDING_FA_CENTRAL_BANK', 'BUILDINGCLASS_BANK'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_PrereqBuildingClasses
WHERE BuildingType = 'BUILDING_FA_CENTRAL_BANK'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_FA_CENTRAL_BANK' AND FlavorType IN ('FLAVOR_DIPLOMACY', 'FLAVOR_GREAT_PEOPLE', 'FLAVOR_WONDER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_FA_CENTRAL_BANK', f.Type, 5 FROM Flavors f
WHERE f.Type IN ('FLAVOR_GROWTH', 'FLAVOR_PRODUCTION', 'FLAVOR_SCIENCE')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'All Cities generate +1 [ICON_FOOD] Food, [ICON_PRODUCTION] Production, and [ICON_RESEARCH] Science for every 50 [ICON_GOLD] Gold it generates. +1 [ICON_GOLD] Gold and [ICON_RESEARCH] Science to Merchants in all Cities. +1 [ICON_GOLD] Gold from all owned Banks.[NEWLINE]
[NEWLINE]The [ICON_PRODUCTION] Production Cost and [ICON_CITIZEN] Population Requirements increase based on the number of Cities you own.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_CENTRAL_BANK_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'The {TXT_KEY_BUILDING_FA_CENTRAL_BANK} makes every City turn its [ICON_GOLD] Gold output into a small amount of [ICON_FOOD] Food, [ICON_PRODUCTION] Production, and [ICON_RESEARCH] Science. '||
'It also makes Merchants more valuable. The City that possess the {TXT_KEY_BUILDING_FA_CENTRAL_BANK} gain [ICON_GOLD] Gold from all owned Banks within the Empire. '||
'The City must be a [ICON_CAPITAL] Capital, and have a {TXT_KEY_BUILDING_BANK} before it can construct the {TXT_KEY_BUILDING_FA_CENTRAL_BANK}.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_CENTRAL_BANK_STRATEGY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

--=====================================================================================================--
-- Central Terminal
--=====================================================================================================--
UPDATE Buildings SET
RequiresRail = 1, CityConnectionTradeRouteModifier = 10, CityConnectionGoldModifier = 15, TRTurnModGlobal = -50, FreeBuildingThisCity = 'BUILDINGCLASS_TRAINSTATION',
Help = 'TXT_KEY_BUILDING_FA_CENTRAL_STATION_HELP',
NumCityCostMod = (SELECT NumCityCostMod FROM Buildings WHERE Type = 'BUILDING_HERMITAGE'),
NationalPopRequired = 50,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_HERMITAGE'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_HERMITAGE')
WHERE Type = 'BUILDING_FA_CENTRAL_STATION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_FA_CENTRAL_STATION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_YieldModifiers
WHERE BuildingType = 'BUILDING_FA_CENTRAL_STATION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_BuildingClassYieldChanges
WHERE BuildingType = 'BUILDING_FA_CENTRAL_STATION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

INSERT INTO Building_BuildingClassYieldChanges
SELECT DISTINCT 'BUILDING_FA_CENTRAL_STATION', b.BuildingClass, y.Type, 1 FROM Buildings b, Yields y
WHERE b.MutuallyExclusiveGroup = 10
AND y.Type IN ('YIELD_PRODUCTION', 'YIELD_GOLD')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Building_ClassesNeededInCity
SET BuildingClassType = 'BUILDINGCLASS_TRAINSTATION'
WHERE BuildingType = 'BUILDING_FA_CENTRAL_STATION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_PrereqBuildingClasses
WHERE BuildingType = 'BUILDING_FA_CENTRAL_STATION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_FA_CENTRAL_STATION' AND FlavorType IN ('FLAVOR_PRODUCTION', 'FLAVOR_GROWTH', 'FLAVOR_WONDER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
SELECT 'BUILDING_FA_CENTRAL_STATION', f.Type, 25 FROM Flavors f
WHERE f.Type IN ('FLAVOR_I_LAND_TRADE_ROUTE', 'FLAVOR_I_SEA_TRADE_ROUTE')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_FreeUnits
WHERE BuildingType = 'BUILDING_FA_CENTRAL_STATION' AND UnitType = 'UNIT_FA_CENTRAL_STATION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM UnitClasses
WHERE Type = 'UNITCLASS_FA_CENTRAL_STATION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Units
WHERE Type = 'UNIT_FA_CENTRAL_STATION'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = '+25% [ICON_GOLD] Gold from [ICON_TRADE] City Connections in this City, and +10% [ICON_GOLD] Gold from [ICON_TRADE] City Connections for the rest of other Cities. Turns required to finish [ICON_INTERNATIONAL_TRADE] Trade Routes reduced by 50% in every City. {TXT_KEY_BUILDING_TRAINSTATION} in this City becomes [COLOR_POSITIVE_TEXT]Free[ENDCOLOR].[NEWLINE]
[NEWLINE]+1 [ICON_GOLD] Gold and [ICON_PRODUCTION] Production to all owned Train Stations and Seaports.[NEWLINE]
[NEWLINE]The [ICON_PRODUCTION] Production Cost and [ICON_CITIZEN] Population Requirements increase based on the number of Cities you own.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_CENTRAL_STATION_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'The {TXT_KEY_BUILDING_FA_CENTRAL_STATION} boosts [ICON_GOLD] Gold income generated by [ICON_TRADE] City Connections, and significantly reduces the amount of turns required to finish a [ICON_INTERNATIONAL_TRADE] Trade Route in all Cities. '||
'It also increases the value of Train Stations and Seaports. '||
'The City must have a {TXT_KEY_BUILDING_TRAINSTATION} before it can construct the {TXT_KEY_BUILDING_FA_CENTRAL_STATION}.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_CENTRAL_STATION_STRATEGY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

--=====================================================================================================--
-- Hydroelectric Power Company -> National Electric Company
--=====================================================================================================--
UPDATE Buildings SET
FreeBuilding = 'BUILDINGCLASS_FA_ELECTRIC_POWER', Help = 'TXT_KEY_BUILDING_FA_ELECTRIC_CO_HELP',
DistressFlatReductionGlobal = 1, River = 0, EnhancedYieldTech = 'TECH_ECOLOGY',
IconAtlas = (SELECT IconAtlas FROM Buildings WHERE Type = 'BUILDING_FA_ELECTRIC_POWER'),
PortraitIndex = (SELECT PortraitIndex FROM Buildings WHERE Type = 'BUILDING_FA_ELECTRIC_POWER'),
NumCityCostMod = (SELECT NumCityCostMod FROM Buildings WHERE Type = 'BUILDING_INTELLIGENCE_AGENCY'),
NationalPopRequired = 70,
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_INTELLIGENCE_AGENCY'),
GoldMaintenance = 0,
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_INTELLIGENCE_AGENCY')
WHERE Type = 'BUILDING_FA_ELECTRIC_CO'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Buildings SET
ShowInPedia = 0, EnhancedYieldTech = 'TECH_ECOLOGY',
PrereqTech = (SELECT PrereqTech FROM Buildings WHERE Type = 'BUILDING_FA_ELECTRIC_CO')
WHERE Type = 'BUILDING_FA_ELECTRIC_POWER'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO Building_TechEnhancedYieldChanges
SELECT 'BUILDING_FA_ELECTRIC_CO', 'YIELD_SCIENCE', 8
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1) UNION ALL
SELECT 'BUILDING_FA_ELECTRIC_POWER', 'YIELD_SCIENCE', 2
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_FA_ELECTRIC_CO'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

DELETE FROM Building_YieldChanges
WHERE BuildingType = 'BUILDING_FA_ELECTRIC_POWER'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

INSERT INTO Building_YieldChangesPerPop (BuildingType, YieldType, Yield)
SELECT 'BUILDING_FA_ELECTRIC_POWER', y.Type, 10 FROM Yields y
WHERE y.Type IN ('YIELD_PRODUCTION', 'YIELD_GOLD')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO Building_YieldFromYieldPercentGlobal (BuildingType, YieldIn, YieldOut, Value)
SELECT 'BUILDING_FA_ELECTRIC_CO', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 5
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

INSERT INTO Building_ClassesNeededInCity
SELECT 'BUILDING_FA_ELECTRIC_CO', 'BUILDINGCLASS_FACTORY'
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_BuildingClassHappiness
WHERE BuildingType = 'BUILDING_FA_ELECTRIC_CO'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

DELETE FROM Building_BuildingClassYieldChanges
WHERE BuildingType = 'BUILDING_FA_ELECTRIC_CO'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1 );

INSERT INTO Building_BuildingClassLocalYieldChanges
SELECT DISTINCT b.Type, 'BUILDINGCLASS_FA_ELECTRIC_POWER', y.Type, 1 FROM Buildings b, Yields y
WHERE b.BuildingClass = 'BUILDINGCLASS_FACTORY'
AND y.Type IN ('YIELD_PRODUCTION', 'YIELD_GOLD')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1) UNION ALL

SELECT DISTINCT b.Type, 'BUILDINGCLASS_FA_ELECTRIC_POWER', y.Type, 1 FROM Buildings b, Yields y
WHERE b.MutuallyExclusiveGroup = 1
AND y.Type IN ('YIELD_PRODUCTION', 'YIELD_GOLD')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

CREATE TRIGGER VPMC_FA_ELECTRIC_POWER_FactoryCompatibility
AFTER INSERT ON Civilization_BuildingClassOverrides
WHEN NEW.BuildingClassType = 'BUILDINGCLASS_FACTORY'
AND NEW.BuildingType IS NOT NULL
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1)
BEGIN
        INSERT INTO Building_BuildingClassLocalYieldChanges
        SELECT DISTINCT NEW.BuildingType, 'BUILDINGCLASS_FA_ELECTRIC_POWER', y.Type, 1 FROM Yields y
        WHERE  y.Type IN ('YIELD_PRODUCTION', 'YIELD_GOLD');
END;

CREATE TRIGGER VPMC_FA_ELECTRIC_POWER_PowerPlantCompatibility
AFTER INSERT ON Civilization_BuildingClassOverrides
WHEN NEW.BuildingClassType IN (SELECT BuildingClass FROM Units WHERE MutuallyExclusiveGroup = 1)
AND NEW.BuildingType IS NOT NULL
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1)
BEGIN
        INSERT INTO Building_BuildingClassLocalYieldChanges
        SELECT DISTINCT NEW.BuildingType, 'BUILDINGCLASS_FA_ELECTRIC_POWER', y.Type, 1 FROM Yields y
        WHERE  y.Type IN ('YIELD_PRODUCTION', 'YIELD_GOLD');
END;

INSERT INTO Building_BuildingClassYieldChanges
SELECT DISTINCT 'BUILDING_FA_ELECTRIC_POWER', 'BUILDINGCLASS_FA_ELECTRIC_CO', 'YIELD_GOLD', 1
WHERE EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_Flavors
WHERE BuildingType = 'BUILDING_FA_ELECTRIC_CO' AND FlavorType IN ('FLAVOR_HAPPINESS', 'FLAVOR_GROWTH', 'FLAVOR_WONDER')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Building_FreeUnits
WHERE BuildingType = 'BUILDING_FA_ELECTRIC_CO' AND UnitType = 'UNIT_FA_ELECTRIC_CO'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM UnitClasses
WHERE Type = 'UNITCLASS_FA_ELECTRIC_CO'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

DELETE FROM Units
WHERE Type = 'UNIT_FA_ELECTRIC_CO'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'National Electric Company'
WHERE Tag = 'TXT_KEY_BUILDING_FA_ELECTRIC_CO'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'All Cities receive {TXT_KEY_BUILDING_FA_ELECTRIC_POWER} which provides +1 [ICON_PRODUCTION] Production and [ICON_GOLD] Gold for every 10 [ICON_CITIZEN] Citizens, also from Factories and Power Plants.[NEWLINE]
[NEWLINE]All Cities gain +1 [ICON_RESEARCH] Science for every 20 [ICON_PRODUCTION] Production it generates. +1 [ICON_GOLD] Gold for every {TXT_KEY_BUILDING_FA_ELECTRIC_POWER} in all Cities. +8 [ICON_RESEARCH] Science after discovering [COLOR_CYAN]{TXT_KEY_TECH_ECOLOGY_TITLE}[ENDCOLOR].[NEWLINE]
[NEWLINE]-1 [ICON_HAPPINESS_3] Unhappiness from [ICON_FOOD] or [ICON_PRODUCTION] Distress in all Cities.[NEWLINE]
[NEWLINE]The [ICON_PRODUCTION] Production Cost and [ICON_CITIZEN] Population Requirements increase based on the number of Cities you own.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_ELECTRIC_CO_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'The {TXT_KEY_BUILDING_FA_ELECTRIC_CO} gives all Cities access to {TXT_KEY_BUILDING_FA_ELECTRIC_POWER}, which provides [ICON_PRODUCTION] Production and [ICON_GOLD] Gold bonus based on the size of a City, also from Factory and Power Plant in the City. It generates [ICON_RESEARCH] Science based on overall [ICON_PRODUCTION] Production output of all Cities within the Empire. '||
'Also helps reduces [ICON_HAPPINESS_3] Distress in every City. The City must have a {TXT_KEY_BUILDING_FACTORY} before it can construct the {TXT_KEY_BUILDING_FA_ELECTRIC_CO}.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_ELECTRIC_CO_STRATEGY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = '+1 [ICON_PRODUCTION] Production and [ICON_GOLD] Gold for every 10 [ICON_CITIZEN] Citizens, and from all owned Factories and Power Plants. +2 [ICON_RESEARCH] Science after discovering [COLOR_CYAN]{TXT_KEY_TECH_ECOLOGY_TITLE}[ENDCOLOR].'
WHERE Tag = 'TXT_KEY_BUILDING_FA_ELECTRIC_POWER_HELP'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'The {TXT_KEY_BUILDING_FA_ELECTRIC_CO} generates [ICON_PRODUCTION] Production and [ICON_GOLD] Gold based on the size of a City, and gain additional yield from Factory and Power Plant in the City. '
WHERE Tag = 'TXT_KEY_BUILDING_FA_ELECTRIC_POWER_STRATEGY'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

UPDATE Language_en_US SET
Text = 'Early electric energy was produced near the device or service requiring that energy. '||
'In the 1880s, electricity competed with steam, hydraulics, and especially coal gas. '||
'Coal gas was first produced on customer''s premises but later evolved into gasification plants that enjoyed economies of scale. '||
'In the industrialized world, cities had networks of piped gas, used for lighting. '||
'But gas lamps produced poor light, wasted heat, made rooms hot and smokey, and gave off hydrogen and carbon monoxide. '||
'They also posed a fire hazard. In the 1880s electric lighting soon became advantageous compared to gas lighting.[NEWLINE][NEWLINE]'||
'Electric utility companies established central stations to take advantage of economies of scale and moved to centralized power generation, distribution, and system management. '||
'After the war of the currents was settled in favor of AC power, with long-distance power transmission it became possible to interconnect stations to balance the loads and improve load factors. '||
'Historically, transmission and distribution lines were owned by the same company, but starting in the 1990s, many countries have liberalized the regulation of the electricity market in ways that have led to the separation of the electricity transmission business from the distribution business.'
WHERE Tag = 'TXT_KEY_BUILDING_FA_ELECTRIC_CO_PEDIA'
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

--=====================================================================================================--
-- Ceremony Policy
--=====================================================================================================--
INSERT INTO Policy_BuildingClassHappiness (PolicyType, BuildingClassType, Happiness)
SELECT DISTINCT bch.PolicyType, bc.Type, bch.Happiness FROM BuildingClasses bc, Policy_BuildingClassHappiness bch
WHERE bch.PolicyType = 'POLICY_LEGALISM'
AND bc.Type IN ('BUILDINGCLASS_FA_WAR_ACADEMY', 'BUILDINGCLASS_FA_SEA_ACADEMY', 'BUILDINGCLASS_FA_AIR_ACADEMY', 'BUILDINGCLASS_FA_CENTRAL_BANK', 'BUILDINGCLASS_FA_CENTRAL_STATION', 'BUILDINGCLASS_FA_ELECTRIC_CO')
AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_NATIONAL' AND Value= 1);

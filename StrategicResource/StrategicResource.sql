UPDATE Buildings SET
ConquestProb = (SELECT ConquestProb FROM Buildings WHERE Type = 'BUILDING_RECYCLING_CENTER'),
NeverCapture = (SELECT NeverCapture FROM Buildings WHERE Type = 'BUILDING_RECYCLING_CENTER'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_GRANARY'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_GRANARY'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_GRANARY')
WHERE Type = 'BUILDING_CORRAL' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_RESBUILDING' AND Value= 1);

UPDATE Buildings SET
ConquestProb = (SELECT ConquestProb FROM Buildings WHERE Type = 'BUILDING_RECYCLING_CENTER'),
NeverCapture = (SELECT NeverCapture FROM Buildings WHERE Type = 'BUILDING_RECYCLING_CENTER'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_AQUEDUCT'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_AQUEDUCT'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_AQUEDUCT')
WHERE Type = 'BUILDING_FOUNDRY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_RESBUILDING' AND Value= 1);

UPDATE Buildings SET
ConquestProb = (SELECT ConquestProb FROM Buildings WHERE Type = 'BUILDING_RECYCLING_CENTER'),
NeverCapture = (SELECT NeverCapture FROM Buildings WHERE Type = 'BUILDING_RECYCLING_CENTER'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_TRAINSTATION'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_TRAINSTATION'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_TRAINSTATION')
WHERE Type = 'BUILDING_DEEP_MINE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_RESBUILDING' AND Value= 1);

UPDATE Buildings SET
ConquestProb = (SELECT ConquestProb FROM Buildings WHERE Type = 'BUILDING_RECYCLING_CENTER'),
NeverCapture = (SELECT NeverCapture FROM Buildings WHERE Type = 'BUILDING_RECYCLING_CENTER'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_MEDICAL_LAB'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_MEDICAL_LAB'),
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_MEDICAL_LAB')
WHERE Type = 'BUILDING_BIOFUEL_REFINERY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_RESBUILDING' AND Value= 1);

UPDATE Buildings SET
ConquestProb = (SELECT ConquestProb FROM Buildings WHERE Type = 'BUILDING_RECYCLING_CENTER'),
NeverCapture = (SELECT NeverCapture FROM Buildings WHERE Type = 'BUILDING_RECYCLING_CENTER'),
Cost = (SELECT Cost FROM Buildings WHERE Type = 'BUILDING_SPACESHIP_FACTORY'),
GoldMaintenance = (SELECT GoldMaintenance FROM Buildings WHERE Type = 'BUILDING_SPACESHIP_FACTORY') + 2,
HurryCostModifier = (SELECT HurryCostModifier FROM Buildings WHERE Type = 'BUILDING_SPACESHIP_FACTORY')
WHERE Type = 'BUILDING_ENRICHMENT_FACILITY' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='CBPMC_RESBUILDING' AND Value= 1);

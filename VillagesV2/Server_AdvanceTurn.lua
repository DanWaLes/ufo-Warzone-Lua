require('UI');
function Server_AdvanceTurn_Start(game, addNewOrder, rootParent)
data = Mod.PublicGameData;
for p, _ in pairs(game.Game.PlayingPlayers) do
 data.Counters[p] = 0;
end
end

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
if order.proxyType == "GameOrderAttackTransfer" then
  if orderResult.IsAttack and UnitCount(game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies, 'Capitalist') then
    if DeadUnit(orderResult.DefendingArmiesKilled, 'Capitalist') then
      local p = order.PlayerID; -- the attacker
      local currentIncome = game.Game.PlayingPlayers[p].Income(0, game.ServerGame.LatestTurnStanding, false, false);
      local IncomeAmount = currentIncome.Total;
      IncomeAmount = IncomeAmount * (0.20);
      addNewOrder(WL.GameOrderEvent.Create(p, "Updated income", {}, {terrMod}, {}, {WL.IncomeMod.Create(p, -IncomeAmount, "You have killed a Capitalist and have been sanctioned")}));	
    end
  end
end

if order.proxyType == "GameOrderAttackTransfer" then
  if orderResult.IsAttack and UnitCount(game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies, 'Diplomat') then
    if DeadUnit(orderResult.DefendingArmiesKilled, 'Diplomat') then
      local p = order.PlayerID; -- the attacker
      local p2 = game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID; --player that was attacked
      if game.Settings.Cards ~= nil then
        if game.Settings.Cards[WL.CardID.Diplomacy] ~= nil then
            local instance = WL.NoParameterCardInstance.Create(WL.CardID.Diplomacy);
            addNewOrder(WL.GameOrderReceiveCard.Create(p, {instance}));
            addNewOrder(WL.GameOrderPlayCardDiplomacy.Create(instance.ID, p, p, p2));
        end
      end
    end
  end
end

if order.proxyType == "GameOrderAttackTransfer" then
  if orderResult.IsAttack and DeadUnit(game.ServerGame.LatestTurnStanding.Territories[order.From].NumArmies, 'Priest') then
    local fromTerr = game.ServerGame.LatestTurnStanding.Territories[order.From]; 
    local terrMod = WL.TerritoryModification.Create(order.From);
    local p = fromTerr.OwnerPlayerID;
    terrMod.AddArmies = round(orderResult.AttackingArmiesKilled.NumArmies * (10 / 100));
    if terrMod.AddArmies ~= nil and terrMod.AddArmies > 0 then
      local event = WL.GameOrderEvent.Create(p, "priest converted " .. terrMod.AddArmies .. " armies", {}, {terrMod});
      addNewOrder(event, true);
    end
  end 	
  if orderResult.IsAttack and DeadUnit(game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies, 'Priest') then
    if(orderResult.IsSuccessful == false)then
      local toTerr = game.ServerGame.LatestTurnStanding.Territories[order.To]; 
      local terrMod = WL.TerritoryModification.Create(order.To);
      local p;
      terrMod.AddArmies = round(orderResult.AttackingArmiesKilled.NumArmies * (20 / 100));
      p = toTerr.OwnerPlayerID;
      if terrMod.AddArmies ~= nil and terrMod.AddArmies > 0 then
        local event = WL.GameOrderEvent.Create(p, "priest converted " .. terrMod.AddArmies .. " of the attacking armies", {}, {terrMod});
        addNewOrder(event, true);
      end
    end 
  end
	
end

if (order.proxyType == 'GameOrderCustom') then
  if (startsWith(order.Payload, 'GetCapitalist_')) then
    local terrID = tonumber(string.sub(order.Payload, 15));
    if terrID ~= nil then
      SpecialUnit(terrID, addNewOrder, order, game, 'Capitalist', 'piggy-bank.png'); 
    end 
  end
  if (startsWith(order.Payload, 'GetMedic_')) then
    local terrID = tonumber(string.sub(order.Payload, 10));
    if terrID ~= nil then
      SpecialUnit(terrID, addNewOrder, order, game, 'Medic', 'Medic.png'); 
    end 
  end
  if (startsWith(order.Payload, 'GetDiplomat_')) then
    local terrID = tonumber(string.sub(order.Payload, 13));
    if terrID ~= nil then
      SpecialUnit(terrID, addNewOrder, order, game, 'Diplomat', 'truce.png'); 
    end 
  end
  if (startsWith(order.Payload, 'GetPriest_')) then
    local terrID = tonumber(string.sub(order.Payload, 11));
    if terrID ~= nil then
      SpecialUnit(terrID, addNewOrder, order, game, 'Priest', 'robe.png'); 
    end 
  end
end
end   

function Server_AdvanceTurn_End(game, addNewOrder, rootParent)

local list = {};
for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
local terrSelected = game.ServerGame.LatestTurnStanding.Territories[terrID];
  if terrSelected.Structures ~= nil then
    if terrSelected.Structures[WL.StructureType.Market] ~= nil then
      if (terrSelected.IsNeutral == false) then
        local terrdata = tostring(terrID); 
        addNewOrder(WL.GameOrderCustom.Create(terrSelected.OwnerPlayerID, 'custom order', 'GetCapitalist_' .. terrdata , {}));
        			
      end
    end
    if terrSelected.Structures[WL.StructureType.Hospital] ~= nil then
      if (terrSelected.IsNeutral == false) then
        local terrdata = tostring(terrID); 
        addNewOrder(WL.GameOrderCustom.Create(terrSelected.OwnerPlayerID, 'custom order', 'GetMedic_' .. terrdata , {}));
        		
      end
    end
    if terrSelected.Structures[WL.StructureType.Recipe] ~= nil then
      if (terrSelected.IsNeutral == false) then
        local terrdata = tostring(terrID); 
        addNewOrder(WL.GameOrderCustom.Create(terrSelected.OwnerPlayerID, 'custom order', 'GetDiplomat_' .. terrdata , {}));
        			
      end
    end
    if terrSelected.Structures[WL.StructureType.Arena] ~= nil then
      if (terrSelected.IsNeutral == false) then
        local terrdata = tostring(terrID); 
        addNewOrder(WL.GameOrderCustom.Create(terrSelected.OwnerPlayerID, 'custom order', 'GetPriest_' .. terrdata , {}));
        			
      end
    end
    if (terrSelected.Structures[WL.StructureType.MercenaryCamp] ~= nil) and (terrSelected.IsNeutral == false) then --finds each territory ID of territories with a merc camp
     if data.Markets[terrSelected.OwnerPlayerID] > 0 then
        data.Markets[terrSelected.OwnerPlayerID] = data.Markets[terrSelected.OwnerPlayerID] - 1;
        CreateStructure(terrID, terrSelected, addNewOrder, WL.StructureType.Market);
      elseif data.Hospitals[terrSelected.OwnerPlayerID] > 0 then
        data.Hospitals[terrSelected.OwnerPlayerID] = data.Hospitals[terrSelected.OwnerPlayerID] - 1;
        CreateStructure(terrID, terrSelected, addNewOrder, WL.StructureType.Hospital);
      elseif data.Embassys[terrSelected.OwnerPlayerID] > 0 then
        data.Embassys[terrSelected.OwnerPlayerID] = data.Embassys[terrSelected.OwnerPlayerID] - 1;
        CreateStructure(terrID, terrSelected, addNewOrder, WL.StructureType.Recipe);     	    	
      elseif data.Markets[terrSelected.OwnerPlayerID] > 0 then
        data.Churchs[terrSelected.OwnerPlayerID] = data.Churchs[terrSelected.OwnerPlayerID] - 1;
        CreateStructure(terrID, terrSelected, addNewOrder, WL.StructureType.Arena);
      else  
	data.Counters[terrSelected.OwnerPlayerID] = data.Counters[terrSelected.OwnerPlayerID] + 1;							
     end	 
    end
end end
--local count = 0;
--for times = 1, #list do
   
--local rand = math.random(#list);
--local terrSelected = game.ServerGame.LatestTurnStanding.Territories[list[rand]];

 --if data.Markets[terrSelected.OwnerPlayerID] > 0 then
   --print(10);
   --data.Markets[terrSelected.OwnerPlayerID] = data.Markets[terrSelected.OwnerPlayerID] - 1;
   --CreateMarket(rand, terrSelected, addNewOrder);
   --table.remove(list, rand);
   --break;
 --end 
Mod.PublicGameData = data;
end

function CreateStructure(terrID, terrSelected, addNewOrder, struct)
    print(100);
    local terrMod = WL.TerritoryModification.Create(terrID);
    structures = {};
    structures[WL.StructureType.MercenaryCamp] = -1; 
    structures[struct] = 1;	
    terrMod.AddStructuresOpt = structures;
    addNewOrder(WL.GameOrderEvent.Create(terrSelected.OwnerPlayerID , 'Renovated Village', {}, {terrMod}));
end


function SpecialUnit(terrID, addNewOrder, order, game, name, filename)

local terrSelected = game.ServerGame.LatestTurnStanding.Territories[terrID];
local targetTerritoryID = terrID;		 		 		
local numUnitsAlreadyHave = 0;		
for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do			
if (ts.OwnerPlayerID == order.PlayerID) then				
numUnitsAlreadyHave = numUnitsAlreadyHave + UnitCount(ts.NumArmies, name);			
end		
end 		
if (numUnitsAlreadyHave >= 5) then			
addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping '.. name .. ' creation since maximum is 5'));			
return; --this player already has the maximum number of Capitalists possible, so skip adding a new one.
end	
local builder = WL.CustomSpecialUnitBuilder.Create(terrSelected.OwnerPlayerID);		
builder.Name = name;		
builder.IncludeABeforeName = true;		
builder.ImageFilename = filename;		
builder.AttackPower = 1;		
builder.DefensePower = 1;		
builder.CombatOrder = 1234; --defends commanders		
builder.DamageToKill = 1;		
builder.DamageAbsorbedWhenAttacked = 1;		
builder.CanBeGiftedWithGiftCard = true;		
builder.CanBeTransferredToTeammate = true;		
builder.CanBeAirliftedToSelf = true;		
builder.CanBeAirliftedToTeammate = true;		
builder.IsVisibleToAllPlayers = false;			
local terrMod = WL.TerritoryModification.Create(targetTerritoryID);		
terrMod.AddSpecialUnits = {builder.Build()};				
addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a ' .. name, {}, {terrMod}));		
end

function UnitCount(armies, name)
local ret = 0;	
 for _,su in pairs(armies.SpecialUnits) do		
  if (su.proxyType == 'CustomSpecialUnit' and su.Name == name) then			
   ret = ret + 1;		
  end	
 end	
return ret;
end

function DeadUnit(army, name)
    for _, su in pairs(army.SpecialUnits) do
        if su.proxyType == "CustomSpecialUnit" and su.Name == name then
            return true;
        end
    end
    return false;
end

function getTableLength(t)
	local a = 0;
	for i, _ in pairs(t) do
		
		a = a + 1;
	end
	return a;
end


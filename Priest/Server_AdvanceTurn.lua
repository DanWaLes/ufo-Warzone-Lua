require('Utilities');

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'BuyPriest_')) then  --look for the order that we inserted in Client_PresentCommercePurchaseUI

		--in Client_PresentMenuUI, we stuck the territory ID after BuyPriest_.  Break it out and parse it to a number.
		local targetTerritoryID = tonumber(string.sub(order.Payload, 11));
		print(string.sub(order.Payload, 11));
		local targetTerritoryStanding = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID];

		if (targetTerritoryStanding.OwnerPlayerID ~= order.PlayerID) then
			return; --can only buy a priest onto a territory you control
		end

		
		if (order.CostOpt == nil) then
			return; --shouldn't ever happen, unless another mod interferes
		end

		local costFromOrder = order.CostOpt[WL.ResourceType.Gold]; --this is the cost from the order.  We can't trust this is accurate, as someone could hack their client and put whatever cost they want in there.  Therefore, we must calculate it ourselves, and only do the purchase if they match

		local realCost = Mod.Settings.CostToBuyPriest;

		if (realCost > costFromOrder) then
			return; --don't do the purchase if their cost didn't line up.  This would only really happen if they hacked their client or another mod interfered
		end

		local numPriestsAlreadyHave = 0;
		for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do
			if (ts.OwnerPlayerID == order.PlayerID) then
				numPriestsAlreadyHave = numPriestsAlreadyHave + NumPriestsIn(ts.NumArmies);
			end
		end

		if (numPriestsAlreadyHave >= Mod.Settings.MaxPriests) then
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping priest purchase since max is ' .. Mod.Settings.MaxPriests .. ' and you have ' .. numPriestsAlreadyHave));
			return; --this player already has the maximum number of priests possible, so skip adding a new one.
		end

		local priestPower = Mod.Settings.PriestPower;

		local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID);
		builder.Name = 'Priest';
		builder.IncludeABeforeName = true;
		builder.ImageFilename = 'robe.png';
		builder.AttackPower = priestPower;
		builder.DefensePower = priestPower;
		builder.CombatOrder = 3415; --defends commanders
		builder.DamageToKill = priestPower;
		builder.DamageAbsorbedWhenAttacked = priestPower;
		builder.CanBeGiftedWithGiftCard = true;
		builder.CanBeTransferredToTeammate = true;
		builder.CanBeAirliftedToSelf = true;
		builder.CanBeAirliftedToTeammate = true;
		builder.IsVisibleToAllPlayers = false;
	
		local terrMod = WL.TerritoryModification.Create(targetTerritoryID);
		terrMod.AddSpecialUnits = {builder.Build()};
		
		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a priest', {}, {terrMod}));
	end
end

function NumPriestsIn(armies)
	local ret = 0;
	for _,su in pairs(armies.SpecialUnits) do
		if (su.proxyType == 'CustomSpecialUnit' and su.Name == 'Priest') then
			ret = ret + 1;
		end
	end
	return ret;
end

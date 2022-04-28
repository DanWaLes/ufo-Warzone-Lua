require('Utilities');
require('WLUtilities');

function Server_EndTurn_Order(game, order, result, skipThisOrder, addNewOrder)
	
      local terr = {};
for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
  if (territory.OwnerPlayerID == WL.PlayerID.Neutral) then
    terr[#terr+1] = terrID;
  end
end
for i=1,Mod.Settings.NumToConvert do
     randomNeutralTerr = neutralTerr[Math.random(#neutralTerr)];
	terrMod = WL.TerritoryModification.Create(randomNeutralTerr);
	terrMod.SetOwnerOpt=terr.OwnerPlayerID;
	terrMod.SetArmiesTo = game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies.NumArmies;
	addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID,"new territory",{},{terrMod}));
		
  
  game.ServerGame.LatestTurnStanding.Territories[randomNeutralTerr].OwnerPlayerID = PlayerID;
end
	
end

require('LoreBook');
Alerted = false;

function Client_GameRefresh(game)
 local data = Mod.PublicGameData; 
	if (not Alerted and not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use the Special Units Structures modpack");
        Alerted = true;
	end
	if(game.Us == nil)then
		return;
	end
  	if game.Game.TurnNumber >= 2 then
         	local advert = advert();
         	UI.Alert(advert);		
   	end	 
for p, _ in pairs(game.Game.PlayingPlayers) do
 if data.Gullible[p] == true then
	local name = p.DisplayName(nil, false)	
	UI.Alert(name .. " is Gullible");
 end
end
end

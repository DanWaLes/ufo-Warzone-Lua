
function Client_PresentConfigureUI(rootParent, rootParent2)
	print(1);
	local initialValueConvert = Mod.Settings.NumToConvert;
	local initialValueArmies = Mod.Settings.SetArmiesTo;
	
	if initialValueConvert == nil then
		initialValueConvert = 2;
	end
	
	if initialValueArmies == nil then
		initialValueArmies = 2;
	end
    
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
    local vertical = UI.CreateVerticalLayoutGroup(rootParent);
	
	UI.CreateLabel(horz).SetText('amount of neutrals a player shall gain each turn');
    numberInputField = UI.CreateNumberInputField(horz)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(initialValueConvert);
	
	    
	UI.CreateLabel(horz).SetText('amount of armies a player shall get with the territory');
    numberInputField = UI.CreateNumberInputField(horz)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(initialValueArmies);

end

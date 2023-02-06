require("UI");

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close) 
Game = game;
Init(rootParent);    
    setMaxSize(500, 400);
    setSize = setMaxSize;

    if game.Us == nil then
       return; 
    end
    if game.Game.TurnNumber < 1 then	
       UI.Alert("This mod cannot be used in the distribution turn");		
       close();		
       return;	
    end	 
    showMenu(game);
end

function showMenu(game)
  DestroyWindow();
  SetWindow("Main");

    local vert = CreateVert(GetRoot());
    local horz = CreateHorz(GetRoot());
    CreateLabel(vert).SetText('This is the main menu screen, select the buttons below related on what you want to do.').SetColor('#606060');
    CreateButton(horz).SetText("Shop").SetOnClick(shopMenu).SetColor('#00FF8C');
    CreateButton(horz).SetText("Battlepass").SetOnClick(BPMenu);
    CreateButton(horz).SetText("Credits").SetOnClick(showCredits).SetColor('#C04000');
end

function shopMenu(game)
  DestroyWindow();
  SetWindow("Shop");

  local vert = CreateVert(GetRoot());
  local horz = CreateHorz(GetRoot());
  CreateLabel(vert).SetText('Welcome to the Warzone Shop, here you can buy items to give you an advantage in game!').SetColor('#606060');
   CreateButton(horz).SetText("Camouflage Green colour").SetOnClick(delayMenu(3)).SetColor('#FFF700');
  CreateButton(horz).SetText("A will to live!").SetOnClick(delayMenu(100)).SetColor('#FFF700');
   CreateButton(horz).SetText("Buy Armies").SetOnClick(delayMenu(4)).SetColor('#FFF700');
   CreateButton(horz).SetText("Buy Fizzium coins").SetOnClick(delayMenu(2)).SetColor('#FFF700');
  CreateButton(GetRoot()).SetText("Return").SetOnClick(menuReturn).SetColor('#94652E');
end

function delayMenu(number)
  DestroyWindow();
  SetWindow("delay");

  local vert = CreateVert(GetRoot());
  local horz = CreateHorz(GetRoot());
  CreateLabel(vert).SetText('This item has been delayed till Season ".. .., stay tuned!').SetColor('#606060');
  CreateButton(GetRoot()).SetText("Return").SetOnClick(shopReturn).SetColor('#94652E');
end

function BPMenu(game)
  DestroyWindow();
  SetWindow("BattlePass");

  local vert = CreateVert(GetRoot());
  local horz = CreateHorz(GetRoot());
  CreateLabel(vert).SetText('We are trying our best to get the battlepass out as soon as possible... stay tuned on our social media!').SetColor('#606060');
  CreateButton(GetRoot()).SetText("Return").SetOnClick(menuReturn).SetColor('#94652E');
end

function showCredits()
DestroyWindow();
SetWindow("Credits"); 
  local vert = CreateVert(GetRoot());
  local horz = CreateHorz(GetRoot());
  CreateLabel(vert).SetText('Thanks for playing, Hope you arent too annoyed by the mod :)');
  CreateTextInputField(vert).SetText('https://discord.gg/hqGkVXagyt');  
  CreateLabel(vert).SetText('Creator: UnFairerOrb76 (UFO)');   
  CreateButton(GetRoot()).SetText("Return").SetOnClick(menuReturn).SetColor('#94652E'); 
end

function menuReturn()
  showMenu(Game);
end
function shopReturn()
  shopMenu(Game);
end

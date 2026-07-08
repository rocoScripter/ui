local plrs = cloneref(game:GetService("Players"))
local uis = cloneref(game:GetService("UserInputService"))
local run = cloneref(game:GetService("RunService"))
local tween_service = cloneref(game:GetService("TweenService"))
local http_service = cloneref(game:GetService('HttpService'))
local text_service = cloneref(game:GetService("TextService"))
local core_gui = cloneref(game:GetService("CoreGui"))
local teams = cloneref(game:GetService("Teams"))
local rgb = Color3.fromRGB
local insert = table.insert
local vec2 = Vector2.new
local dim2 = UDim2.new
local dim = UDim.new
local rect = Rect.new
local dim_offset = UDim2.fromOffset
local color = Color3.new
local lp = plrs.LocalPlayer
local mouse = lp:GetMouse()
local max = math.max
local floor = math.floor
local min = math.min
local random = math.random
local clamp = math.clamp;
local ceil = math.ceil;
local find = table.find
local remove = table.remove
local concat = table.concat

do
--library init
pcall(function()
    local ExistingGui = core_gui:FindFirstChild('LinoriaUI');
    if ExistingGui then
        ExistingGui:Destroy();
    end;
end);

local ScreenGui = Instance.new('ScreenGui');

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
ScreenGui.DisplayOrder = 999999;
ScreenGui.Parent = core_gui;
ScreenGui.Name = 'LinoriaUI'

local Toggles = {};
local Options = {};

getgenv().Toggles = Toggles
getgenv().Options = Options

local Library = {
    directory = "atlas",
    folders = {
        "/configs",
        "/assets",
        "/assets/fonts",
        "/assets/sounds",
        "/themes",
        "/log",
    },

    Registry = {},
    RegistryMap = {},
    ActiveRegistry = {},

    HudRegistry = {},

    FontColor = rgb(255, 255, 255),
    MainColor = rgb(14, 12, 12),
    BackgroundColor = rgb(14, 12, 12),
    AccentColor = rgb(119, 150, 214),
    OutlineColor = rgb(26, 21, 21),
    RiskColor = rgb(255, 50, 500),

    Black = color(0, 0, 0),
    DefaultFont = Enum.Font.SourceSans,

    GlowEnabled = true,
    GlowColor = rgb(0, 85, 255),
    GlowTransparency = 0.5,
    GlowSize = 45,
    GlowColorMatchAccent = true,

    OpenedFrames = {},
    DependencyBoxes = {},

    Signals = {},
    ScreenGui = ScreenGui,
    GlowInstances = {},
};

Library.Keys = {
    [Enum.KeyCode.LeftShift] = "LS",
    [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.LeftControl] = "LC",
    [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Insert] = "INS",
    [Enum.KeyCode.Backspace] = "BS",
    [Enum.KeyCode.Return] = "Ent",
    [Enum.KeyCode.LeftAlt] = "LA",
    [Enum.KeyCode.RightAlt] = "RA",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.KeypadOne] = "Num1",
    [Enum.KeyCode.KeypadTwo] = "Num2",
    [Enum.KeyCode.KeypadThree] = "Num3",
    [Enum.KeyCode.KeypadFour] = "Num4",
    [Enum.KeyCode.KeypadFive] = "Num5",
    [Enum.KeyCode.KeypadSix] = "Num6",
    [Enum.KeyCode.KeypadSeven] = "Num7",
    [Enum.KeyCode.KeypadEight] = "Num8",
    [Enum.KeyCode.KeypadNine] = "Num9",
    [Enum.KeyCode.KeypadZero] = "Num0",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.RightParenthesis] = ")",
    [Enum.KeyCode.LeftParenthesis] = "(",
    [Enum.KeyCode.Semicolon] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
    [Enum.KeyCode.Escape] = "ESC",
    [Enum.KeyCode.Space] = "SPC",
}

function Library:NormalizeKey(Key)
    if Key == Enum.UserInputType.MouseButton1 then
        return "mb1"
    elseif Key == Enum.UserInputType.MouseButton2 then
        return "mb2"
    elseif Key == Enum.UserInputType.MouseButton3 then
        return "mb3"
    elseif type(Key) ~= "string" then
        return Key and Key.Name and Key.Name:lower() or Key
    end

    local LowerKey = Key:lower()
    if LowerKey == "none" then
        return "none"
    end

    for Input, Label in next, Library.Keys do
        if LowerKey == tostring(Label):lower() or LowerKey == Input.Name:lower() then
            return Library:NormalizeKey(Input)
        end
    end

    return LowerKey
end

function Library:GetKeyCode(Key)
    local NormalizedKey = Library:NormalizeKey(Key)
    if type(NormalizedKey) ~= "string" then
        return nil
    end

    for _, KeyCode in next, Enum.KeyCode:GetEnumItems() do
        if KeyCode.Name:lower() == NormalizedKey then
            return KeyCode
        end
    end
end

function Library:GetKeyName(Key)
    local NormalizedKey = Library:NormalizeKey(Key)
    if NormalizedKey == "none" then
        return "None"
    elseif NormalizedKey == "mb1" then
        return Library.Keys[Enum.UserInputType.MouseButton1]
    elseif NormalizedKey == "mb2" then
        return Library.Keys[Enum.UserInputType.MouseButton2]
    elseif NormalizedKey == "mb3" then
        return Library.Keys[Enum.UserInputType.MouseButton3]
    end

    local KeyCode = Library:GetKeyCode(NormalizedKey)
    if KeyCode then
        return Library.Keys[KeyCode] or KeyCode.Name
    end

    return tostring(Key)
end

function Library:GetKeybindHudKey(Key)
    if Library:NormalizeKey(Key) == "none" then
        return "none"
    end
    return string.lower(Library:GetKeyName(Key))
end

Library.KeybindHudNames = {
    TargetAimbotKeybind = "target aim keybind",
    ConnectionExploitKeybind = "connection exploit",
    TargetStrafeKeybind = "target strafe",
    ClientMods_CFrameBind = "cframe",
    ClientMods_FlyBind = "fly",
    ClientMods_WalkSpeedBind = "walkspeed",
    ClientMods_JumpPowerBind = "jumppower",
    VelocitySpooferKeybind = "velocity spoofer",
    AntiAimKeybind = "anti-aim",
    AutoKillResolverKeybind = "auto killer resolver",
    ResolverKeybind = "target aim resolver",
    FlameExploitKeybind = "flame exploit",
    MenuKeybind = "menu bind",
}

function Library:GetKeybindHudLabel(Idx, Info, ParentObj)
    if Info.Text and Info.Text ~= "" then
        return string.lower(Info.Text)
    end
    if Library.KeybindHudNames[Idx] then
        return Library.KeybindHudNames[Idx]
    end
    if ParentObj and ParentObj.TextLabel and ParentObj.TextLabel.Text ~= "" then
        return string.lower(ParentObj.TextLabel.Text)
    end
    return string.lower(Idx)
end

function Library:UpdateKeybindFrame()
    if not Library.KeybindContainer then
        return
    end

    local ySize = 0
    local xSize = 0

    for _, label in next, Library.KeybindContainer:GetChildren() do
        if label:IsA("TextLabel") and label.Visible then
            ySize = ySize + 15
            if label.TextBounds.X > xSize then
                xSize = label.TextBounds.X
            end
        end
    end

    Library.KeybindFrame.Size = dim2(0, max(xSize + 16, 170), 0, ySize + 26)
end

function connect(Signal, Callback)
    return Library:Connect(Signal, Callback)
end

if not isfolder(Library.directory) then
    makefolder(Library.directory);
end;

for _, folder in next, Library.folders do
    local path = Library.directory .. folder;

    if not isfolder(path) then
        makefolder(path);
    end;
end;

if not isfolder(Library.directory .. "/fonts") then
    makefolder(Library.directory .. "/fonts")
end

pcall(function()
    Library.TahomaFontPath = Library.directory .. "/fonts/main.ttf"
    Library.TahomaFontMetaPath = Library.directory .. "/fonts/main_encoded.ttf"

    if not isfile(Library.TahomaFontPath) then
        writefile(Library.TahomaFontPath, game:HttpGet("https://github.com/rocoScripter/font/raw/refs/heads/main/tahoma.ttf"))
    end

    writefile(Library.TahomaFontMetaPath, http_service:JSONEncode({
        name = "Tahoma",
        faces = {
            {
                name = "Bold",
                weight = Enum.FontWeight.Bold.Value,
                style = "normal",
                assetId = getcustomasset(Library.TahomaFontPath),
            },
        },
    }))

    Library.FontFace = Font.new(getcustomasset(Library.TahomaFontMetaPath), Enum.FontWeight.Bold)
end)

local RainbowStep = 0
local Hue = 0

local rainbowTick = LPH_NO_VIRTUALIZE(function(dt)
    RainbowStep = RainbowStep + dt

    if RainbowStep >= (1 / 60) then
        RainbowStep = 0

        Hue = Hue + (1 / 400);

        if Hue > 1 then
            Hue = 0;
        end;

        Library.CurrentRainbowHue = Hue;
        Library.CurrentRainbowColor = Color3.fromHSV(Hue, 0.8, 1);
    end
end)

local function GetPlayersString()
    local success, PlayerList = pcall(function()
        return plrs:GetPlayers();
    end);

    if not success or type(PlayerList) ~= "table" then
        return {};
    end;

    for i, Player in PlayerList do
        local Name = tostring(Player.Name);
        local DisplayName = tostring(Player.DisplayName or Player.Name):lower();
        PlayerList[i] = {
            Name = Name;
            DisplayName = DisplayName;
            Label = string.format('%s (@%s)', DisplayName, Name);
        };
    end;

    table.sort(PlayerList, function(PlayerA, PlayerB)
        local DisplayA = PlayerA.DisplayName:lower();
        local DisplayB = PlayerB.DisplayName:lower();

        if DisplayA == DisplayB then
            return PlayerA.Name:lower() < PlayerB.Name:lower();
        end;

        return DisplayA < DisplayB;
    end);

    for i, Player in PlayerList do
        PlayerList[i] = Player.Label;
    end;

    return PlayerList;
end;

local function GetPlayerNameFromDisplayLabel(Label)
    return tostring(Label):match('%(@([^%)]+)%)$') or Label;
end;

local function FindPlayerByName(name)
    if not name or name == "" then
        return nil
    end
    local player = plrs:FindFirstChild(name)
    if player then
        return player
    end
    local lower = name:lower()
    for _, candidate in ipairs(plrs:GetPlayers()) do
        if candidate.Name:lower() == lower then
            return candidate
        end
    end
    return nil
end;

local function GetTeamsString()
    local TeamList = teams:GetTeams();

    for i = 1, #TeamList do
        TeamList[i] = TeamList[i].Name;
    end;

    table.sort(TeamList, function(str1, str2) return str1 < str2 end);

    return TeamList;
end;

function Library:WriteLog(msg)
    pcall(function()
        appendfile(self.directory .. "/log/errors.log", "[" .. os.date("!%Y-%m-%d %H:%M:%S") .. "] " .. msg .. "\n")
    end)
end

function Library:SafeCallback(f, ...)
    if (not f) then
        return;
    end;

    if not Library.NotifyOnError then
        return f(...);
    end;

    local success, event = pcall(f, ...);

    if not success then
        Library:WriteLog("SafeCallback error: " .. tostring(event))

        local _, i = event:find(":%d+: ");

        if not i then
            return Library:Notify(event);
        end;

        return Library:Notify(event:sub(i + 1), 3);
    end;
end;

function Library:AttemptSave()
    if Library.SaveManager then
        Library.SaveManager:Save();
    end;
end;

function Library:Create(Class, Properties)
    local _Instance = Class;

    if type(Class) == 'string' then
        _Instance = Instance.new(Class);
    end;

    for Property, Value in next, Properties do
        _Instance[Property] = Value;
    end;

    if Library.FontFace and ( _Instance:IsA("TextLabel") or _Instance:IsA("TextButton") or _Instance:IsA("TextBox") ) then
        _Instance.FontFace = Library.FontFace;
    end;

    return _Instance;
end;

function Library:ApplyTextStroke(Inst)
    Inst.TextStrokeTransparency = 1;

    Library:Create('UIStroke', {
        Color = color(0, 0, 0);
        Thickness = 1;
        LineJoinMode = Enum.LineJoinMode.Miter;
        Parent = Inst;
    });
end;

function Library:CreateLabel(Properties, IsHud)
    local _Instance = Library:Create('TextLabel', {
        BackgroundTransparency = 1;
        Font = Library.DefaultFont;
        TextColor3 = Library.FontColor;
        TextSize = 16;
        TextStrokeTransparency = 0;
    });

    if Library.FontFace then
        _Instance.FontFace = Library.FontFace;
    end;

    Library:ApplyTextStroke(_Instance);

    Library:AddToRegistry(_Instance, {
        TextColor3 = 'FontColor';
    }, IsHud);

    return Library:Create(_Instance, Properties);
end;

function Library:MakeDraggable(Instance, Cutoff)
    Instance.Active = true;

local DragPreview = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BackgroundTransparency = 0.75;
        BorderColor3 = Library.AccentColor;
        BorderSizePixel = 2;
        Size = Instance.Size;
        Position = Instance.Position;
        AnchorPoint = Instance.AnchorPoint;
        Visible = false;
        ZIndex = 1000;
        Parent = ScreenGui;
    });

    Library:AddToRegistry(DragPreview, {
        BackgroundColor3 = 'AccentColor';
        BorderColor3 = 'AccentColor';
    });

    Instance.InputBegan:Connect(function(Input)
        if Instance:GetAttribute("NoDrag") then
            return
        end

        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ObjPos = vec2(
                mouse.X - Instance.AbsolutePosition.X,
                mouse.Y - Instance.AbsolutePosition.Y
            );

            if ObjPos.Y > (Cutoff or 40) then
                return;
            end;

DragPreview.Size = Instance.Size;
            DragPreview.Position = Instance.Position;
            DragPreview.AnchorPoint = Instance.AnchorPoint;
            DragPreview.Visible = true;

            while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                if Instance:GetAttribute("NoDrag") then
                    DragPreview.Visible = false;
                    return;
                end;

                DragPreview.Position = dim2(
                    0,
                    mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
                    0,
                    mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
                );

                render_stepped:Wait();
            end;

Instance.Position = DragPreview.Position;
            DragPreview.Visible = false;
        end;
    end)
end;

function Library:AddToolTip(InfoStr, HoverInstance)
    local X, Y = Library:GetTextBounds(InfoStr, Library.DefaultFont, 14);
    local Tooltip = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor,
        BorderColor3 = Library.OutlineColor,

        Size = dim_offset(X + 5, Y + 4),
        ZIndex = 100,
        Parent = Library.ScreenGui,

        Visible = false,
    })

    local Label = Library:CreateLabel({
        Position = dim_offset(3, 1),
        Size = dim_offset(X, Y);
        TextSize = 14;
        Text = InfoStr,
        TextColor3 = Library.FontColor,
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = Tooltip.ZIndex + 1,

        Parent = Tooltip;
    });

    Library:AddToRegistry(Tooltip, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });

    Library:AddToRegistry(Label, {
        TextColor3 = 'FontColor',
    });

    local IsHovering = false

    HoverInstance.MouseEnter:Connect(function()
        if Library:MouseIsOverOpenedFrame() then
            return
        end

        IsHovering = true

        Tooltip.Position = dim_offset(mouse.X + 15, mouse.Y + 12)
        Tooltip.Visible = true

        while IsHovering do
            run.Heartbeat:Wait()
            Tooltip.Position = dim_offset(mouse.X + 15, mouse.Y + 12)
        end
    end)

    HoverInstance.MouseLeave:Connect(function()
        IsHovering = false
        Tooltip.Visible = false
    end)
end

function Library:OnHighlight(HighlightInstance, Instance, Properties, PropertiesDefault)
    HighlightInstance.MouseEnter:Connect(function()
        local Reg = Library.RegistryMap[Instance];

        for Property, ColorIdx in next, Properties do
            local TargetValue = Library[ColorIdx] or ColorIdx;

            tween_service:Create(Instance, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                [Property] = TargetValue
            }):Play();

            if Reg and Reg.Properties[Property] then
                Reg.Properties[Property] = ColorIdx;
            end;
        end;
    end)

    HighlightInstance.MouseLeave:Connect(function()
        local Reg = Library.RegistryMap[Instance];

        for Property, ColorIdx in next, PropertiesDefault do
            local TargetValue = Library[ColorIdx] or ColorIdx;

            tween_service:Create(Instance, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                [Property] = TargetValue
            }):Play();

            if Reg and Reg.Properties[Property] then
                Reg.Properties[Property] = ColorIdx;
            end;
        end;
    end)
end;

function Library:MouseIsOverOpenedFrame()
    for Frame, _ in next, Library.OpenedFrames do
        local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

        if mouse.X >= AbsPos.X and mouse.X <= AbsPos.X + AbsSize.X
            and mouse.Y >= AbsPos.Y and mouse.Y <= AbsPos.Y + AbsSize.Y then

            return true;
        end;
    end;
end;

function Library:IsMouseOverFrame(Frame)
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

    if mouse.X >= AbsPos.X and mouse.X <= AbsPos.X + AbsSize.X
        and mouse.Y >= AbsPos.Y and mouse.Y <= AbsPos.Y + AbsSize.Y then

        return true;
    end;
end;

function Library:UpdateDependencyBoxes()
    for _, Depbox in next, Library.DependencyBoxes do
        Depbox:Update();
    end;
end;

function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
    return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB;
end;

function Library:GetTextBounds(Text, Font, Size, Resolution)
    local Bounds = text_service:GetTextSize(Text, Size, Font, Resolution or vec2(1920, 1080))
    return Bounds.X, Bounds.Y
end;

function Library:GetDarkerColor(Color)
    local H, S, V = Color3.toHSV(Color);
    return Color3.fromHSV(H, S, V / 1.5);
end;
Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor);

function Library:AddToActiveRegistry(Data)
    if Data.ActiveIdx then
        return;
    end;

    local Idx = #Library.ActiveRegistry + 1;
    Library.ActiveRegistry[Idx] = Data;
    Data.ActiveIdx = Idx;
end;

function Library:RemoveFromActiveRegistry(Data)
    local Idx = Data.ActiveIdx;

    if not Idx then
        return;
    end;

    local LastIdx = #Library.ActiveRegistry;
    local Last = Library.ActiveRegistry[LastIdx];

    Library.ActiveRegistry[Idx] = Last;
    Library.ActiveRegistry[LastIdx] = nil;
    Data.ActiveIdx = nil;

    if Last and Last ~= Data then
        Last.ActiveIdx = Idx;
    end;
end;

function Library:UpdateRegistryObjectColors(Object)
    for Property, ColorIdx in next, Object.Properties do
        if type(ColorIdx) == 'string' then
            Object.Instance[Property] = Library[ColorIdx];
        elseif type(ColorIdx) == 'function' then
            Object.Instance[Property] = ColorIdx();
        end;
    end;
end;

function Library:AddToRegistry(Instance, Properties, IsHud)
    local Idx = #Library.Registry + 1;
    local Data = {
        Instance = Instance;
        Properties = Properties;
        Idx = Idx;
        ActiveIdx = nil;
        VisibilityConnection = nil;
    };

    insert(Library.Registry, Data);
    Library.RegistryMap[Instance] = Data;

    if Instance:IsA('GuiObject') then
        if Instance.Visible then
            Library:AddToActiveRegistry(Data);
        end;

        Data.VisibilityConnection = Instance:GetPropertyChangedSignal('Visible'):Connect(function()
            if Instance.Visible then
                Library:AddToActiveRegistry(Data);
                Library:UpdateRegistryObjectColors(Data);
            else
                Library:RemoveFromActiveRegistry(Data);
            end;
        end);
    else
        Library:AddToActiveRegistry(Data);
    end;

    if IsHud then
        insert(Library.HudRegistry, Data);
    end;
end;

function Library:RemoveFromRegistry(Instance)
    local Data = Library.RegistryMap[Instance];

    if Data then
        for Idx = #Library.Registry, 1, -1 do
            if Library.Registry[Idx] == Data then
                remove(Library.Registry, Idx);
            end;
        end;

        for Idx = #Library.HudRegistry, 1, -1 do
            if Library.HudRegistry[Idx] == Data then
                remove(Library.HudRegistry, Idx);
            end;
        end;

        Library:RemoveFromActiveRegistry(Data);

        if Data.VisibilityConnection then
            Data.VisibilityConnection:Disconnect();
            Data.VisibilityConnection = nil;
        end;

        Library.RegistryMap[Instance] = nil;
    end;
end;

function Library:UpdateColorsUsingRegistry()
    for Idx = 1, #Library.ActiveRegistry do
        local Object = Library.ActiveRegistry[Idx];

        for Property, ColorIdx in next, Object.Properties do
            local ColorIdxType = type(ColorIdx);

            if ColorIdxType == 'string' then
                Object.Instance[Property] = Library[ColorIdx];
            elseif ColorIdxType == 'function' then
                Object.Instance[Property] = ColorIdx();
            end;
        end;
    end;

    Library:UpdateGlow();

    -- Update watermark colors
    if Library.WatermarkRawText then
        Library:SetWatermark(Library.WatermarkRawText);
    end
end;
function Library:UpdateGlow()
    local GlowColor = Library.GlowColorMatchAccent and Library.AccentColor or Library.GlowColor;

    for _, Glow in next, Library.GlowInstances do
        if Glow and Glow.Parent then
            Glow.Visible = Library.GlowEnabled;
            Glow.ImageColor3 = GlowColor;
            Glow.ImageTransparency = Library.GlowTransparency;
            Glow.Size = dim2(1, Library.GlowSize, 1, Library.GlowSize);
        end;
    end;
end;

function Library:SetGlowEnabled(Enabled)
    Library.GlowEnabled = Enabled;
    Library:UpdateGlow();
end;

function Library:SetGlowColor(Color)
    Library.GlowColor = Color;
    if not Library.GlowColorMatchAccent then
        Library:UpdateGlow();
    end;
end;

function Library:SetGlowTransparency(Transparency)
    Library.GlowTransparency = Transparency;
    Library:UpdateGlow();
end;

function Library:SetGlowSize(Size)
    Library.GlowSize = Size;
    Library:UpdateGlow();
end;

function Library:SetGlowMatchAccent(Match)
    Library.GlowColorMatchAccent = Match;
    Library:UpdateGlow();
end;

function Library:SetKeybindFilter(Filter)
    assert(Filter == 'Always' or Filter == 'On' or Filter == 'Off', 'Invalid keybind filter. Use "Always", "On", or "Off"');
    Library.KeybindFilter = Filter;

    -- Update all keybinds
    for _, Option in next, Options do
        if Option.Type == 'KeyPicker' then
            Option:Update();
        end;
    end;
end;

function Library:GiveSignal(Signal)
    -- Only used for signals not attached to library instances, as those should be cleaned up on object destruction by Roblox
    insert(Library.Signals, Signal)
    return Signal
end

function Library:Connect(Signal, Callback)
    return Library:GiveSignal(Signal:Connect(Callback))
end

function Library:BindToRenderStep(Name, Priority, Callback)
    pcall(run.UnbindFromRenderStep, run, Name)
    run:BindToRenderStep(Name, Priority, Callback)
    Library.BoundRenderSteps = Library.BoundRenderSteps or {}
    Library.BoundRenderSteps[Name] = true
end

function Library:Unload()
    Library.Unloaded = true

    for Name in next, Library.BoundRenderSteps or {} do
        run:UnbindFromRenderStep(Name)
    end

    Script.UnbindChannels()

    -- Unload all of the signals
    for Idx = #Library.Signals, 1, -1 do
        local Connection = remove(Library.Signals, Idx)
        Connection:Disconnect()
    end

     -- Clean up noclip event connections
    for char in next, noclipConnections do
        disconnectNoclipEvents(char)
    end

    -- Call our unload callback, maybe to undo some hooks etc
    if Library.OnUnload then
        Library.OnUnload()
    end

    ScreenGui:Destroy()
end

function Library:OnUnload(Callback)
    Library.OnUnload = Callback
end

Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
    if Library.RegistryMap[Instance] then
        Library:RemoveFromRegistry(Instance);
    end;
end))

local BaseAddons = {};

do
    local Funcs = {};

    function Funcs:AddColorPicker(Idx, Info)
        local ParentObj = self;
        local ToggleLabel = self.TextLabel;
        -- local Container = self.Container;

        assert(Info.Default, 'AddColorPicker: Missing default value.');

        local ColorPicker = {
            Value = Info.Default;
            Transparency = Info.Transparency or 0;
            Type = 'ColorPicker';
            Title = type(Info.Title) == 'string' and Info.Title or 'Color picker',
            Callback = Info.Callback or function(Color) end;
        };

        function ColorPicker:SetHSVFromRGB(Color)
            local H, S, V = Color3.toHSV(Color);

            ColorPicker.Hue = H;
            ColorPicker.Sat = S;
            ColorPicker.Vib = V;
        end;

        ColorPicker:SetHSVFromRGB(ColorPicker.Value);

local DisplayFrame = Library:Create('Frame', {
    BackgroundColor3 = color(0, 0, 0);
    BorderColor3 = Library.OutlineColor;
    Size = dim2(0, 28, 0, 14);
    ZIndex = 6;
    Parent = ToggleLabel;
});

Library:AddToRegistry(DisplayFrame, {
            BorderColor3 = 'OutlineColor';
        });

        Library:OnHighlight(DisplayFrame, DisplayFrame,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'OutlineColor' }
        );

Library:Create('UICorner', {
    CornerRadius = dim(0, 3);
    Parent = DisplayFrame;
});

local DisplayInner = Library:Create('Frame', {
    BackgroundColor3 = ColorPicker.Value;
    BorderSizePixel = 0;
    Position = dim_offset(1, 1);
    Size = dim2(1, -2, 1, -2);
    ZIndex = 7;
    Parent = DisplayFrame;
});

Library:Create('UICorner', {
    CornerRadius = dim(0, 2);
    Parent = DisplayInner;
});

        -- Transparency image taken from https://github.com/matas3535/SplixPrivateDrawingLibrary/blob/main/Library.lua cus i'm lazy
        Library:Create('ImageLabel', {
            BorderSizePixel = 0;
            Size = dim2(0, 27, 0, 13);
            ZIndex = 5;
            Image = 'http://www.roblox.com/asset/?id=12977615774';
            Visible = not not Info.Transparency;
            Parent = DisplayFrame;
        });

        -- 1/16/23
        -- Rewrote this to be placed inside the Library ScreenGui
        -- There was some issue which caused RelativeOffset to be way off
        -- Thus the color picker would never show

        local PickerFrameOuter = Library:Create('Frame', {
            Name = 'Color';
            BackgroundColor3 = color(1, 1, 1);
            BorderColor3 = color(0, 0, 0);
            Position = dim_offset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18),
            Size = dim_offset(230, Info.Transparency and 271 or 253);
            Visible = false;
            ZIndex = 15;
            Parent = ScreenGui,
        });

        DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
            PickerFrameOuter.Position = dim_offset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18);
        end)

        local PickerFrameInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 16;
            Parent = PickerFrameOuter;
        });

        local Highlight = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Size = dim2(1, 0, 0, 2);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local SatVibMapOuter = Library:Create('Frame', {
            BorderColor3 = color(0, 0, 0);
            Position = dim2(0, 4, 0, 25);
            Size = dim2(0, 200, 0, 200);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local SatVibMapInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 18;
            Parent = SatVibMapOuter;
        });

        local SatVibMap = Library:Create('ImageLabel', {
            BorderSizePixel = 0;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 18;
            Image = 'rbxassetid://4155801252';
            Parent = SatVibMapInner;
        });

        local CursorOuter = Library:Create('ImageLabel', {
            AnchorPoint = vec2(0.5, 0.5);
            Size = dim2(0, 6, 0, 6);
            BackgroundTransparency = 1;
            Image = 'http://www.roblox.com/asset/?id=9619665977';
            ImageColor3 = color(0, 0, 0);
            ZIndex = 19;
            Parent = SatVibMap;
        });

        Library:Create('ImageLabel', {
            Size = dim2(0, CursorOuter.Size.X.Offset - 2, 0, CursorOuter.Size.Y.Offset - 2);
            Position = dim2(0, 1, 0, 1);
            BackgroundTransparency = 1;
            Image = 'http://www.roblox.com/asset/?id=9619665977';
            ZIndex = 20;
            Parent = CursorOuter;
        })

        local HueSelectorOuter = Library:Create('Frame', {
            BorderColor3 = color(0, 0, 0);
            Position = dim2(0, 208, 0, 25);
            Size = dim2(0, 15, 0, 200);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local HueSelectorInner = Library:Create('Frame', {
            BackgroundColor3 = color(1, 1, 1);
            BorderSizePixel = 0;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 18;
            Parent = HueSelectorOuter;
        });

        local HueCursor = Library:Create('Frame', {
            BackgroundColor3 = color(1, 1, 1);
            AnchorPoint = vec2(0, 0.5);
            BorderColor3 = color(0, 0, 0);
            Size = dim2(1, 0, 0, 1);
            ZIndex = 18;
            Parent = HueSelectorInner;
        });

        local HueBoxOuter = Library:Create('Frame', {
            BorderColor3 = color(0, 0, 0);
            Position = dim_offset(4, 228),
            Size = dim2(0.5, -6, 0, 20),
            ZIndex = 18,
            Parent = PickerFrameInner;
        });

        local HueBoxInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 18,
            Parent = HueBoxOuter;
        });

        Library:Create('UIGradient', {
            Color = rgbseq({
                rgbkey(0, color(1, 1, 1)),
                rgbkey(1, rgb(212, 212, 212))
            });
            Rotation = 90;
            Parent = HueBoxInner;
        });

        local HueBox = Library:Create('TextBox', {
            BackgroundTransparency = 1;
            Position = dim2(0, 5, 0, 0);
            Size = dim2(1, -5, 1, 0);
            Font = Library.DefaultFont;
            PlaceholderColor3 = rgb(190, 190, 190);
            PlaceholderText = 'Hex color',
            Text = '#FFFFFF',
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextStrokeTransparency = 0;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 20,
            Parent = HueBoxInner;
        });

        Library:ApplyTextStroke(HueBox);

        local RgbBoxBase = Library:Create(HueBoxOuter:Clone(), {
            Position = dim2(0.5, 2, 0, 228),
            Size = dim2(0.5, -6, 0, 20),
            Parent = PickerFrameInner
        });

        local RgbBox = Library:Create(RgbBoxBase.Frame:FindFirstChild('TextBox'), {
            Text = '255, 255, 255',
            PlaceholderText = 'RGB color',
            TextColor3 = Library.FontColor
        });

        -- RGB Sliders
local SliderContainer = Library:Create('Frame', {
    BackgroundTransparency = 1;
    Position = dim_offset(4, Info.Transparency and 228 or 210);
    Size = dim2(1, -8, 0, 60);
    ZIndex = 18;
    Visible = false; -- Toggle this for advanced mode
    Parent = PickerFrameInner;
});

local function CreateRGBSlider(Name, YPos, ColorChannel)
    Library:CreateLabel({
        Position = dim_offset(0, YPos);
        Size = dim2(0, 15, 0, 15);
        Text = Name;
        TextSize = 12;
        ZIndex = 19;
        Parent = SliderContainer;
    });

    local SliderOuter = Library:Create('Frame', {
        BackgroundColor3 = color(0, 0, 0);
        BorderColor3 = color(0, 0, 0);
        Position = dim_offset(20, YPos);
        Size = dim2(1, -50, 0, 15);
        ZIndex = 19;
        Parent = SliderContainer;
    });

    local SliderInner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = dim2(1, 0, 1, 0);
        ZIndex = 20;
        Parent = SliderOuter;
    });

    Library:AddToRegistry(SliderInner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });

    local SliderFill = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Size = dim2(1, 0, 1, 0);
        ZIndex = 21;
        Parent = SliderInner;
    });

    Library:AddToRegistry(SliderFill, {
        BackgroundColor3 = 'AccentColor';
    });

    local ValueLabel = Library:CreateLabel({
        Position = dim2(1, 5, 0, 0);
        Size = dim2(0, 25, 0, 15);
        Text = '255';
        TextSize = 12;
        ZIndex = 19;
        Parent = SliderContainer;
    });

    SliderInner.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                local MinX = SliderInner.AbsolutePosition.X;
                local MaxX = MinX + SliderInner.AbsoluteSize.X;
                local MouseX = clamp(mouse.X, MinX, MaxX);
                local Value = floor(((MouseX - MinX) / (MaxX - MinX)) * 255);

                local R, G, B = floor(ColorPicker.Value.R * 255),
                                floor(ColorPicker.Value.G * 255),
                                floor(ColorPicker.Value.B * 255);

                if ColorChannel == 'R' then R = Value
                elseif ColorChannel == 'G' then G = Value
                else B = Value end

                ColorPicker:SetHSVFromRGB(rgb(R, G, B));
                ColorPicker:Display();

                SliderFill.Size = dim2(Value / 255, 0, 1, 0);
                ValueLabel.Text = tostring(Value);

                render_stepped:Wait();
            end;
        end;
    end);

    return SliderOuter, ValueLabel;
end

CreateRGBSlider('R', 0, 'R');
CreateRGBSlider('G', 20, 'G');
CreateRGBSlider('B', 40, 'B');

        local TransparencyBoxOuter, TransparencyBoxInner, TransparencyCursor;

        if Info.Transparency then
            TransparencyBoxOuter = Library:Create('Frame', {
                BorderColor3 = color(0, 0, 0);
                Position = dim_offset(4, 251);
                Size = dim2(1, -8, 0, 15);
                ZIndex = 19;
                Parent = PickerFrameInner;
            });

            TransparencyBoxInner = Library:Create('Frame', {
                BackgroundColor3 = ColorPicker.Value;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = dim2(1, 0, 1, 0);
                ZIndex = 19;
                Parent = TransparencyBoxOuter;
            });

            Library:AddToRegistry(TransparencyBoxInner, { BorderColor3 = 'OutlineColor' });

            Library:Create('ImageLabel', {
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 1, 0);
                Image = 'http://www.roblox.com/asset/?id=12978095818';
                ZIndex = 20;
                Parent = TransparencyBoxInner;
            });

            TransparencyCursor = Library:Create('Frame', {
                BackgroundColor3 = color(1, 1, 1);
                AnchorPoint = vec2(0.5, 0);
                BorderColor3 = color(0, 0, 0);
                Size = dim2(0, 1, 1, 0);
                ZIndex = 21;
                Parent = TransparencyBoxInner;
            });
        end;

        local DisplayLabel = Library:CreateLabel({
            Size = dim2(1, 0, 0, 14);
            Position = dim_offset(5, 5);
            TextXAlignment = Enum.TextXAlignment.Left;
            TextSize = 14;
            Text = ColorPicker.Title,--Info.Default;
            TextWrapped = false;
            ZIndex = 16;
            Parent = PickerFrameInner;
        });



        -- Minus button
local MinusButton = Library:Create('TextLabel', {
    BackgroundTransparency = 1;
    Position = dim2(1, -30, 0, 0);
    Size = dim2(0, 15, 1, 0);
    Font = Library.DefaultFont;
    Text = '-';
    TextColor3 = Library.FontColor;
    TextSize = 16;
    TextStrokeTransparency = 0;
    ZIndex = 10;
    Parent = SliderInner;
});

Library:ApplyTextStroke(MinusButton);
Library:AddToRegistry(MinusButton, {
    TextColor3 = 'FontColor';
});

-- Plus button
local PlusButton = Library:Create('TextLabel', {
    BackgroundTransparency = 1;
    Position = dim2(1, -15, 0, 0);
    Size = dim2(0, 15, 1, 0);
    Font = Library.DefaultFont;
    Text = '+';
    TextColor3 = Library.FontColor;
    TextSize = 16;
    TextStrokeTransparency = 0;
    ZIndex = 10;
    Parent = SliderInner;
});

Library:ApplyTextStroke(PlusButton);
Library:AddToRegistry(PlusButton, {
    TextColor3 = 'FontColor';
});

-- Make buttons clickable
local MinusClickFrame = Library:Create('Frame', {
    BackgroundTransparency = 1;
    Position = dim2(1, -30, 0, 0);
    Size = dim2(0, 15, 1, 0);
    ZIndex = 11;
    Parent = SliderInner;
});

local PlusClickFrame = Library:Create('Frame', {
    BackgroundTransparency = 1;
    Position = dim2(1, -15, 0, 0);
    Size = dim2(0, 15, 1, 0);
    ZIndex = 11;
    Parent = SliderInner;
});

MinusClickFrame.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        local NewValue = max(Slider.Min, Slider.Value - 1);
        Slider:SetValue(NewValue);
        Library:AttemptSave();
    end;
end);

PlusClickFrame.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        local NewValue = min(Slider.Max, Slider.Value + 1);
        Slider:SetValue(NewValue);
        Library:AttemptSave();
    end;
end);

Library:OnHighlight(MinusClickFrame, MinusButton,
    { TextColor3 = 'AccentColor' },
    { TextColor3 = 'FontColor' }
);

Library:OnHighlight(PlusClickFrame, PlusButton,
    { TextColor3 = 'AccentColor' },
    { TextColor3 = 'FontColor' }
);


        local ContextMenu = {}
        do
            ContextMenu.Options = {}
            ContextMenu.Container = Library:Create('Frame', {
                BorderColor3 = color(),
                ZIndex = 14,

                Visible = false,
                Parent = ScreenGui
            })

            ContextMenu.Inner = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.fromScale(1, 1);
                ZIndex = 15;
                Parent = ContextMenu.Container;
            });

            Library:Create('UIListLayout', {
                Name = 'Layout',
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = ContextMenu.Inner;
            });

            Library:Create('UIPadding', {
                Name = 'Padding',
                PaddingLeft = dim(0, 4),
                Parent = ContextMenu.Inner,
            });

            local function updateMenuPosition()
                ContextMenu.Container.Position = dim_offset(
                    (DisplayFrame.AbsolutePosition.X + DisplayFrame.AbsoluteSize.X) + 4,
                    DisplayFrame.AbsolutePosition.Y + 1
                )
            end

            local function updateMenuSize()
                local menuWidth = 60
                for i, label in next, ContextMenu.Inner:GetChildren() do
                    if label:IsA('TextLabel') then
                        menuWidth = max(menuWidth, label.TextBounds.X)
                    end
                end

                ContextMenu.Container.Size = dim_offset(
                    menuWidth + 8,
                    ContextMenu.Inner.Layout.AbsoluteContentSize.Y + 4
                )
            end

            DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(updateMenuPosition)
            ContextMenu.Inner.Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(updateMenuSize)

            task.spawn(updateMenuPosition)
            task.spawn(updateMenuSize)

            Library:AddToRegistry(ContextMenu.Inner, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });

            function ContextMenu:Show()
                self.Container.Visible = true
            end

            function ContextMenu:Hide()
                self.Container.Visible = false
            end

            function ContextMenu:AddOption(Str, Callback)
                if type(Callback) ~= 'function' then
                    Callback = function() end
                end

                local Button = Library:CreateLabel({
                    Active = false;
                    Size = dim2(1, 0, 0, 15);
                    TextSize = 13;
                    Text = Str;
                    ZIndex = 16;
                    Parent = self.Inner;
                    TextXAlignment = Enum.TextXAlignment.Left,
                });

                Library:OnHighlight(Button, Button,
                    { TextColor3 = 'AccentColor' },
                    { TextColor3 = 'FontColor' }
                );

                Button.InputBegan:Connect(function(Input)
                    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                        return
                    end

                    Callback()
                end)
            end

            ContextMenu:AddOption('Copy color', function()
                Library.ColorClipboard = ColorPicker.Value
                Library:Notify('Copied color!', 2)
            end)

            ContextMenu:AddOption('Paste color', function()
                if not Library.ColorClipboard then
                    return Library:Notify('You have not copied a color!', 2)
                end
                ColorPicker:SetValueRGB(Library.ColorClipboard)
            end)


            ContextMenu:AddOption('Copy HEX', function()
                pcall(setclipboard, ColorPicker.Value:ToHex())
                Library:Notify('Copied hex code to clipboard!', 2)
            end)

            ContextMenu:AddOption('Copy RGB', function()
                pcall(setclipboard, concat({ floor(ColorPicker.Value.R * 255), floor(ColorPicker.Value.G * 255), floor(ColorPicker.Value.B * 255) }, ', '))
                Library:Notify('Copied RGB values to clipboard!', 2)
            end)

        end

        Library:AddToRegistry(PickerFrameInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(Highlight, { BackgroundColor3 = 'AccentColor'; });
        Library:AddToRegistry(SatVibMapInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });

        Library:AddToRegistry(HueBoxInner, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(RgbBoxBase.Frame, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(RgbBox, { TextColor3 = 'FontColor', });
        Library:AddToRegistry(HueBox, { TextColor3 = 'FontColor', });

        local SequenceTable = {};

        for Hue = 0, 1, 0.1 do
            insert(SequenceTable, rgbkey(Hue, Color3.fromHSV(Hue, 1, 1)));
        end;

        Library:Create('UIGradient', {
            Color = rgbseq(SequenceTable);
            Rotation = 90;
            Parent = HueSelectorInner;
        });

        HueBox.FocusLost:Connect(function(enter)
            if enter then
                local success, result = pcall(hex, HueBox.Text)
                if success and typeof(result) == 'Color3' then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(result)
                end
            end

            ColorPicker:Display()
        end)

        RgbBox.FocusLost:Connect(function(enter)
            if enter then
                local r, g, b = RgbBox.Text:match('(%d+),%s*(%d+),%s*(%d+)')
                if r and g and b then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(rgb(r, g, b))
                end
            end

            ColorPicker:Display()
        end)

        function ColorPicker:Display()
            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib);
            SatVibMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1);

Library:Create(DisplayInner, {
    BackgroundColor3 = ColorPicker.Value;
    BackgroundTransparency = ColorPicker.Transparency;
});

            if TransparencyBoxInner then
                TransparencyBoxInner.BackgroundColor3 = ColorPicker.Value;
                TransparencyCursor.Position = dim2(1 - ColorPicker.Transparency, 0, 0, 0);
            end;

            CursorOuter.Position = dim2(ColorPicker.Sat, 0, 1 - ColorPicker.Vib, 0);
            HueCursor.Position = dim2(0, 0, ColorPicker.Hue, 0);

            HueBox.Text = '#' .. ColorPicker.Value:ToHex()
            RgbBox.Text = concat({ floor(ColorPicker.Value.R * 255), floor(ColorPicker.Value.G * 255), floor(ColorPicker.Value.B * 255) }, ', ')

            Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value);
            Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value);
        end;

        function ColorPicker:OnChanged(Func)
            ColorPicker.Changed = Func;
            Func(ColorPicker.Value)
        end;

        function ColorPicker:Show()
            for Frame, Val in next, Library.OpenedFrames do
                if Frame.Name == 'Color' then
                    Frame.Visible = false;
                    Library.OpenedFrames[Frame] = nil;
                end;
            end;

            PickerFrameOuter.Visible = true;
            Library.OpenedFrames[PickerFrameOuter] = true;
        end;

        function ColorPicker:Hide()
            PickerFrameOuter.Visible = false;
            Library.OpenedFrames[PickerFrameOuter] = nil;
        end;

        function ColorPicker:SetValue(HSV, Transparency)
            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3]);

            ColorPicker.Transparency = Transparency or 0;
            ColorPicker:SetHSVFromRGB(Color);
            ColorPicker:Display();
        end;

        function ColorPicker:SetValueRGB(Color, Transparency)
            ColorPicker.Transparency = Transparency or 0;
            ColorPicker:SetHSVFromRGB(Color);
            ColorPicker:Display();
        end;

        SatVibMap.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local MinX = SatVibMap.AbsolutePosition.X;
                    local MaxX = MinX + SatVibMap.AbsoluteSize.X;
                    local MouseX = clamp(mouse.X, MinX, MaxX);

                    local MinY = SatVibMap.AbsolutePosition.Y;
                    local MaxY = MinY + SatVibMap.AbsoluteSize.Y;
                    local MouseY = clamp(mouse.Y, MinY, MaxY);

                    ColorPicker.Sat = (MouseX - MinX) / (MaxX - MinX);
                    ColorPicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY));
                    ColorPicker:Display();

                    render_stepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        HueSelectorInner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local MinY = HueSelectorInner.AbsolutePosition.Y;
                    local MaxY = MinY + HueSelectorInner.AbsoluteSize.Y;
                    local MouseY = clamp(mouse.Y, MinY, MaxY);

                    ColorPicker.Hue = ((MouseY - MinY) / (MaxY - MinY));
                    ColorPicker:Display();

                    render_stepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        DisplayFrame.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                if ParentObj.Type == 'Toggle' then
                    ParentObj.IgnoreNextToggleClick = true;
                    task.delay(0.1, function()
                        ParentObj.IgnoreNextToggleClick = false;
                    end);
                end;

                if PickerFrameOuter.Visible then
                    ColorPicker:Hide()
                else
                    ContextMenu:Hide()
                    ColorPicker:Show()
                end;
            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
                ContextMenu:Show()
                ColorPicker:Hide()
            end
        end);

        if TransparencyBoxInner then
            TransparencyBoxInner.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        local MinX = TransparencyBoxInner.AbsolutePosition.X;
                        local MaxX = MinX + TransparencyBoxInner.AbsoluteSize.X;
                        local MouseX = clamp(mouse.X, MinX, MaxX);

                        ColorPicker.Transparency = 1 - ((MouseX - MinX) / (MaxX - MinX));

                        ColorPicker:Display();

                        render_stepped:Wait();
                    end;

                    Library:AttemptSave();
                end;
            end);
        end;

        Library:GiveSignal(uis.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = PickerFrameOuter.AbsolutePosition, PickerFrameOuter.AbsoluteSize;

                if mouse.X < AbsPos.X or mouse.X > AbsPos.X + AbsSize.X
                    or mouse.Y < (AbsPos.Y - 20 - 1) or mouse.Y > AbsPos.Y + AbsSize.Y then

                    ColorPicker:Hide();
                end;

                if not Library:IsMouseOverFrame(ContextMenu.Container) then
                    ContextMenu:Hide()
                end
            end;

            if Input.UserInputType == Enum.UserInputType.MouseButton2 and ContextMenu.Container.Visible then
                if not Library:IsMouseOverFrame(ContextMenu.Container) and not Library:IsMouseOverFrame(DisplayFrame) then
                    ContextMenu:Hide()
                end
            end
        end))

        ColorPicker:Display();
        ColorPicker.DisplayFrame = DisplayFrame
        if ParentObj.Addons then
            insert(ParentObj.Addons, ColorPicker)

            if ParentObj.UpdateHitbox then
                task.defer(function()
                    ParentObj:UpdateHitbox();
                end);
            end
        end

        Options[Idx] = ColorPicker;

        return self;
    end;

    function Funcs:AddKeyPicker(Idx, Info)
        local ParentObj = self;
        local ToggleLabel = self.TextLabel;
        local Container = self.Container;

        assert(Info.Default, 'AddKeyPicker: Missing default value.');

        local KeyPicker = {
            Value = Library:NormalizeKey(Info.Default);
            Toggled = false;
            Mode = Info.Mode or 'Toggle'; -- Always, Toggle, Hold
            Type = 'KeyPicker';
            Callback = Info.Callback or function(Value) end;
            ChangedCallback = Info.ChangedCallback or function(New) end;

            SyncToggleState = Info.SyncToggleState or false;
        };

        if KeyPicker.SyncToggleState then
            Info.Modes = { 'Toggle' }
            Info.Mode = 'Toggle'
        end

        local PickOuter = Library:Create('Frame', {
            BackgroundColor3 = color(0, 0, 0);
            BorderColor3 = color(0, 0, 0);
            Size = dim2(0, 34, 0, 15);
            ZIndex = 20;
            Parent = ToggleLabel;
        });

        local PickInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 21;
            Parent = PickOuter;
        });

        Library:AddToRegistry(PickInner, {
            BackgroundColor3 = 'BackgroundColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:OnHighlight(PickOuter, PickOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        local DisplayLabel = Library:CreateLabel({
            Size = dim2(1, 0, 1, 0);
            TextSize = 13;
            Text = Library:GetKeyName(Info.Default);
            TextWrapped = false;
            ZIndex = 22;
            Parent = PickInner;
        });

        local ModeSelectOuter = Library:Create('Frame', {
            BorderColor3 = color(0, 0, 0);
            Position = dim_offset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y + 1);
            Size = dim2(0, 60, 0, 45 + 2);
            Visible = false;
            ZIndex = 14;
            Parent = ScreenGui;
        });

        ToggleLabel:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
            ModeSelectOuter.Position = dim_offset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y + 1);
        end);

        local ModeSelectInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 15;
            Parent = ModeSelectOuter;
        });

        Library:AddToRegistry(ModeSelectInner, {
            BackgroundColor3 = 'BackgroundColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = ModeSelectInner;
        });

        local ContainerLabel = Library:CreateLabel({
            TextXAlignment = Enum.TextXAlignment.Left;
            Size = dim2(1, 0, 0, 15);
            TextSize = 12;
            Visible = false;
            ZIndex = 110;
            Parent = Library.KeybindContainer;
        }, true);

        local Modes = Info.Modes or { 'Always', 'Toggle', 'Hold' };
        local ModeButtons = {};

        for Idx, Mode in next, Modes do
            local ModeButton = {};

            local Label = Library:CreateLabel({
                Active = false;
                Size = dim2(1, 0, 0, 15);
                TextSize = 13;
                Text = Mode;
                ZIndex = 16;
                Parent = ModeSelectInner;
            });

            function ModeButton:Select()
                for _, Button in next, ModeButtons do
                    Button:Deselect();
                end;

                KeyPicker.Mode = Mode;

                Label.TextColor3 = Library.AccentColor;
                local RegistryData = Library.RegistryMap[Label];
                if RegistryData and RegistryData.Properties then
                    RegistryData.Properties.TextColor3 = 'AccentColor';
                end;

                ModeSelectOuter.Visible = false;
            end;

            function ModeButton:Deselect()
                KeyPicker.Mode = nil;

                Label.TextColor3 = Library.FontColor;
                local RegistryData = Library.RegistryMap[Label];
                if RegistryData and RegistryData.Properties then
                    RegistryData.Properties.TextColor3 = 'FontColor';
                end;
            end;

            Label.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    ModeButton:Select();
                    Library:AttemptSave();
                end;
            end);

            if Mode == KeyPicker.Mode then
                ModeButton:Select();
            end;

            ModeButtons[Mode] = ModeButton;
        end;

function KeyPicker:Update()
    if Info.NoUI then
        return;
    end;

    local State = KeyPicker:GetState();
    local keyName = Library:GetKeybindHudKey(KeyPicker.Value);
    local labelName = Library:GetKeybindHudLabel(Idx, Info, ParentObj);
    local modeName = string.lower(KeyPicker.Mode or "toggle");

    ContainerLabel.Text = string.format('[%s] %s (%s)', keyName, labelName, modeName);

    local ShouldShow = true;
    if Library.KeybindFilter == 'On' then
        ShouldShow = State;
    elseif Library.KeybindFilter == 'Off' then
        ShouldShow = not State;
    end;

    ContainerLabel.Visible = ShouldShow;
    ContainerLabel.TextColor3 = State and Library.AccentColor or Library.FontColor;

    local RegistryData = Library.RegistryMap[ContainerLabel];
    if RegistryData and RegistryData.Properties then
        RegistryData.Properties.TextColor3 = State and 'AccentColor' or 'FontColor';
    end;

    Library:UpdateKeybindFrame();
        end;

        function KeyPicker:GetState()
            if KeyPicker.Mode == 'Always' then
                return true;
            elseif KeyPicker.Mode == 'Hold' then
                if KeyPicker.Value == 'none' then
                    return false;
                end

                local Key = KeyPicker.Value;

                if Key == 'mb1' or Key == 'mb2' or Key == 'mb3' then
                    return Key == 'mb1' and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                        or Key == 'mb2' and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                        or Key == 'mb3' and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton3);
                else
                    local KeyCode = Library:GetKeyCode(Key);
                    return KeyCode and uis:IsKeyDown(KeyCode);
                end;
            else
                return KeyPicker.Toggled;
            end;
        end;

        function KeyPicker:SetValue(Data)
            local Key, Mode = Library:NormalizeKey(Data[1]), Data[2];
            DisplayLabel.Text = Library:GetKeyName(Key);
            KeyPicker.Value = Key;
            ModeButtons[Mode]:Select();
            KeyPicker:Update();
        end;

        function KeyPicker:OnClick(Callback)
            KeyPicker.Clicked = Callback
        end

        function KeyPicker:OnChanged(Callback)
            KeyPicker.Changed = Callback
            Callback(KeyPicker.Value)
        end

        if ParentObj.Addons then
            insert(ParentObj.Addons, KeyPicker)

            if ParentObj.UpdateHitbox then
                task.defer(function()
                    ParentObj:UpdateHitbox();
                end);
            end
        end

        function KeyPicker:DoClick()
            if ParentObj.Type == 'Toggle' and KeyPicker.SyncToggleState then
                ParentObj:SetValue(not ParentObj.Value)
            end

            Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
            Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)
        end

        local Picking = false;

        local function SetParentToggleHoverIgnored(Ignored)
            if ParentObj.Type ~= 'Toggle' then
                return;
            end;

            ParentObj.IgnoreToggleHover = Ignored;

            if Ignored and ParentObj.ToggleOuter then
                tween_service:Create(ParentObj.ToggleOuter, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = Library.Black
                }):Play();

                if Library.RegistryMap[ParentObj.ToggleOuter] then
                    Library.RegistryMap[ParentObj.ToggleOuter].Properties.BorderColor3 = 'Black';
                end;
            end;
        end;

        PickOuter.MouseEnter:Connect(function()
            SetParentToggleHoverIgnored(true);
        end);

        PickOuter.MouseLeave:Connect(function()
            SetParentToggleHoverIgnored(false);
        end);

        PickOuter.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                if ParentObj.Type == 'Toggle' then
                    ParentObj.IgnoreNextToggleClick = true;
                    task.delay(0.1, function()
                        ParentObj.IgnoreNextToggleClick = false;
                    end);
                end;

                Picking = true;

                DisplayLabel.Text = '';

                local Break;
                local Text = '';

                task.spawn(function()
                    while (not Break) do
                        if Text == '...' then
                            Text = '';
                        end;

                        Text = Text .. '.';
                        DisplayLabel.Text = Text;

                        wait(0.4);
                    end;
                end);

                wait(0.2);

                local Event;
                Event = uis.InputBegan:Connect(function(Input)
                    local Key;

                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        Key = Library:NormalizeKey(Input.KeyCode);
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton1
                        or Input.UserInputType == Enum.UserInputType.MouseButton2
                        or Input.UserInputType == Enum.UserInputType.MouseButton3 then
                        Key = Library:NormalizeKey(Input.UserInputType);
                    end;

                    if not Key then
                        return;
                    end;

                    Break = true;
                    Picking = false;

                    DisplayLabel.Text = Library:GetKeyName(Key);
                    KeyPicker.Value = Key;

                    Library:SafeCallback(KeyPicker.ChangedCallback, Input.KeyCode or Input.UserInputType)
                    Library:SafeCallback(KeyPicker.Changed, Input.KeyCode or Input.UserInputType)

                    Library:AttemptSave();

                    Event:Disconnect();
                end);
            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
                if ParentObj.Type == 'Toggle' then
                    ParentObj.IgnoreNextToggleClick = true;
                    task.delay(0.1, function()
                        ParentObj.IgnoreNextToggleClick = false;
                    end);
                end;

                ModeSelectOuter.Visible = true;
            end;
        end);

        Library:GiveSignal(uis.InputBegan:Connect(function(Input)
            if (not Picking) then
                if KeyPicker.Mode == 'Toggle' then
                    local Key = KeyPicker.Value;

                    if Key == 'mb1' or Key == 'mb2' or Key == 'mb3' then
                        if Key == 'mb1' and Input.UserInputType == Enum.UserInputType.MouseButton1
                        or Key == 'mb2' and Input.UserInputType == Enum.UserInputType.MouseButton2
                        or Key == 'mb3' and Input.UserInputType == Enum.UserInputType.MouseButton3 then
                            KeyPicker.Toggled = not KeyPicker.Toggled
                            KeyPicker:DoClick()
                        end;
                    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                        if Library:NormalizeKey(Input.KeyCode) == Key then
                            KeyPicker.Toggled = not KeyPicker.Toggled;
                            KeyPicker:DoClick()
                        end;
                    end;
                end;

                KeyPicker:Update();
            end;

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ModeSelectOuter.AbsolutePosition, ModeSelectOuter.AbsoluteSize;

                if mouse.X < AbsPos.X or mouse.X > AbsPos.X + AbsSize.X
                    or mouse.Y < (AbsPos.Y - 20 - 1) or mouse.Y > AbsPos.Y + AbsSize.Y then

                    ModeSelectOuter.Visible = false;
                end;
            end;
        end))

        Library:GiveSignal(uis.InputEnded:Connect(function(Input)
            if (not Picking) then
                KeyPicker:Update();
            end;
        end))

        KeyPicker.PickOuter = PickOuter;
        KeyPicker:Update();

        Options[Idx] = KeyPicker;

        return self;
    end;

    BaseAddons.__index = Funcs;
    BaseAddons.__namecall = function(Table, Key, ...)
        return Funcs[Key](...);
    end;
end;

local BaseGroupbox = {};

do
    local Funcs = {};

    function Funcs:AddBlank(Size)
        local Groupbox = self;
        local Container = Groupbox.Container;

        Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, Size);
            ZIndex = 1;
            Parent = Container;
        });
    end;

    function Funcs:AddLabel(Text, DoesWrap)
        local Label = {};

        local Groupbox = self;
        local Container = Groupbox.Container;

        local TextLabel = Library:CreateLabel({
            Size = dim2(1, -4, 0, 15);
            TextSize = 14;
            Text = Text;
            TextWrapped = DoesWrap or false,
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 5;
            Parent = Container;
        });

        if DoesWrap then
            local Y = select(2, Library:GetTextBounds(Text, Library.DefaultFont, 14, vec2(TextLabel.AbsoluteSize.X, math.huge)))
            TextLabel.Size = dim2(1, -4, 0, Y)
        else
            Library:Create('UIListLayout', {
                Padding = dim(0, 4);
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = TextLabel;
            });
        end

        Label.TextLabel = TextLabel;
        Label.Container = Container;

        function Label:SetText(Text)
            TextLabel.Text = Text

            if DoesWrap then
                local Y = select(2, Library:GetTextBounds(Text, Library.DefaultFont, 14, vec2(TextLabel.AbsoluteSize.X, math.huge)))
                TextLabel.Size = dim2(1, -4, 0, Y)
            end

            Groupbox:Resize();
        end

        if (not DoesWrap) then
            setmetatable(Label, BaseAddons);
        end

        Groupbox:AddBlank(5);
        Groupbox:Resize();

        return Label;
    end;

    function Funcs:AddButton(...)
        local Button = {};
        local function ProcessButtonParams(Obj, ...)
            local Props = ...

            if type(Props) == 'table' then
                Obj.Text = Props.Text
                Obj.Func = Props.Func
                Obj.DoubleClick = Props.DoubleClick
                Obj.Tooltip = Props.Tooltip
            else
                Obj.Text = select(1, ...)
                Obj.Func = select(2, ...)
            end

            assert(type(Obj.Func) == 'function', 'AddButton: `Func` callback is missing.');
        end

        ProcessButtonParams(Button, ...)

        local Groupbox = self;
        local Container = Groupbox.Container;

        local function CreateBaseButton(Button)
            local Outer = Library:Create('Frame', {
                BackgroundColor3 = color(0, 0, 0);
                BorderColor3 = color(0, 0, 0);
                Size = dim2(1, -4, 0, 20);
                ZIndex = 5;
            });

            local Inner = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = dim2(1, 0, 1, 0);
                ZIndex = 6;
                Parent = Outer;
            });

            local Label = Library:CreateLabel({
                Size = dim2(1, 0, 1, 0);
                TextSize = 14;
                Text = Button.Text;
                ZIndex = 6;
                Parent = Inner;
            });

            Library:Create('UIGradient', {
                Color = rgbseq({
                    rgbkey(0, color(1, 1, 1)),
                    rgbkey(1, rgb(212, 212, 212))
                });
                Rotation = 90;
                Parent = Inner;
            });

            Library:AddToRegistry(Outer, {
                BorderColor3 = 'Black';
            });

            Library:AddToRegistry(Inner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            });

            Library:OnHighlight(Outer, Outer,
                { BorderColor3 = 'AccentColor' },
                { BorderColor3 = 'Black' }
            );

            return Outer, Inner, Label
        end

        local function InitEvents(Button)
            local function ValidateClick(Input)
                if Library:MouseIsOverOpenedFrame() then
                    return false
                end

                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return false
                end

                return true
            end

            local function SetConfirmState(Enabled)
                Library:RemoveFromRegistry(Button.Label)

                if Enabled then
                    Library:AddToRegistry(Button.Label, { TextColor3 = 'AccentColor' })
                    Button.Label.TextColor3 = Library.AccentColor
                    Button.Label.Text = 'Are you sure?'
                else
                    Library:AddToRegistry(Button.Label, { TextColor3 = 'FontColor' })
                    Button.Label.TextColor3 = Library.FontColor
                    Button.Label.Text = Button.Text
                end
            end

            local function ResetConfirm(Token)
                if Button.ConfirmToken ~= Token then
                    return
                end

                Button.ConfirmToken = nil
                Button.AwaitingConfirm = false
                Button.Locked = false
                SetConfirmState(false)
            end

            Button.Outer.InputBegan:Connect(function(Input)
                if not ValidateClick(Input) then return end
                if Button.Locked and not Button.AwaitingConfirm then return end

                if Button.DoubleClick then
                    if Button.AwaitingConfirm then
                        Button.ConfirmToken = nil
                        Button.AwaitingConfirm = false
                        Button.Locked = false
                        SetConfirmState(false)
                        Library:SafeCallback(Button.Func)
                        return
                    end

                    local Token = {}
                    Button.ConfirmToken = Token
                    Button.AwaitingConfirm = true
                    Button.Locked = true
                    SetConfirmState(true)
                    task.delay(0.5, ResetConfirm, Token)
                    return
                end

                Library:SafeCallback(Button.Func);
            end)
        end

        Button.Outer, Button.Inner, Button.Label = CreateBaseButton(Button)
        Button.Outer.Parent = Container

        InitEvents(Button)

        function Button:AddTooltip(tooltip)
            if type(tooltip) == 'string' then
                Library:AddToolTip(tooltip, self.Outer)
            end
            return self
        end

        function Button:AddButton(...)
            local SubButton = {}

            ProcessButtonParams(SubButton, ...)

            self.Outer.Size = dim2(0.5, -2, 0, 20)

            SubButton.Outer, SubButton.Inner, SubButton.Label = CreateBaseButton(SubButton)

            SubButton.Outer.Position = dim2(1, 3, 0, 0)
            SubButton.Outer.Size = dim2(1, -1, 1, 0)
            SubButton.Outer.Parent = self.Outer

            function SubButton:AddTooltip(tooltip)
                if type(tooltip) == 'string' then
                    Library:AddToolTip(tooltip, self.Outer)
                end
                return SubButton
            end

            if type(SubButton.Tooltip) == 'string' then
                SubButton:AddTooltip(SubButton.Tooltip)
            end

            InitEvents(SubButton)
            return SubButton
        end

        if type(Button.Tooltip) == 'string' then
            Button:AddTooltip(Button.Tooltip)
        end

        Groupbox:AddBlank(5);
        Groupbox:Resize();

        return Button;
    end;

    function Funcs:AddDivider()
        local Groupbox = self;
        local Container = self.Container

        local Divider = {
            Type = 'Divider',
        }

        Groupbox:AddBlank(2);
        local DividerOuter = Library:Create('Frame', {
            BackgroundColor3 = color(0, 0, 0);
            BorderColor3 = color(0, 0, 0);
            Size = dim2(1, -4, 0, 5);
            ZIndex = 5;
            Parent = Container;
        });

        local DividerInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 6;
            Parent = DividerOuter;
        });

        Library:AddToRegistry(DividerOuter, {
            BorderColor3 = 'Black';
        });

        Library:AddToRegistry(DividerInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Groupbox:AddBlank(9);
        Groupbox:Resize();
    end

    function Funcs:AddInput(Idx, Info)
        assert(Info.Text, 'AddInput: Missing `Text` string.')

        local Textbox = {
            Value = Info.Default or '';
            Numeric = Info.Numeric or false;
            Finished = Info.Finished or false;
            Type = 'Input';
            Callback = Info.Callback or function(Value) end;
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        Library:CreateLabel({
            Size = dim2(1, 0, 0, 15);
            TextSize = 14;
            Text = Info.Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 5;
            Parent = Container;
        });

        Groupbox:AddBlank(1);

        local TextBoxOuter = Library:Create('Frame', {
            BackgroundColor3 = color(0, 0, 0);
            BorderColor3 = color(0, 0, 0);
            Size = dim2(1, -4, 0, 20);
            ZIndex = 5;
            Parent = Container;
        });

        local TextBoxInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 6;
            Parent = TextBoxOuter;
        });

        Library:AddToRegistry(TextBoxInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:OnHighlight(TextBoxOuter, TextBoxOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, TextBoxOuter)
        end

        Library:Create('UIGradient', {
            Color = rgbseq({
                rgbkey(0, color(1, 1, 1)),
                rgbkey(1, rgb(212, 212, 212))
            });
            Rotation = 90;
            Parent = TextBoxInner;
        });

        local Container = Library:Create('Frame', {
            BackgroundTransparency = 1;
            ClipsDescendants = true;

            Position = dim2(0, 5, 0, 0);
            Size = dim2(1, -5, 1, 0);

            ZIndex = 7;
            Parent = TextBoxInner;
        })

        local Box = Library:Create('TextBox', {
            BackgroundTransparency = 1;

            Position = dim_offset(0, 0),
            Size = UDim2.fromScale(5, 1),

            Font = Library.DefaultFont;
            PlaceholderColor3 = rgb(190, 190, 190);
            PlaceholderText = Info.Placeholder or '';

            Text = Info.Default or '';
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextStrokeTransparency = 0;
            TextXAlignment = Enum.TextXAlignment.Left;

            ZIndex = 7;
            Parent = Container;
        });

        Library:ApplyTextStroke(Box);

        function Textbox:SetValue(Text)
            if Info.MaxLength and #Text > Info.MaxLength then
                Text = Text:sub(1, Info.MaxLength);
            end;

            if Textbox.Numeric then
                if (not tonumber(Text)) and Text:len() > 0 then
                    Text = Textbox.Value
                end
            end

            Textbox.Value = Text;
            Box.Text = Text;

            Library:SafeCallback(Textbox.Callback, Textbox.Value);
            Library:SafeCallback(Textbox.Changed, Textbox.Value);
        end;

        if Textbox.Finished then
            Box.FocusLost:Connect(function(enter)
                if not enter then return end

                Textbox:SetValue(Box.Text);
                Library:AttemptSave();
            end)
        else
            Box:GetPropertyChangedSignal('Text'):Connect(function()
                Textbox:SetValue(Box.Text);
                Library:AttemptSave();
            end);
        end

        -- https://devforum.roblox.com/t/how-to-make-textboxes-follow-current-cursor-position/1368429/6
        -- thank you nicemike40 :)

        local function Update()
            local PADDING = 2
            local reveal = Container.AbsoluteSize.X

            if not Box:IsFocused() or Box.TextBounds.X <= reveal - 2 * PADDING then
                -- we aren't focused, or we fit so be normal
                Box.Position = dim2(0, PADDING, 0, 0)
            else
                -- we are focused and don't fit, so adjust position
                local cursor = Box.CursorPosition
                if cursor ~= -1 then
                    -- calculate pixel width of text from start to cursor
                    local subtext = string.sub(Box.Text, 1, cursor-1)
                    local width = text_service:GetTextSize(subtext, Box.TextSize, Box.Font, vec2(math.huge, math.huge)).X

                    -- check if we're inside the box with the cursor
                    local currentCursorPos = Box.Position.X.Offset + width

                    -- adjust if necessary
                    if currentCursorPos < PADDING then
                        Box.Position = dim_offset(PADDING-width, 0)
                    elseif currentCursorPos > reveal - PADDING - 1 then
                        Box.Position = dim_offset(reveal-width-PADDING-1, 0)
                    end
                end
            end
        end

        task.spawn(Update)

        Box:GetPropertyChangedSignal('Text'):Connect(Update)
        Box:GetPropertyChangedSignal('CursorPosition'):Connect(Update)
        Box.FocusLost:Connect(Update)
        Box.Focused:Connect(Update)

        Library:AddToRegistry(Box, {
            TextColor3 = 'FontColor';
        });

        function Textbox:OnChanged(Func)
            Textbox.Changed = Func;
            Func(Textbox.Value);
        end;

        Groupbox:AddBlank(5);
        Groupbox:Resize();

        Options[Idx] = Textbox;

        return Textbox;
    end;

    function Funcs:AddToggle(Idx, Info)
        assert(Info.Text, 'AddInput: Missing `Text` string.')

        local Toggle = {
            Value = Info.Default or false;
            Type = 'Toggle';

            Callback = Info.Callback or function(Value) end;
            Addons = {},
            Risky = Info.Risky,
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local ToggleOuter = Library:Create('Frame', {
            BackgroundColor3 = color(0, 0, 0);
            BorderColor3 = color(0, 0, 0);
            Size = dim2(0, 13, 0, 13);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(ToggleOuter, {
            BorderColor3 = 'Black';
        });

        local ToggleInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 6;
            Parent = ToggleOuter;
        });

        Library:AddToRegistry(ToggleInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local ToggleLabel = Library:CreateLabel({
            Size = dim2(0, 216, 1, 0);
            Position = dim2(1, 6, 0, 0);
            TextSize = 14;
            Text = Info.Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 6;
            Parent = ToggleInner;
        });

        Library:Create('UIListLayout', {
            Padding = dim(0, 4);
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = ToggleLabel;
        });

        local ToggleRegion = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = dim2(0, 170, 1, 0);
            ZIndex = 8;
            Parent = ToggleOuter;
        });

        function Toggle:UpdateHitbox()
            local Width = Container.AbsoluteSize.X;

            if Width <= 0 then
                return;
            end;

            ToggleLabel.Size = dim2(0, max(Width - 23, 216), 1, 0);

            local RightInset = 0;

            for _, Addon in next, Toggle.Addons do
                local AddonFrame = Addon.DisplayFrame or Addon.PickOuter;

                if AddonFrame and AddonFrame.AbsoluteSize.X > 0 then
                    local Offset = AddonFrame.AbsolutePosition.X - ToggleOuter.AbsolutePosition.X;

                    if Offset > 0 then
                        RightInset = max(RightInset, Width - Offset + 4);
                    end;
                end;
            end;

            if RightInset == 0 and #Toggle.Addons > 0 then
                RightInset = 44;
            end;

            ToggleRegion.Size = dim2(0, max(13, Width - RightInset), 1, 0);
        end;

        Toggle:UpdateHitbox();
        Container:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
            Toggle:UpdateHitbox();
        end);

        ToggleRegion.MouseEnter:Connect(function()
            if Toggle.IgnoreToggleHover then
                return;
            end;

            tween_service:Create(ToggleOuter, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BorderColor3 = Library.AccentColor
            }):Play();

            Library.RegistryMap[ToggleOuter].Properties.BorderColor3 = 'AccentColor';
        end);

        ToggleRegion.MouseLeave:Connect(function()
            tween_service:Create(ToggleOuter, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BorderColor3 = Library.Black
            }):Play();

            Library.RegistryMap[ToggleOuter].Properties.BorderColor3 = 'Black';
        end);

        function Toggle:UpdateColors()
            Toggle:Display();
        end;

        function Toggle:IsMouseOverAddon()
            for _, Addon in next, Toggle.Addons do
                if Addon.DisplayFrame and Library:IsMouseOverFrame(Addon.DisplayFrame) then
                    return true;
                end;

                if Addon.PickOuter and Library:IsMouseOverFrame(Addon.PickOuter) then
                    return true;
                end;
            end;
        end;

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, ToggleRegion)
        end

function Toggle:Display()
    local targetColor = Toggle.Value and Library.AccentColor or Library.MainColor;
    local targetBorder = Toggle.Value and Library.AccentColorDark or Library.OutlineColor;

    tween_service:Create(ToggleInner, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = targetColor,
        BorderColor3 = targetBorder
    }):Play();

    Library.RegistryMap[ToggleInner].Properties.BackgroundColor3 = Toggle.Value and 'AccentColor' or 'MainColor';
    Library.RegistryMap[ToggleInner].Properties.BorderColor3 = Toggle.Value and 'AccentColorDark' or 'OutlineColor';
end;

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func;
            Func(Toggle.Value);
        end;

        function Toggle:SetValue(Bool)
            Bool = (not not Bool);

            Toggle.Value = Bool;
            Toggle:Display();

            for _, Addon in next, Toggle.Addons do
                if Addon.Type == 'KeyPicker' and Addon.SyncToggleState then
                    Addon.Toggled = Bool
                    Addon:Update()
                end
            end

            Library:SafeCallback(Toggle.Callback, Toggle.Value);
            Library:SafeCallback(Toggle.Changed, Toggle.Value);
            Library:UpdateDependencyBoxes();
        end;

        ToggleRegion.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                if Toggle.IgnoreNextToggleClick or Toggle:IsMouseOverAddon() then
                    Toggle.IgnoreNextToggleClick = false;
                    return;
                end;

                Toggle:SetValue(not Toggle.Value) -- Why was it not like this from the start?
                Library:AttemptSave();
            end;
        end);

        if Toggle.Risky then
            Library:RemoveFromRegistry(ToggleLabel)
            ToggleLabel.TextColor3 = Library.RiskColor
            Library:AddToRegistry(ToggleLabel, { TextColor3 = 'RiskColor' })
        end

        Toggle:Display();
        Groupbox:AddBlank(Info.BlankSize or 5 + 2);
        Groupbox:Resize();

        Toggle.TextLabel = ToggleLabel;
        Toggle.Container = Container;
        Toggle.ToggleOuter = ToggleOuter;
        setmetatable(Toggle, BaseAddons);

        Toggles[Idx] = Toggle;

        Library:UpdateDependencyBoxes();

        return Toggle;
    end;

    function Funcs:AddSlider(Idx, Info)
        assert(Info.Default, 'AddSlider: Missing default value.');
        assert(Info.Text, 'AddSlider: Missing slider text.');
        assert(Info.Min, 'AddSlider: Missing minimum value.');
        assert(Info.Max, 'AddSlider: Missing maximum value.');
        assert(Info.Rounding, 'AddSlider: Missing rounding value.');

local Slider = {
            Value = Info.Default;
            Min = Info.Min;
            Max = Info.Max;
            Rounding = Info.Rounding;
            MaxSize = 232;
            Type = 'Slider';
            Callback = Info.Callback or function(Value) end;
            UpdateMaxSize = function(self)
                self.MaxSize = SliderInner.AbsoluteSize.X;
            end;
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        if not Info.Compact then
            Library:CreateLabel({
                Size = dim2(1, 0, 0, 10);
                TextSize = 14;
                Text = Info.Text;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                ZIndex = 5;
                Parent = Container;
            });

            Groupbox:AddBlank(3);
        end

        local SliderOuter = Library:Create('Frame', {
            BackgroundColor3 = color(0, 0, 0);
            BorderColor3 = color(0, 0, 0);
            Size = dim2(1, -4, 0, 13);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(SliderOuter, {
            BorderColor3 = 'Black';
        });

        local SliderInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 6;
            Parent = SliderOuter;
        });

        Library:AddToRegistry(SliderInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        SliderInner:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
            Slider.MaxSize = SliderInner.AbsoluteSize.X;
            Slider:Display();
        end);

        local Fill = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderColor3 = Library.AccentColorDark;
            Size = dim2(0, 0, 1, 0);
            ZIndex = 7;
            Parent = SliderInner;
        });

        Library:AddToRegistry(Fill, {
            BackgroundColor3 = 'AccentColor';
            BorderColor3 = 'AccentColorDark';
        });

local FillGradient = Library:Create('UIGradient', {
            Color = rgbseq({
                rgbkey(0, rgb(
                    min(255, Library.AccentColor.R * 255 + 20),
                    min(255, Library.AccentColor.G * 255 + 20),
                    min(255, Library.AccentColor.B * 255 + 20)
                )),
                rgbkey(1, Library.AccentColor)
            });
            Rotation = 0;
            Parent = Fill;
        });

        Library:AddToRegistry(FillGradient, {
            Color = function()
                return rgbseq({
                    rgbkey(0, rgb(
                        min(255, Library.AccentColor.R * 255 + 20),
                        min(255, Library.AccentColor.G * 255 + 20),
                        min(255, Library.AccentColor.B * 255 + 20)
                    )),
                    rgbkey(1, Library.AccentColor)
                });
            end
        });

        local HideBorderRight = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Position = dim2(1, 0, 0, 0);
            Size = dim2(0, 1, 1, 0);
            ZIndex = 8;
            Parent = Fill;
        });

        Library:AddToRegistry(HideBorderRight, {
            BackgroundColor3 = 'AccentColor';
        });

        local DisplayLabel = Library:CreateLabel({
            Size = dim2(1, 0, 1, 0);
            TextSize = 14;
            Text = 'Infinite';
            ZIndex = 9;
            Parent = SliderInner;
        });

        Library:OnHighlight(SliderOuter, SliderOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, SliderOuter)
        end

        function Slider:UpdateColors()
            Fill.BackgroundColor3 = Library.AccentColor;
            Fill.BorderColor3 = Library.AccentColorDark;
        end;

        function Slider:Display()
            local Suffix = Info.Suffix or '';

            if Info.Compact then
                DisplayLabel.Text = Info.Text .. ': ' .. Slider.Value .. Suffix
            elseif Info.HideMax then
                DisplayLabel.Text = string.format('%s', Slider.Value .. Suffix)
            else
                DisplayLabel.Text = string.format('%s/%s', Slider.Value .. Suffix, Slider.Max .. Suffix);
            end

            local X = ceil(Library:MapValue(Slider.Value, Slider.Min, Slider.Max, 0, Slider.MaxSize));
            Fill.Size = dim2(0, X, 1, 0);

            HideBorderRight.Visible = not (X == Slider.MaxSize or X == 0);
        end;

        function Slider:OnChanged(Func)
            Slider.Changed = Func;
            Func(Slider.Value);
        end;

        local function Round(Value)
            if Slider.Rounding == 0 then
                return floor(Value);
            end;


            return tonumber(string.format('%.' .. Slider.Rounding .. 'f', Value))
        end;

        function Slider:GetValueFromXOffset(X)
            return Round(Library:MapValue(X, 0, Slider.MaxSize, Slider.Min, Slider.Max));
        end;

        function Slider:SetValue(Str)
            local Num = tonumber(Str);

            if (not Num) then
                return;
            end;

            Num = clamp(Num, Slider.Min, Slider.Max);

            Slider.Value = Num;
            Slider:Display();

            Library:SafeCallback(Slider.Callback, Slider.Value);
            Library:SafeCallback(Slider.Changed, Slider.Value);
        end;

SliderInner.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
        local mPos = mouse.X;
        local gPos = Fill.Size.X.Offset;
        local Diff = mPos - (Fill.AbsolutePosition.X + gPos);

        while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            local nMPos = mouse.X;
            local nX = clamp(gPos + (nMPos - mPos) + Diff, 0, Slider.MaxSize);

            local nValue = Slider:GetValueFromXOffset(nX);
            local OldValue = Slider.Value;
            Slider.Value = nValue;

            -- Smooth slider animation
            tween_service:Create(Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = dim2(0, nX, 1, 0)
            }):Play();

            -- Update text immediately
            local Suffix = Info.Suffix or '';
            if Info.Compact then
                DisplayLabel.Text = Info.Text .. ': ' .. Slider.Value .. Suffix
            elseif Info.HideMax then
                DisplayLabel.Text = string.format('%s', Slider.Value .. Suffix)
            else
                DisplayLabel.Text = string.format('%s/%s', Slider.Value .. Suffix, Slider.Max .. Suffix);
            end

            HideBorderRight.Visible = not (nX == Slider.MaxSize or nX == 0);

            if nValue ~= OldValue then
                Library:SafeCallback(Slider.Callback, Slider.Value);
                Library:SafeCallback(Slider.Changed, Slider.Value);
            end;

            render_stepped:Wait();
        end;

        Library:AttemptSave();
    end;
end);

        Slider:Display();
        Groupbox:AddBlank(Info.BlankSize or 6);
        Groupbox:Resize();

        Options[Idx] = Slider;

        return Slider;
    end;

function Funcs:AddMultiSlider(Idx, Info)
        assert(Info.Default, 'AddMultiSlider: Missing default value (table with Min and Max).');
        assert(Info.Text, 'AddMultiSlider: Missing slider text.');
        assert(Info.Min, 'AddMultiSlider: Missing minimum value.');
        assert(Info.Max, 'AddMultiSlider: Missing maximum value.');
        assert(Info.Rounding, 'AddMultiSlider: Missing rounding value.');

local MultiSlider = {
            MinValue = Info.Default.Min or Info.Min;
            MaxValue = Info.Default.Max or Info.Max;
            Min = Info.Min;
            Max = Info.Max;
            Rounding = Info.Rounding;
            MinMaxSize = 0;
            MaxMaxSize = 0;
            Type = 'MultiSlider';
            Callback = Info.Callback or function(Values) end;
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        if not Info.Compact then
            Library:CreateLabel({
                Size = dim2(1, 0, 0, 10);
                TextSize = 14;
                Text = Info.Text;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                ZIndex = 5;
                Parent = Container;
            });

            Groupbox:AddBlank(3);
        end

        -- Container for both sliders side by side
        local SliderContainer = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = dim2(1, -4, 0, 13);
            ZIndex = 5;
            Parent = Container;
        });

        local function CreateSlider(IsMin, Position)
            local SliderOuter = Library:Create('Frame', {
                BackgroundColor3 = color(0, 0, 0);
                BorderColor3 = color(0, 0, 0);
                Position = Position;
                Size = dim2(0.5, -2, 0, 13);
                ZIndex = 5;
                Parent = SliderContainer;
            });

            Library:AddToRegistry(SliderOuter, {
                BorderColor3 = 'Black';
            });

            local SliderInner = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = dim2(1, 0, 1, 0);
                ZIndex = 6;
                Parent = SliderOuter;
            });

Library:AddToRegistry(SliderInner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            });

            local Fill = Library:Create('Frame', {
                BackgroundColor3 = Library.AccentColor;
                BorderColor3 = Library.AccentColorDark;
                Size = dim2(0, 0, 1, 0);
                ZIndex = 7;
                Parent = SliderInner;
            });

            Library:AddToRegistry(Fill, {
                BackgroundColor3 = 'AccentColor';
                BorderColor3 = 'AccentColorDark';
            });

            local FillGradient = Library:Create('UIGradient', {
                Color = rgbseq({
                    rgbkey(0, rgb(
                        min(255, Library.AccentColor.R * 255 + 20),
                        min(255, Library.AccentColor.G * 255 + 20),
                        min(255, Library.AccentColor.B * 255 + 20)
                    )),
                    rgbkey(1, Library.AccentColor)
                });
                Rotation = 0;
                Parent = Fill;
            });

            Library:AddToRegistry(FillGradient, {
                Color = function()
                    return rgbseq({
                        rgbkey(0, rgb(
                            min(255, Library.AccentColor.R * 255 + 20),
                            min(255, Library.AccentColor.G * 255 + 20),
                            min(255, Library.AccentColor.B * 255 + 20)
                        )),
                        rgbkey(1, Library.AccentColor)
                    });
                end
            });

            local HideBorderRight = Library:Create('Frame', {
                BackgroundColor3 = Library.AccentColor;
                BorderSizePixel = 0;
                Position = dim2(1, 0, 0, 0);
                Size = dim2(0, 1, 1, 0);
                ZIndex = 8;
                Parent = Fill;
            });

            Library:AddToRegistry(HideBorderRight, {
                BackgroundColor3 = 'AccentColor';
            });

            local DisplayLabel = Library:CreateLabel({
                Size = dim2(1, 0, 1, 0);
                TextSize = 14;
                Text = '';
                ZIndex = 9;
                Parent = SliderInner;
            });

            Library:OnHighlight(SliderOuter, SliderOuter,
                { BorderColor3 = 'AccentColor' },
                { BorderColor3 = 'Black' }
            );

            return {
                Outer = SliderOuter,
                Inner = SliderInner,
                Fill = Fill,
                Label = DisplayLabel,
                HideBorder = HideBorderRight
            };
        end

local MinSlider = CreateSlider(true, dim2(0, 0, 0, 0));
        local MaxSlider = CreateSlider(false, dim2(0.5, 2, 0, 0));

        -- Update MaxSize when sliders are resized
        MinSlider.Inner:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
            MultiSlider.MinMaxSize = MinSlider.Inner.AbsoluteSize.X;
            MultiSlider:Display();
        end);

        MaxSlider.Inner:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
            MultiSlider.MaxMaxSize = MaxSlider.Inner.AbsoluteSize.X;
            MultiSlider:Display();
        end);

        function MultiSlider:Display()
            local Suffix = Info.Suffix or '';

            MinSlider.Label.Text = 'Min: ' .. MultiSlider.MinValue .. Suffix;
            MaxSlider.Label.Text = 'Max: ' .. MultiSlider.MaxValue .. Suffix;

            local MinX = ceil(Library:MapValue(MultiSlider.MinValue, MultiSlider.Min, MultiSlider.Max, 0, MultiSlider.MinMaxSize));
            local MaxX = ceil(Library:MapValue(MultiSlider.MaxValue, MultiSlider.Min, MultiSlider.Max, 0, MultiSlider.MaxMaxSize));

            MinSlider.Fill.Size = dim2(0, MinX, 1, 0);
            MaxSlider.Fill.Size = dim2(0, MaxX, 1, 0);

            MinSlider.HideBorder.Visible = not (MinX == MultiSlider.MinMaxSize or MinX == 0);
            MaxSlider.HideBorder.Visible = not (MaxX == MultiSlider.MaxMaxSize or MaxX == 0);
        end;

        function MultiSlider:OnChanged(Func)
            MultiSlider.Changed = Func;
            Func({ Min = MultiSlider.MinValue, Max = MultiSlider.MaxValue });
        end;

        local function Round(Value)
            if MultiSlider.Rounding == 0 then
                return floor(Value);
            end;
            return tonumber(string.format('%.' .. MultiSlider.Rounding .. 'f', Value))
        end;

function MultiSlider:GetValueFromXOffset(X, IsMin)
            local MaxSize = IsMin and MultiSlider.MinMaxSize or MultiSlider.MaxMaxSize;
            return Round(Library:MapValue(X, 0, MaxSize, MultiSlider.Min, MultiSlider.Max));
        end;

        function MultiSlider:SetMin(Value)
            local Num = tonumber(Value);
            if (not Num) then return; end;

            Num = clamp(Num, MultiSlider.Min, MultiSlider.MaxValue);
            MultiSlider.MinValue = Num;
            MultiSlider:Display();

            Library:SafeCallback(MultiSlider.Callback, { Min = MultiSlider.MinValue, Max = MultiSlider.MaxValue });
            Library:SafeCallback(MultiSlider.Changed, { Min = MultiSlider.MinValue, Max = MultiSlider.MaxValue });
        end;

        function MultiSlider:SetMax(Value)
            local Num = tonumber(Value);
            if (not Num) then return; end;

            Num = clamp(Num, MultiSlider.MinValue, MultiSlider.Max);
            MultiSlider.MaxValue = Num;
            MultiSlider:Display();

            Library:SafeCallback(MultiSlider.Callback, { Min = MultiSlider.MinValue, Max = MultiSlider.MaxValue });
            Library:SafeCallback(MultiSlider.Changed, { Min = MultiSlider.MinValue, Max = MultiSlider.MaxValue });
        end;

MinSlider.Inner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                local mPos = mouse.X;
                local gPos = MinSlider.Fill.Size.X.Offset;
                local Diff = mPos - (MinSlider.Fill.AbsolutePosition.X + gPos);

                while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local nMPos = mouse.X;
                    local nX = clamp(gPos + (nMPos - mPos) + Diff, 0, MultiSlider.MinMaxSize);

                    local nValue = MultiSlider:GetValueFromXOffset(nX, true);

                    -- Don't allow min to go above max
                    if nValue <= MultiSlider.MaxValue then
                        MultiSlider.MinValue = nValue;

                        tween_service:Create(MinSlider.Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = dim2(0, nX, 1, 0)
                        }):Play();

                        MinSlider.Label.Text = 'Min: ' .. MultiSlider.MinValue .. (Info.Suffix or '');
                        MinSlider.HideBorder.Visible = not (nX == MultiSlider.MaxSize or nX == 0);

                        Library:SafeCallback(MultiSlider.Callback, { Min = MultiSlider.MinValue, Max = MultiSlider.MaxValue });
                        Library:SafeCallback(MultiSlider.Changed, { Min = MultiSlider.MinValue, Max = MultiSlider.MaxValue });
                    end;

                    render_stepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

MaxSlider.Inner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                local mPos = mouse.X;
                local gPos = MaxSlider.Fill.Size.X.Offset;
                local Diff = mPos - (MaxSlider.Fill.AbsolutePosition.X + gPos);

                while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local nMPos = mouse.X;
                    local nX = clamp(gPos + (nMPos - mPos) + Diff, 0, MultiSlider.MaxMaxSize);

                    local nValue = MultiSlider:GetValueFromXOffset(nX, false);

                    -- Don't allow max to go below min
                    if nValue >= MultiSlider.MinValue then
                        MultiSlider.MaxValue = nValue;

                        tween_service:Create(MaxSlider.Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = dim2(0, nX, 1, 0)
                        }):Play();

                        MaxSlider.Label.Text = 'Max: ' .. MultiSlider.MaxValue .. (Info.Suffix or '');
                        MaxSlider.HideBorder.Visible = not (nX == MultiSlider.MaxSize or nX == 0);

                        Library:SafeCallback(MultiSlider.Callback, { Min = MultiSlider.MinValue, Max = MultiSlider.MaxValue });
                        Library:SafeCallback(MultiSlider.Changed, { Min = MultiSlider.MinValue, Max = MultiSlider.MaxValue });
                    end;

                    render_stepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        MultiSlider:Display();
        Groupbox:AddBlank(Info.BlankSize or 6);
        Groupbox:Resize();

        Options[Idx] = MultiSlider;

        return MultiSlider;
    end;

    function Funcs:AddDualSlider(LeftIdx, RightIdx, LeftInfo, RightInfo)
        assert(LeftInfo.Default, 'AddDualSlider: Missing left slider default value.');
        assert(LeftInfo.Text, 'AddDualSlider: Missing left slider text.');
        assert(LeftInfo.Min, 'AddDualSlider: Missing left slider minimum value.');
        assert(LeftInfo.Max, 'AddDualSlider: Missing left slider maximum value.');
        assert(LeftInfo.Rounding, 'AddDualSlider: Missing left slider rounding value.');

        assert(RightInfo.Default, 'AddDualSlider: Missing right slider default value.');
        assert(RightInfo.Text, 'AddDualSlider: Missing right slider text.');
        assert(RightInfo.Min, 'AddDualSlider: Missing right slider minimum value.');
        assert(RightInfo.Max, 'AddDualSlider: Missing right slider maximum value.');
        assert(RightInfo.Rounding, 'AddDualSlider: Missing right slider rounding value.');

        local Groupbox = self;
        local Container = Groupbox.Container;

        local function CreateSliderObj(Info, Position, IsLeft)
            local Slider = {
                Value = Info.Default;
                Min = Info.Min;
                Max = Info.Max;
                Rounding = Info.Rounding;
                MaxSize = 0;
                Type = 'Slider';
                Callback = Info.Callback or function(Value) end;
            };

            local SliderOuter = Library:Create('Frame', {
                BackgroundColor3 = color(0, 0, 0);
                BorderColor3 = color(0, 0, 0);
                Position = Position;
                Size = dim2(0.5, -2, 0, 13);
                ZIndex = 5;
            });

            Library:AddToRegistry(SliderOuter, {
                BorderColor3 = 'Black';
            });

            local SliderInner = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = dim2(1, 0, 1, 0);
                ZIndex = 6;
                Parent = SliderOuter;
            });

            Library:AddToRegistry(SliderInner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            });

            SliderInner:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
                Slider.MaxSize = SliderInner.AbsoluteSize.X;
                Slider:Display();
            end);

            local Fill = Library:Create('Frame', {
                BackgroundColor3 = Library.AccentColor;
                BorderColor3 = Library.AccentColorDark;
                Size = dim2(0, 0, 1, 0);
                ZIndex = 7;
                Parent = SliderInner;
            });

            Library:AddToRegistry(Fill, {
                BackgroundColor3 = 'AccentColor';
                BorderColor3 = 'AccentColorDark';
            });

            local FillGradient = Library:Create('UIGradient', {
                Color = rgbseq({
                    rgbkey(0, rgb(
                        min(255, Library.AccentColor.R * 255 + 20),
                        min(255, Library.AccentColor.G * 255 + 20),
                        min(255, Library.AccentColor.B * 255 + 20)
                    )),
                    rgbkey(1, Library.AccentColor)
                });
                Rotation = 0;
                Parent = Fill;
            });

            Library:AddToRegistry(FillGradient, {
                Color = function()
                    return rgbseq({
                        rgbkey(0, rgb(
                            min(255, Library.AccentColor.R * 255 + 20),
                            min(255, Library.AccentColor.G * 255 + 20),
                            min(255, Library.AccentColor.B * 255 + 20)
                        )),
                        rgbkey(1, Library.AccentColor)
                    });
                end
            });

            local HideBorderRight = Library:Create('Frame', {
                BackgroundColor3 = Library.AccentColor;
                BorderSizePixel = 0;
                Position = dim2(1, 0, 0, 0);
                Size = dim2(0, 1, 1, 0);
                ZIndex = 8;
                Parent = Fill;
            });

            Library:AddToRegistry(HideBorderRight, {
                BackgroundColor3 = 'AccentColor';
            });

            local DisplayLabel = Library:CreateLabel({
                Size = dim2(1, 0, 1, 0);
                TextSize = 14;
                Text = '';
                ZIndex = 9;
                Parent = SliderInner;
            });

            Library:OnHighlight(SliderOuter, SliderOuter,
                { BorderColor3 = 'AccentColor' },
                { BorderColor3 = 'Black' }
            );

            if type(Info.Tooltip) == 'string' then
                Library:AddToolTip(Info.Tooltip, SliderOuter)
            end

            function Slider:UpdateColors()
                Fill.BackgroundColor3 = Library.AccentColor;
                Fill.BorderColor3 = Library.AccentColorDark;
            end;

            function Slider:Display()
                local Suffix = Info.Suffix or '';
                DisplayLabel.Text = Info.Text .. ': ' .. Slider.Value .. Suffix;

                local X = ceil(Library:MapValue(Slider.Value, Slider.Min, Slider.Max, 0, Slider.MaxSize));
                Fill.Size = dim2(0, X, 1, 0);

                HideBorderRight.Visible = not (X == Slider.MaxSize or X == 0);
            end;

            function Slider:OnChanged(Func)
                Slider.Changed = Func;
                Func(Slider.Value);
            end;

            local function Round(Value)
                if Slider.Rounding == 0 then
                    return floor(Value);
                end;
                return tonumber(string.format('%.' .. Slider.Rounding .. 'f', Value))
            end;

            function Slider:GetValueFromXOffset(X)
                return Round(Library:MapValue(X, 0, Slider.MaxSize, Slider.Min, Slider.Max));
            end;

            function Slider:SetValue(Str)
                local Num = tonumber(Str);
                if (not Num) then return; end;

                Num = clamp(Num, Slider.Min, Slider.Max);
                Slider.Value = Num;
                Slider:Display();

                Library:SafeCallback(Slider.Callback, Slider.Value);
                Library:SafeCallback(Slider.Changed, Slider.Value);
            end;

            SliderInner.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                    local mPos = mouse.X;
                    local gPos = Fill.Size.X.Offset;
                    local Diff = mPos - (Fill.AbsolutePosition.X + gPos);

                    while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        local nMPos = mouse.X;
                        local nX = clamp(gPos + (nMPos - mPos) + Diff, 0, Slider.MaxSize);

                        local nValue = Slider:GetValueFromXOffset(nX);
                        local OldValue = Slider.Value;
                        Slider.Value = nValue;

                        tween_service:Create(Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = dim2(0, nX, 1, 0)
                        }):Play();

                        local Suffix = Info.Suffix or '';
                        DisplayLabel.Text = Info.Text .. ': ' .. Slider.Value .. Suffix;
                        HideBorderRight.Visible = not (nX == Slider.MaxSize or nX == 0);

                        if nValue ~= OldValue then
                            Library:SafeCallback(Slider.Callback, Slider.Value);
                            Library:SafeCallback(Slider.Changed, Slider.Value);
                        end;

                        render_stepped:Wait();
                    end;

                    Library:AttemptSave();
                end;
            end);

            return Slider, SliderOuter, Fill, DisplayLabel, HideBorderRight;
        end

        local SliderContainer = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = dim2(1, -4, 0, 13);
            ZIndex = 5;
            Parent = Container;
        });

        local LeftSlider, LeftOuter = CreateSliderObj(LeftInfo, dim2(0, 0, 0, 0), true);
        local RightSlider, RightOuter = CreateSliderObj(RightInfo, dim2(0.5, 2, 0, 0), false);

        LeftOuter.Parent = SliderContainer;
        RightOuter.Parent = SliderContainer;

        LeftSlider:Display();
        RightSlider:Display();

        Groupbox:AddBlank(LeftInfo.BlankSize or 6);
        Groupbox:Resize();

        Options[LeftIdx] = LeftSlider;
        Options[RightIdx] = RightSlider;

        return LeftSlider, RightSlider;
    end;

    function Funcs:AddDropdown(Idx, Info)
        if Info.SpecialType == 'Player' then
            Info.Values = GetPlayersString();
            Info.AllowNull = true;
        elseif Info.SpecialType == 'Team' then
            Info.Values = GetTeamsString();
            Info.AllowNull = true;
        end;

        assert(Info.Values, 'AddDropdown: Missing dropdown value list.');
        assert(Info.AllowNull or Info.Default, 'AddDropdown: Missing default value. Pass `AllowNull` as true if this was intentional.')

        if (not Info.Text) then
            Info.Compact = true;
        end;

        local Dropdown = {
            Values = Info.Values;
            Value = Info.Multi and {};
            Multi = Info.Multi;
            Type = 'Dropdown';
            SpecialType = Info.SpecialType; -- can be either 'Player' or 'Team'
            Callback = Info.Callback or function(Value) end;
        };

        local IsWhitelistSearchDropdown = Idx == 'TargetAimbotWhitelist' or Idx == 'TeleportOnKnockedWhitelist';
        local IsWhitelistDropdown = false;
        if IsWhitelistSearchDropdown then
            Info.Searchable = true;
        end;

        local Groupbox = self;
        local Container = Groupbox.Container;

        local RelativeOffset = 0;

        if not Info.Compact then
            Library:CreateLabel({
                Size = dim2(1, 0, 0, 10);
                TextSize = 14;
                Text = Info.Text;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                ZIndex = 5;
                Parent = Container;
            });

            Groupbox:AddBlank(3);
        end

        for _, Element in next, Container:GetChildren() do
            if not Element:IsA('UIListLayout') then
                RelativeOffset = RelativeOffset + Element.Size.Y.Offset;
            end;
        end;

        local DropdownOuter = Library:Create('Frame', {
            BackgroundColor3 = color(0, 0, 0);
            BorderColor3 = IsWhitelistDropdown and rgb(82, 58, 31) or color(0, 0, 0);
            Size = dim2(1, -4, 0, 20);
            ZIndex = 5;
            Parent = Container;
        });

        if not IsWhitelistDropdown then
            Library:AddToRegistry(DropdownOuter, {
                BorderColor3 = 'Black';
            });
        end;

        local DropdownInner = Library:Create('Frame', {
            BackgroundColor3 = IsWhitelistDropdown and rgb(6, 6, 6) or Library.MainColor;
            BorderColor3 = IsWhitelistDropdown and rgb(48, 48, 48) or Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 6;
            Parent = DropdownOuter;
        });

        if not IsWhitelistDropdown then
            Library:AddToRegistry(DropdownInner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            });

            Library:Create('UIGradient', {
                Color = rgbseq({
                    rgbkey(0, color(1, 1, 1)),
                    rgbkey(1, rgb(212, 212, 212))
                });
                Rotation = 90;
                Parent = DropdownInner;
            });
        end;

        local DropdownArrow = Library:Create('ImageLabel', {
            AnchorPoint = vec2(0, 0.5);
            BackgroundTransparency = 1;
            Position = dim2(1, -16, 0.5, 0);
            Size = dim2(0, 12, 0, 12);
            Image = 'http://www.roblox.com/asset/?id=6282522798';
            ZIndex = 8;
            Parent = DropdownInner;
        });

        local ItemList = Library:CreateLabel({
            Position = dim2(0, 5, 0, 0);
            Size = dim2(1, -5, 1, 0);
            TextSize = IsWhitelistDropdown and 13 or 14;
            Text = '--';
            TextXAlignment = Enum.TextXAlignment.Left;
            TextWrapped = true;
            ZIndex = 7;
            Parent = DropdownInner;
        });

        if not IsWhitelistDropdown then
            Library:OnHighlight(DropdownOuter, DropdownOuter,
                { BorderColor3 = 'AccentColor' },
                { BorderColor3 = 'Black' }
            );
        end;

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, DropdownOuter)
        end

        local MAX_DROPDOWN_ITEMS = Info.MaxDropdownItems or (IsWhitelistDropdown and 10 or 8);
        local SearchHeight = Info.Searchable and 22 or 0;

local ListOuter = Library:Create('Frame', {
            BackgroundColor3 = color(0, 0, 0);
            BorderColor3 = IsWhitelistDropdown and rgb(70, 70, 70) or color(0, 0, 0);
            ZIndex = 20;
            Visible = false;
            Parent = ScreenGui;
        });

local function RecalculateListPosition()
    ListOuter.Position = dim_offset(DropdownOuter.AbsolutePosition.X, DropdownOuter.AbsolutePosition.Y + DropdownOuter.AbsoluteSize.Y + 1);
end;

local function RecalculateListSize(YSize)
    local ItemHeight = IsWhitelistDropdown and 21 or 20;
    ListOuter.Size = dim_offset(DropdownOuter.AbsoluteSize.X, SearchHeight + (YSize or (MAX_DROPDOWN_ITEMS * ItemHeight + 2)))
end;

RecalculateListPosition();
RecalculateListSize();

DropdownOuter:GetPropertyChangedSignal('AbsolutePosition'):Connect(RecalculateListPosition);
DropdownOuter:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
    RecalculateListPosition();
    RecalculateListSize();
end);

local ListInner = Library:Create('Frame', {
            BackgroundColor3 = IsWhitelistDropdown and rgb(5, 5, 5) or Library.BackgroundColor;
            BorderColor3 = IsWhitelistDropdown and rgb(30, 30, 30) or Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = dim2(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListOuter;
        });

        if not IsWhitelistDropdown then
            Library:AddToRegistry(ListInner, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });
        end;

        local Scrolling = Library:Create('ScrollingFrame', {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            CanvasSize = dim2(0, 0, 0, 0);
            Position = dim2(0, 0, 0, SearchHeight);
            Size = dim2(1, 0, 1, -SearchHeight);
            ZIndex = 21;
            Parent = ListInner;

            TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
            BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',

            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.AccentColor,
        });

        Library:AddToRegistry(Scrolling, {
            ScrollBarImageColor3 = 'AccentColor'
        })

        Library:Create('UIListLayout', {
            Padding = dim(0, 0);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Scrolling;
        });

        local SearchText = ''
        if Info.Searchable then
            local SearchBox = Library:Create('TextBox', {
                BackgroundColor3 = IsWhitelistDropdown and rgb(8, 8, 8) or Library.MainColor;
                BorderColor3 = IsWhitelistDropdown and rgb(44, 44, 44) or Library.OutlineColor;
                Position = IsWhitelistDropdown and dim2(0, 4, 0, 2) or dim2(0, 2, 0, 2);
                Size = IsWhitelistDropdown and dim2(1, -8, 0, 18) or dim2(1, -4, 0, 18);
                Font = Library.DefaultFont;
                PlaceholderText = IsWhitelistDropdown and 'search' or 'search...';
                Text = '';
                TextColor3 = IsWhitelistDropdown and rgb(165, 165, 165) or Library.FontColor;
                PlaceholderColor3 = IsWhitelistDropdown and rgb(115, 115, 115) or rgb(178, 178, 178);
                TextSize = IsWhitelistDropdown and 13 or 14;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 24;
                Parent = ListInner;
            });

            if not IsWhitelistDropdown then
                Library:AddToRegistry(SearchBox, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                    TextColor3 = 'FontColor';
                });
            end;

            SearchBox:GetPropertyChangedSignal('Text'):Connect(function()
                SearchText = SearchBox.Text:lower()
                Dropdown:BuildDropdownList()
            end)
        end

        function Dropdown:Display()
            local Values = Dropdown.Values;
            local Str = '';

            if Info.Multi then
                for Idx, Value in next, Values do
                    if Dropdown.Value[Value] then
                        Str = Str .. Value .. ', ';
                    end;
                end;

                Str = Str:sub(1, #Str - 2);
            else
                Str = Dropdown.Value or '';
            end;

            ItemList.Text = (Str == '' and '--' or Str);
        end;

        function Dropdown:GetActiveValues()
            if Info.Multi then
                local T = {};

                for Value, Bool in next, Dropdown.Value do
                    insert(T, Value);
                end;

                return T;
            else
                return Dropdown.Value and 1 or 0;
            end;
        end;

        function Dropdown:BuildDropdownList()
            local Values = Dropdown.Values;
            local Buttons = {};

            for _, Element in next, Scrolling:GetChildren() do
                if not Element:IsA('UIListLayout') then
                    for _, Descendant in next, Element:GetDescendants() do
                        Library:RemoveFromRegistry(Descendant);
                    end;
                    Library:RemoveFromRegistry(Element);
                    Element:Destroy();
                end;
            end;

            local Count = 0;

            for Idx, Value in next, Values do
                if SearchText ~= '' and not Value:lower():find(SearchText, 1, true) then
                    continue
                end

                local Table = {};

                Count = Count + 1;

                local ItemHeight = IsWhitelistDropdown and 21 or 20;
                local Button = Library:Create('Frame', {
                    BackgroundColor3 = IsWhitelistDropdown and rgb(8, 8, 8) or Library.MainColor;
                    BorderColor3 = IsWhitelistDropdown and rgb(28, 28, 28) or Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Middle;
                    Size = dim2(1, -1, 0, ItemHeight);
                    ZIndex = 23;
                    Active = true,
                    Parent = Scrolling;
                });

                if not IsWhitelistDropdown then
                    Library:AddToRegistry(Button, {
                        BackgroundColor3 = 'MainColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    Library:Create('UICorner', {
                        CornerRadius = dim(0, 4);
                        Parent = Button;
                    });
                end;


                local ButtonLabel = Library:CreateLabel({
                    Active = false;
                    Size = dim2(1, -8, 1, 0);
                    Position = dim2(0, IsWhitelistDropdown and 7 or 6, 0, 0);
                    TextSize = IsWhitelistDropdown and 13 or 14;
                    Text = Value;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 25;
                    Parent = Button;
                });

                if not IsWhitelistDropdown then
                    Library:OnHighlight(Button, Button,
                        { BorderColor3 = 'AccentColor', ZIndex = 24 },
                        { BorderColor3 = 'OutlineColor', ZIndex = 23 }
                    );
                end;

                local Selected;

                if Info.Multi then
                    Selected = Dropdown.Value[Value];
                else
                    Selected = Dropdown.Value == Value;
                end;

                function Table:UpdateButton()
                    if Info.Multi then
                        Selected = Dropdown.Value[Value];
                    else
                        Selected = Dropdown.Value == Value;
                    end;

                    ButtonLabel.TextColor3 = Selected and Library.AccentColor or (IsWhitelistDropdown and rgb(125, 125, 125) or Library.FontColor);
                    if Library.RegistryMap[ButtonLabel] then
                        Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and 'AccentColor' or 'FontColor';
                    end;
                end;

                ButtonLabel.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local Try = not Selected;

                        if Dropdown:GetActiveValues() == 1 and (not Try) and (not Info.AllowNull) then
                        else
                            if Info.Multi then
                                Selected = Try;

                                if Selected then
                                    Dropdown.Value[Value] = true;
                                else
                                    Dropdown.Value[Value] = nil;
                                end;
                            else
                                Selected = Try;

                                if Selected then
                                    Dropdown.Value = Value;
                                else
                                    Dropdown.Value = nil;
                                end;

                                for _, OtherButton in next, Buttons do
                                    OtherButton:UpdateButton();
                                end;
                            end;

                            Table:UpdateButton();
                            Dropdown:Display();

                            Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
                            Library:SafeCallback(Dropdown.Changed, Dropdown.Value);

                            Library:AttemptSave();
                        end;
                    end;
                end);

                Table:UpdateButton();
                Dropdown:Display();

                Buttons[Button] = Table;
            end;

            local ItemHeight = IsWhitelistDropdown and 21 or 20;
            Scrolling.CanvasSize = dim_offset(0, (Count * ItemHeight) + 1);

            local Y = clamp(Count * ItemHeight, 0, MAX_DROPDOWN_ITEMS * ItemHeight) + 1;
            RecalculateListSize(Y);
        end;

        function Dropdown:SetValues(NewValues)
            if NewValues then
                Dropdown.Values = NewValues;
            end;

            Dropdown:BuildDropdownList();
        end;

function Dropdown:OpenDropdown()
    ListOuter.Visible = true;
    Library.OpenedFrames[ListOuter] = true;

    tween_service:Create(DropdownArrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = 180
    }):Play();
end;

function Dropdown:CloseDropdown()
    tween_service:Create(DropdownArrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = 0
    }):Play();

    task.wait(0.2);
    ListOuter.Visible = false;
    Library.OpenedFrames[ListOuter] = nil;
end;

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func;
            Func(Dropdown.Value);
        end;

        function Dropdown:SetValue(Val)
            if Dropdown.Multi then
                local nTable = {};

                for Value, Bool in next, Val do
                    if find(Dropdown.Values, Value) then
                        nTable[Value] = true
                    end;
                end;

                Dropdown.Value = nTable;
            else
                if (not Val) then
                    Dropdown.Value = nil;
                elseif find(Dropdown.Values, Val) then
                    Dropdown.Value = Val;
                end;
            end;

            Dropdown:BuildDropdownList();

            Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
            Library:SafeCallback(Dropdown.Changed, Dropdown.Value);
        end;

        DropdownOuter.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                if ListOuter.Visible then
                    Dropdown:CloseDropdown();
                else
                    Dropdown:OpenDropdown();
                end;
            end;
        end);

        uis.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize;

                if mouse.X < AbsPos.X or mouse.X > AbsPos.X + AbsSize.X
                    or mouse.Y < (AbsPos.Y - 20 - 1) or mouse.Y > AbsPos.Y + AbsSize.Y then

                    Dropdown:CloseDropdown();
                end;
            end;
        end);

        Dropdown:BuildDropdownList();
        Dropdown:Display();

        local Defaults = {}

        if type(Info.Default) == 'string' then
            local Idx = find(Dropdown.Values, Info.Default)
            if Idx then
                insert(Defaults, Idx)
            end
        elseif type(Info.Default) == 'table' then
            for _, Value in next, Info.Default do
                local Idx = find(Dropdown.Values, Value)
                if Idx then
                    insert(Defaults, Idx)
                end
            end
        elseif type(Info.Default) == 'number' and Dropdown.Values[Info.Default] ~= nil then
            insert(Defaults, Info.Default)
        end

        if next(Defaults) then
            for i = 1, #Defaults do
                local Index = Defaults[i]
                if Info.Multi then
                    Dropdown.Value[Dropdown.Values[Index]] = true
                else
                    Dropdown.Value = Dropdown.Values[Index];
                end

                if (not Info.Multi) then break end
            end

            Dropdown:BuildDropdownList();
            Dropdown:Display();
        end

        Groupbox:AddBlank(Info.BlankSize or 5);
        Groupbox:Resize();

        Options[Idx] = Dropdown;

        return Dropdown;
    end;

    function Funcs:AddDependencyBox()
        local Depbox = {
            Dependencies = {};
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local Holder = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 0, 0);
            Visible = false;
            Parent = Container;
        });

        local Frame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 1, 0);
            Visible = true;
            Parent = Holder;
        });

        local Layout = Library:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Frame;
        });

        function Depbox:Resize()
            Holder.Size = dim2(1, 0, 0, Layout.AbsoluteContentSize.Y);
            Groupbox:Resize();
        end;

        Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
            Depbox:Resize();
        end);

        Holder:GetPropertyChangedSignal('Visible'):Connect(function()
            Depbox:Resize();
        end);

        function Depbox:Update()
            for _, Dependency in next, Depbox.Dependencies do
                local Elem = Dependency[1];
                local Value = Dependency[2];

                if Elem.Type == 'Toggle' and Elem.Value ~= Value then
                    Holder.Visible = false;
                    Depbox:Resize();
                    return;
                end;
            end;

            Holder.Visible = true;
            Depbox:Resize();
        end;

        function Depbox:SetupDependencies(Dependencies)
            for _, Dependency in next, Dependencies do
                assert(type(Dependency) == 'table', 'SetupDependencies: Dependency is not of type `table`.');
                assert(Dependency[1], 'SetupDependencies: Dependency is missing element argument.');
                assert(Dependency[2] ~= nil, 'SetupDependencies: Dependency is missing value argument.');
            end;

            Depbox.Dependencies = Dependencies;
            Depbox:Update();
        end;

        Depbox.Container = Frame;

        setmetatable(Depbox, BaseGroupbox);

        insert(Library.DependencyBoxes, Depbox);

        return Depbox;
    end;

    BaseGroupbox.__index = Funcs;
    BaseGroupbox.__namecall = function(Table, Key, ...)
        return Funcs[Key](...);
    end;
end;

-- < Create other UI elements >
do
    Library.NotificationArea = Library:Create('Frame', {
        Name = 'AtlasNotifications';
        BackgroundTransparency = 1;
        Position = UDim2.fromScale(0, 0);
        Size = UDim2.fromScale(1, 1);
        ZIndex = 10000;
        Parent = ScreenGui;
    });
    Library.Notifications = {};

    local WatermarkOuter = Library:Create('Frame', {
        BorderColor3 = color(0, 0, 0);
        Position = dim2(0, 100, 0, -25);
        Size = dim2(0, 213, 0, 20);
        ZIndex = 200;
        Visible = false;
        Parent = ScreenGui;
    });

    local WatermarkGlow = Library:Create('ImageLabel', {
    AnchorPoint = vec2(0.5, 0.5);
    BackgroundTransparency = 1;
    Image = 'http://www.roblox.com/asset/?id=18245826428';
    ImageColor3 = Library.GlowColorMatchAccent and Library.AccentColor or Library.GlowColor;
    ImageTransparency = Library.GlowTransparency;
    Position = dim2(0.5, 0, 0.5, 0);
    Size = dim2(1, Library.GlowSize, 1, Library.GlowSize);
    ScaleType = Enum.ScaleType.Slice;
    SliceCenter = rect(vec2(21, 21), vec2(79, 79));
    Visible = Library.GlowEnabled;
    ZIndex = 199;
    Parent = WatermarkOuter;
});

insert(Library.GlowInstances, WatermarkGlow);

    local WatermarkInner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.AccentColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = dim2(1, 0, 1, 0);
        ZIndex = 201;
        Parent = WatermarkOuter;
    });

    Library:AddToRegistry(WatermarkInner, {
        BorderColor3 = 'AccentColor';
    });

    local InnerFrame = Library:Create('Frame', {
        BackgroundColor3 = color(1, 1, 1);
        BorderSizePixel = 0;
        Position = dim2(0, 1, 0, 1);
        Size = dim2(1, -2, 1, -2);
        ZIndex = 202;
        Parent = WatermarkInner;
    });

    local Gradient = Library:Create('UIGradient', {
        Color = rgbseq({
            rgbkey(0, Library:GetDarkerColor(Library.MainColor)),
            rgbkey(1, Library.MainColor),
        });
        Rotation = -90;
        Parent = InnerFrame;
    });

    Library:AddToRegistry(Gradient, {
        Color = function()
            return rgbseq({
                rgbkey(0, Library:GetDarkerColor(Library.MainColor)),
                rgbkey(1, Library.MainColor),
            });
        end
    });

local WatermarkLabel = Library:CreateLabel({
    Position = dim2(0, 5, 0, 0);
    Size = dim2(1, -4, 1, 0);
    TextSize = 14;
    TextXAlignment = Enum.TextXAlignment.Left;
    ZIndex = 203;
    RichText = true;
    Parent = InnerFrame;
});

    Library.Watermark = WatermarkOuter;
    Library.WatermarkText = WatermarkLabel;
    Library:MakeDraggable(Library.Watermark);
    Library.KeybindFilter = 'Always';



    local KeybindOuter = Library:Create('Frame', {
        AnchorPoint = vec2(0, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Position = dim2(0, 10, 0, 10);
        Size = dim2(0, 170, 0, 26);
        Visible = false;
        ZIndex = 100;
        Parent = ScreenGui;
    });

    local KeybindInner = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = dim2(1, 0, 1, 0);
        ZIndex = 101;
        Parent = KeybindOuter;
    });

    Library:AddToRegistry(KeybindInner, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    }, true);

Library:CreateLabel({
    Size = dim2(1, -16, 0, 14);
    Position = dim_offset(8, 4),
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 12;
    Text = 'keybinds';
    ZIndex = 104;
    Parent = KeybindInner;
}, true);

local KeybindDivider = Library:Create('Frame', {
    BackgroundColor3 = Library.OutlineColor;
    BorderSizePixel = 0;
    Position = dim2(0, 6, 0, 20);
    Size = dim2(1, -12, 0, 1);
    ZIndex = 104;
    Parent = KeybindInner;
});

Library:AddToRegistry(KeybindDivider, {
    BackgroundColor3 = 'OutlineColor';
}, true);

local KeybindContainer = Library:Create('Frame', {
    BackgroundTransparency = 1;
    Size = dim2(1, 0, 1, -22);
    Position = dim2(0, 0, 0, 22);
    ZIndex = 1;
    Parent = KeybindInner;
});

Library:Create('UIListLayout', {
    FillDirection = Enum.FillDirection.Vertical;
    SortOrder = Enum.SortOrder.LayoutOrder;
    Padding = dim(0, 0);
    Parent = KeybindContainer;
});

Library:Create('UIPadding', {
    PaddingLeft = dim(0, 8),
    PaddingRight = dim(0, 8),
    PaddingTop = dim(0, 2),
    PaddingBottom = dim(0, 4),
    Parent = KeybindContainer,
})

    Library.KeybindFrame = KeybindOuter;
    Library.KeybindContainer = KeybindContainer;
    Library:MakeDraggable(KeybindOuter, 22);
end;

function Library:SetWatermarkVisibility(Bool)
    Library.Watermark.Visible = Bool;
end;

function Library:SetWatermark(Text)
    local X, Y = Library:GetTextBounds(Text, Library.DefaultFont, 14);
    Library.Watermark.Size = dim2(0, X + 15, 0, (Y * 1.5) + 3);
    Library:SetWatermarkVisibility(true)

    -- Store raw text for later updates
    Library.WatermarkRawText = Text;

    -- Split the text to color only the first part
    local pipePos = string.find(Text, '|')
    if pipePos then
        local firstPart = string.sub(Text, 1, pipePos - 1)
        local restPart = string.sub(Text, pipePos)
        local accentHex = string.format("#%02X%02X%02X",
            floor(Library.AccentColor.R * 255),
            floor(Library.AccentColor.G * 255),
            floor(Library.AccentColor.B * 255))
        Library.WatermarkText.Text = string.format('<font color="%s">%s</font>%s', accentHex, firstPart, restPart)
    else
        Library.WatermarkText.Text = Text;
    end
end;

function Library:UpdateNotifications()
    local Notifications = Library.Notifications or {};
    local BaseX = 29;
    local BaseY = 6;
    local Gap = 44;

    if #Notifications > 6 then
        Notifications[1]:Dismiss();
    end;

    for Idx, Notification in Notifications do
        if Notification.Active and Notification.Frame then
            local TargetPosition = UDim2.new(1, -BaseX, 0, BaseY + ((Idx - 1) * Gap));

            tween_service:Create(Notification.Frame, TweenInfo.new(0.14, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Position = TargetPosition
            }):Play();
        end;
    end;
end;

function Library:Notify(Text, TypeOrTime, Time)
    Text = tostring(Text or '');

    local Duration = 2;
    local Color = Library.AccentColor;
    local NotificationType = nil;

    if typeof(TypeOrTime) == 'Color3' then
        Color = TypeOrTime;
        Duration = typeof(Time) == 'number' and Time or Duration;
    elseif typeof(TypeOrTime) == 'number' and typeof(Time) == 'number' then
        NotificationType = TypeOrTime;
        Duration = Time;
    elseif typeof(TypeOrTime) == 'number' then
        Duration = TypeOrTime;
    end;

    if NotificationType == 1 then
        Color = rgb(174, 255, 0);
    elseif NotificationType == 2 then
        Color = rgb(255, 225, 0);
    elseif NotificationType == 3 or NotificationType == 4 then
        Color = rgb(255, 60, 63);
    end;

    Duration = clamp(Duration, 0.5, 7);

    local TextWidth = Library:GetTextBounds(Text, Enum.Font.GothamBold, 12);
    local Width = clamp(TextWidth + 43, 158, 320);
    local Height = 39;

    local Frame = Library:Create('Frame', {
        Name = 'AtlasNotification';
        BackgroundColor3 = rgb(7, 10, 15);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ClipsDescendants = true;
        AnchorPoint = Vector2.new(1, 0);
        Position = UDim2.new(1, -9, 0, 6);
        Size = dim_offset(Width, Height);
        ZIndex = 10001;
        Parent = Library.NotificationArea;
    });

    Library:Create('UICorner', {
        CornerRadius = dim(0, 7);
        Parent = Frame;
    });

    local Dot = Library:Create('Frame', {
        Name = 'Dot';
        BackgroundColor3 = rgb(88, 151, 255);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Position = dim_offset(14, 17);
        Size = dim_offset(4, 4);
        ZIndex = 10002;
        Parent = Frame;
    });

    Library:Create('UICorner', {
        CornerRadius = dim(1, 0);
        Parent = Dot;
    });

    local Label = Library:Create('TextLabel', {
        Name = 'Message';
        BackgroundTransparency = 1;
        Font = Enum.Font.GothamBold;
        Position = dim_offset(31, 0);
        Size = dim2(1, -39, 1, 0);
        Text = Text;
        TextTransparency = 1;
        TextColor3 = rgb(238, 241, 246);
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Center;
        TextTruncate = Enum.TextTruncate.AtEnd;
        ZIndex = 10002;
        Parent = Frame;
    });

    local Notification = {
        Active = true;
        Frame = Frame;
        Dot = Dot;
        Label = Label;
    };

    function Notification:Dismiss()
        if not self.Active then
            return;
        end;

        self.Active = false;

        for Idx, Item in Library.Notifications do
            if Item == self then
                remove(Library.Notifications, Idx);
                break;
            end;
        end;

        tween_service:Create(Frame, TweenInfo.new(0.12, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play();
        tween_service:Create(Frame, TweenInfo.new(0.12, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
            Position = Frame.Position + dim_offset(20, 0)
        }):Play();
        tween_service:Create(Dot, TweenInfo.new(0.12, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play();
        tween_service:Create(Label, TweenInfo.new(0.12, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
            TextTransparency = 1
        }):Play();

        task.delay(0.12, function()
            Frame:Destroy();
            Library:UpdateNotifications();
        end);
    end;

    insert(Library.Notifications, Notification);
    Library:UpdateNotifications();

    tween_service:Create(Frame, TweenInfo.new(0.12, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.08
    }):Play();
    tween_service:Create(Dot, TweenInfo.new(0.12, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play();
    tween_service:Create(Label, TweenInfo.new(0.12, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play();

    task.delay(Duration, function()
        Notification:Dismiss();
    end);
end;

function Library:CreateWindow(...)
    local Arguments = { ... }
    local Config = { AnchorPoint = Vector2.zero }

    if type(...) == 'table' then
        Config = ...;
    else
        Config.Title = Arguments[1]
        Config.AutoShow = Arguments[2] or false;
    end

    if type(Config.Title) ~= 'string' then Config.Title = 'No title' end
    if type(Config.TabPadding) ~= 'number' then Config.TabPadding = 6 end
    if type(Config.MenuFadeTime) ~= 'number' then Config.MenuFadeTime = 0.2 end

    if typeof(Config.Position) ~= 'UDim2' then Config.Position = dim_offset(175, 50) end
    if typeof(Config.Size) ~= 'UDim2' then Config.Size = dim_offset(550, 600) end

    if Config.Center then
        Config.AnchorPoint = vec2(0.5, 0.5)
        Config.Position = UDim2.fromScale(0.5, 0.5)
    end

    local Window = {
        Tabs = {};
    };

    local Outer = Library:Create('Frame', {
        AnchorPoint = Config.AnchorPoint,
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Position = Config.Position,
        Size = Config.Size,
        Visible = false;
        ZIndex = 1;
        Parent = ScreenGui;
    });

    Library:MakeDraggable(Outer, 25);

    local GlowColor = Library.GlowColorMatchAccent and Library.AccentColor or Library.GlowColor;

    local Glow = Library:Create('ImageLabel', {
        AnchorPoint = vec2(0.5, 0.5);
        BackgroundTransparency = 1;
        Image = 'http://www.roblox.com/asset/?id=18245826428';
        ImageColor3 = GlowColor;
        ImageTransparency = Library.GlowTransparency;
        Position = dim2(0.5, 0, 0.5, 0);
        Size = dim2(1, Library.GlowSize, 1, Library.GlowSize);
        ScaleType = Enum.ScaleType.Slice;
        SliceCenter = rect(vec2(21, 21), vec2(79, 79));
        Visible = Library.GlowEnabled;
        ZIndex = 0;
        Parent = Outer;
    });

    insert(Library.GlowInstances, Glow);

    -- Resize areas
local MinSize = vec2(400, 300);
local MaxSize = vec2(1000, 800);

-- Bottom-right corner resize
local ResizeCorner = Library:Create('Frame', {
    BackgroundTransparency = 1;
    Position = dim2(1, -15, 1, -15);
    Size = dim2(0, 15, 0, 15);
    ZIndex = 999;
    Parent = Outer;
});

-- Bottom edge resize
local ResizeBottom = Library:Create('Frame', {
    BackgroundTransparency = 1;
    Position = dim2(0, 15, 1, -5);
    Size = dim2(1, -30, 0, 5);
    ZIndex = 999;
    Parent = Outer;
});

-- Right edge resize
local ResizeRight = Library:Create('Frame', {
    BackgroundTransparency = 1;
    Position = dim2(1, -5, 0, 15);
    Size = dim2(0, 5, 1, -30);
    ZIndex = 999;
    Parent = Outer;
});

ResizeCorner.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        local StartSize = Outer.AbsoluteSize;
        local StartPos = vec2(mouse.X, mouse.Y);

        while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            local Delta = vec2(mouse.X - StartPos.X, mouse.Y - StartPos.Y);
            local NewSize = vec2(
                clamp(StartSize.X + Delta.X, MinSize.X, MaxSize.X),
                clamp(StartSize.Y + Delta.Y, MinSize.Y, MaxSize.Y)
            );

            Outer.Size = dim_offset(NewSize.X, NewSize.Y);

            render_stepped:Wait();
        end;
    end;
end);

ResizeBottom.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        local StartSize = Outer.AbsoluteSize;
        local StartPos = mouse.Y;

        while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            local Delta = mouse.Y - StartPos;
            local NewHeight = clamp(StartSize.Y + Delta, MinSize.Y, MaxSize.Y);

            Outer.Size = dim_offset(Outer.AbsoluteSize.X, NewHeight);

            render_stepped:Wait();
        end;
    end;
end);

ResizeRight.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        local StartSize = Outer.AbsoluteSize;
        local StartPos = mouse.X;

        while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            local Delta = mouse.X - StartPos;
            local NewWidth = clamp(StartSize.X + Delta, MinSize.X, MaxSize.X);

            Outer.Size = dim_offset(NewWidth, Outer.AbsoluteSize.Y);

            render_stepped:Wait();
        end;
    end;
end);

    Library:AddToRegistry(Outer, {
        BackgroundColor3 = 'AccentColor';
    });

    local Inner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.AccentColor;
        BorderMode = Enum.BorderMode.Inset;
        Position = dim2(0, 1, 0, 1);
        Size = dim2(1, -2, 1, -2);
        ZIndex = 1;
        Parent = Outer;
    });

    Library:AddToRegistry(Inner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'AccentColor';
    });

local WindowLabel = Library:CreateLabel({
    Position = dim2(0, 0, 0, 0);
    Size = dim2(1, 0, 0, 24);
    Text = '';
    TextXAlignment = Enum.TextXAlignment.Center;
    ZIndex = 1;
    Parent = Inner;
});

Library:AddToRegistry(WindowLabel, {
    TextColor3 = 'FontColor';
});

local AnimatedTitle = {
    Enabled = Config.AnimatedTitle ~= false,
    Speed = 0.08,
    FullText = Config.Title or '',
    CurrentIndex = 0,
    Direction = 1,
    PauseTime = 0,
    LastUpdate = 0,
}

function AnimatedTitle:Start()
    if not self.Enabled then
        WindowLabel.Text = self.FullText
        return
    end

    task.spawn(function()
        while self.Enabled and WindowLabel.Parent do
            local Now = tick()

            -- Handle pausing
            if self.PauseTime > 0 then
                if Now - self.LastUpdate >= self.PauseTime then
                    self.PauseTime = 0
                    self.LastUpdate = Now
                end
                task.wait(0.1)
            else
                -- Handle typing/deleting
                if Now - self.LastUpdate >= self.Speed then
                    if self.Direction == 1 then
                        -- Typing
                        self.CurrentIndex = self.CurrentIndex + 1
                        if self.CurrentIndex >= #self.FullText then
                            self.CurrentIndex = #self.FullText
                            self.PauseTime = 2 -- Pause for 2 seconds at full text
                            self.Direction = -1
                        end
                    else
                        -- Deleting
                        self.CurrentIndex = self.CurrentIndex - 1
                        if self.CurrentIndex <= 0 then
                            self.CurrentIndex = 0
                            self.PauseTime = 1 -- Pause for 1 second when empty
                            self.Direction = 1
                        end
                    end

                    WindowLabel.Text = string.sub(self.FullText, 1, self.CurrentIndex)
                    self.LastUpdate = Now
                end

                task.wait()
            end
        end
    end)
end

Window.AnimatedTitle = AnimatedTitle
AnimatedTitle:Start()

    local MainSectionOuter = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        Position = dim2(0, 8, 0, 26);
        Size = dim2(1, -16, 1, -34);
        ZIndex = 1;
        Parent = Inner;
    });

    Library:AddToRegistry(MainSectionOuter, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    });

    local MainSectionInner = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = color(0, 0, 0);
        BorderMode = Enum.BorderMode.Inset;
        Position = dim2(0, 0, 0, 0);
        Size = dim2(1, 0, 1, 0);
        ZIndex = 1;
        Parent = MainSectionOuter;
    });

    Library:AddToRegistry(MainSectionInner, {
        BackgroundColor3 = 'BackgroundColor';
    });

local TabArea = Library:Create('Frame', {
    BackgroundTransparency = 1;
    Position = dim2(0, 8, 0, 5);
    Size = dim2(1, -16, 0, 22);
    ZIndex = 1;
    Parent = MainSectionInner;
});

    local TabListLayout = Library:Create('UIListLayout', {
        Padding = dim(0, Config.TabPadding);
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = TabArea;
    });

    local TabContainer = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        Position = dim2(0, 8, 0, 31);
        Size = dim2(1, -16, 1, -39);
        ZIndex = 2;
        Parent = MainSectionInner;
    });


    Library:AddToRegistry(TabContainer, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });

function Window:SetWindowTitle(Title)
    Window.AnimatedTitle.FullText = Title
    Window.AnimatedTitle.CurrentIndex = 0
    Window.AnimatedTitle.Direction = 1

    if not Window.AnimatedTitle.Enabled then
        WindowLabel.Text = Title
    end
end;

    function Window:AddTab(Name)
        local Tab = {
            Groupboxes = {};
            Tabboxes = {};
        };

        local TabTextSize = 14;
        local TabButtonWidth = Library:GetTextBounds(Name, Library.DefaultFont, TabTextSize);

        local TabButton = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            Size = dim2(0, max(TabButtonWidth + 28, 58), 1, 0);
            ZIndex = 1;
            Parent = TabArea;
        });

        Library:AddToRegistry(TabButton, {
            BackgroundColor3 = 'BackgroundColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:CreateLabel({
            Position = dim2(0, 0, 0, 0);
            Size = dim2(1, 0, 1, -1);
            TextSize = TabTextSize;
            Text = Name;
            TextXAlignment = Enum.TextXAlignment.Center;
            ZIndex = 1;
            Parent = TabButton;
        });

local TabIndicator = Library:Create('Frame', {
    BackgroundColor3 = Library.AccentColor;
    BorderSizePixel = 0;
    Position = dim2(0, 0, 0, 0);
    Size = dim2(1, 0, 0, 2);
    BackgroundTransparency = 1;
    ZIndex = 10;
    Parent = TabButton;
});

Library:AddToRegistry(TabIndicator, {
    BackgroundColor3 = 'AccentColor';
});

        local Blocker = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderSizePixel = 0;
            Position = dim2(0, 0, 1, 0);
            Size = dim2(1, 0, 0, 1);
            BackgroundTransparency = 1;
            ZIndex = 3;
            Parent = TabButton;
        });

        Library:AddToRegistry(Blocker, {
            BackgroundColor3 = 'MainColor';
        });

        local TabFrame = Library:Create('Frame', {
            Name = 'TabFrame',
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, 0);
            Size = dim2(1, 0, 1, 0);
            Visible = false;
            ZIndex = 2;
            Parent = TabContainer;
        });

local LeftSide = Library:Create('ScrollingFrame', {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = dim2(0, 8 - 1, 0, 8 - 1);
            Size = dim2(0.5, -12 + 2, 1, -16);
            CanvasSize = dim2(0, 0, 0, 0);
            BottomImage = '';
            TopImage = '';
            ScrollBarThickness = 0;
            ZIndex = 2;
            Parent = TabFrame;
        });

        local RightSide = Library:Create('ScrollingFrame', {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = dim2(0.5, 4 + 1, 0, 8 - 1);
            Size = dim2(0.5, -12 + 2, 1, -16);
            CanvasSize = dim2(0, 0, 0, 0);
            BottomImage = '';
            TopImage = '';
            ScrollBarThickness = 0;
            ZIndex = 2;
            Parent = TabFrame;
        });

        Library:Create('UIListLayout', {
            Padding = dim(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            Parent = LeftSide;
        });

        Library:Create('UIListLayout', {
            Padding = dim(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            Parent = RightSide;
        });

        for _, Side in next, { LeftSide, RightSide } do
            Side:WaitForChild('UIListLayout'):GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                Side.CanvasSize = dim_offset(0, Side.UIListLayout.AbsoluteContentSize.Y);
            end);
        end;

function Tab:ShowTab()
    for _, OtherTab in next, Window.Tabs do
        if OtherTab ~= Tab then
            OtherTab:HideTab();
        end;
    end;

    Window.ActiveTab = Tab;
    Blocker.BackgroundTransparency = 0;
    TabButton.BackgroundColor3 = Library.MainColor;
    Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'MainColor';
    TabFrame.Visible = true;

    if Tab.IndicatorTween then
        Tab.IndicatorTween:Cancel();
        Tab.IndicatorTween = nil;
    end;
    TabIndicator.BackgroundTransparency = 0;
end;

function Tab:HideTab()
    if Window.ActiveTab == Tab then
        Window.ActiveTab = nil;
    end;

    Blocker.BackgroundTransparency = 1;
    TabButton.BackgroundColor3 = Library.BackgroundColor;
    Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'BackgroundColor';
    TabFrame.Visible = false;

    if Tab.IndicatorTween then
        Tab.IndicatorTween:Cancel();
        Tab.IndicatorTween = nil;
    end;
    TabIndicator.BackgroundTransparency = 1;
end;

        function Tab:SetLayoutOrder(Position)
            TabButton.LayoutOrder = Position;
            TabListLayout:ApplyLayout();
        end;

        function Tab:AddGroupbox(Info)
            local Groupbox = {};

            local BoxOuter = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = dim2(1, 0, 0, 507 + 2);
                ZIndex = 2;
                Parent = Info.Side == 1 and LeftSide or RightSide;
            });

            Library:AddToRegistry(BoxOuter, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });

            local BoxInner = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = color(0, 0, 0);
                -- BorderMode = Enum.BorderMode.Inset;
                Size = dim2(1, -2, 1, -2);
                Position = dim2(0, 1, 0, 1);
                ZIndex = 4;
                Parent = BoxOuter;
            });

            Library:AddToRegistry(BoxInner, {
                BackgroundColor3 = 'BackgroundColor';
            });

Library:CreateLabel({
    Size = dim2(1, 0, 0, 18);
    Position = dim2(0, 0, 0, 2);
    TextSize = 14;
    Text = Info.Name;
    TextXAlignment = Enum.TextXAlignment.Center;
    ZIndex = 5;
    Parent = BoxInner;
});

            local Container = Library:Create('Frame', {
                BackgroundTransparency = 1;
                Position = dim2(0, 4, 0, 20);
                Size = dim2(1, -4, 1, -20);
                ZIndex = 1;
                Parent = BoxInner;
            });

            Library:Create('UIListLayout', {
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = Container;
            });

            function Groupbox:Resize()
                local Size = 0;

                for _, Element in next, Groupbox.Container:GetChildren() do
                    if (not Element:IsA('UIListLayout')) and Element.Visible then
                        Size = Size + Element.Size.Y.Offset;
                    end;
                end;

                BoxOuter.Size = dim2(1, 0, 0, 20 + Size + 2 + 2);
            end;

            Groupbox.Container = Container;
            setmetatable(Groupbox, BaseGroupbox);

            Groupbox:AddBlank(3);
            Groupbox:Resize();

            Tab.Groupboxes[Info.Name] = Groupbox;

            return Groupbox;
        end;

        function Tab:AddLeftGroupbox(Name)
            return Tab:AddGroupbox({ Side = 1; Name = Name; });
        end;

        function Tab:AddRightGroupbox(Name)
            return Tab:AddGroupbox({ Side = 2; Name = Name; });
        end;

        function Tab:AddTabbox(Info)
            local Tabbox = {
                Tabs = {};
            };

            local BoxOuter = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = dim2(1, 0, 0, 0);
                ZIndex = 2;
                Parent = Info.Side == 1 and LeftSide or RightSide;
            });

            Library:AddToRegistry(BoxOuter, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });

            local BoxInner = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = color(0, 0, 0);
                -- BorderMode = Enum.BorderMode.Inset;
                Size = dim2(1, -2, 1, -2);
                Position = dim2(0, 1, 0, 1);
                ZIndex = 4;
                Parent = BoxOuter;
            });

            Library:AddToRegistry(BoxInner, {
                BackgroundColor3 = 'BackgroundColor';
            });

local Highlight = Library:Create('Frame', {
    BackgroundColor3 = Library.AccentColor;
    BorderSizePixel = 0;
    Size = dim2(1, 0, 0, 2);
    ZIndex = 10;
    BackgroundTransparency = 1;
    Parent = BoxInner;
});

Library:AddToRegistry(Highlight, {
    BackgroundColor3 = 'AccentColor';
});

local TabboxButtons = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = dim2(0, 1, 0, 1);
            Size = dim2(1, -2, 0, 18);
            ZIndex = 5;
            Parent = BoxInner;
        });

Library:Create('UIListLayout', {
            Padding = dim(0, 2);
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = TabboxButtons;
        });

            function Tabbox:AddTab(Name)
                local Tab = {};

local Button = Library:Create('Frame', {
    BackgroundColor3 = Library.MainColor;
    BorderColor3 = Library.OutlineColor;
    Size = dim2(0.5, 0, 1, 0);
    ZIndex = 6;
    Parent = TabboxButtons;
});

Library:AddToRegistry(Button, {
    BorderColor3 = 'OutlineColor';
});

                Library:AddToRegistry(Button, {
                    BackgroundColor3 = 'MainColor';
                });

                local ButtonLabel = Library:CreateLabel({
                    Position = dim2(0, 0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    TextSize = 14;
                    Text = Name;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    ZIndex = 7;
                    Parent = Button;
                });

local TabboxIndicator = Library:Create('Frame', {
    BackgroundColor3 = Library.AccentColor;
    BorderSizePixel = 0;
    Position = dim2(0, 0, 0, 0);
    Size = dim2(1, 0, 0, 2);
    BackgroundTransparency = 1;
    ZIndex = 10;
    Parent = Button;
});

Library:AddToRegistry(TabboxIndicator, {
    BackgroundColor3 = 'AccentColor';
});

                local Block = Library:Create('Frame', {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderSizePixel = 0;
                    Position = dim2(0, 0, 1, 0);
                    Size = dim2(1, 0, 0, 1);
                    Visible = false;
                    ZIndex = 9;
                    Parent = Button;
                });

                Library:AddToRegistry(Block, {
                    BackgroundColor3 = 'BackgroundColor';
                });

                local Container = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 20);
                    Size = dim2(1, -4, 1, -20);
                    ZIndex = 1;
                    Visible = false;
                    Parent = BoxInner;
                });

                Library:Create('UIListLayout', {
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = Container;
                });

function Tab:Show()
    for _, OtherTab in next, Tabbox.Tabs do
        if OtherTab ~= Tab then
            OtherTab:Hide();
        end;
    end;

    Tabbox.ActiveTab = Tab;
    Container.Visible = true;
    Block.Visible = true;

    Button.BackgroundColor3 = Library.BackgroundColor;
    Library.RegistryMap[Button].Properties.BackgroundColor3 = 'BackgroundColor';

    if Tab.IndicatorTween then
        Tab.IndicatorTween:Cancel();
        Tab.IndicatorTween = nil;
    end;
    TabboxIndicator.BackgroundTransparency = 0;

    Tab:Resize();
end;

function Tab:Hide()
    if Tabbox.ActiveTab == Tab then
        Tabbox.ActiveTab = nil;
    end;

    Container.Visible = false;
    Block.Visible = false;

    Button.BackgroundColor3 = Library.MainColor;
    Library.RegistryMap[Button].Properties.BackgroundColor3 = 'MainColor';

    if Tab.IndicatorTween then
        Tab.IndicatorTween:Cancel();
        Tab.IndicatorTween = nil;
    end;
    TabboxIndicator.BackgroundTransparency = 1;
end;

                function Tab:Resize()
                    local TabCount = 0;

                    for _, Tab in next, Tabbox.Tabs do
                        TabCount = TabCount + 1;
                    end;

                    for _, Button in next, TabboxButtons:GetChildren() do
                        if not Button:IsA('UIListLayout') then
                            Button.Size = dim2(1 / TabCount, 0, 1, 0);
                        end;
                    end;

                    if (not Container.Visible) then
                        return;
                    end;

                    local Size = 0;

                    for _, Element in next, Tab.Container:GetChildren() do
                        if (not Element:IsA('UIListLayout')) and Element.Visible then
                            Size = Size + Element.Size.Y.Offset;
                        end;
                    end;

                    BoxOuter.Size = dim2(1, 0, 0, 20 + Size + 2 + 2);
                end;

                Button.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                        Tab:Show();
                        Tab:Resize();
                    end;
                end);

                Tab.Container = Container;
                Tabbox.Tabs[Name] = Tab;

                setmetatable(Tab, BaseGroupbox);

                Tab:AddBlank(3);
                Tab:Resize();

                -- Show first tab (number is 2 cus of the UIListLayout that also sits in that instance)
                if #TabboxButtons:GetChildren() == 2 then
                    Tab:Show();
                end;

                return Tab;
            end;

            Tab.Tabboxes[Info.Name or ''] = Tabbox;

            return Tabbox;
        end;

        function Tab:AddLeftTabbox(Name)
            return Tab:AddTabbox({ Name = Name, Side = 1; });
        end;

        function Tab:AddRightTabbox(Name)
            return Tab:AddTabbox({ Name = Name, Side = 2; });
        end;

        TabButton.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Tab:ShowTab();
            end;
        end);

        Window.Tabs[Name] = Tab;

        -- This was the first tab added, so we show it by default.
        if #TabContainer:GetChildren() == 1 then
            Tab:ShowTab();
        end;

        return Tab;
    end;

    local ModalElement = Library:Create('TextButton', {
        BackgroundTransparency = 1;
        Size = dim2(0, 0, 0, 0);
        Visible = true;
        Text = '';
        Modal = false;
        Parent = ScreenGui;
    });

    local TransparencyCache = {};
    local Toggled = false;
    local Fading = false;

    function Library:Toggle()
        if Fading then
            return;
        end;

        local FadeTime = Config.MenuFadeTime;
        Fading = true;
        Toggled = (not Toggled);
        ModalElement.Modal = Toggled;

        if Toggled then
            -- A bit scuffed, but if we're going from not toggled -> toggled we want to show the frame immediately so that the fade is visible.
            Outer.Visible = true;

            task.spawn(function()
                local State = uis.MouseIconEnabled;
                local CursorTransparency = 0;
                local LastStep = 0;

                local Cursor = Drawing.new('Triangle');
                Cursor.Thickness = 1;
                Cursor.Filled = true;
                Cursor.Visible = true;
                Cursor.Transparency = 0;

                local CursorOutline = Drawing.new('Triangle');
                CursorOutline.Thickness = 1;
                CursorOutline.Filled = false;
                CursorOutline.Color = color(0, 0, 0);
                CursorOutline.Visible = true;
                CursorOutline.Transparency = 0;

                while (Toggled or CursorTransparency > 0) and ScreenGui.Parent do
                    uis.MouseIconEnabled = false;

                    if FadeTime > 0 then
                        CursorTransparency = clamp(CursorTransparency + (Toggled and LastStep or -LastStep) / FadeTime, 0, 1);
                    else
                        CursorTransparency = Toggled and 1 or 0;
                    end;

                    local mPos = uis:GetMouseLocation();

                    Cursor.Color = Library.AccentColor;
                    Cursor.Transparency = CursorTransparency;
                    CursorOutline.Transparency = CursorTransparency;

                    Cursor.PointA = vec2(mPos.X, mPos.Y);
                    Cursor.PointB = vec2(mPos.X + 16, mPos.Y + 6);
                    Cursor.PointC = vec2(mPos.X + 6, mPos.Y + 16);

                    CursorOutline.PointA = Cursor.PointA;
                    CursorOutline.PointB = Cursor.PointB;
                    CursorOutline.PointC = Cursor.PointC;

                    LastStep = render_stepped:Wait();
                end;

                uis.MouseIconEnabled = State;

                Cursor:Remove();
                CursorOutline:Remove();
            end);
        end;

        for _, Desc in next, Outer:GetDescendants() do
            local Properties = {};

            if Desc:IsA('ImageLabel') then
                insert(Properties, 'ImageTransparency');
                insert(Properties, 'BackgroundTransparency');
            elseif Desc:IsA('TextLabel') or Desc:IsA('TextBox') then
                insert(Properties, 'TextTransparency');
            elseif Desc:IsA('Frame') or Desc:IsA('ScrollingFrame') then
                insert(Properties, 'BackgroundTransparency');
            elseif Desc:IsA('UIStroke') then
                insert(Properties, 'Transparency');
            end;

            local Cache = TransparencyCache[Desc];

            if (not Cache) then
                Cache = {};
                TransparencyCache[Desc] = Cache;
            end;

            for _, Prop in next, Properties do
                if not Cache[Prop] then
                    Cache[Prop] = Desc[Prop];
                end;

                if Cache[Prop] == 1 then
                    continue;
                end;

                tween_service:Create(Desc, TweenInfo.new(FadeTime, Enum.EasingStyle.Linear), { [Prop] = Toggled and Cache[Prop] or 1 }):Play();
            end;
        end;

        task.wait(FadeTime);

        Outer.Visible = Toggled;
        if Toggled and Window.ActiveTab then
            Window.ActiveTab:ShowTab();
        end;

        Fading = false;
    end

    Library:GiveSignal(uis.InputBegan:Connect(function(Input, Processed)
        if type(Library.ToggleKeybind) == 'table' and Library.ToggleKeybind.Type == 'KeyPicker' then
            if Input.UserInputType == Enum.UserInputType.Keyboard and Library:NormalizeKey(Input.KeyCode) == Library.ToggleKeybind.Value then
                task.spawn(Library.Toggle)
            end
        elseif Input.KeyCode == Enum.KeyCode.RightControl or (Input.KeyCode == Enum.KeyCode.RightShift and (not Processed)) then
            task.spawn(Library.Toggle)
        end
    end))

    if Config.AutoShow then task.spawn(Library.Toggle) end

    Window.Holder = Outer;

    return Window;
end;

local function OnPlayerChange()
    local PlayerList = GetPlayersString();

    for _, Value in next, Options do
        if Value.Type == 'Dropdown' and Value.SpecialType == 'Player' then
            Value:SetValues(PlayerList);
        end;
    end;

    if Script and Script.SyncAutoKillDropdownDisplay then
        Script.SyncAutoKillDropdownDisplay()
    end
end;

connect(plrs.PlayerAdded, OnPlayerChange);
connect(plrs.PlayerRemoving, OnPlayerChange);

getgenv().Library = Library

local ThemeManager = {} do
	ThemeManager.Folder = 'LinoriaLibSettings'
	ThemeManager.Library = nil
	ThemeManager.BuiltInThemes = {
		['default'] = { 1, http_service:JSONDecode('{"FontColor":"d8d8dc","MainColor":"111216","AccentColor":"e5a329","BackgroundColor":"090a0d","OutlineColor":"292b32"}') },
		['atlas'] = { 2, http_service:JSONDecode('{"FontColor":"d6def5","MainColor":"111722","AccentColor":"547cff","BackgroundColor":"080c14","OutlineColor":"26334d"}') },
		['fatality'] = { 3, http_service:JSONDecode('{"FontColor":"f3e8f0","MainColor":"21152d","AccentColor":"d12b75","BackgroundColor":"120b1a","OutlineColor":"43234d"}') },
		['gamesense'] = { 4, http_service:JSONDecode('{"FontColor":"e3e8dd","MainColor":"171a17","AccentColor":"9acd32","BackgroundColor":"0d0f0d","OutlineColor":"343b2d"}') },
		['neverlose'] = { 5, http_service:JSONDecode('{"FontColor":"d9efff","MainColor":"10212b","AccentColor":"00b7ff","BackgroundColor":"07141b","OutlineColor":"214657"}') },
		['ruby'] = { 6, http_service:JSONDecode('{"FontColor":"f4d4d8","MainColor":"241316","AccentColor":"db4b5e","BackgroundColor":"11090b","OutlineColor":"49242b"}') },
		['amethyst'] = { 7, http_service:JSONDecode('{"FontColor":"eadcff","MainColor":"1d1528","AccentColor":"ad6dff","BackgroundColor":"100b17","OutlineColor":"3e2a53"}') },
		['emerald'] = { 8, http_service:JSONDecode('{"FontColor":"d7f4e3","MainColor":"102019","AccentColor":"45c486","BackgroundColor":"08110d","OutlineColor":"224936"}') },
		['ocean'] = { 9, http_service:JSONDecode('{"FontColor":"d8ecff","MainColor":"101c2a","AccentColor":"3c8cff","BackgroundColor":"080f18","OutlineColor":"233d5d"}') },
		['rose'] = { 10, http_service:JSONDecode('{"FontColor":"ffe2eb","MainColor":"26151d","AccentColor":"ff76a5","BackgroundColor":"130a0f","OutlineColor":"4b2938"}') },
		['mint'] = { 11, http_service:JSONDecode('{"FontColor":"dffff0","MainColor":"10231d","AccentColor":"59e3b0","BackgroundColor":"08130f","OutlineColor":"285243"}') },
		['midnight'] = { 12, http_service:JSONDecode('{"FontColor":"d7dcf5","MainColor":"131628","AccentColor":"6675db","BackgroundColor":"090b16","OutlineColor":"2c3359"}') },
		['sunset'] = { 13, http_service:JSONDecode('{"FontColor":"ffe1d5","MainColor":"261812","AccentColor":"ff805d","BackgroundColor":"130c09","OutlineColor":"503026"}') },
		['monochrome'] = { 14, http_service:JSONDecode('{"FontColor":"dedede","MainColor":"171717","AccentColor":"8b8b8b","BackgroundColor":"0b0b0b","OutlineColor":"343434"}') },
		['synthwave'] = { 15, http_service:JSONDecode('{"FontColor":"ffe2ff","MainColor":"211334","AccentColor":"f14dce","BackgroundColor":"10091b","OutlineColor":"48275e"}') },
		['arctic'] = { 16, http_service:JSONDecode('{"FontColor":"1f3440","MainColor":"dceef4","AccentColor":"4aa7c5","BackgroundColor":"eff8fa","OutlineColor":"a4cbd7"}') },
	}

	function ThemeManager:ApplyTheme(theme)
		local customThemeData = self:GetCustomTheme(theme)
		local data = customThemeData or self.BuiltInThemes[theme]

		if not data then return false end

		local scheme = data[2]
		for idx, col in next, customThemeData or scheme do
			self.Library[idx] = Color3.fromHex(col)

			if Options[idx] then
				Options[idx]:SetValueRGB(Color3.fromHex(col))
			end
		end

		self:ThemeUpdate()
		return true
	end

	function ThemeManager:ThemeUpdate()
		-- This allows us to force apply themes without loading the themes tab :)
		local options = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
		for i, field in next, options do
			if Options and Options[field] then
				self.Library[field] = Options[field].Value
			end
		end

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
		self.Library:UpdateColorsUsingRegistry()
	end

	function ThemeManager:LoadDefault()
		local theme = 'default'
		local content = isfile(self.Folder .. '/default.txt') and readfile(self.Folder .. '/default.txt')

		local isDefault = true
		if content then
			if self.BuiltInThemes[content] then
				theme = content
			elseif self:GetCustomTheme(content) then
				theme = content
				isDefault = false;
			end
		elseif self.BuiltInThemes[self.DefaultTheme] then
		 	theme = self.DefaultTheme
		end

		if isDefault then
			Options.ThemeManager_ThemeList:SetValue(theme)
			self:ApplyTheme(theme)
		else
			self:ApplyTheme(theme)
		end
	end

	function ThemeManager:SaveDefault(theme)
		writefile(self.Folder .. '/default.txt', theme)
	end

	function ThemeManager:CreateThemeManager(groupbox)
		local function getDefaultTheme()
			return isfile(self.Folder .. '/default.txt') and readfile(self.Folder .. '/default.txt') or 'none'
		end

		local function refreshCustomThemes()
			Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end
		local defaultThemeLabel

		groupbox:AddLabel('background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
		groupbox:AddLabel('main color')	:AddColorPicker('MainColor', { Default = self.Library.MainColor });
		groupbox:AddLabel('accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
		groupbox:AddLabel('outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
		groupbox:AddLabel('font color')	:AddColorPicker('FontColor', { Default = self.Library.FontColor });

		local ThemesArray = {}
		for Name, Theme in next, self.BuiltInThemes do
			table.insert(ThemesArray, Name)
		end

		table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

		groupbox:AddDivider()
		groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'theme list', Values = ThemesArray, Default = 1 })

		groupbox:AddButton('apply theme', function()
			local theme = Options.ThemeManager_ThemeList.Value
			if theme then
				self:ApplyTheme(theme)
			end
		end)

		groupbox:AddButton('set as default', function()
			local theme = Options.ThemeManager_ThemeList.Value
			if theme then
				self:SaveDefault(theme)
				if defaultThemeLabel then
					defaultThemeLabel:SetText('default theme: ' .. theme)
				end
				self.Library:Notify(string.format('Set "%s" as default theme', theme))
			end
		end)

		groupbox:AddDivider()
		groupbox:AddInput('ThemeManager_CustomThemeName', { Text = 'custom theme name' })

		local customThemes = self:ReloadCustomThemes()
		groupbox:AddDropdown('ThemeManager_CustomThemeList', { Text = 'custom themes', Values = customThemes, AllowNull = true })

		groupbox:AddButton('save theme', function()
			local name = Options.ThemeManager_CustomThemeName.Value
			if not name or name:gsub(' ', '') == '' then
				return self.Library:Notify('Invalid theme name (empty)', 2)
			end

			self:SaveCustomTheme(name)
			self.Library:Notify(string.format('Saved custom theme %q', name))
			Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end):AddButton('load theme', function()
			local themeName = Options.ThemeManager_CustomThemeList.Value
			if not themeName or themeName == '' then
				return self.Library:Notify('No custom theme selected', 2)
			end

			local success = self:ApplyTheme(themeName)
			if success then
				self.Library:Notify(string.format('Loaded custom theme %q', themeName))
			end
		end)

		groupbox:AddButton('delete theme', function()
			if Options.ThemeManager_CustomThemeList.Value ~= nil and Options.ThemeManager_CustomThemeList.Value ~= '' then
				local path = self.Folder .. '/' .. Options.ThemeManager_CustomThemeList.Value .. '.json'
				if isfile(path) then
					delfile(path)
					self.Library:Notify(string.format('Deleted theme %q', Options.ThemeManager_CustomThemeList.Value))
					Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
					Options.ThemeManager_CustomThemeList:SetValue(nil)
				end
			end
		end)

		groupbox:AddDivider()
		groupbox:AddButton('export to clipboard', function()
			local theme = {}
			local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
			for _, field in next, fields do
				theme[field] = Options[field].Value:ToHex()
			end
			setclipboard(http_service:JSONEncode(theme))
			self.Library:Notify('Exported theme to clipboard')
		end)

		groupbox:AddButton('import from clipboard', function()
			local success, decoded = pcall(function()
				return http_service:JSONDecode(getclipboard())
			end)
			if success and decoded then
				for _, field in next, { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" } do
					if decoded[field] then
						Options[field]:SetValueRGB(Color3.fromHex(decoded[field]))
					end
				end
				self:ThemeUpdate()
				self.Library:Notify('Imported theme from clipboard')
			else
				self.Library:Notify('Failed to import theme from clipboard')
			end
		end)

		groupbox:AddDivider()
		groupbox:AddButton('generate random theme', function()
			local function randomColor()
				return Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
			end
			Options.BackgroundColor:SetValueRGB(randomColor())
			Options.MainColor:SetValueRGB(randomColor())
			Options.AccentColor:SetValueRGB(randomColor())
			Options.OutlineColor:SetValueRGB(randomColor())
			Options.FontColor:SetValueRGB(randomColor())
			self:ThemeUpdate()
			self.Library:Notify('Generated random theme')
		end)

		groupbox:AddButton('refresh list', refreshCustomThemes)
		groupbox:AddDivider()
		groupbox:AddLabel('default theme settings')
		defaultThemeLabel = groupbox:AddLabel('default theme: ' .. getDefaultTheme())

		groupbox:AddButton('set current as default', function()
			local theme = Options.ThemeManager_CustomThemeList.Value or Options.ThemeManager_ThemeList.Value
			if not theme then
				return self.Library:Notify('No theme selected', 2)
			end

			self:SaveDefault(theme)
			defaultThemeLabel:SetText('default theme: ' .. theme)
			self.Library:Notify(string.format('Set "%s" as default theme', theme))
		end):AddButton('clear default', function()
			if isfile(self.Folder .. '/default.txt') then
				delfile(self.Folder .. '/default.txt')
			end

			defaultThemeLabel:SetText('default theme: none')
			self.Library:Notify('Cleared default theme')
		end)

		ThemeManager:LoadDefault()

		local function UpdateTheme()
			self:ThemeUpdate()
		end

		Options.BackgroundColor:OnChanged(UpdateTheme)
		Options.MainColor:OnChanged(UpdateTheme)
		Options.AccentColor:OnChanged(UpdateTheme)
		Options.OutlineColor:OnChanged(UpdateTheme)
		Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:GetCustomTheme(file)
		local path = self.Folder .. '/' .. file .. '.json'
		if not isfile(path) then
			return nil
		end

		local data = readfile(path)
		local success, decoded = pcall(http_service.JSONDecode, http_service, data)

		if not success then
			return nil
		end

		return decoded
	end

	function ThemeManager:SaveCustomTheme(file)
		if file:gsub(' ', '') == '' then
			return self.Library:Notify('Invalid file name for theme (empty)', 3)
		end

		local theme = {}
		local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

		for _, field in next, fields do
			theme[field] = Options[field].Value:ToHex()
		end

		writefile(self.Folder .. '/' .. file .. '.json', http_service:JSONEncode(theme))
	end

	function ThemeManager:ReloadCustomThemes()
		local list = listfiles(self.Folder .. '/')

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then
				-- i hate this but it has to be done ...

				local pos = file:find('.json', 1, true)
				local char = file:sub(pos, pos)

				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					-- Strip the .json extension for display
					local name = file:sub(pos + 1)
					name = name:sub(1, -6) -- Remove '.json'
					table.insert(out, name)
				end
			end
		end

		return out
	end

	function ThemeManager:SetLibrary(lib)
		self.Library = lib
	end

	function ThemeManager:BuildFolderTree()
		local paths = {}

		-- build the entire tree if a path is like some-hub/phantom-forces
		-- makefolder builds the entire tree on Synapse X but not other exploits

		local parts = self.Folder:split('/')
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, '/', 1, idx)
		end

		table.insert(paths, self.Folder .. '/')

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function ThemeManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		return tab:AddLeftGroupbox('themes')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end

	ThemeManager:BuildFolderTree()
end

local SaveManager = {} do
	SaveManager.Folder = 'LinoriaLibSettings'
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object)
				return { type = 'Toggle', idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if Toggles[idx] then
					Toggles[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = 'Slider', idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				if Options[idx] then
					Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = 'Dropdown', idx = idx, value = object.Value, mutli = object.Multi }
			end,
			Load = function(idx, data)
				if Options[idx] then
					local value = data.value
					if type(value) == 'string' then
						value = { value }
					end
					Options[idx]:SetValue(value)
				end
			end,
		},
		ColorPicker = {
			Save = function(idx, object)
				return { type = 'ColorPicker', idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
			end,
			Load = function(idx, data)
				if Options[idx] then
					Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
				end
			end,
		},
		KeyPicker = {
			Save = function(idx, object)
				return { type = 'KeyPicker', idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data)
				if Options[idx] then
					Options[idx]:SetValue({ data.key, data.mode })
				end
			end,
		},

		Input = {
			Save = function(idx, object)
				return { type = 'Input', idx = idx, text = object.Value }
			end,
			Load = function(idx, data)
				if Options[idx] and type(data.text) == 'string' then
					Options[idx]:SetValue(data.text)
				end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list)
		for _, key in next, list do
			self.Ignore[key] = true
		end
	end

	function SaveManager:SetFolder(folder)
		self.Folder = folder;
		self:BuildFolderTree()
	end

	function SaveManager:Save(name)
		if (not name) then
			return false, 'no config file is selected'
		end

		local fullPath = self.Folder .. '/' .. name .. '.json'

		local data = {
			objects = {}
		}

		for idx, toggle in next, Toggles do
			if self.Ignore[idx] then continue end

			table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
		end

		for idx, option in next, Options do
			if not self.Parser[option.Type] then continue end
			if self.Ignore[idx] then continue end

			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
		end

		local success, encoded = pcall(http_service.JSONEncode, http_service, data)
		if not success then
			return false, 'failed to encode data'
		end

		writefile(fullPath, encoded)
		return true
	end

	function SaveManager:Load(name)
		if (not name) then
			return false, 'no config file is selected'
		end

		local file = self.Folder .. '/' .. name .. '.json'
		if not isfile(file) then return false, 'invalid file' end

		local success, decoded = pcall(http_service.JSONDecode, http_service, readfile(file))
		if not success then return false, 'decode error' end

		for _, option in next, decoded.objects do
			if self.Parser[option.type] then
				task.spawn(function() self.Parser[option.type].Load(option.idx, option) end) -- task.spawn() so the config loading wont get stuck.
			end
		end

		return true
	end

	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({
			"BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", -- themes
			"ThemeManager_ThemeList", 'ThemeManager_CustomThemeList', 'ThemeManager_CustomThemeName', -- themes
		})
	end

	function SaveManager:BuildFolderTree()
		local paths = {
			self.Folder
		}

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function SaveManager:RefreshConfigList()
		local list = listfiles(self.Folder)

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then
				-- i hate this but it has to be done ...

				local pos = file:find('.json', 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(out, file:sub(pos + 1, start - 1))
				end
			end
		end

		return out
	end

	function SaveManager:SetLibrary(library)
		self.Library = library
	end

	function SaveManager:LoadAutoloadConfig()
		if isfile(self.Folder .. '/autoload.txt') then
			local name = readfile(self.Folder .. '/autoload.txt')

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify('Failed to load autoload config: ' .. err)
			end

			self.Library:Notify(string.format('Auto loaded config %q', name))
		end
	end


	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, 'Must set SaveManager.Library')

		local section = tab:AddRightGroupbox('configuration')

		section:AddInput('SaveManager_ConfigName',    { Text = 'config name' })
		section:AddDropdown('SaveManager_ConfigList', { Text = 'config list', Values = self:RefreshConfigList(), AllowNull = true })

		section:AddDivider()

		section:AddButton('create', function()
			local name = Options.SaveManager_ConfigName.Value

			if name:gsub(' ', '') == '' then
				return self.Library:Notify('Invalid config name (empty)', 2)
			end

			local success, err = self:Save(name)
			if not success then
				return self.Library:Notify('Failed to save config: ' .. err)
			end

			self.Library:Notify(string.format('Created config %q', name))

			Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			Options.SaveManager_ConfigList:SetValue(nil)
		end):AddButton('load', function()
			local name = Options.SaveManager_ConfigList.Value

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify('Failed to load config: ' .. err)
			end

			self.Library:Notify(string.format('Loaded config %q', name))
		end)

		section:AddButton('overwrite', function()
			local name = Options.SaveManager_ConfigList.Value

			local success, err = self:Save(name)
			if not success then
				return self.Library:Notify('Failed to overwrite config: ' .. err)
			end

			self.Library:Notify(string.format('Overwrote config %q', name))
		end):AddButton('delete', function()
			local name = Options.SaveManager_ConfigList.Value
			if not name then
				return self.Library:Notify('No config selected', 2)
			end

			local path = self.Folder .. '/' .. name .. '.json'
			if isfile(path) then
				delfile(path)
				self.Library:Notify(string.format('Deleted config %q', name))
				Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
				Options.SaveManager_ConfigList:SetValue(nil)
			end
		end)

		section:AddButton('rename', function()
			local oldName = Options.SaveManager_ConfigList.Value
			local newName = Options.SaveManager_ConfigName.Value

			if not oldName then
				return self.Library:Notify('No config selected', 2)
			end
			if newName:gsub(' ', '') == '' then
				return self.Library:Notify('Invalid new name (empty)', 2)
			end

			local oldPath = self.Folder .. '/' .. oldName .. '.json'
			local newPath = self.Folder .. '/' .. newName .. '.json'
			if isfile(oldPath) then
				local content = readfile(oldPath)
				writefile(newPath, content)
				delfile(oldPath)
				self.Library:Notify(string.format('Renamed config %q to %q', oldName, newName))
				Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
				Options.SaveManager_ConfigList:SetValue(nil)
			end
		end):AddButton('duplicate', function()
			local name = Options.SaveManager_ConfigList.Value

			if not name then
				return self.Library:Notify('No config selected', 2)
			end

			local path = self.Folder .. '/' .. name .. '.json'
			if not isfile(path) then
				return self.Library:Notify('Config file not found', 2)
			end

			-- Generate a unique duplicate name
			local dupName
			local counter = 1
			repeat
				dupName = name .. ' (' .. counter .. ')'
				counter = counter + 1
			until not isfile(self.Folder .. '/' .. dupName .. '.json')

			local dupPath = self.Folder .. '/' .. dupName .. '.json'
			local content = readfile(path)
			writefile(dupPath, content)
			self.Library:Notify(string.format('Duplicated config %q to %q', name, dupName))
			Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			Options.SaveManager_ConfigList:SetValue(nil)
		end)

		section:AddDivider()
		section:AddButton('config info', function()
			local name = Options.SaveManager_ConfigList.Value
			if not name then
				return self.Library:Notify('No config selected', 2)
			end

			local path = self.Folder .. '/' .. name .. '.json'
			if isfile(path) then
				local content = readfile(path)
				local success, decoded = pcall(http_service.JSONDecode, http_service, content)
				if success and decoded then
					local count = #decoded.objects
					self.Library:Notify(string.format('Config %q has %d saved objects', name, count))
				else
					self.Library:Notify('Failed to read config info')
				end
			end
		end):AddButton('refresh list', function()
			Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			Options.SaveManager_ConfigList:SetValue(nil)
		end)

		section:AddDivider()
		section:AddButton('pin as autoload', function()
			local name = Options.SaveManager_ConfigList.Value
			if not name then
				return self.Library:Notify('No config selected', 2)
			end
			writefile(self.Folder .. '/autoload.txt', name)
			SaveManager.AutoloadLabel:SetText('autoload: ' .. name)
			self.Library:Notify(string.format('Set %q to auto load', name))
		end):AddButton('clear autoload', function()
			if isfile(self.Folder .. '/autoload.txt') then
				delfile(self.Folder .. '/autoload.txt')
			end
			SaveManager.AutoloadLabel:SetText('autoload: none')
			self.Library:Notify('Cleared autoload config')
		end)

		SaveManager.AutoloadLabel = section:AddLabel('autoload: none', true)

		if isfile(self.Folder .. '/autoload.txt') then
			local name = readfile(self.Folder .. '/autoload.txt')
			SaveManager.AutoloadLabel:SetText('autoload: ' .. name)
		end

		SaveManager:SetIgnoreIndexes({ 'SaveManager_ConfigList', 'SaveManager_ConfigName' })
	end

	SaveManager:BuildFolderTree()
end

getgenv().ThemeManager = ThemeManager
getgenv().SaveManager = SaveManager
end

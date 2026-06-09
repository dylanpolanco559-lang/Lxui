

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ================================================
-- CONFIGURACION
-- ================================================
local CONFIG = {
    Name        = "LLLLL.HUB",
    Version     = "v1.0",
    LogoID      = "rbxassetid://139936495253326",
    MenuIconID  = "rbxassetid://76570232811249",
    LoaderTime  = 3,  -- segundos
    -- Colores
    BG          = Color3.fromRGB(13, 14, 22),
    BGSecondary = Color3.fromRGB(18, 20, 32),
    Panel       = Color3.fromRGB(10, 11, 18),
    Accent      = Color3.fromRGB(80, 100, 220),
    AccentHover = Color3.fromRGB(100, 120, 255),
    Text        = Color3.fromRGB(220, 225, 255),
    TextDim     = Color3.fromRGB(120, 130, 160),
    Red         = Color3.fromRGB(220, 60, 60),
    Orange      = Color3.fromRGB(220, 160, 40),
    Border      = Color3.fromRGB(35, 40, 65),
}

-- ================================================
-- UTILIDADES
-- ================================================
local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function NewInstance(class, parent, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

-- ================================================
-- LIMPIAR GUI ANTERIOR
-- ================================================
if PlayerGui:FindFirstChild("LLLLL_HUB_GUI") then
    PlayerGui.LLLLL_HUB_GUI:Destroy()
end

-- ================================================
-- GUI RAIZ
-- ================================================
local ScreenGui = NewInstance("ScreenGui", PlayerGui, {
    Name            = "LLLLL_HUB_GUI",
    ResetOnSpawn    = false,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset  = true,
})

-- ================================================
-- LOADER / SPLASH SCREEN
-- ================================================
local LoaderFrame = NewInstance("Frame", ScreenGui, {
    Name            = "Loader",
    Size            = UDim2.fromScale(1, 1),
    Position        = UDim2.fromScale(0, 0),
    BackgroundColor3 = CONFIG.BG,
    BorderSizePixel = 0,
    ZIndex          = 100,
})

-- Imagen centrada
local LoaderImage = NewInstance("ImageLabel", LoaderFrame, {
    Name              = "Logo",
    Size              = UDim2.fromOffset(180, 180),
    Position          = UDim2.new(0.5, -90, 0.5, -130),
    BackgroundTransparency = 1,
    Image             = CONFIG.LogoID,
    ScaleType         = Enum.ScaleType.Fit,
    ZIndex            = 101,
})

-- Nombre debajo de imagen
local LoaderTitle = NewInstance("TextLabel", LoaderFrame, {
    Name              = "Title",
    Size              = UDim2.fromOffset(300, 36),
    Position          = UDim2.new(0.5, -150, 0.5, 60),
    BackgroundTransparency = 1,
    Text              = CONFIG.Name,
    TextColor3        = CONFIG.Text,
    TextSize          = 26,
    Font              = Enum.Font.GothamBold,
    ZIndex            = 101,
})

-- Subtitulo
local LoaderSub = NewInstance("TextLabel", LoaderFrame, {
    Name              = "Sub",
    Size              = UDim2.fromOffset(300, 22),
    Position          = UDim2.new(0.5, -150, 0.5, 96),
    BackgroundTransparency = 1,
    Text              = "Cargando...",
    TextColor3        = CONFIG.TextDim,
    TextSize          = 13,
    Font              = Enum.Font.Gotham,
    ZIndex            = 101,
})

-- Contenedor barra
local BarBG = NewInstance("Frame", LoaderFrame, {
    Name              = "BarBG",
    Size              = UDim2.fromOffset(260, 6),
    Position          = UDim2.new(0.5, -130, 0.5, 130),
    BackgroundColor3  = CONFIG.Border,
    BorderSizePixel   = 0,
    ZIndex            = 101,
})
NewInstance("UICorner", BarBG, { CornerRadius = UDim.new(1, 0) })

local BarFill = NewInstance("Frame", BarBG, {
    Name              = "Fill",
    Size              = UDim2.new(0, 0, 1, 0),
    BackgroundColor3  = CONFIG.Accent,
    BorderSizePixel   = 0,
    ZIndex            = 102,
})
NewInstance("UICorner", BarFill, { CornerRadius = UDim.new(1, 0) })

-- Contador porcentaje
local BarLabel = NewInstance("TextLabel", LoaderFrame, {
    Name              = "BarLabel",
    Size              = UDim2.fromOffset(260, 18),
    Position          = UDim2.new(0.5, -130, 0.5, 140),
    BackgroundTransparency = 1,
    Text              = "0 / 100",
    TextColor3        = CONFIG.TextDim,
    TextSize          = 11,
    Font              = Enum.Font.Gotham,
    TextXAlignment    = Enum.TextXAlignment.Right,
    ZIndex            = 101,
})

-- Animacion de carga
local steps = 100
local interval = CONFIG.LoaderTime / steps
local currentStep = 0

local loaderConnection
loaderConnection = RunService.Heartbeat:Connect(function(dt)
    -- Nada, usamos task.spawn para el loop
end)
loaderConnection:Disconnect()

task.spawn(function()
    for i = 1, steps do
        task.wait(interval)
        currentStep = i
        local pct = i / steps
        BarFill.Size = UDim2.new(pct, 0, 1, 0)
        BarLabel.Text = i .. " / 100"
        -- Cambiar color segun progreso
        BarFill.BackgroundColor3 = Color3.fromRGB(
            math.floor(80 + 60 * pct),
            math.floor(100 + 20 * pct),
            220
        )
    end

    LoaderSub.Text = "Listo!"
    task.wait(0.3)

    -- Desvanecer loader rapido
    Tween(LoaderFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
    })
    Tween(LoaderImage, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        ImageTransparency = 1,
    })
    for _, child in ipairs(LoaderFrame:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("Frame") then
            pcall(function()
                if child:IsA("TextLabel") then
                    Tween(child, TweenInfo.new(0.3), { TextTransparency = 1 })
                end
            end)
        end
    end

    task.wait(0.45)
    LoaderFrame:Destroy()

    -- Mostrar Hub
    showHub()
end)

-- ================================================
-- HUB PRINCIPAL
-- ================================================
function showHub()
    -- Variables de estado
    local isMinimized = false
    local currentTab = nil
    local tabs = {}

    -- Ventana principal
    local HubFrame = NewInstance("Frame", ScreenGui, {
        Name              = "Hub",
        Size              = UDim2.fromOffset(520, 360),
        Position          = UDim2.new(0.5, -260, 0.5, -180),
        BackgroundColor3  = CONFIG.BG,
        BorderSizePixel   = 0,
        ClipsDescendants  = true,
    })
    NewInstance("UICorner", HubFrame, { CornerRadius = UDim.new(0, 8) })
    NewInstance("UIStroke", HubFrame, {
        Color     = CONFIG.Border,
        Thickness = 1.5,
    })

    -- Entrada suave
    HubFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
    HubFrame.BackgroundTransparency = 1
    Tween(HubFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position              = UDim2.new(0.5, -260, 0.5, -180),
        BackgroundTransparency = 0,
    })

    -- ---- BARRA DE TITULO ----
    local TitleBar = NewInstance("Frame", HubFrame, {
        Name              = "TitleBar",
        Size              = UDim2.new(1, 0, 0, 42),
        BackgroundColor3  = CONFIG.BGSecondary,
        BorderSizePixel   = 0,
    })
    NewInstance("UICorner", TitleBar, { CornerRadius = UDim.new(0, 8) })
    -- Recortar esquinas inferiores redondeadas del titlebar
    NewInstance("Frame", TitleBar, {
        Size              = UDim2.new(1, 0, 0, 8),
        Position          = UDim2.new(0, 0, 1, -8),
        BackgroundColor3  = CONFIG.BGSecondary,
        BorderSizePixel   = 0,
    })

    -- Logo icono
    local LogoIcon = NewInstance("ImageLabel", TitleBar, {
        Size              = UDim2.fromOffset(28, 28),
        Position          = UDim2.new(0, 8, 0.5, -14),
        BackgroundColor3  = CONFIG.Accent,
        BackgroundTransparency = 0,
        Image             = CONFIG.LogoID,
        ScaleType         = Enum.ScaleType.Fit,
    })
    NewInstance("UICorner", LogoIcon, { CornerRadius = UDim.new(0, 6) })

    -- Nombre
    NewInstance("TextLabel", TitleBar, {
        Size              = UDim2.fromOffset(200, 20),
        Position          = UDim2.new(0, 44, 0, 5),
        BackgroundTransparency = 1,
        Text              = CONFIG.Name,
        TextColor3        = CONFIG.Text,
        TextSize          = 14,
        Font              = Enum.Font.GothamBold,
        TextXAlignment    = Enum.TextXAlignment.Left,
    })
    NewInstance("TextLabel", TitleBar, {
        Size              = UDim2.fromOffset(200, 14),
        Position          = UDim2.new(0, 44, 0, 23),
        BackgroundTransparency = 1,
        Text              = "by LLLLL  •  " .. CONFIG.Version,
        TextColor3        = CONFIG.TextDim,
        TextSize          = 10,
        Font              = Enum.Font.Gotham,
        TextXAlignment    = Enum.TextXAlignment.Left,
    })

    -- Botones de control (x, -)
    local function MakeCtrlBtn(color, symbol, xOffset)
        local btn = NewInstance("TextButton", TitleBar, {
            Size              = UDim2.fromOffset(20, 20),
            Position          = UDim2.new(1, xOffset, 0.5, -10),
            BackgroundColor3  = color,
            BorderSizePixel   = 0,
            Text              = symbol,
            TextColor3        = Color3.fromRGB(255,255,255),
            TextSize          = 12,
            Font              = Enum.Font.GothamBold,
        })
        NewInstance("UICorner", btn, { CornerRadius = UDim.new(1,0) })
        btn.MouseEnter:Connect(function()
            Tween(btn, TweenInfo.new(0.12), { Size = UDim2.fromOffset(22,22), Position = UDim2.new(1, xOffset-1, 0.5, -11) })
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, TweenInfo.new(0.12), { Size = UDim2.fromOffset(20,20), Position = UDim2.new(1, xOffset, 0.5, -10) })
        end)
        return btn
    end

    local CloseBtn   = MakeCtrlBtn(CONFIG.Red,    "×", -30)
    local MinBtn     = MakeCtrlBtn(CONFIG.Orange,  "−", -56)

    -- Draggable por titlebar
    MakeDraggable(HubFrame, TitleBar)

    -- ---- PANEL IZQUIERDO (tabs) ----
    local LeftPanel = NewInstance("Frame", HubFrame, {
        Name              = "LeftPanel",
        Size              = UDim2.new(0, 140, 1, -42),
        Position          = UDim2.new(0, 0, 0, 42),
        BackgroundColor3  = CONFIG.Panel,
        BorderSizePixel   = 0,
    })

    -- Separador vertical
    NewInstance("Frame", HubFrame, {
        Size              = UDim2.new(0, 1, 1, -42),
        Position          = UDim2.new(0, 140, 0, 42),
        BackgroundColor3  = CONFIG.Border,
        BorderSizePixel   = 0,
    })

    -- Icono de menu en panel izq arriba
    local MenuIcon = NewInstance("ImageLabel", LeftPanel, {
        Size              = UDim2.fromOffset(100, 100),
        Position          = UDim2.new(0.5, -50, 0, 10),
        BackgroundTransparency = 1,
        Image             = CONFIG.MenuIconID,
        ScaleType         = Enum.ScaleType.Fit,
    })

    local TabList = NewInstance("Frame", LeftPanel, {
        Size              = UDim2.new(1, 0, 1, -120),
        Position          = UDim2.new(0, 0, 0, 115),
        BackgroundTransparency = 1,
        ClipsDescendants  = true,
    })
    NewInstance("UIListLayout", TabList, {
        Padding           = UDim.new(0, 2),
        SortOrder         = Enum.SortOrder.LayoutOrder,
    })
    NewInstance("UIPadding", TabList, {
        PaddingLeft   = UDim.new(0, 6),
        PaddingRight  = UDim.new(0, 6),
        PaddingTop    = UDim.new(0, 4),
    })

    -- ---- PANEL DERECHO (contenido) ----
    local RightPanel = NewInstance("Frame", HubFrame, {
        Name              = "RightPanel",
        Size              = UDim2.new(1, -141, 1, -42),
        Position          = UDim2.new(0, 141, 0, 42),
        BackgroundColor3  = CONFIG.BGSecondary,
        BorderSizePixel   = 0,
        ClipsDescendants  = true,
    })

    -- Footer version
    NewInstance("TextLabel", HubFrame, {
        Size              = UDim2.new(1, 0, 0, 16),
        Position          = UDim2.new(0, 0, 1, -16),
        BackgroundTransparency = 1,
        Text              = CONFIG.Name .. "  " .. CONFIG.Version,
        TextColor3        = CONFIG.TextDim,
        TextSize          = 10,
        Font              = Enum.Font.Gotham,
        TextXAlignment    = Enum.TextXAlignment.Center,
        ZIndex            = 5,
    })

    -- ---- FUNCIONES DE LIBRERIA ----

    -- Crear tab
    local function AddTab(name, icon)
        local tabPage = NewInstance("ScrollingFrame", RightPanel, {
            Size              = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel   = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = CONFIG.Accent,
            Visible           = false,
            CanvasSize        = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
        })
        NewInstance("UIPadding", tabPage, {
            PaddingLeft   = UDim.new(0, 10),
            PaddingRight  = UDim.new(0, 10),
            PaddingTop    = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
        })
        NewInstance("UIListLayout", tabPage, {
            Padding   = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        -- Boton tab
        local tabBtn = NewInstance("TextButton", TabList, {
            Size              = UDim2.new(1, 0, 0, 32),
            BackgroundColor3  = CONFIG.BGSecondary,
            BorderSizePixel   = 0,
            Text              = "",
            AutoButtonColor   = false,
        })
        NewInstance("UICorner", tabBtn, { CornerRadius = UDim.new(0, 6) })

        if icon then
            NewInstance("ImageLabel", tabBtn, {
                Size              = UDim2.fromOffset(16, 16),
                Position          = UDim2.new(0, 8, 0.5, -8),
                BackgroundTransparency = 1,
                Image             = icon,
                ScaleType         = Enum.ScaleType.Fit,
            })
        end

        local tabLabel = NewInstance("TextLabel", tabBtn, {
            Size              = UDim2.new(1, icon and -32 or -10, 1, 0),
            Position          = UDim2.new(0, icon and 30 or 8, 0, 0),
            BackgroundTransparency = 1,
            Text              = name,
            TextColor3        = CONFIG.TextDim,
            TextSize          = 12,
            Font              = Enum.Font.GothamSemibold,
            TextXAlignment    = Enum.TextXAlignment.Left,
        })

        local isActive = false

        local function Activate()
            if currentTab and currentTab ~= tabPage then
                currentTab.Visible = false
            end
            currentTab = tabPage
            tabPage.Visible = true
            isActive = true
            Tween(tabBtn, TweenInfo.new(0.15), { BackgroundColor3 = CONFIG.Accent })
            Tween(tabLabel, TweenInfo.new(0.15), { TextColor3 = CONFIG.Text })
            -- Desactivar otros
            for _, t in ipairs(tabs) do
                if t.btn ~= tabBtn then
                    Tween(t.btn, TweenInfo.new(0.15), { BackgroundColor3 = CONFIG.BGSecondary })
                    Tween(t.lbl, TweenInfo.new(0.15), { TextColor3 = CONFIG.TextDim })
                end
            end
        end

        tabBtn.MouseButton1Click:Connect(Activate)
        tabBtn.MouseEnter:Connect(function()
            if currentTab ~= tabPage then
                Tween(tabBtn, TweenInfo.new(0.12), { BackgroundColor3 = CONFIG.Border })
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if currentTab ~= tabPage then
                Tween(tabBtn, TweenInfo.new(0.12), { BackgroundColor3 = CONFIG.BGSecondary })
            end
        end)

        local entry = { btn = tabBtn, lbl = tabLabel, page = tabPage, activate = Activate }
        table.insert(tabs, entry)

        -- Activar primer tab automaticamente
        if #tabs == 1 then
            task.defer(Activate)
        end

        -- Retorna objeto seccion para agregar elementos
        local Section = {}

        function Section:AddButton(text, callback)
            local btn = NewInstance("TextButton", tabPage, {
                Size              = UDim2.new(1, 0, 0, 36),
                BackgroundColor3  = CONFIG.BG,
                BorderSizePixel   = 0,
                Text              = "",
                AutoButtonColor   = false,
                LayoutOrder       = #tabPage:GetChildren(),
            })
            NewInstance("UICorner", btn, { CornerRadius = UDim.new(0, 6) })
            NewInstance("UIStroke", btn, { Color = CONFIG.Border, Thickness = 1 })
            NewInstance("TextLabel", btn, {
                Size              = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text              = text,
                TextColor3        = CONFIG.Text,
                TextSize          = 12,
                Font              = Enum.Font.GothamSemibold,
            })
            btn.MouseButton1Click:Connect(function()
                Tween(btn, TweenInfo.new(0.08), { BackgroundColor3 = CONFIG.Accent })
                task.delay(0.15, function()
                    Tween(btn, TweenInfo.new(0.15), { BackgroundColor3 = CONFIG.BG })
                end)
                if callback then pcall(callback) end
            end)
            btn.MouseEnter:Connect(function()
                Tween(btn, TweenInfo.new(0.12), { BackgroundColor3 = CONFIG.Border })
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, TweenInfo.new(0.12), { BackgroundColor3 = CONFIG.BG })
            end)
            return btn
        end

        function Section:AddToggle(text, default, callback)
            local state = default or false
            local row = NewInstance("Frame", tabPage, {
                Size              = UDim2.new(1, 0, 0, 36),
                BackgroundColor3  = CONFIG.BG,
                BorderSizePixel   = 0,
                LayoutOrder       = #tabPage:GetChildren(),
            })
            NewInstance("UICorner", row, { CornerRadius = UDim.new(0, 6) })
            NewInstance("UIStroke", row, { Color = CONFIG.Border, Thickness = 1 })
            NewInstance("TextLabel", row, {
                Size              = UDim2.new(1, -52, 1, 0),
                Position          = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text              = text,
                TextColor3        = CONFIG.Text,
                TextSize          = 12,
                Font              = Enum.Font.GothamSemibold,
                TextXAlignment    = Enum.TextXAlignment.Left,
            })
            local track = NewInstance("Frame", row, {
                Size              = UDim2.fromOffset(36, 20),
                Position          = UDim2.new(1, -44, 0.5, -10),
                BackgroundColor3  = state and CONFIG.Accent or CONFIG.Border,
                BorderSizePixel   = 0,
            })
            NewInstance("UICorner", track, { CornerRadius = UDim.new(1, 0) })
            local knob = NewInstance("Frame", track, {
                Size              = UDim2.fromOffset(14, 14),
                Position          = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                BackgroundColor3  = Color3.fromRGB(255,255,255),
                BorderSizePixel   = 0,
            })
            NewInstance("UICorner", knob, { CornerRadius = UDim.new(1, 0) })

            local btn = NewInstance("TextButton", row, {
                Size              = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text              = "",
            })
            btn.MouseButton1Click:Connect(function()
                state = not state
                Tween(track, TweenInfo.new(0.15), { BackgroundColor3 = state and CONFIG.Accent or CONFIG.Border })
                Tween(knob, TweenInfo.new(0.15), {
                    Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                })
                if callback then pcall(callback, state) end
            end)
            return row
        end

        function Section:AddLabel(text)
            local lbl = NewInstance("TextLabel", tabPage, {
                Size              = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Text              = text,
                TextColor3        = CONFIG.TextDim,
                TextSize          = 11,
                Font              = Enum.Font.Gotham,
                TextXAlignment    = Enum.TextXAlignment.Left,
                LayoutOrder       = #tabPage:GetChildren(),
            })
            return lbl
        end

        function Section:AddSeparator()
            local sep = NewInstance("Frame", tabPage, {
                Size              = UDim2.new(1, 0, 0, 1),
                BackgroundColor3  = CONFIG.Border,
                BorderSizePixel   = 0,
                LayoutOrder       = #tabPage:GetChildren(),
            })
            return sep
        end

        function Section:AddTextbox(placeholder, callback)
            local box = NewInstance("TextBox", tabPage, {
                Size              = UDim2.new(1, 0, 0, 36),
                BackgroundColor3  = CONFIG.BG,
                BorderSizePixel   = 0,
                PlaceholderText   = placeholder or "Escribe aqui...",
                PlaceholderColor3 = CONFIG.TextDim,
                Text              = "",
                TextColor3        = CONFIG.Text,
                TextSize          = 12,
                Font              = Enum.Font.Gotham,
                ClearTextOnFocus  = false,
                LayoutOrder       = #tabPage:GetChildren(),
            })
            NewInstance("UICorner", box, { CornerRadius = UDim.new(0, 6) })
            NewInstance("UIStroke", box, { Color = CONFIG.Border, Thickness = 1 })
            NewInstance("UIPadding", box, { PaddingLeft = UDim.new(0, 10) })
            box.FocusLost:Connect(function(enter)
                if enter and callback then pcall(callback, box.Text) end
                Tween(box, TweenInfo.new(0.12), { BackgroundColor3 = CONFIG.BG })
            end)
            box.Focused:Connect(function()
                Tween(box, TweenInfo.new(0.12), { BackgroundColor3 = CONFIG.BGSecondary })
            end)
            return box
        end

        return Section
    end

    -- ---- BOTON CERRAR ----
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(HubFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(520, 0),
            Position = UDim2.new(0.5, -260, 0.5, -180),
        })
        task.delay(0.3, function()
            ScreenGui:Destroy()
        end)
    end)

    -- ---- BOTON MINIMIZAR ----
    local normalSize = UDim2.fromOffset(520, 360)
    local miniSize   = UDim2.fromOffset(520, 42)

    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(HubFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = miniSize,
            })
            HubFrame.ClipsDescendants = true
        else
            Tween(HubFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = normalSize,
            })
        end
    end)

    -- ---- EXPONER API ----
    local Hub = {}

    function Hub:AddTab(name, icon)
        return AddTab(name, icon)
    end

    -- Retornar hub para que el usuario lo use
    return Hub
end

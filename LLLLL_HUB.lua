-- LLLLL.HUB UI Library
-- Uso: loadstring(game:HttpGet("RAW_URL"))()

local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ================================================
-- CONFIGURACION
-- ================================================
local CFG = {
    Name       = "LLLLL.HUB",
    Version    = "v1.0",
    LogoID     = "rbxassetid://139936495253326",
    MenuIconID = "rbxassetid://76570232811249",
    LoadTime   = 3,

    BG         = Color3.fromRGB(13,  14,  22),
    BG2        = Color3.fromRGB(18,  20,  32),
    Panel      = Color3.fromRGB(10,  11,  18),
    Accent     = Color3.fromRGB(80,  100, 220),
    Text       = Color3.fromRGB(220, 225, 255),
    TextDim    = Color3.fromRGB(120, 130, 160),
    Border     = Color3.fromRGB(35,  40,  65),
    Red        = Color3.fromRGB(220, 60,  60),
    Orange     = Color3.fromRGB(220, 160, 40),
}

-- ================================================
-- HELPERS
-- ================================================
local function tw(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad), props):Play()
end
local function twE(obj, t, style, dir, props)
    TweenService:Create(obj, TweenInfo.new(t, style, dir), props):Play()
end

local function New(class, parent, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end

local function Corner(parent, r)
    New("UICorner", parent, { CornerRadius = UDim.new(0, r or 8) })
end

local function Draggable(frame, handle)
    local drag, inp, s0, p0 = false, nil, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; s0 = i.Position; p0 = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then inp = i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i == inp and drag then
            local d = i.Position - s0
            frame.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X,
                                        p0.Y.Scale, p0.Y.Offset + d.Y)
        end
    end)
end

-- ================================================
-- LIMPIAR GUI ANTERIOR
-- ================================================
if PlayerGui:FindFirstChild("LLLLL_HUB") then
    PlayerGui.LLLLL_HUB:Destroy()
end

local Root = New("ScreenGui", PlayerGui, {
    Name            = "LLLLL_HUB",
    ResetOnSpawn    = false,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset  = true,
})

-- ================================================
-- LOADER / SPLASH
-- ================================================
local Loader = New("Frame", Root, {
    Name             = "Loader",
    Size             = UDim2.fromScale(1, 1),
    BackgroundColor3 = CFG.BG,
    BorderSizePixel  = 0,
    ZIndex           = 100,
})

-- Imagen logo centrada (sin fondo de color)
local LImg = New("ImageLabel", Loader, {
    Size                   = UDim2.fromOffset(200, 200),
    Position               = UDim2.new(0.5, -100, 0.5, -150),
    BackgroundTransparency = 1,
    Image                  = CFG.LogoID,
    ScaleType              = Enum.ScaleType.Fit,
    ZIndex                 = 101,
})
Corner(LImg, 16)

local LTitle = New("TextLabel", Loader, {
    Size                   = UDim2.fromOffset(320, 38),
    Position               = UDim2.new(0.5, -160, 0.5, 60),
    BackgroundTransparency = 1,
    Text                   = CFG.Name,
    TextColor3             = CFG.Text,
    TextSize               = 28,
    Font                   = Enum.Font.GothamBold,
    ZIndex                 = 101,
})

local LSub = New("TextLabel", Loader, {
    Size                   = UDim2.fromOffset(320, 20),
    Position               = UDim2.new(0.5, -160, 0.5, 100),
    BackgroundTransparency = 1,
    Text                   = "Cargando...",
    TextColor3             = CFG.TextDim,
    TextSize               = 13,
    Font                   = Enum.Font.Gotham,
    ZIndex                 = 101,
})

-- Barra de progreso
local BarBG = New("Frame", Loader, {
    Size             = UDim2.fromOffset(280, 6),
    Position         = UDim2.new(0.5, -140, 0.5, 134),
    BackgroundColor3 = CFG.Border,
    BorderSizePixel  = 0,
    ZIndex           = 101,
})
Corner(BarBG, 10)

local BarFill = New("Frame", BarBG, {
    Size             = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = CFG.Accent,
    BorderSizePixel  = 0,
    ZIndex           = 102,
})
Corner(BarFill, 10)

local BarNum = New("TextLabel", Loader, {
    Size                   = UDim2.fromOffset(280, 18),
    Position               = UDim2.new(0.5, -140, 0.5, 144),
    BackgroundTransparency = 1,
    Text                   = "0 / 100",
    TextColor3             = CFG.TextDim,
    TextSize               = 11,
    Font                   = Enum.Font.Gotham,
    TextXAlignment         = Enum.TextXAlignment.Right,
    ZIndex                 = 101,
})

-- ================================================
-- ANIMACION LOADER
-- ================================================
local function showHub() end  -- declarada abajo

task.spawn(function()
    local steps    = 100
    local interval = CFG.LoadTime / steps
    for i = 1, steps do
        task.wait(interval)
        local pct = i / steps
        BarFill.Size     = UDim2.new(pct, 0, 1, 0)
        BarNum.Text      = i .. " / 100"
        BarFill.BackgroundColor3 = Color3.fromRGB(
            math.floor(80  + 60 * pct),
            math.floor(100 + 20 * pct),
            220
        )
    end

    LSub.Text = "Listo!"
    task.wait(0.25)

    -- Desvanecer rapido
    tw(Loader,  0.3, { BackgroundTransparency = 1 })
    tw(LImg,    0.3, { ImageTransparency      = 1 })
    tw(LTitle,  0.2, { TextTransparency       = 1 })
    tw(LSub,    0.2, { TextTransparency       = 1 })
    tw(BarNum,  0.2, { TextTransparency       = 1 })
    tw(BarBG,   0.2, { BackgroundTransparency = 1 })
    tw(BarFill, 0.2, { BackgroundTransparency = 1 })

    task.wait(0.35)
    Loader:Destroy()
    showHub()
end)

-- ================================================
-- HUB PRINCIPAL
-- ================================================
function showHub()
    local isMinimized = false
    local currentTab  = nil
    local tabs        = {}

    -- ---- PASTILLA MINIMIZADA (estilo LX HUB) ----
    local Pill = New("Frame", Root, {
        Name             = "Pill",
        Size             = UDim2.fromOffset(160, 30),
        Position         = UDim2.new(0.5, -80, 0, 8),
        BackgroundColor3 = Color3.fromRGB(8, 9, 15),
        BorderSizePixel  = 0,
        Visible          = false,
        ZIndex           = 50,
    })
    Corner(Pill, 20)
    New("UIStroke", Pill, { Color = CFG.Border, Thickness = 1.5 })

    -- Punto indicador verde
    New("Frame", Pill, {
        Size             = UDim2.fromOffset(7, 7),
        Position         = UDim2.new(0, 14, 0.5, -3),
        BackgroundColor3 = Color3.fromRGB(80, 220, 100),
        BorderSizePixel  = 0,
        ZIndex           = 51,
    }):CFrame = CFrame.new()  -- solo para tener esquinas
    local pillDot = New("Frame", Pill, {
        Size             = UDim2.fromOffset(7, 7),
        Position         = UDim2.new(0, 14, 0.5, -3),
        BackgroundColor3 = Color3.fromRGB(80, 220, 100),
        BorderSizePixel  = 0,
        ZIndex           = 51,
    })
    Corner(pillDot, 10)

    New("TextLabel", Pill, {
        Size                   = UDim2.new(1, -32, 1, 0),
        Position               = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        Text                   = CFG.Name,
        TextColor3             = CFG.Text,
        TextSize               = 13,
        Font                   = Enum.Font.GothamBold,
        ZIndex                 = 51,
    })

    local PillBtn = New("TextButton", Pill, {
        Size                   = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text                   = "",
        ZIndex                 = 52,
    })
    Draggable(Pill, Pill)

    -- ---- VENTANA PRINCIPAL ----
    local Hub = New("Frame", Root, {
        Name             = "Hub",
        Size             = UDim2.fromOffset(520, 360),
        Position         = UDim2.new(0.5, -260, 0.5, -180),
        BackgroundColor3 = CFG.BG,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        ZIndex           = 10,
    })
    Corner(Hub, 10)
    New("UIStroke", Hub, { Color = CFG.Border, Thickness = 1.5 })

    -- Entrada suave
    Hub.BackgroundTransparency = 1
    Hub.Position = UDim2.new(0.5, -260, 0.5, -165)
    twE(Hub, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
        BackgroundTransparency = 0,
        Position               = UDim2.new(0.5, -260, 0.5, -180),
    })

    -- ---- TITLEBAR ----
    local TBar = New("Frame", Hub, {
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = CFG.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    })
    -- Esquinas redondas solo arriba
    Corner(TBar, 10)
    New("Frame", TBar, {
        Size             = UDim2.new(1, 0, 0, 10),
        Position         = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = CFG.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    })

    -- Logo imagen (sin fondo de color, solo la imagen)
    local LogoImg = New("ImageLabel", TBar, {
        Size                   = UDim2.fromOffset(30, 30),
        Position               = UDim2.new(0, 8, 0.5, -15),
        BackgroundTransparency = 1,
        Image                  = CFG.LogoID,
        ScaleType              = Enum.ScaleType.Fit,
        ZIndex                 = 12,
    })
    Corner(LogoImg, 6)

    New("TextLabel", TBar, {
        Size                   = UDim2.fromOffset(220, 20),
        Position               = UDim2.new(0, 46, 0, 6),
        BackgroundTransparency = 1,
        Text                   = CFG.Name,
        TextColor3             = CFG.Text,
        TextSize               = 14,
        Font                   = Enum.Font.GothamBold,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 12,
    })
    New("TextLabel", TBar, {
        Size                   = UDim2.fromOffset(220, 14),
        Position               = UDim2.new(0, 46, 0, 25),
        BackgroundTransparency = 1,
        Text                   = "by LLLLL  •  " .. CFG.Version,
        TextColor3             = CFG.TextDim,
        TextSize               = 10,
        Font                   = Enum.Font.Gotham,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 12,
    })

    -- Botones X y -
    local function CtrlBtn(color, sym, offX)
        local b = New("TextButton", TBar, {
            Size             = UDim2.fromOffset(20, 20),
            Position         = UDim2.new(1, offX, 0.5, -10),
            BackgroundColor3 = color,
            BorderSizePixel  = 0,
            Text             = sym,
            TextColor3       = Color3.fromRGB(255,255,255),
            TextSize         = 13,
            Font             = Enum.Font.GothamBold,
            ZIndex           = 13,
            AutoButtonColor  = false,
        })
        Corner(b, 10)
        b.MouseEnter:Connect(function()
            tw(b, 0.1, { Size = UDim2.fromOffset(22,22), Position = UDim2.new(1, offX-1, 0.5, -11) })
        end)
        b.MouseLeave:Connect(function()
            tw(b, 0.1, { Size = UDim2.fromOffset(20,20), Position = UDim2.new(1, offX, 0.5, -10) })
        end)
        return b
    end

    local BtnClose = CtrlBtn(CFG.Red,    "×", -28)
    local BtnMin   = CtrlBtn(CFG.Orange, "−", -54)

    Draggable(Hub, TBar)

    -- ---- PANEL IZQUIERDO ----
    local Left = New("Frame", Hub, {
        Size             = UDim2.new(0, 140, 1, -44),
        Position         = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = CFG.Panel,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    })

    -- Separador
    New("Frame", Hub, {
        Size             = UDim2.new(0, 1, 1, -44),
        Position         = UDim2.new(0, 140, 0, 44),
        BackgroundColor3 = CFG.Border,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    })

    -- Imagen del menu (grande, centrada arriba del panel izquierdo)
    local MenuImg = New("ImageLabel", Left, {
        Size                   = UDim2.fromOffset(110, 110),
        Position               = UDim2.new(0.5, -55, 0, 8),
        BackgroundTransparency = 1,
        Image                  = CFG.MenuIconID,
        ScaleType              = Enum.ScaleType.Fit,
        ZIndex                 = 12,
    })
    Corner(MenuImg, 12)

    -- Separador bajo imagen
    New("Frame", Left, {
        Size             = UDim2.new(1, -20, 0, 1),
        Position         = UDim2.new(0, 10, 0, 124),
        BackgroundColor3 = CFG.Border,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    })

    local TabList = New("Frame", Left, {
        Size                   = UDim2.new(1, 0, 1, -132),
        Position               = UDim2.new(0, 0, 0, 132),
        BackgroundTransparency = 1,
        ClipsDescendants       = true,
        ZIndex                 = 12,
    })
    New("UIListLayout", TabList, {
        Padding   = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    New("UIPadding", TabList, {
        PaddingLeft   = UDim.new(0, 6),
        PaddingRight  = UDim.new(0, 6),
        PaddingTop    = UDim.new(0, 6),
    })

    -- ---- PANEL DERECHO ----
    local Right = New("Frame", Hub, {
        Name             = "Right",
        Size             = UDim2.new(1, -141, 1, -44),
        Position         = UDim2.new(0, 141, 0, 44),
        BackgroundColor3 = CFG.BG2,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        ZIndex           = 11,
    })

    -- Footer
    New("TextLabel", Hub, {
        Size                   = UDim2.new(1, 0, 0, 16),
        Position               = UDim2.new(0, 0, 1, -16),
        BackgroundTransparency = 1,
        Text                   = CFG.Name .. "  " .. CFG.Version,
        TextColor3             = CFG.TextDim,
        TextSize               = 10,
        Font                   = Enum.Font.Gotham,
        TextXAlignment         = Enum.TextXAlignment.Center,
        ZIndex                 = 15,
    })

    -- ================================================
    -- MINIMIZAR: colapsa a pastilla flotante
    -- ================================================
    BtnMin.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            twE(Hub, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {
                Size = UDim2.fromOffset(520, 0),
                BackgroundTransparency = 1,
            })
            task.delay(0.22, function()
                Hub.Visible = false
                Pill.Visible = true
                Pill.Size = UDim2.fromOffset(0, 30)
                Pill.Position = UDim2.new(0.5, 0, 0, 8)
                twE(Pill, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
                    Size     = UDim2.fromOffset(160, 30),
                    Position = UDim2.new(0.5, -80, 0, 8),
                })
            end)
        else
            tw(Pill, 0.15, { Size = UDim2.fromOffset(0, 30) })
            task.delay(0.18, function()
                Pill.Visible = false
                Hub.Visible  = true
                Hub.Size     = UDim2.fromOffset(520, 0)
                Hub.BackgroundTransparency = 1
                twE(Hub, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
                    Size                   = UDim2.fromOffset(520, 360),
                    BackgroundTransparency = 0,
                })
            end)
        end
    end)

    -- Pastilla: click para restaurar
    PillBtn.MouseButton1Click:Connect(function()
        isMinimized = false
        tw(Pill, 0.15, { Size = UDim2.fromOffset(0, 30) })
        task.delay(0.18, function()
            Pill.Visible = false
            Hub.Visible  = true
            Hub.Size     = UDim2.fromOffset(520, 0)
            Hub.BackgroundTransparency = 1
            twE(Hub, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
                Size                   = UDim2.fromOffset(520, 360),
                BackgroundTransparency = 0,
            })
        end)
    end)

    -- ================================================
    -- CERRAR
    -- ================================================
    BtnClose.MouseButton1Click:Connect(function()
        tw(Hub,  0.2, { BackgroundTransparency = 1, Size = UDim2.fromOffset(520, 0) })
        tw(Pill, 0.15, { BackgroundTransparency = 1 })
        task.delay(0.25, function() Root:Destroy() end)
    end)

    -- ================================================
    -- API: AddTab
    -- ================================================
    local function AddTab(name, icon)
        local Page = New("ScrollingFrame", Right, {
            Size                 = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            ScrollBarThickness   = 3,
            ScrollBarImageColor3 = CFG.Accent,
            Visible              = false,
            CanvasSize           = UDim2.new(0,0,0,0),
            AutomaticCanvasSize  = Enum.AutomaticSize.Y,
            ZIndex               = 12,
        })
        New("UIPadding", Page, {
            PaddingLeft   = UDim.new(0, 12),
            PaddingRight  = UDim.new(0, 12),
            PaddingTop    = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
        })
        New("UIListLayout", Page, {
            Padding   = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        -- Boton tab
        local TBtn = New("TextButton", TabList, {
            Size             = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = CFG.BG2,
            BorderSizePixel  = 0,
            Text             = "",
            AutoButtonColor  = false,
            ZIndex           = 13,
        })
        Corner(TBtn, 6)

        if icon then
            New("ImageLabel", TBtn, {
                Size                   = UDim2.fromOffset(16, 16),
                Position               = UDim2.new(0, 8, 0.5, -8),
                BackgroundTransparency = 1,
                Image                  = icon,
                ScaleType              = Enum.ScaleType.Fit,
                ZIndex                 = 14,
            })
        end

        local TLbl = New("TextLabel", TBtn, {
            Size                   = UDim2.new(1, icon and -32 or -12, 1, 0),
            Position               = UDim2.new(0, icon and 30 or 10, 0, 0),
            BackgroundTransparency = 1,
            Text                   = name,
            TextColor3             = CFG.TextDim,
            TextSize               = 12,
            Font                   = Enum.Font.GothamSemibold,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 14,
        })

        local function Activate()
            if currentTab and currentTab ~= Page then
                currentTab.Visible = false
            end
            currentTab = Page
            Page.Visible = true
            tw(TBtn, 0.15, { BackgroundColor3 = CFG.Accent })
            tw(TLbl, 0.15, { TextColor3 = CFG.Text })
            for _, t in ipairs(tabs) do
                if t.b ~= TBtn then
                    tw(t.b, 0.15, { BackgroundColor3 = CFG.BG2 })
                    tw(t.l, 0.15, { TextColor3 = CFG.TextDim })
                end
            end
        end

        TBtn.MouseButton1Click:Connect(Activate)
        TBtn.MouseEnter:Connect(function()
            if currentTab ~= Page then tw(TBtn, 0.1, { BackgroundColor3 = CFG.Border }) end
        end)
        TBtn.MouseLeave:Connect(function()
            if currentTab ~= Page then tw(TBtn, 0.1, { BackgroundColor3 = CFG.BG2 }) end
        end)

        table.insert(tabs, { b = TBtn, l = TLbl, p = Page })
        if #tabs == 1 then task.defer(Activate) end

        -- ---- SECCION ----
        local Sec = {}

        function Sec:AddButton(text, cb)
            local btn = New("TextButton", Page, {
                Size             = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = CFG.BG,
                BorderSizePixel  = 0,
                Text             = "",
                AutoButtonColor  = false,
                ZIndex           = 13,
            })
            Corner(btn, 6)
            New("UIStroke", btn, { Color = CFG.Border, Thickness = 1 })
            New("TextLabel", btn, {
                Size                   = UDim2.fromScale(1,1),
                BackgroundTransparency = 1,
                Text                   = text,
                TextColor3             = CFG.Text,
                TextSize               = 12,
                Font                   = Enum.Font.GothamSemibold,
                ZIndex                 = 14,
            })
            btn.MouseButton1Click:Connect(function()
                tw(btn, 0.08, { BackgroundColor3 = CFG.Accent })
                task.delay(0.18, function() tw(btn, 0.15, { BackgroundColor3 = CFG.BG }) end)
                if cb then pcall(cb) end
            end)
            btn.MouseEnter:Connect(function() tw(btn, 0.1, { BackgroundColor3 = CFG.Border }) end)
            btn.MouseLeave:Connect(function() tw(btn, 0.1, { BackgroundColor3 = CFG.BG }) end)
            return btn
        end

        function Sec:AddToggle(text, default, cb)
            local on = default or false
            local row = New("Frame", Page, {
                Size             = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = CFG.BG,
                BorderSizePixel  = 0,
                ZIndex           = 13,
            })
            Corner(row, 6)
            New("UIStroke", row, { Color = CFG.Border, Thickness = 1 })
            New("TextLabel", row, {
                Size                   = UDim2.new(1, -54, 1, 0),
                Position               = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text                   = text,
                TextColor3             = CFG.Text,
                TextSize               = 12,
                Font                   = Enum.Font.GothamSemibold,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 14,
            })
            local track = New("Frame", row, {
                Size             = UDim2.fromOffset(38, 20),
                Position         = UDim2.new(1, -46, 0.5, -10),
                BackgroundColor3 = on and CFG.Accent or CFG.Border,
                BorderSizePixel  = 0,
                ZIndex           = 14,
            })
            Corner(track, 10)
            local knob = New("Frame", track, {
                Size             = UDim2.fromOffset(14, 14),
                Position         = on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel  = 0,
                ZIndex           = 15,
            })
            Corner(knob, 10)
            local tbtn = New("TextButton", row, {
                Size                   = UDim2.fromScale(1,1),
                BackgroundTransparency = 1,
                Text                   = "",
                ZIndex                 = 16,
            })
            tbtn.MouseButton1Click:Connect(function()
                on = not on
                tw(track, 0.15, { BackgroundColor3 = on and CFG.Accent or CFG.Border })
                tw(knob,  0.15, { Position = on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7) })
                if cb then pcall(cb, on) end
            end)
            return row
        end

        function Sec:AddLabel(text)
            return New("TextLabel", Page, {
                Size                   = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                Text                   = text,
                TextColor3             = CFG.TextDim,
                TextSize               = 11,
                Font                   = Enum.Font.Gotham,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 13,
            })
        end

        function Sec:AddSeparator()
            return New("Frame", Page, {
                Size             = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = CFG.Border,
                BorderSizePixel  = 0,
                ZIndex           = 13,
            })
        end

        function Sec:AddTextbox(placeholder, cb)
            local box = New("TextBox", Page, {
                Size              = UDim2.new(1, 0, 0, 36),
                BackgroundColor3  = CFG.BG,
                BorderSizePixel   = 0,
                PlaceholderText   = placeholder or "Escribe aqui...",
                PlaceholderColor3 = CFG.TextDim,
                Text              = "",
                TextColor3        = CFG.Text,
                TextSize          = 12,
                Font              = Enum.Font.Gotham,
                ClearTextOnFocus  = false,
                ZIndex            = 13,
            })
            Corner(box, 6)
            New("UIStroke", box, { Color = CFG.Border, Thickness = 1 })
            New("UIPadding", box, { PaddingLeft = UDim.new(0,10) })
            box.Focused:Connect(function()    tw(box, 0.1, { BackgroundColor3 = CFG.BG2 }) end)
            box.FocusLost:Connect(function(e)
                tw(box, 0.1, { BackgroundColor3 = CFG.BG })
                if e and cb then pcall(cb, box.Text) end
            end)
            return box
        end

        function Sec:AddSlider(text, min, max, default, cb)
            min = min or 0; max = max or 100; default = default or min
            local val = default
            local row = New("Frame", Page, {
                Size             = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = CFG.BG,
                BorderSizePixel  = 0,
                ZIndex           = 13,
            })
            Corner(row, 6)
            New("UIStroke", row, { Color = CFG.Border, Thickness = 1 })
            New("TextLabel", row, {
                Size                   = UDim2.new(1, -60, 0, 20),
                Position               = UDim2.new(0, 10, 0, 6),
                BackgroundTransparency = 1,
                Text                   = text,
                TextColor3             = CFG.Text,
                TextSize               = 12,
                Font                   = Enum.Font.GothamSemibold,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 14,
            })
            local valLbl = New("TextLabel", row, {
                Size                   = UDim2.fromOffset(50, 20),
                Position               = UDim2.new(1, -58, 0, 6),
                BackgroundTransparency = 1,
                Text                   = tostring(val),
                TextColor3             = CFG.Accent,
                TextSize               = 12,
                Font                   = Enum.Font.GothamBold,
                TextXAlignment         = Enum.TextXAlignment.Right,
                ZIndex                 = 14,
            })
            local track2 = New("Frame", row, {
                Size             = UDim2.new(1, -20, 0, 4),
                Position         = UDim2.new(0, 10, 0, 34),
                BackgroundColor3 = CFG.Border,
                BorderSizePixel  = 0,
                ZIndex           = 14,
            })
            Corner(track2, 10)
            local pct0 = (val - min) / (max - min)
            local fill2 = New("Frame", track2, {
                Size             = UDim2.new(pct0, 0, 1, 0),
                BackgroundColor3 = CFG.Accent,
                BorderSizePixel  = 0,
                ZIndex           = 15,
            })
            Corner(fill2, 10)
            local drag2 = New("TextButton", track2, {
                Size                   = UDim2.fromScale(1,1),
                BackgroundTransparency = 1,
                Text                   = "",
                ZIndex                 = 16,
            })
            local function update(input)
                local abs = track2.AbsolutePosition.X
                local wid = track2.AbsoluteSize.X
                local p = math.clamp((input.Position.X - abs) / wid, 0, 1)
                val = math.floor(min + p * (max - min))
                fill2.Size = UDim2.new(p, 0, 1, 0)
                valLbl.Text = tostring(val)
                if cb then pcall(cb, val) end
            end
            local sliding = false
            drag2.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    sliding = true; update(i)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement
                    or i.UserInputType == Enum.UserInputType.Touch) then
                    update(i)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
            return row
        end

        return Sec
    end

    -- API publica
    local API = {}
    function API:AddTab(name, icon) return AddTab(name, icon) end
    return API
end

--[[

    Euphoria UI (Modified Milenium)
    -> Reskinned to match 'Reulen' look
    -> Dark theme, Purple Accents, Modern Controls
]]

-- Variables 
    local uis = game:GetService("UserInputService") 
    local players = game:GetService("Players") 
    local ws = game:GetService("Workspace")
    local rs = game:GetService("ReplicatedStorage")
    local http_service = game:GetService("HttpService")
    local gui_service = game:GetService("GuiService")
    local lighting = game:GetService("Lighting")
    local run = game:GetService("RunService")
    local stats = game:GetService("Stats")
    local coregui = game:GetService("CoreGui")
    local debris = game:GetService("Debris")
    local tween_service = game:GetService("TweenService")
    local sound_service = game:GetService("SoundService")

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new 
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local point_object_space = empty_cfr.PointToObjectSpace
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer 
    local mouse = lp:GetMouse() 
    local gui_offset = gui_service:GetGuiInset().Y

    local max = math.max 
    local floor = math.floor 
    local min = math.min 
    local abs = math.abs 
    local noise = math.noise
    local rad = math.rad 
    local random = math.random 
    local pow = math.pow 
    local sin = math.sin 
    local pi = math.pi 
    local tan = math.tan 
    local atan2 = math.atan2 
    local clamp = math.clamp 

    local insert = table.insert 
    local find = table.find 
    local remove = table.remove
    local concat = table.concat
-- 

-- Library init
    getgenv().library = {
        directory = "euphoria",
        folders = {
            "/fonts",
            "/configs",
        },
        flags = {},
        config_flags = {},
        connections = {},   
        notifications = {notifs = {}},
        current_open; 
    }

    local themes = {
        preset = {
            accent = rgb(210, 115, 255), -- Reulen Purple
            background = rgb(15, 15, 15),
            sidebar = rgb(20, 20, 20),
            section = rgb(25, 25, 25),
            text = rgb(240, 240, 240),
            text_dim = rgb(150, 150, 150)
        }, 

        utility = {
            accent = {
                BackgroundColor3 = {}, 	
                TextColor3 = {}, 
                ImageColor3 = {}, 
                ScrollBarImageColor3 = {} 
            },
        }
    }

    local keys = {
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
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
    }
        
    library.__index = library

    -- Font Handling (Using Gotham for Reulen look)
    local fonts = {
        small = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        bold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    }

-- Library functions 
    -- Misc functions
        function library:tween(obj, properties, easing_style, time) 
            local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()
            return tween
        end

        function library:resizify(frame) 
            -- Resizing implementation (standard)
            local Frame = Instance.new("TextButton")
            Frame.Position = dim2(1, -10, 1, -10)
            Frame.Size = dim2(0, 10, 0, 10)
            Frame.BackgroundTransparency = 1 
            Frame.Text = ""
            Frame.Parent = frame

            local resizing = false 
            local start_size 
            local start 
            local og_size = frame.Size  

            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = true
                    start = input.Position
                    start_size = frame.Size
                end
            end)

            Frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = false
                end
            end)

            library:connection(uis.InputChanged, function(input) 
                if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local current_size = dim2(
                        start_size.X.Scale,
                        math.max(start_size.X.Offset + (input.Position.X - start.X), og_size.X.Offset),
                        start_size.Y.Scale,
                        math.max(start_size.Y.Offset + (input.Position.Y - start.Y), og_size.Y.Offset)
                    )
                    library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05)
                end
            end)
        end 

        function library:draggify(frame)
            local dragging = false 
            local start_pos = frame.Position
            local start 

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    start = input.Position
                    start_pos = frame.Position
                end
            end)

            frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            library:connection(uis.InputChanged, function(input) 
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - start
                    local pos = dim2(start_pos.X.Scale, start_pos.X.Offset + delta.X, start_pos.Y.Scale, start_pos.Y.Offset + delta.Y)
                    library:tween(frame, {Position = pos}, Enum.EasingStyle.Linear, 0.05)
                end
            end)
        end 

        function library:fag(tbl)
            local Size = 0
            for _ in tbl do Size = Size + 1 end
            return Size
        end
        
        function library:next_flag()
            return string.format("flag_%s", library:fag(library.flags) + 1)
        end 

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)
            insert(library.connections, connection)
            return connection 
        end

        function library:close_element(new_path) 
            local open_element = library.current_open
            if open_element and new_path ~= open_element then
                open_element.set_visible(false)
                open_element.open = false;
            end 
            if new_path ~= open_element then 
                library.current_open = new_path or nil;
            end
        end 

        function library:create(instance, options)
            local ins = Instance.new(instance) 
            for prop, value in options do ins[prop] = value end
            return ins 
        end

        function library:unload_menu() 
            if library[ "items" ] then library[ "items" ]:Destroy() end
            if library[ "other" ] then library[ "other" ]:Destroy() end 
            for _, connection in library.connections do connection:Disconnect() end
            library = nil 
        end 

        function library:round(number, float) 
            local multiplier = 1 / (float or 1)
            return floor(number * multiplier + 0.5) / multiplier
        end 

        function library:apply_theme(instance, theme, property) 
            insert(themes.utility[theme][property], instance)
        end

        function library:update_theme(theme, color)
            for _, property in themes.utility[theme] do 
                for m, object in property do 
                    if object[_] == themes.preset[theme] then 
                        object[_] = color 
                    end 
                end 
            end 
            themes.preset[theme] = color 
        end 

    -- Library element functions
        function library:window(properties)
            local cfg = { 
                name = properties.name or "Euphoria",
                size = properties.size or dim2(0, 700, 0, 450);
                items = {};
            }
            
            library[ "items" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "EuphoriaLib";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Global;
                IgnoreGuiInset = true;
            });
            
            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "EuphoriaLib_Other";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            }); 

            local items = cfg.items; do
                -- Main Frame
                items[ "main" ] = library:create( "Frame" , {
                    Parent = library[ "items" ];
                    Size = cfg.size;
                    Name = "Main";
                    Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
                    BackgroundColor3 = themes.preset.background;
                    BorderSizePixel = 0;
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "main" ];
                    CornerRadius = dim(0, 8)
                });

                -- Sidebar
                items[ "sidebar" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "Sidebar";
                    Size = dim2(0, 180, 1, 0);
                    BackgroundColor3 = themes.preset.sidebar;
                    BorderSizePixel = 0;
                });

                library:create( "UICorner" , {
                    Parent = items[ "sidebar" ];
                    CornerRadius = dim(0, 8)
                });
                
                -- Fix sidebar corner
                library:create("Frame", {
                    Parent = items["sidebar"],
                    Size = dim2(0, 10, 1, 0),
                    Position = dim2(1, -10, 0, 0),
                    BackgroundColor3 = themes.preset.sidebar,
                    BorderSizePixel = 0
                })

                -- Title
                items[ "title" ] = library:create( "TextLabel" , {
                    Parent = items[ "sidebar" ];
                    Text = cfg.name;
                    FontFace = fonts.bold;
                    TextSize = 18;
                    TextColor3 = themes.preset.text;
                    Size = dim2(1, -20, 0, 50);
                    Position = dim2(0, 20, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });

                -- Tab Container
                items[ "tab_container" ] = library:create( "ScrollingFrame" , {
                    Parent = items[ "sidebar" ];
                    Size = dim2(1, 0, 1, -60);
                    Position = dim2(0, 0, 0, 60);
                    BackgroundTransparency = 1;
                    ScrollBarThickness = 0;
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "tab_container" ];
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Padding = dim(0, 5);
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "tab_container" ];
                    PaddingLeft = dim(0, 10);
                });

                -- Content Area
                items[ "content_area" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "ContentArea";
                    Size = dim2(1, -180, 1, 0);
                    Position = dim2(0, 180, 0, 0);
                    BackgroundTransparency = 1;
                });
                
                items[ "pages" ] = library:create("Folder", {
                    Parent = items["content_area"],
                    Name = "Pages"
                })

                library:draggify(items[ "main" ])
                library:resizify(items[ "main" ])
            end 

            function cfg.toggle_menu(bool) 
                library[ "items" ].Enabled = bool
                library[ "other" ].Enabled = bool
            end 
                
            return setmetatable(cfg, library)
        end 

        function library:tab(properties)
            local cfg = {
                name = properties.name or "Tab"; 
                icon = properties.icon or "";
                items = {};
            } 

            local items = cfg.items; do 
                -- Tab Button
                items[ "button" ] = library:create( "TextButton" , {
                    Parent = self.items[ "tab_container" ];
                    Size = dim2(1, -20, 0, 35);
                    BackgroundTransparency = 1;
                    Text = "";
                });
                
                items[ "icon" ] = library:create( "TextLabel" , {
                    Parent = items[ "button" ];
                    Size = dim2(0, 30, 1, 0);
                    BackgroundTransparency = 1;
                    Text = cfg.icon;
                    TextSize = 18;
                    TextColor3 = themes.preset.text_dim;
                    FontFace = fonts.font;
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    Parent = items[ "button" ];
                    Size = dim2(1, -35, 1, 0);
                    Position = dim2(0, 35, 0, 0);
                    BackgroundTransparency = 1;
                    Text = cfg.name;
                    TextSize = 14;
                    TextColor3 = themes.preset.text_dim;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    FontFace = fonts.font;
                });
                
                items[ "indicator" ] = library:create( "Frame" , {
                    Parent = items[ "button" ];
                    Size = dim2(0, 2, 0.6, 0);
                    Position = dim2(0, 0, 0.2, 0);
                    BackgroundColor3 = themes.preset.accent;
                    BackgroundTransparency = 1;
                }); library:apply_theme(items[ "indicator" ], "accent", "BackgroundColor3");

                -- Page Frame
                items[ "page" ] = library:create( "ScrollingFrame" , {
                    Parent = self.items[ "pages" ];
                    Name = cfg.name .. "Page";
                    Size = dim2(1, -40, 1, -40);
                    Position = dim2(0, 20, 0, 20);
                    BackgroundTransparency = 1;
                    Visible = false;
                    ScrollBarThickness = 2;
                    ScrollBarImageColor3 = themes.preset.accent;
                }); library:apply_theme(items[ "page" ], "accent", "ScrollBarImageColor3");

                -- Columns
                items[ "left_col" ] = library:create( "Frame" , {
                    Parent = items[ "page" ];
                    Size = dim2(0.5, -5, 1, 0);
                    BackgroundTransparency = 1;
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "left_col" ];
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Padding = dim(0, 10);
                });

                items[ "right_col" ] = library:create( "Frame" , {
                    Parent = items[ "page" ];
                    Size = dim2(0.5, -5, 1, 0);
                    Position = dim2(0.5, 5, 0, 0);
                    BackgroundTransparency = 1;
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "right_col" ];
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Padding = dim(0, 10);
                });
            end 

            function cfg.Activate()
                -- Reset all tabs
                for _, tab_btn in self.items.tab_container:GetChildren() do
                    if tab_btn:IsA("TextButton") then
                        for _, child in tab_btn:GetChildren() do
                            if child:IsA("TextLabel") then child.TextColor3 = themes.preset.text_dim end
                            if child.Name == "Frame" then child.BackgroundTransparency = 1 end -- indicator
                        end
                    end
                end
                
                for _, page in self.items.pages:GetChildren() do
                    page.Visible = false
                end

                -- Activate current
                items.name.TextColor3 = themes.preset.text
                items.icon.TextColor3 = themes.preset.text
                items.indicator.BackgroundTransparency = 0
                items.page.Visible = true
            end

            items.button.MouseButton1Click:Connect(cfg.Activate)

            -- Auto activate first tab
            if #self.items.pages:GetChildren() == 1 then
                cfg.Activate()
            end

            return setmetatable(cfg, library)
        end

        function library:section(properties)
            local cfg = {
                name = properties.name or "Section";
                side = properties.side or "left"; -- left or right
                items = {};
            }
            
            local parent = (cfg.side:lower() == "right") and self.items.right_col or self.items.left_col
            local items = cfg.items; do
                items[ "section_frame" ] = library:create( "Frame" , {
                    Parent = parent;
                    Size = dim2(1, 0, 0, 0); -- Auto sized
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.Y;
                });

                items[ "title" ] = library:create( "TextLabel" , {
                    Parent = items[ "section_frame" ];
                    Text = cfg.name;
                    Size = dim2(1, 0, 0, 20);
                    BackgroundTransparency = 1;
                    TextColor3 = themes.preset.text_dim;
                    FontFace = fonts.bold;
                    TextSize = 12;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });

                items[ "container" ] = library:create( "Frame" , {
                    Parent = items[ "section_frame" ];
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 0, 0, 25);
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.Y;
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "container" ];
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Padding = dim(0, 5);
                });
            end
            
            return setmetatable(cfg, library)
        end

        function library:toggle(options) 
            local cfg = {
                name = options.name or "Toggle",
                default = options.default or false,
                callback = options.callback or function() end,
                flag = options.flag or library:next_flag(),
                items = {};
            }

            library.flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "frame" ] = library:create( "Frame" , {
                    Parent = self.items.container;
                    Size = dim2(1, 0, 0, 30);
                    BackgroundTransparency = 1;
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    Parent = items[ "frame" ];
                    Text = cfg.name;
                    Size = dim2(0.7, 0, 1, 0);
                    BackgroundTransparency = 1;
                    TextColor3 = themes.preset.text;
                    FontFace = fonts.font;
                    TextSize = 13;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });

                -- Toggle Switch (Pill Shape)
                items[ "switch_bg" ] = library:create( "Frame" , {
                    Parent = items[ "frame" ];
                    Size = dim2(0, 40, 0, 20);
                    Position = dim2(1, 0, 0.5, 0);
                    AnchorPoint = vec2(1, 0.5);
                    BackgroundColor3 = cfg.default and themes.preset.accent or rgb(50, 50, 50);
                }); library:apply_theme(items[ "switch_bg" ], "accent", "BackgroundColor3");

                library:create( "UICorner" , {
                    Parent = items[ "switch_bg" ];
                    CornerRadius = dim(1, 0);
                });

                items[ "knob" ] = library:create( "Frame" , {
                    Parent = items[ "switch_bg" ];
                    Size = dim2(0, 16, 0, 16);
                    Position = cfg.default and dim2(1, -18, 0.5, 0) or dim2(0, 2, 0.5, 0);
                    AnchorPoint = vec2(0, 0.5);
                    BackgroundColor3 = rgb(255, 255, 255);
                });

                library:create( "UICorner" , {
                    Parent = items[ "knob" ];
                    CornerRadius = dim(1, 0);
                });

                items[ "button" ] = library:create( "TextButton" , {
                    Parent = items[ "frame" ];
                    Size = dim2(1, 0, 1, 0);
                    BackgroundTransparency = 1;
                    Text = "";
                });
            end

            function cfg.set(bool)
                library.flags[cfg.flag] = bool
                library:tween(items.switch_bg, {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)})
                library:tween(items.knob, {Position = bool and dim2(1, -18, 0.5, 0) or dim2(0, 2, 0.5, 0)})
                cfg.callback(bool)
            end

            items.button.MouseButton1Click:Connect(function()
                cfg.set(not library.flags[cfg.flag])
            end)

            return setmetatable(cfg, library)
        end 
        
        function library:slider(options) 
            local cfg = {
                name = options.name or "Slider",
                min = options.min or 0,
                max = options.max or 100,
                default = options.default or 50,
                increment = options.increment or 1,
                suffix = options.suffix or "",
                callback = options.callback or function() end,
                flag = options.flag or library:next_flag(),
                items = {};
            } 

            library.flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "frame" ] = library:create( "Frame" , {
                    Parent = self.items.container;
                    Size = dim2(1, 0, 0, 45);
                    BackgroundTransparency = 1;
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    Parent = items[ "frame" ];
                    Text = cfg.name;
                    Size = dim2(1, 0, 0, 20);
                    BackgroundTransparency = 1;
                    TextColor3 = themes.preset.text;
                    FontFace = fonts.font;
                    TextSize = 13;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });

                items[ "value" ] = library:create( "TextLabel" , {
                    Parent = items[ "frame" ];
                    Text = tostring(cfg.default) .. cfg.suffix;
                    Size = dim2(1, 0, 0, 20);
                    BackgroundTransparency = 1;
                    TextColor3 = themes.preset.text;
                    FontFace = fonts.font;
                    TextSize = 13;
                    TextXAlignment = Enum.TextXAlignment.Right;
                });

                -- Slider Bar
                items[ "slider_bg" ] = library:create( "Frame" , {
                    Parent = items[ "frame" ];
                    Size = dim2(1, 0, 0, 6);
                    Position = dim2(0, 0, 0, 30);
                    BackgroundColor3 = themes.preset.section;
                });

                library:create( "UICorner" , { Parent = items[ "slider_bg" ]; CornerRadius = dim(1, 0) });

                items[ "fill" ] = library:create( "Frame" , {
                    Parent = items[ "slider_bg" ];
                    Size = dim2((cfg.default - cfg.min) / (cfg.max - cfg.min), 0, 1, 0);
                    BackgroundColor3 = themes.preset.accent;
                }); library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");

                library:create( "UICorner" , { Parent = items[ "fill" ]; CornerRadius = dim(1, 0) });

                items[ "button" ] = library:create( "TextButton" , {
                    Parent = items[ "slider_bg" ];
                    Size = dim2(1, 0, 1, 0);
                    BackgroundTransparency = 1;
                    Text = "";
                });
            end

            function cfg.set(val)
                val = clamp(library:round(val, cfg.increment), cfg.min, cfg.max)
                library.flags[cfg.flag] = val
                items.value.Text = tostring(val) .. cfg.suffix
                library:tween(items.fill, {Size = dim2((val - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)}, Enum.EasingStyle.Linear, 0.05)
                cfg.callback(val)
            end

            local dragging = false
            items.button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local size_x = (input.Position.X - items.slider_bg.AbsolutePosition.X) / items.slider_bg.AbsoluteSize.X
                    cfg.set(((cfg.max - cfg.min) * size_x) + cfg.min)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)

            library:connection(uis.InputChanged, function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local size_x = (input.Position.X - items.slider_bg.AbsolutePosition.X) / items.slider_bg.AbsoluteSize.X
                    cfg.set(((cfg.max - cfg.min) * size_x) + cfg.min)
                end
            end)

            return setmetatable(cfg, library)
        end 

        function library:dropdown(options) 
            local cfg = {
                name = options.name or "Dropdown",
                items = options.items or {"Option 1", "Option 2"},
                default = options.default or "Option 1",
                callback = options.callback or function() end,
                flag = options.flag or library:next_flag(),
                items = {};
            }   

            library.flags[cfg.flag] = cfg.default
            local expanded = false

            local items = cfg.items; do 
                items[ "frame" ] = library:create( "Frame" , {
                    Parent = self.items.container;
                    Size = dim2(1, 0, 0, 50);
                    BackgroundTransparency = 1;
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    Parent = items[ "frame" ];
                    Text = cfg.name;
                    Size = dim2(1, 0, 0, 20);
                    BackgroundTransparency = 1;
                    TextColor3 = themes.preset.text;
                    FontFace = fonts.font;
                    TextSize = 13;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });

                items[ "bar" ] = library:create( "Frame" , {
                    Parent = items[ "frame" ];
                    Size = dim2(1, 0, 0, 25);
                    Position = dim2(0, 0, 0, 25);
                    BackgroundColor3 = themes.preset.section;
                });

                library:create( "UICorner" , { Parent = items[ "bar" ]; CornerRadius = dim(0, 4) });

                items[ "selected" ] = library:create( "TextLabel" , {
                    Parent = items[ "bar" ];
                    Text = cfg.default;
                    Size = dim2(1, -10, 1, 0);
                    Position = dim2(0, 10, 0, 0);
                    BackgroundTransparency = 1;
                    TextColor3 = themes.preset.text_dim;
                    FontFace = fonts.font;
                    TextSize = 13;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });

                items[ "button" ] = library:create( "TextButton" , {
                    Parent = items[ "bar" ];
                    Size = dim2(1, 0, 1, 0);
                    BackgroundTransparency = 1;
                    Text = "";
                });

                items[ "list" ] = library:create( "Frame" , {
                    Parent = items[ "bar" ];
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 0, 1, 5);
                    BackgroundColor3 = themes.preset.section;
                    Visible = false;
                    ZIndex = 10;
                });

                library:create( "UICorner" , { Parent = items[ "list" ]; CornerRadius = dim(0, 4) });
                library:create( "UIListLayout" , { Parent = items[ "list" ]; SortOrder = Enum.SortOrder.LayoutOrder });
                
                for _, option in cfg.items do
                    local btn = library:create( "TextButton" , {
                        Parent = items[ "list" ];
                        Size = dim2(1, 0, 0, 25);
                        BackgroundTransparency = 1;
                        Text = option;
                        TextColor3 = themes.preset.text_dim;
                        FontFace = fonts.font;
                        TextSize = 13;
                        ZIndex = 11;
                    });
                    
                    btn.MouseButton1Click:Connect(function()
                        items.selected.Text = option
                        library.flags[cfg.flag] = option
                        cfg.callback(option)
                        expanded = false
                        items.list.Visible = false
                        items.frame.Size = dim2(1, 0, 0, 50)
                    end)
                end
            end

            items.button.MouseButton1Click:Connect(function()
                expanded = not expanded
                items.list.Visible = expanded
                if expanded then
                    items.list.Size = dim2(1, 0, 0, #cfg.items * 25)
                    items.frame.Size = dim2(1, 0, 0, 50 + (#cfg.items * 25) + 5)
                else
                    items.frame.Size = dim2(1, 0, 0, 50)
                end
            end)
                
            return setmetatable(cfg, library)
        end

        function library:keybind(options) 
            local cfg = {
                name = options.name or "Keybind",
                default = options.default or Enum.KeyCode.RightShift,
                callback = options.callback or function() end,
                flag = options.flag or library:next_flag(),
                items = {};
            }

            library.flags[cfg.flag] = cfg.default

            local items = cfg.items; do 
                items[ "frame" ] = library:create( "Frame" , {
                    Parent = self.items.container;
                    Size = dim2(1, 0, 0, 30);
                    BackgroundTransparency = 1;
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    Parent = items[ "frame" ];
                    Text = cfg.name;
                    Size = dim2(0.6, 0, 1, 0);
                    BackgroundTransparency = 1;
                    TextColor3 = themes.preset.text;
                    FontFace = fonts.font;
                    TextSize = 13;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });

                -- Key Display
                items[ "key_btn" ] = library:create( "TextButton" , {
                    Parent = items[ "frame" ];
                    Size = dim2(0, 80, 0, 20);
                    Position = dim2(1, -25, 0.5, 0);
                    AnchorPoint = vec2(1, 0.5);
                    BackgroundColor3 = themes.preset.section;
                    Text = cfg.default.Name;
                    TextColor3 = themes.preset.text_dim;
                    FontFace = fonts.font;
                    TextSize = 11;
                });

                library:create( "UICorner" , { Parent = items[ "key_btn" ]; CornerRadius = dim(0, 4) });

                -- Cog Wheel
                items[ "cog" ] = library:create( "ImageButton" , {
                    Parent = items[ "frame" ];
                    Size = dim2(0, 20, 0, 20);
                    Position = dim2(1, 0, 0.5, 0);
                    AnchorPoint = vec2(1, 0.5);
                    BackgroundTransparency = 1;
                    Image = "rbxassetid://3926307971";
                    ImageRectOffset = Vector2.new(324, 124);
                    ImageRectSize = Vector2.new(36, 36);
                    ImageColor3 = themes.preset.text_dim;
                });
            end
        
            items.key_btn.MouseButton1Click:Connect(function()
                items.key_btn.Text = "..."
                local input = uis.InputBegan:Wait()
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    items.key_btn.Text = input.KeyCode.Name
                    library.flags[cfg.flag] = input.KeyCode
                    cfg.callback(input.KeyCode)
                end
            end)

            return setmetatable(cfg, library)
        end
        
        function library:colorpicker(options)
            local cfg = {
                name = options.name or "Color",
                default = options.default or Color3.fromRGB(255, 255, 255),
                callback = options.callback or function() end,
                flag = options.flag or library:next_flag(),
                items = {};
            }
            
            library.flags[cfg.flag] = cfg.default
            
            local items = cfg.items; do
                items[ "frame" ] = library:create( "Frame" , {
                    Parent = self.items.container;
                    Size = dim2(1, 0, 0, 30);
                    BackgroundTransparency = 1;
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    Parent = items[ "frame" ];
                    Text = cfg.name;
                    Size = dim2(0.7, 0, 1, 0);
                    BackgroundTransparency = 1;
                    TextColor3 = themes.preset.text;
                    FontFace = fonts.font;
                    TextSize = 13;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });
                
                items[ "display" ] = library:create( "TextButton" , {
                    Parent = items[ "frame" ];
                    Size = dim2(0, 40, 0, 20);
                    Position = dim2(1, 0, 0.5, 0);
                    AnchorPoint = vec2(1, 0.5);
                    BackgroundColor3 = cfg.default;
                    Text = "";
                });
                
                library:create( "UICorner" , { Parent = items[ "display" ]; CornerRadius = dim(0, 4) });
                
                items.display.MouseButton1Click:Connect(function()
                    -- Simulating color change for demo
                    local newC = Color3.fromHSV(math.random(), 1, 1)
                    items.display.BackgroundColor3 = newC
                    library.flags[cfg.flag] = newC
                    cfg.callback(newC)
                end)
            end
            
            return setmetatable(cfg, library)
        end

        function library:Notify(title, msg, duration, type)
            local frame = library:create("Frame", {
                Parent = library["other"];
                Size = dim2(0, 250, 0, 60);
                Position = dim2(1, 260, 0.8, 0);
                BackgroundColor3 = themes.preset.section;
                BorderSizePixel = 0;
            })
            
            library:create("UICorner", {Parent = frame; CornerRadius = dim(0, 6)})
            
            library:create("TextLabel", {
                Parent = frame;
                Text = title;
                FontFace = fonts.bold;
                TextSize = 14;
                TextColor3 = (type == "success" and rgb(100, 255, 100)) or (type == "error" and rgb(255, 100, 100)) or themes.preset.text;
                Size = dim2(1, -20, 0, 20);
                Position = dim2(0, 10, 0, 10);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            
            library:create("TextLabel", {
                Parent = frame;
                Text = msg;
                FontFace = fonts.font;
                TextSize = 12;
                TextColor3 = themes.preset.text_dim;
                Size = dim2(1, -20, 0, 20);
                Position = dim2(0, 10, 0, 30);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            
            library:tween(frame, {Position = dim2(1, -260, 0.8, 0)})
            
            task.delay(duration or 3, function()
                library:tween(frame, {Position = dim2(1, 260, 0.8, 0)})
                task.wait(0.5)
                frame:Destroy()
            end)
        end
        
        function library:SetToggleKey(key)
             uis.InputBegan:Connect(function(input, gp)
                if not gp and input.KeyCode == key then
                    if library["items"] then
                        library["items"].Enabled = not library["items"].Enabled
                    end
                end
            end)
        end

return library

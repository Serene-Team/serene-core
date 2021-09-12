print("Loading client shops")
local gui = require(game.ReplicatedStorage:WaitForChild("modules").client.gui)
local openClientShop = game.ReplicatedStorage:WaitForChild("events"):WaitForChild("openClientShop")
local shopUi = gui.getGameUi().shopUi
local itemTemplate = shopUi.shopItemTemplate
local gameDb = require(game.ReplicatedStorage:WaitForChild("modules").gameDatabase)
local player = game.Players.LocalPlayer
gui.waitForMouseover(shopUi.configZone.confirmPurchase, "Confirm Item Purchase")
gui.waitForMouseover(shopUi.close, "Close Window")
shopUi.close.MouseButton1Click:Connect(function()
    for _, button in pairs(shopUi.shopZone:GetChildren()) do
        if button:IsA("Frame") then
            button:Destroy()
        end
    end
    shopUi.Visible = false
    player:SetAttribute("hasOpenShop", false)
    print("shop: closed")
end)
shopUi.configZone.confirmPurchase.MouseButton1Click:Connect(function()
    shopUi.configZone.confirmPurchase.Text = "Purchasing..."
    local item = shopUi.currentItem.Value
    local amount = shopUi.amount.Value
    local shopId = shopUi.shopId.Value
    if item == nil or item == "" or amount == nil or amount == "" or shopId == nil or shopId == "" then
        shopUi.configZone.confirmPurchase.Text = "Failed!"
        task.wait(1)
        shopUi.configZone.confirmPurchase.Text = "Confirm Purchase"
    else
        local shopResult = game.ReplicatedStorage:WaitForChild("events"):WaitForChild("confirmPurchase"):InvokeServer(item, shopId, amount)
        if shopResult == nil then
            shopUi.configZone.confirmPurchase.Text = "Purchased!"
            task.wait(1)
            shopUi.configZone.confirmPurchase.Text = "Confirm Purchase"
        else
            warn(shopResult)
            shopUi.configZone.confirmPurchase.Text = "Failed!"
            task.wait(1)
            shopUi.configZone.confirmPurchase.Text = "Confirm Purchase"
        end
    end
end)
-- setup draggable window
gui.setupDraggableWindow(shopUi)
shopUi.configZone.amount:GetPropertyChangedSignal("Text"):Connect(function()
    local amount = tonumber(shopUi.configZone.amount.Text)
    if amount == nil then
        warn("Failed to convert string to int")
    else
        shopUi.amount.Value = amount
        local currentItem = shopUi.currentItem.Value
        if currentItem == nil or currentItem == "" then
            warn("current item is empty!")
        else
            if shopUi.shopId.Value == nil or shopUi.shopId.Value == "" then
                warn("empty shopId")
            else
                local itemPrice = tonumber(gameDb.getItemInfo(currentItem).shops[shopUi.shopId.Value])
                if itemPrice == nil then
                    warn("ok, thats a error. Failed to convert item price to a int. report this to the devs pls")
                else
                    shopUi.configZone.price.Text = "Price: "..(amount * itemPrice)
                end
            end
        end
    end
end)
function getShopInfo(shopId)
    if game.ReplicatedStorage:WaitForChild("shop"):FindFirstChild(shopId) then
        return require(game.ReplicatedStorage.shop:FindFirstChild(shopId))
    else
        error("Failed to load shop: invalid shopId")
    end
end
openClientShop.OnClientEvent:Connect(function(shopId)
    -- make sure the shop is invisible
    print("shop: open")
    if player:GetAttribute("hasOpenShop") == nil or player:GetAttribute("hasOpenShop") == false then
        player:SetAttribute("hasOpenShop", true)
        shopUi.Visible = false
        shopUi.shopId.Value = shopId
        local shopInfo = getShopInfo(shopId)
        shopUi.title.Text = shopInfo.shopTitle
        print("shop: load items")
        for _, item in pairs(shopInfo.items) do
            local itemInfo = gameDb.getItemInfo(item)
            local itemButton = itemTemplate:Clone()
            itemButton.itemName.Text = itemInfo.name
            itemButton.Parent = shopUi.shopZone
            itemButton.iconFolder.icon.Image = "rbxassetid://"..itemInfo.icon
            itemButton.Visible = true
            itemButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    print(itemInfo.shops)
                    shopUi.configZone.price.Text = "Price: "..itemInfo.shops[shopId]
                    shopUi.configZone.amount.Text = 1
                    shopUi.currentItem.Value = item
                end
            end)
        end
        shopUi.Visible = true
    else
        warn("Shop already open! Closing the current")
        shopUi.Visible = false
        for _, button in pairs(shopUi.shopZone:GetChildren()) do
            if button:IsA("Frame") then
                button:Destroy()
            end
        end
        player:SetAttribute("hasOpenShop", false)
    end
end)
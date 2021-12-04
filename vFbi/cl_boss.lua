ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societyfbimoney = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

---------------- FONCTIONS ------------------

function BossFbi()
  local vFbi = RageUI.CreateMenu("Actions Patron", "FIB")

    RageUI.Visible(vFbi, not RageUI.Visible(vFbi))

            while vFbi do
                Citizen.Wait(0)
                    RageUI.IsVisible(vFbi, true, true, true, function()
                   
              if societyfbimoney ~= nil then
                  RageUI.ButtonWithStyle("Argent société :", nil, {RightLabel = "$" .. societyfbimoney}, true, function()
                  end)
              end
  
              RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                  if Selected then
                      local amount = KeyboardInput("Montant", "", 10)
                      amount = tonumber(amount)
                      if amount == nil then
                          RageUI.Popup({message = "Montant invalide"})
                      else
                          TriggerServerEvent('esx_society:withdrawMoney', 'fbi', amount)
                          RefreshfbiMoney()
                      end
                  end
              end)
  
              RageUI.ButtonWithStyle("Déposer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                  if Selected then
                      local amount = KeyboardInput("Montant", "", 10)
                      amount = tonumber(amount)
                      if amount == nil then
                          RageUI.Popup({message = "Montant invalide"})
                      else
                          TriggerServerEvent('esx_society:depositMoney', 'fbi', amount)
                          RefreshfbiMoney()
                      end
                  end
              end) 
  
             RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                  if Selected then
                      aboss()
                      RageUI.CloseAll()
                  end
              end)


                end, function()
            end)
            if not RageUI.Visible(vFbi) then
            vFbi = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'fbi' and ESX.PlayerData.job.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Fbi.pos.boss.position.x, Fbi.pos.boss.position.y, Fbi.pos.boss.position.z)
        if dist3 <= 7.0 and Fbi.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Fbi.pos.boss.position.x, Fbi.pos.boss.position.y, Fbi.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        RefreshfbiMoney()           
                            BossFbi()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshfbiMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            Updatesocietyfbimoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function Updatesocietyfbimoney(money)
    societyfbimoney = ESX.Math.GroupDigits(money)
end

function aboss()
    TriggerEvent('esx_society:openBossMenu', 'fbi', function(data, menu)
        menu.close()
    end, {wash = false})
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end
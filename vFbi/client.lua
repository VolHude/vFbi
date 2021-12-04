ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local busy = false


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


Citizen.CreateThread(function()
    local fbimap = AddBlipForCoord(Fbi.pos.blips.position.x, Fbi.pos.blips.position.y, Fbi.pos.blips.position.z)
    SetBlipSprite(fbimap, 60)
    SetBlipColour(fbimap, 29)
    SetBlipScale(fbimap, 0.80)
    SetBlipAsShortRange(fbimap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Entreprise | Fib")
    EndTextCommandSetBlipName(fbimap)
end)

function Menuf6fbi()
    local fFbif5 = RageUI.CreateMenu("Fib", "Interactions")
    local fFbif5Info = RageUI.CreateSubMenu(fFbif5, "Fib", "Informations")
    local fFbif5Renfort = RageUI.CreateSubMenu(fFbif5, "Fib", "Renfort")
    RageUI.Visible(fFbif5, not RageUI.Visible(fFbif5))
    while fFbif5 do
        Citizen.Wait(0)
            RageUI.IsVisible(fFbif5, true, true, true, function()

                RageUI.Separator("~r~"..ESX.PlayerData.job.grade_label.." - "..GetPlayerName(PlayerId()))

                RageUI.ButtonWithStyle("Facture / Amende",nil, {RightLabel = "→"}, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                        local raison = ""
                        local montant = 0
                        AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                raison = result
                                result = nil
                                AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0)
                                    Wait(0)
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    result = GetOnscreenKeyboardResult()
                                    if result then
                                        montant = result
                                        result = nil
                                        if player ~= -1 and distance <= 3.0 then
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_fib', ('Fib'), montant)
                                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                        else
                                            ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Interagir avec le citoyen",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then                
                        TriggerEvent('fellow:MenuFouille')
                        RageUI.CloseAll()
            end
        end)

                  RageUI.Separator('~r~↓ Intéractions sur véhicules ↓')

            RageUI.ButtonWithStyle("Mettre véhicule en fourriere",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                        local playerPed = PlayerPedId()

                        if IsPedSittingInAnyVehicle(playerPed) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
                            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                                ESX.ShowNotification('la voiture a été mis en fourrière')
                                ESX.Game.DeleteVehicle(vehicle)
                               
                            else
                                ESX.ShowNotification('Mais toi place conducteur, ou sortez de la voiture.')
                            end
                        else
                            local vehicle = ESX.Game.GetVehicleInDirection()
            
                            if DoesEntityExist(vehicle) then
                                TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, true)
                                Citizen.Wait(5000)
                                ClearPedTasks(playerPed)
                                ESX.ShowNotification('La voiture à été placer en fourriere.')
                                ESX.Game.DeleteVehicle(vehicle)
            
                            else
                                ESX.ShowNotification('Aucune voitures autour')
                            end
                        end
                        end
                    end)


                  RageUI.Separator('~r~↓ Autres ↓')

                  RageUI.Checkbox("Bouclier",nil, service,{},function(Hovered,Ative,Selected,Checked)
                    if Selected then
    
                        service = Checked
    
    
                        if Checked then
                            EnableShield()
                            
                        else
                            DisableShield()
                        end
                    end
                end)


			RageUI.ButtonWithStyle("Demande de renfort", nil,  {}, true, function(Hovered, Active, Selected)
                  end, fFbif5Renfort)

                end, function() 
                end)

                RageUI.IsVisible(fFbif5Info, true, true, true, function()

                    RageUI.ButtonWithStyle("Prise de service",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local info = 'prise'
                            TriggerServerEvent('fbi:PriseEtFinservice', info)
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Fin de service",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local info = 'fin'
                            TriggerServerEvent('fbi:PriseEtFinservice', info)
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Pause de service",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local info = 'pause'
                            TriggerServerEvent('fbi:PriseEtFinservice', info)
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Standby",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local info = 'standby'
                            TriggerServerEvent('fbi:PriseEtFinservice', info)
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Control en cours",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local info = 'control'
                            TriggerServerEvent('fbi:PriseEtFinservice', info)
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Refus d'obtempérer",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local info = 'refus'
                            TriggerServerEvent('fbi:PriseEtFinservice', info)
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Crime en cours",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local info = 'crime'
                            TriggerServerEvent('fbi:PriseEtFinservice', info)
                        end
                    end)
            
                end, function()
                end)

                RageUI.IsVisible(fFbif5Renfort, true, true, true, function()

                    RageUI.ButtonWithStyle("Petite demande",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = 'petitfbi'
                            local elements  = {}
                            local playerPed = PlayerPedId()
                            local coords  = GetEntityCoords(playerPed)
                            local name = GetPlayerName(PlayerId())
                        TriggerServerEvent('renfort', coords, raison)
                    end
                end)
            
                RageUI.ButtonWithStyle("Moyenne demande",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local raison = 'importantefbi'
                        local elements  = {}
                        local playerPed = PlayerPedId()
                        local coords  = GetEntityCoords(playerPed)
                        local name = GetPlayerName(PlayerId())
                    TriggerServerEvent('renfort', coords, raison)
                end
            end)
            
            RageUI.ButtonWithStyle("Grosse demande",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    local raison = 'omgadfbi'
                    local elements  = {}
                    local playerPed = PlayerPedId()
                    local coords  = GetEntityCoords(playerPed)
                    local name = GetPlayerName(PlayerId())
                TriggerServerEvent('renfort', coords, raison)
            end
            end)
            
                end, function()
                end)

                if not RageUI.Visible(fFbif5) and not RageUI.Visible(fFbif5Info) and not RageUI.Visible(fFbif5Renfort) then
                    fFbif5 = RMenu:DeleteType("Fib", true)
        end
    end
end


Keys.Register('F6', 'Fib', 'Ouvrir le menu Fib', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'fbi' then
    	Menuf6fbi()
	end
end)

function OpenPrendreMenu()
    local PrendreMenu = RageUI.CreateMenu("Fib", "Arsenal")
        RageUI.Visible(PrendreMenu, not RageUI.Visible(PrendreMenu))
    while PrendreMenu do
        Citizen.Wait(0)
            RageUI.IsVisible(PrendreMenu, true, true, true, function()
            for k,v in pairs(Arsenal.Fbi) do
            RageUI.ButtonWithStyle(v.Label.. ' Prix: ' .. v.Price .. '€', nil, { }, true, function(Hovered, Active, Selected)
              if (Selected) then
                  TriggerServerEvent('vFbi:arsenal', v.Name, v.Price)
                end
            end)
        end
                end, function() 
                end)
    
                if not RageUI.Visible(PrendreMenu) then
                    PrendreMenu = RMenu:DeleteType("Fib", true)
        end
    end
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'fbi' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Fbi.pos.MenuPrendre.position.x, Fbi.pos.MenuPrendre.position.y, Fbi.pos.MenuPrendre.position.z)
        if dist3 <= 7.0 and Fbi.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Fbi.pos.MenuPrendre.position.x, Fbi.pos.MenuPrendre.position.y, Fbi.pos.MenuPrendre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour accéder à l'arsenal", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            OpenPrendreMenu()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)



function Coffrefbi()
    local Cfbi = RageUI.CreateMenu("Coffre", "Fib")
        RageUI.Visible(Cfbi, not RageUI.Visible(Cfbi))
            while Cfbi do
            Citizen.Wait(0)
            RageUI.IsVisible(Cfbi, true, true, true, function()

                RageUI.Separator("↓ Objet ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            FRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ADeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not RageUI.Visible(Cfbi) then
            Cfbi = RMenu:DeleteType("Cfbi", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'fbi' then
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Fbi.pos.coffre.position.x, Fbi.pos.coffre.position.y, Fbi.pos.coffre.position.z)
            if jobdist <= 10.0 and Fbi.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Fbi.pos.coffre.position.x, Fbi.pos.coffre.position.y, Fbi.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        Coffrefbi()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)


--- vestiaire


function vestiairefbi()
    local Vfbi = RageUI.CreateMenu("Vestiaire", "Fib")
        RageUI.Visible(Vfbi, not RageUI.Visible(Vfbi))
            while Vfbi do
            Citizen.Wait(0)
            RageUI.IsVisible(Vfbi, true, true, true, function()
                RageUI.Separator("↓ Votre Tenue ↓")
                    if ESX.PlayerData.job.grade_name == 'recruit' then
                    RageUI.ButtonWithStyle("Tenue Recrue",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tenuerecrue()
                            RageUI.CloseAll()
                        end
                    end)
                end
                    if ESX.PlayerData.job.grade_name == 'officer' then
                    RageUI.ButtonWithStyle("Tenue Officier",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tenueofficier()
                            RageUI.CloseAll()
                        end
                    end)
                end
                    if ESX.PlayerData.job.grade_name == 'sergeant' then
                    RageUI.ButtonWithStyle("Tenue Sergent",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tenuesergeant()
                            RageUI.CloseAll()
                        end
                    end)
                end
                    if ESX.PlayerData.job.grade_name == 'lieutenant' then
                    RageUI.ButtonWithStyle("Tenue Lieutenant",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tenuelieutenant()
                            RageUI.CloseAll()
                        end
                    end)
                end
                    if ESX.PlayerData.job.grade_name == 'boss' then
                    RageUI.ButtonWithStyle("Tenue Commandant",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tenueboss()
                            RageUI.CloseAll()
                        end
                    end)
                end

                    RageUI.ButtonWithStyle("Remettre sa tenue",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            vcivil()
                            RageUI.CloseAll()
                        end
                    end)

            RageUI.Separator("~g~↓ Gilet par balle ↓")

            RageUI.ButtonWithStyle("Mettre",nil, {nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    mettrebullet_wear()
                    SetPedArmour(GetPlayerPed(-1), 100)
                end
            end)

            RageUI.ButtonWithStyle("Enlever",nil, {nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    enleverbullet_wear()
                    SetPedArmour(GetPlayerPed(-1), 0)
                end
            end)
                end, function()
                end)
            if not RageUI.Visible(Vfbi) then
            Vfbi = RMenu:DeleteType("Vestiaire", true)
        end
    end
end

function tenuerecrue()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Fbi.Uniforms.recruit.male
        else
            uniformObject = Fbi.Uniforms.recruit.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end

function tenueofficier()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Fbi.Uniforms.officer.male
        else
            uniformObject = Fbi.Uniforms.officer.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end

function tenuesergeant()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Fbi.Uniforms.sergeant.male
        else
            uniformObject = Fbi.Uniforms.sergeant.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end

function tenuelieutenant()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Fbi.Uniforms.lieutenant.male
        else
            uniformObject = Fbi.Uniforms.lieutenant.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end

function tenueboss()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Fbi.Uniforms.boss.male
        else
            uniformObject = Fbi.Uniforms.boss.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end

function mettrebullet_wear()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Fbi.Uniforms.bullet_wear.male
        else
            uniformObject = Fbi.Uniforms.bullet_wear.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end

function enleverbullet_wear()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Fbi.Uniforms.bullet_wearno.male
        else
            uniformObject = Fbi.Uniforms.bullet_wearno.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end


function vcivil()
ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
TriggerEvent('skinchanger:loadSkin', skin)
end)
end


Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'fbi' then
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Fbi.pos.vestiaire.position.x, Fbi.pos.vestiaire.position.y, Fbi.pos.vestiaire.position.z)
            if jobdist <= 10.0 and Fbi.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Fbi.pos.vestiaire.position.x, Fbi.pos.vestiaire.position.y, Fbi.pos.vestiaire.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour accéder au vestiaire", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        vestiairefbi()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)


--- fin



-- Garage

function Garagefbi()
  local Gfbi = RageUI.CreateMenu("Garage", "Fib")
    RageUI.Visible(Gfbi, not RageUI.Visible(Gfbi))
        while Gfbi do
            Citizen.Wait(0)
                RageUI.IsVisible(Gfbi, true, true, true, function()
                    RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                        local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                        if dist4 < 4 then
                            DeleteEntity(veh)
                            end 
                        end
                    end) 

                    for k,v in pairs(Gfbivoiture) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarfbi(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(Gfbi) then
            Gfbi = RMenu:DeleteType("Garage", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'fbi' then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Fbi.pos.garage.position.x, Fbi.pos.garage.position.y, Fbi.pos.garage.position.z)
            if dist3 <= 10.0 and Fbi.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Fbi.pos.garage.position.x, Fbi.pos.garage.position.y, Fbi.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 3.0 then
                Timer = 0   
                    RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        Garagefbi()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

function spawnuniCarfbi(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Fbi.pos.spawnvoiture.position.x, Fbi.pos.spawnvoiture.position.y, Fbi.pos.spawnvoiture.position.z, Fbi.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "FBI"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
end

function Helifbi()
    local Hfbi = RageUI.CreateMenu("Garage", "Fib")
      RageUI.Visible(Hfbi, not RageUI.Visible(Hfbi))
          while Hfbi do
              Citizen.Wait(0)
                  RageUI.IsVisible(Hfbi, true, true, true, function()
                      RageUI.ButtonWithStyle("Ranger le hélicoptère", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                          if (Selected) then   
                          local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                          if dist4 < 4 then
                              DeleteEntity(veh)
                              RageUI.CloseAll()
                              end 
                          end
                      end) 
  
                      for k,v in pairs(Hfbiheli) do
                      RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                          if (Selected) then
                          Citizen.Wait(1)  
                            spawnuniCarheli(v.modele)
                              RageUI.CloseAll()
                              end
                          end)
                      end
                  end, function()
                  end)
              if not RageUI.Visible(Hfbi) then
              Hfbi = RMenu:DeleteType("Garage", true)
          end
      end
  end
  
  Citizen.CreateThread(function()
          while true do
              local Timer = 500
              if ESX.PlayerData.job and ESX.PlayerData.job.name == 'fbi' then
              local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
              local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Fbi.pos.garageheli.position.x, Fbi.pos.garageheli.position.y, Fbi.pos.garageheli.position.z)
              if dist3 <= 10.0 and Fbi.jeveuxmarker then
                  Timer = 0
                  DrawMarker(20, Fbi.pos.garageheli.position.x, Fbi.pos.garageheli.position.y, Fbi.pos.garageheli.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                  end
                  if dist3 <= 3.0 then
                  Timer = 0   
                      RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour accéder au garage des hélicoptères", time_display = 1 })
                      if IsControlJustPressed(1,51) then           
                          Helifbi()
                      end   
                  end
              end 
          Citizen.Wait(Timer)
       end
  end)
  
  function spawnuniCarheli(car)
      local car = GetHashKey(car)
  
      RequestModel(car)
      while not HasModelLoaded(car) do
          RequestModel(car)
          Citizen.Wait(0)
      end
  
      local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
      local vehicle = CreateVehicle(car, Fbi.pos.spawnheli.position.x, Fbi.pos.spawnheli.position.y, Fbi.pos.spawnheli.position.z, Fbi.pos.spawnheli.position.h, true, false)
      SetEntityAsMissionEntity(vehicle, true, true)
      local plaque = "FBI"..math.random(1,9)
      SetVehicleNumberPlateText(vehicle, plaque) 
      SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
  end

itemstock = {}
function FRetirerobjet()
    local Stockfbi = RageUI.CreateMenu("Coffre", "Fib")
    ESX.TriggerServerCallback('vFbi:getStockItems', function(items) 
    itemstock = items
   
    RageUI.Visible(Stockfbi, not RageUI.Visible(Stockfbi))
        while Stockfbi do
            Citizen.Wait(0)
                RageUI.IsVisible(Stockfbi, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", "", 2)
                                    TriggerServerEvent('Vfbi:getStockItem', v.name, tonumber(count))
                                    FRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Stockfbi) then
            Stockfbi = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end

local PlayersItem = {}
function ADeposerobjet()
    local StockPlayer = RageUI.CreateMenu("Coffre", "Fib")
    ESX.TriggerServerCallback('vFbi:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('Vfbi:putStockItems', item.name, tonumber(count))
                                            ADeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end


RegisterNetEvent('renfort:setBlip')
AddEventHandler('renfort:setBlip', function(coords, raison)
	if raison == 'petitfbi' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		ESX.ShowAdvancedNotification('FIB INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-2\n~w~Importance: ~g~Légère.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 2
	elseif raison == 'importantefbi' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		ESX.ShowAdvancedNotification('FIB INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-3\n~w~Importance: ~o~Importante.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 47
	elseif raison == 'omgadfbi' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
		ESX.ShowAdvancedNotification('FIB INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-99\n~w~Importance: ~r~URGENTE !\nDANGER IMPORTANT', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
		color = 1
	end
	local blipId = AddBlipForCoord(coords)
	SetBlipSprite(blipId, 161)
	SetBlipScale(blipId, 1.2)
	SetBlipColour(blipId, color)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Demande renfort')
	EndTextCommandSetBlipName(blipId)
	Wait(80 * 1000)
	RemoveBlip(blipId)
end)

RegisterNetEvent('fbi:InfoService')
AddEventHandler('fbi:InfoService', function(service, nom)
	if service == 'prise' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('FIB INFORMATIONS', '~b~Prise de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-8\n~w~Information: ~g~Prise de service.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'fin' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('FIB INFORMATIONS', '~b~Fin de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-10\n~w~Information: ~g~Fin de service.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'pause' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('FIB INFORMATIONS', '~b~Pause de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-6\n~w~Information: ~g~Pause de service.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'standby' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('FIB INFORMATIONS', '~b~Mise en standby', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-12\n~w~Information: ~g~Standby, en attente de dispatch.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'control' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('FIB INFORMATIONS', '~b~Control routier', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-48\n~w~Information: ~g~Control routier en cours.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'refus' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('FIB INFORMATIONS', '~b~Refus d\'obtemperer', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-30\n~w~Information: ~g~Refus d\'obtemperer / Delit de fuite en cours.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'crime' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('FIB INFORMATIONS', '~b~Crime en cours', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-31\n~w~Information: ~g~Crime en cours / poursuite en cours.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	end
end)

local shieldActive = false
local shieldEntity = nil

-- ANIM
local animDict = "combat@gestures@gang@pistol_1h@beckon"
local animName = "0"

local prop = "prop_ballistic_shield"

function EnableShield()
    shieldActive = true
    local ped = GetPlayerPed(-1)
    local pedPos = GetEntityCoords(ped, false)
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(250)
    end

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)

    RequestModel(GetHashKey(prop))
    while not HasModelLoaded(GetHashKey(prop)) do
        Citizen.Wait(250)
    end

    local shield = CreateObject(GetHashKey(prop), pedPos.x, pedPos.y, pedPos.z, 1, 1, 1)
    shieldEntity = shield
    AttachEntityToEntity(shieldEntity, ped, GetEntityBoneIndexByName(ped, "IK_L_Hand"), 0.0, -0.05, -0.10, -30.0, 180.0, 40.0, 0, 0, 1, 0, 0, 1)
    SetWeaponAnimationOverride(ped, GetHashKey("Gang1H"))
    SetEnableHandcuffs(ped, true)
end

function DisableShield()
    local ped = GetPlayerPed(-1)
    DeleteEntity(shieldEntity)
    ClearPedTasksImmediately(ped)
    SetWeaponAnimationOverride(ped, GetHashKey("Default"))
    SetEnableHandcuffs(ped, false)
    shieldActive = false
end

Citizen.CreateThread(function()
    while true do
        if shieldActive then
            local ped = GetPlayerPed(-1)
            if not IsEntityPlayingAnim(ped, animDict, animName, 1) then
                RequestAnimDict(animDict)
                while not HasAnimDictLoaded(animDict) do
                    Citizen.Wait(100)
                end
            
                TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)
            end
        end
        Citizen.Wait(500)
    end
end)

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


-----tp
key_to_teleport = 38

positions = {
    {{136.12, -761.82, 241.15, 342.93}, {136.05, -761.83, 44.75, 347.26},{255, 0, 0}, "Descendre/Monter"},
}



local player = GetPlayerPed(-1)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(5)
        local player = GetPlayerPed(-1)
        local playerLoc = GetEntityCoords(player)

        for _,location in ipairs(positions) do
            teleport_text = location[4]
            loc1 = {
                x=location[1][1],
                y=location[1][2],
                z=location[1][3],
                heading=location[1][4]
            }
            loc2 = {
                x=location[2][1],
                y=location[2][2],
                z=location[2][3],
                heading=location[2][4]
            }
            Red = location[3][1]
            Green = location[3][2]
            Blue = location[3][3]

            DrawMarker(1, loc1.x, loc1.y, loc1.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, Red, Green, Blue, 200, 0, 0, 0, 0)
            DrawMarker(1, loc2.x, loc2.y, loc2.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, Red, Green, Blue, 200, 0, 0, 0, 0)

            if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 2) then 
                alert(teleport_text)
                
                if IsControlJustReleased(1, key_to_teleport) then
                    if IsPedInAnyVehicle(player, true) then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                    else
                        SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(player, loc2.heading)
                    end
                end

            elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 2) then
                alert(teleport_text)

                if IsControlJustReleased(1, key_to_teleport) then
                    if IsPedInAnyVehicle(player, true) then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)
                    else
                        SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(player, loc1.heading)
                    end
                end
            end            
        end
    end
end)

function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end
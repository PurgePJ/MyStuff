if FileExist(COMMON_PATH.."CustomPred.lua") then
 require('CustomPred')
else
 PrintChat("CustomPred not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/PurgePJ/MyStuff/master/CustomPred.lua", COMMON_PATH.."CustomPred.lua", function() PrintChat("CustomPred download Complete, please 2x F6!") return end)
end
require("DamageLib")

if FileExist(SCRIPT_PATH.."Draw.lua") then
 require('Draw')
else
 PrintChat("Draw.lua not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/LoggeL/GoS/master/draw.lua", SCRIPT_PATH.."Draw.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
end

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() Print("Update Complete, please 2x F6!") return end)
end

local version = "0.1.1"
function AutoUpdate(data)
	if tonumber(data) > tonumber(ver) then
		PrintChat("New Update Found: " .. data)
		PrintChat("Downloading update, please wait...")
		DownloadFileAsync("https://raw.githubusercontent.com/PurgePJ/MyStuff/master/EloGrabber.lua", SCRIPT_PATH .. "EloGrabber.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
	end
end

class "Malzahar"
local n = 0
-- Variables and constants
	function Malzahar:__init()


	self.SkillQ = { name = "Call of the Void", ready = false }
	self.SkillW = { name = "Void Swarm", ready = false }
	self.SkillE = { name = "Malefic Visions", ready = false }
	self.SkillR = { name = "Spirit Rush", ready = false }

	Ignite = { name = "summonerdot", slot = nil }
	ignite = GetCastName(myHero, SUMMONER_1):lower() == "summonerdot" or GetCastName(myHero, SUMMONER_2):lower() == "summonerdot" or nil
	self.SelectedTarget = nil

	self.SpellData = {
		[0] = {width = 110, delay = 0.37, speed = 1440, range = 900},
		[1] = {width = 60, delay = 0.01, range = 450}
	}

	self.LevelUpTable={
			[1]={_E,_W,_Q,_W,_W,_R,_W,_E,_W,_E,_R,_W,_W,_Q,_Q,_R,_Q,_Q},

			[2]={_Q,_W,_Q,_E,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_E,_E,_R,_W,_W},

			[3]={_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W}
	}

	self.SpellRanges = 
	  {
	  [_Q] = {range = GetCastRange(myHero, 0)},
	  [_W] = {range = GetCastRange(myHero, 1)},
	  [_E] = {range = GetCastRange(myHero, 2)},
	  [_R] = {range = GetCastRange(myHero, 3)}
	  }

	  self.Dmg = 
	{
	[0] = function(target, source) return getdmg("Q",GetCurrentTarget(), myHero, 3) end,
	[1] = function(target, source) return getdmg("W",GetCurrentTarget(), myHero, 3) end,
	[2] = function(target, source) return getdmg("E",GetCurrentTarget(), myHero, 3) end,
	[3] = function(target, source) return getdmg("R",GetCurrentTarget(), myHero, 3) end
	}

Settings = MenuConfig("Malzahar Version: "..version.."", "Malzahar")
	Settings:SubMenu("combo", "["..myHero.charName.."] - Combo Settings")
		Settings.combo:DropDown("comboMode", "Combo Mode", 2, { "EQWR", "EQW"})
		Settings.combo:Empty("f", 0)
		Settings.combo:Info("se", "For a better performance, keep combo in EQW until you reach level 6")
		
	Settings:SubMenu("ks", "["..myHero.charName.."] - KillSteal Settings")
		Settings.ks:Boolean("killSteal", "Use Smart Kill Steal", true)
		Settings.ks:Boolean("autoIgnite", "Auto Ignite", true)

	Settings:SubMenu("SubReq", "["..myHero.charName.."] - AutoLevel Settings")
		Settings.SubReq:Boolean("LevelUp", "Level Up Skills", true)
		Settings.SubReq:Slider("Start_Level", "Level to enable lvlUP", 1, 1, 17) 
		Settings.SubReq:DropDown("autoLvl", "Skill order", 1, {"E-W-Q","Q-W-Q","Q-E-W",})
		Settings.SubReq:Boolean("Humanizer", "Enable Level Up Humanizer", true)

	Settings:SubMenu("AutoE", "["..myHero.charName.."] - Auto Skills Settings")
		Settings.AutoE:Boolean("AutoEEnabled", "Enable Auto E on minions", true)
		Settings.AutoE:Slider("AutoEHP", "Minimum hp % needed for auto E", 15, 1, 100)
		Settings.AutoE:Empty("Ess", 0)
		Settings.AutoE:Boolean("AutoWEnabled", "Enable Auto W", true)
		Settings.AutoE:Slider("AutoWMana", "Minimum mana % for W", 20, 1, 100)
		Settings.AutoE:Empty("Esss", 0)
		Settings.AutoE:Boolean("AutoREnabled", "Enable Auto R", true)
		Settings.AutoE:Slider("AutoRVoid", "Minimum Voildlings around target", 4, 1, 7)
       	
	Settings:SubMenu("Awareness", "["..myHero.charName.."] - Awareness Settings")
		Settings.Awareness:Boolean("AwarenessON", "Enable Awareness", true)

	Settings:SubMenu("misc", "["..myHero.charName.."] - Misc Settings")
		Settings.misc:Slider("skinList", "Choose your skin", 4, 1, 6)


	Settings:SubMenu("drawing", "["..myHero.charName.."] - Draw Settings")	
		Settings.drawing:Boolean("mDraw", "Disable All Range Draws", false)
		for i = 0,3 do
    	local str = {[0] = "Q", [1] = "W", [2] = "E", [3] = "R"}
      Settings.drawing:Boolean(str[i], "Draw "..str[i], true)
      Settings.drawing:ColorPick(str[i].."c", "Drawing Color", {255, 25, 155, 175})
    end

  Settings:SubMenu("s", "Info + other stuff")
		Settings.s:Info("ver", "Current Version: "..version.."")

	if heal then
		Settings:SubMenu("heal", "["..myHero.charName.."] - Summoner Heal")
			Settings.heal:Boolean("enable", "Use Heal", true)
			Settings.heal:Slider("health", "If My Health % is Less Than", 10, 0, 100)
	if realheals then
			Settings.heal:Boolean("ally", "Also use on ally", false)
			end
	end

	if ignite then
		Settings:SubMenu("ignite", "["..myHero.charName.."] - Ignite Settings")
		Settings.ignite:DropDown("set", "Use Smart Ignite", 2, {"OFF", "Optimal", "Aggressive", "Very Aggressive"})	
	end

	local HpMenu = MenuConfig("Minion HP: Version: "..version.."", "Malzahar Minion HP Drawing")

HpMenu:SubMenu("sel", "Drawings")
	HpMenu.sel:Boolean("Enabled", "Enable HP Drawings", true)
		HpMenu.sel:SubMenu("select", "Select Minions")
			HpMenu.sel.select:Boolean("mcr", "Draw on Ranged Minions", true)
			HpMenu.sel.select:Boolean("mcm", "Draw on Melee Minions", true)
			HpMenu.sel.select:Boolean("mcs", "Draw on Siege Minions", true)
local color
OnDraw(function()
    if HpMenu.sel.Enabled:Value() then
        for i, minion in ipairs(minionManager.objects) do
            if GetTeam(minion) ~= myHero.team and not minion.dead then
                if GetObjectName(minion):lower():find("ranged") and not HpMenu.sel.select.mcr:Value() then return end
                if GetObjectName(minion):lower():find("melee") and not HpMenu.sel.select.mcm:Value() then return end
                if GetObjectName(minion):lower():find("siege") and not HpMenu.sel.select.mcs:Value() then return end
               	if GetObjectName(minion):lower():find("order") then color = ARGB(255,227,52,75) else color = ARGB(255,33,184,184) end
                DrawText(""..math.ceil(GetCurrentHP(minion)).."", 16, minion.pos2D.x-15, minion.pos2D.y-55, color)
            end
        end
    end
end)

	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
	OnTick(function(myHero) self:Tick() end)
	OnDraw(function(myHero) self:Draw() end)
	OnUpdateBuff(function(unit, buff) self:OnUpdate(unit, buff) end)
	OnRemoveBuff(function(unit, buff) self:OnRemove(unit, buff) end)
	OnCreateObj(function(Object) self:OnCreate(Object) end)
	OnDeleteObj(function(Object) self:OnDelete(Object) end)
end
local got
function Malzahar:Checks()
		self.SkillQ.ready = (myHero:CanUseSpell(0) == READY)
		self.SkillW.ready = (myHero:CanUseSpell(1) == READY)
		self.SkillE.ready = (myHero:CanUseSpell(2) == READY)
		self.SkillR.ready = (myHero:CanUseSpell(3) == READY)
		
		if GetCastName(myHero, SUMMONER_1):lower():find("summonerdot") then
			Ignite.slot = SUMMONER_1
			got = 1
		elseif GetCastName(myHero, SUMMONER_2):lower():find("summonerdot") then
			Ignite.slot = SUMMONER_2
			got = 1
		else got = 0
		end
		if got == 1 then
			Ignite.ready = (Ignite.slot ~= nil and myHero:CanUseSpell(Ignite.slot) == READY)
		end
	end

	function Malzahar:AutoIgnite(unit)
		if got == 1 then
			if ValidTarget(unit, Ignite.range) and unit.health <= 50 + (20 * myHero.level) then
				if Ignite.ready then
					CastTargetSpell(unit, Ignite.slot)
				end
			end
		end
	end

	function Malzahar:DmgDrawing()
		local target = GetCurrentTarget()
			if ValidTarget(target, 2000)  then
				if GetCurrentHP(target) <= self.Dmg[0](target, myHero) then
					DrawText("Killable: Q", 16, WorldToScreen(0, GetOrigin(target)).x, WorldToScreen(0, GetOrigin(target)).y, ARGB(255, 10, 255, 10))
				elseif GetCurrentHP(target) <= self.Dmg[2](target, myHero) then
					DrawText("Killable: E", 16, WorldToScreen(0, GetOrigin(target)).x, WorldToScreen(0, GetOrigin(target)).y, ARGB(255, 10, 255, 10))
				elseif GetCurrentHP(target) <= self.Dmg[0](target, myHero) + self.Dmg[2](target, myHero) then
					DrawText("Killable: E + Q", 16, WorldToScreen(0, GetOrigin(target)).x, WorldToScreen(0, GetOrigin(target)).y, ARGB(255, 10, 255, 10))
				end
			end
	end

	function Malzahar:HealSlot()
		if GetCastName(myHero, SUMMONER_1):lower():find("summonerheal") or GetCastName(myHero, SUMMONER_2):lower():find("summonerheal") then
			realheals = true
		end
		if GetCastName(myHero, SUMMONER_1):lower():find("summonerheal") then
			return SUMMONER_1
		elseif GetCastName(myHero, SUMMONER_2):lower():find("summonerheal")  then
			return SUMMONER_2
		end
	end

	local sAllies = GetAllyHeroes()
	function Malzahar:findClosestAlly(obj)
	    local closestAlly = nil
	    local currentAlly = nil
		for i, currentAlly in pairs(sAllies) do
	        if currentAlly and not currentAlly.dead then
	            if closestAlly == nil then
	                closestAlly = currentAlly
				end
	            if GetDistanceSqr(currentAlly.pos, obj) < GetDistanceSqr(closestAlly.pos, obj) then
					closestAlly = currentAlly
	            end
	        end
	    end
		return closestAlly
	end
	heal = Malzahar:HealSlot()

	function Malzahar:CastQ()
		if GetDistance(GetCurrentTarget()) <= GetCastRange(myHero, 0) and self.SkillQ.ready then
			local Q = CustomPred(myHero.pos, GetCurrentTarget(), self.SpellData[0])
			if Q and Q.HitPer >= 2 then
		    	CastSkillShot(0, Q.castPos)
		    end
		end
	end

	function Malzahar:CastW()
		if GetDistance(GetCurrentTarget()) <= GetCastRange(myHero, 1) and self.SkillW.ready then
			local W = CustomPred(myHero.pos, GetCurrentTarget(), self.SpellData[1])
			if W.HitPer >= 1.2 then
		    	CastSkillShot(1, W.castPos)
		    end
		end
	end

	function Malzahar:CastE()
		if GetDistance(GetCurrentTarget()) <= GetCastRange(myHero, 2) and self.SkillE.ready then
		    CastTargetSpell(GetCurrentTarget(), 2)
		end
	end

	function Malzahar:CastR()
		if GetDistance(GetCurrentTarget()) <= GetCastRange(myHero, 3) and self.SkillR.ready then
			CastTargetSpell(GetCurrentTarget(), 3)
		end
	end

	function Malzahar:KillSteal()
		local target = GetCurrentTarget()
		for _, target in pairs(GetEnemyHeroes()) do
			if ValidTarget(target, 710) and target.visible then	
				if GetCurrentHP(GetCurrentTarget()) <= self.Dmg[0](target, myHero) then
					self:CastQ(target)
				elseif GetCurrentHP(GetCurrentTarget()) <= (self.Dmg[0](target, myHero) + self.Dmg[2](target, myHero)) then
					self:CastE(target)
					self:CastQ(target)
				elseif GetCurrentHP(GetCurrentTarget()) <= self.Dmg[2](target, myHero) then
					self:CastE(target)
				end

				if Settings.ks.autoIgnite:Value() then
					self:IgniteProperties(target)
				end
			end
		end
	end

	function Malzahar:Combo(unit)
		if ValidTarget(unit, 700) and unit ~= nil and unit.type == myHero.type then	
			if Settings.combo.comboMode:Value() == 1 then
				self:CastR()
					if not GotBuff(unit, "malzaharrsound")== 1 then
						self:CastE()
						self:CastQ()
						self:CastW()
					end

			elseif Settings.combo.comboMode:Value() == 2 then
				self:CastE()
				self:CastQ()
				self:CastW()
			end
		end
	end

	function Malzahar:HealMeHealAlly()
		if heal then
			if ValidTarget(GetCurrentTarget(), 1000) then
				if Settings.heal.enable:Value() and CanUseSpell(myHero, heal) == READY then
					if GetLevel(myHero) > 5 and GetCurrentHP(myHero)/GetMaxHP(myHero) < Settings.heal.health:Value() /100 then
						CastSpell(heal)
					elseif  GetLevel(myHero) < 6 and GetCurrentHP(myHero)/GetMaxHP(myHero) < (Settings.heal.health:Value()/100)*.75 then
						CastSpell(heal)
					end
					
					if realheals and Settings.heal.ally:Value() then
						local ally = Teemo:findClosestAlly(myHero)
						if ally and not ally.dead and GetDistance(ally) < 850 then
							if  GetCurrentHP(ally)/GetMaxHP(ally) < Settings.heal.health:value()/100 then
								CastSpell(heal)
							end
						end
					end
				end
			end
		end
	end

	function Malzahar:AutoSkillLevelUp()
		if Settings.SubReq.LevelUp:Value() and GetLevelPoints(myHero) >= 1 and GetLevel(myHero) >= Settings.SubReq.Start_Level:Value() then
	        if Settings.SubReq.Humanizer:Value() then
	            DelayAction(function() LevelSpell(self.LevelUpTable[Settings.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(0.3286,1.33250))
	        else
	            LevelSpell(self.LevelUpTable[Settings.SubReq.autoLvl:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
	        end
	    end
    end

    function Malzahar:eOnMinions()
    	for i,minion in pairs(minionManager.objects) do
			if GetTeam(minion) ~= myHero.team and ValidTarget(minion, GetCastRange(myHero, 2)) then
				if GetPercentHP(minion) < Settings.AutoE.AutoEHP:Value() and Ready(_E) then
					CastTargetSpell(minion, 2)
				end
			end
		end
    end

    lastSkin = 0
	function Malzahar:ChooseSkin()
		if Settings.misc.skinList:Value() ~= lastSkin then
			lastSkin = Settings.misc.skinList:Value()
			HeroSkinChanger(myHero, Settings.misc.skinList:Value())
		end
	end

	function Malzahar:Awareness()
		DrawCircle(myHero.pos, 2300, 1, 8, ARGB(140,34,122,155))
		for _, enemy in pairs(GetEnemyHeroes()) do
				if enemy ~= nil and not enemy.dead then
					if EnemiesAround(myHero, 2300) >= 1 then
						--local V = GetOrigin(myHero) + Vector(Vector(enemy) + Vector(myHero)):normalized()*300
						--DrawText("algo", V.x)
						if GetDistance(enemy, myHero) >= 1600 then
							DrawLine(WorldToScreen(0, GetOrigin(myHero)).x,WorldToScreen(0, GetOrigin(myHero)).y,WorldToScreen(0, GetOrigin(enemy)).x,WorldToScreen(0, GetOrigin(enemy)).y,5,ARGB(130, 39, 243, 107))
						elseif GetDistance(enemy, myHero) < 1600 and GetDistance(enemy, myHero) >= 900 then
							DrawLine(WorldToScreen(0, GetOrigin(myHero)).x,WorldToScreen(0, GetOrigin(myHero)).y,WorldToScreen(0, GetOrigin(enemy)).x,WorldToScreen(0, GetOrigin(enemy)).y,5,ARGB(130, 255, 255, 0))
						elseif GetDistance(enemy, myHero) < 900 then
							DrawLine(WorldToScreen(0, GetOrigin(myHero)).x,WorldToScreen(0, GetOrigin(myHero)).y,WorldToScreen(0, GetOrigin(enemy)).x,WorldToScreen(0, GetOrigin(enemy)).y,5,ARGB(130, 255, 0, 0))
						end
					end
				end
		end
	end

	function Malzahar:AutoW()
		if Settings.AutoE.AutoWEnabled:Value() then
			for i, minion in ipairs(minionManager.objects) do
				if GetPercentMP(myHero) >= Settings.AutoE.AutoWMana:Value() then
		            if GetTeam(minion) ~= myHero.team and not minion.dead then
		            	if GetDistance(minion, myHero) <= GetCastRange(myHero, _W) then
							CastSkillShot(_W, minion.pos)
						end
					end
				end
			end
		end
	end

local tieneE
    function Malzahar:OnUpdate(unit, buff)
  		if unit and unit.isMe and buff.Name:lower() == "malzaharrsound" then
  			BlockInput(true)
			Mix:BlockMovement(true) 
			Mix:BlockAttack(true) 
			Mix:BlockOrb(true)
		end

		if unit and unit == GetCurrentTarget() and buff.Name:lower() == "malzahare" then
			tieneE = 1
		end
	end

	function Malzahar:OnRemove(unit, buff)
  		if unit and unit.isMe and buff.Name:lower() == "malzaharrsound" then
  			BlockInput(false)
			Mix:BlockMovement(false) 
			Mix:BlockAttack(false) 
			Mix:BlockOrb(false)
		end
		if unit and unit == GetCurrentTarget() and buff.Name:lower() == "malzahare" then
			tieneE = 0
		end
	end

	function Malzahar:AutoR()
		if Settings.AutoE.AutoREnabled:Value() then
			if tieneE == 1 and n >= Settings.AutoE.AutoRVoid:Value() then
				self:CastR()
			end
		end
	end

	function Malzahar:IgniteProperties(unit)
		if Ignite.ready and GetDistance(unit) < 600 then
			if Settings.ignite.set:Value() ~= 1 then 
				if Settings.ignite.set:Value() == 2 and KeyIsDown(Settings.Combo.comboKey:Key()) then
					if unit.health <= 50 + (20-0.03 * myHero.level) then
						CastTargetSpell(unit, Ignite.slot)
					end
				elseif Settings.ignite.set:Value() == 3 and KeyIsDown(Settings.Combo.comboKey:Key()) and GetPercentHP(unit) < 30 then
					CastTargetSpell(unit, Ignite.slot)
			    elseif  Settings.ignite.set:Value() == 4 and GetPercentHP(unit) < 70 then
			    	CastTargetSpell(unit, Ignite.slot)
			    end
			end
		end
	end

    function Malzahar:Tick()
    	if Settings.AutoE.AutoEEnabled:Value() then
    		self:eOnMinions()
    	end
		if KeyIsDown(32) then 
			self:Combo(GetCurrentTarget())
		end
		self:AutoR()
		self:AutoW()
		self:AutoSkillLevelUp()
		self:HealMeHealAlly()
		self:Checks()
		self:AutoIgnite(GetCurrentTarget())
		self:KillSteal()
	end

	function Malzahar:Draw()
		if Settings.Awareness.AwarenessON:Value() then
			self:Awareness()
		end
		self:DmgDrawing()
		self:ChooseSkin()
		if not Settings.drawing.mDraw:Value() then
			for i,s in pairs({"Q","W","E","R"}) do
			    if Settings.drawing[s]:Value() then
			      DrawCircle(myHero.pos, self.SpellRanges[i-1].range, 1, 32, Settings.drawing[s.."c"]:Value())
			    end
			end
		end
	end

	function Malzahar:WndMsg(msg,key)

	if msg == 513 then
		local minD = 0
		local starget = nil
		for i, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, GetMousePos()) <= minD or starget == nil then
					minD = GetDistance(enemy, GetMousePos())
					starget = enemy
				end
			end
		end
		
		if starget and minD < 200 then
			if self.SelectedTarget and starget.charName == self.SelectedTarget.charName then
				self.SelectedTarget = nil
				PrintChat("<font color=\"#FF0000\">Deselected target: "..starget.charName.."</font>")
			else
				self.SelectedTarget = starget
				PrintChat("<font color=\"#ff8c00\">New target selected: "..starget.charName.."</font>")
			end
		end
	
	end
end

	function Malzahar:OnCreate(Object)
		if Object and GetObjectBaseName(Object) == "MalzaharVoidling" then
			n = n + 1
		end
	end

	function Malzahar:OnDelete(Object)
		if Object and GetObjectBaseName(Object) == "Malzahar_Base_W_Voidling_Death.troy" then
			n = n - 1 or 0
		end
	end
--[[
OnCreateObj(function(Object)
	if Object and GetObjectBaseName(Object) == "MalzaharVoidling" then
		print("hi")
	end
end)

OnDeleteObj(function(Object)
	if Object and GetObjectBaseName(Object) == "Malzahar_Base_W_Voidling_Death.troy" then
		print("bye")
	end
	if GetDistance(Object) < 600 then
		PrintChat(string.format("<font color='#ff0000'>DeletedObject = %s</font>",GetObjectBaseName(Object)))
	end
end) ]]

_G[GetObjectName(myHero)]()
GetWebResultAsync("https://raw.githubusercontent.com/PurgePJ/MyStuff/master/SomeRandVersion.version", AutoUpdate)

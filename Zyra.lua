
if GetObjectName(GetMyHero()) ~= "Zyra" then return end

require("OpenPredict")
require("DamageLib")


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end

local SetDCP, SkinChanger = 0


local ZyraMenu = Menu("Zyra", "Zyra")

ZyraMenu:SubMenu("Zyra", "Zyra")

ZyraMenu.Combo:Boolean("Q", "Use Q in combo", true)
ZyraMenu.Combo:Boolean("W", "Use W in combo", true)
ZyraMenu.Combo:Boolean("E", "Use E in combo", true)
ZyraMenu.Combo:Boolean("R", "Use R in combo", true)

ZyraMenu:SubMenu("URFMode", "URFMode")
ZyraMenu.URFMode:Boolean("Level", "Auto level spells", false)
ZyraMenu.URFMode:Boolean("Ghost", "Auto Ghost", false)
ZyraMenu.URFMode:Boolean("Q", "Auto Q", false)
ZyraMenu.URFMode:Boolean("W", "Auto W", false)
ZyraMenu.URFMode:Boolean("E", "Auto E", false)

ZyraMenu:SubMenu("LaneClear", "LaneClear")
ZyraMenu.LaneClear:Boolean("Q", "Use Q", true)
ZyraMenu.LaneClear:Boolean("E", "Use E", true)

ZyraMenu:SubMenu("Harass", "Harass")
ZyraMenu.Harass:Boolean("Q", "Use Q", true)
ZyraMenu.Harass:Boolean("E", "Use E", true)

ZyraMenu:SubMenu("KillSteal", "KillSteal")
ZyraMenu.KillSteal:Boolean("Q", "KS w Q", true)
ZyraMenu.KillSteal:Boolean("E", "KS w E", true)

ZyraMenu:SubMenu("AutoIgnite", "AutoIgnite")
ZyraMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

ZyraMenu:SubMenu("Drawings", "Drawings")
ZyraMenu.Drawings:Boolean("DQ", "Draw Q Range", true)
ZyraMenu.Drawings:Boolean("DE", "Draw E Range", true)
ZyraMenu.Drawings:Boolean("DR", "Draw R Range", true)

ZyraMenu:SubMenu("SkinChanger", "SkinChanger")
ZyraMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
ZyraMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()

	--AUTO LEVEL UP
	if UrgotMenu.URFMode.Level:Value() then

			spellorder = {_Q, _E, _W, _Q, _E, _R, _Q, _W, _W, _Q, _R, _Q, _W, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if IOW:Mode() == "Harass" then

            if ZyraMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 800) then
	                                CastSkillShot(_Q, target.pos)
                       	
             end
             if ZyraMenu.Harass.E:Value() and Ready(_E) and ValidTarget(target, 850) then
				                          CastSkillShot(_E, target)
             end
          end
	--COMBO
		     if IOW:Mode() == "Combo" then

             if ZyraMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 800) then
				                           CastTargetSpell(_Q, target.pos)
             end
            	    
	           if ZyraMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 850) then
				                           CastTargetSpell(_W, target.pos)
	           end
             
	           if ZyraMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 850) then
				                           CastSkillShot(_E, target)
			       end
	    
             if ZyraMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 500) then
				                            CastTargetSpell(target, _R)
             end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 800) and ZyraMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		                    CastSkillShot(_Q, target.pos)
		
                end 

                if IsReady(_E) and ValidTarget(enemy, 850) and ZyraMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                    CastSkillShot(_E, target)
  
                end
      end

      if IOW:Mode() == "LaneClear" then

      	  for _,closeminion in pairs(minionManager.objects) do
	         if ZyraMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 800) then
	        	   CastSkillShot(_Q, closeminion)
	         end
          
           if UrgotMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 900) then
	        	   CastSkillShot(_E, closeminion)
	         end
      	 end
      end
        --URFMode
        if ZyraMenu.URFMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 800) then
						CastSkillShot(_Q, target.pos)
          end
        end 
        if ZyraMenu.URFMode.W:Value() and ValidTarget(target, 850) then        
          if Ready(_W) then
	  	      CastTargetSpell(_W, target.pos)
          end
        end
        if ZyraMenu.URFMode.E:Value() then        
	        if Ready(_E) and ValidTarget(target, 850) then
						CastSkillShot(_E, target)
	        end
        end
                
	--AUTO IGNITE
	if ZyraMenu.URFMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if ZyraMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 800, 0, 150, GoS.Black)
	end

	if ZyraMenu.Drawings.DE:Value() then
		DrawCircle(GetOrigin(myHero), 850, 0, 150, GoS.Black)
	end

	if ZyraMenu.Drawings.DR:Value() then
		DrawCircle(GetOrigin(myHero), 500, 0, 150, GoS.Black)
	end

end)

local function SkinChanger()
	if ZyraMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Zyra</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')


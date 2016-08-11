function MyFunction(self, ...)
	local name, level, areaName, className, comment, partyMembers, status, class, encountersTotal, encountersComplete, isLeader, isTank, isHealer, isDamage, talentPoints, spec1, spec2, spec3, isLFM, Armor, SpellDamage, SpellHeal, CritMelee, CritRanged, CritSpell, MP5, MP5Combat, AttackPower, Agility, Health, Mana, avgILevel, Defense, Dodge, Block, Parry, Haste, Expertise = SearchLFGGetResults(self.index);
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 27, -37);

	if ( partyMembers > 0 ) then
		GameTooltip:AddLine(name);
		GameTooltip:AddLine(format("Level %u |c%s%s%s|r (%.0f)", level, ColorToString(GetClassColor(class)), GetSpecName(class, spec1, spec2, spec3), className, avgILevel));
		GameTooltip:AddTexture("Interface\\LFGFrame\\LFGRole", 0, 0.25, 0, 1);
		GameTooltip:AddLine(format(LFM_NUM_RAID_MEMBER_TEMPLATE, partyMembers+1));
	else
		GameTooltip:AddLine(name);
		GameTooltip:AddLine(format("Level %u |c%s%s%s|r (%.0f)", level, ColorToString(GetClassColor(class)), GetSpecName(class, spec1, spec2, spec3), className, avgILevel));
	end

	if ( comment and comment ~= "" ) then
		GameTooltip:AddLine("\n"..comment, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1);
	end

	if ( partyMembers == 0 ) then
		GameTooltip:AddLine("\n"..LFG_TOOLTIP_ROLES);
		if ( isTank ) then
			GameTooltip:AddLine(TANK);
			GameTooltip:AddTexture("Interface\\LFGFrame\\LFGRole", 0.5, 0.75, 0, 1);
		end
		if ( isHealer ) then
			GameTooltip:AddLine(HEALER);
			GameTooltip:AddTexture("Interface\\LFGFrame\\LFGRole", 0.75, 1, 0, 1);
		end
		if ( isDamage ) then
			GameTooltip:AddLine(DAMAGER);
			GameTooltip:AddTexture("Interface\\LFGFrame\\LFGRole", 0.25, 0.5, 0, 1);
		end
	end

	if ( encountersComplete > 0 ) then
		GameTooltip:AddLine("\nPerm bound to instance:");
		for i=1, encountersTotal do
			local bossName, texture, isKilled = SearchLFGGetEncounterResults(self.index, i);
			if ( isKilled ) then
				GameTooltip:AddDoubleLine(bossName, BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
			else
				GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
			end
		end
	elseif ( partyMembers > 0 and encountersTotal > 0) then
		GameTooltip:AddLine("\n"..ALL_BOSSES_ALIVE);
	end

	if (partyMembers == 0) then
		local powername = GetPowerForClassName(className);
		GameTooltip:AddLine("\nExtra info:");
		GameTooltip:AddLine(format("Average itemLevel: %.0f", avgILevel));
		GameTooltip:AddLine(format("Talent points: %u/%u/%u", spec1, spec2, spec3));
		if (powername == "Mana") then GameTooltip:AddLine(format("Spell Power: %u", SpellDamage)); end
		if (powername == "Mana") then GameTooltip:AddLine(format("Healing Power: %u", SpellHeal)); end
		if (className == "Hunter") then
			GameTooltip:AddLine(format("Ranged Attack Power: %u", AttackPower))
		else
			GameTooltip:AddLine(format("Attack Power: %u", AttackPower));
		end
		GameTooltip:AddLine(format("Crit Rating melee: %u", CritMelee));
		GameTooltip:AddLine(format("Crit Rating ranged: %u", CritRanged));
		GameTooltip:AddLine(format("Crit Rating spell: %u", CritSpell));
		if (powername == "Mana") then GameTooltip:AddLine(format("MP5: %u (%u in combat)", MP5, MP5Combat)); end
		GameTooltip:AddLine(format("Max Health: %u", Health));
		GameTooltip:AddLine(format("Max %s: %u", tostring(powername), Mana));
		GameTooltip:AddLine(format("Armor: %u", Armor));
		GameTooltip:AddLine(format("Defense skill: %u", Defense));
		GameTooltip:AddLine(format("Dodge Rating: %u", Dodge));
		GameTooltip:AddLine(format("Block Rating: %u", Block));
		GameTooltip:AddLine(format("Parry Rating: %u", Parry));
		GameTooltip:AddLine(format("Haste Rating: %u", Haste));
		GameTooltip:AddLine(format("Expertise Rating: %u", Expertise));
		
		if (areaName) then GameTooltip:AddLine(format("Zone: %s", tostring(areaName))); end
	else
		local avgGroupItemLevel = 0;
		GameTooltip:AddLine("\nPlayers in Group:");
		for i=0, partyMembers do
			local name, level, relationship, className, areaName, comment, isLeader, isTank, isHealer, isDamage, talentPoints, spec1, spec2, spec3, isLFM, Armor, SpellDamage, SpellHeal, CritMelee, CritRanged, CritSpell, MP5, MP5Combat, AttackPower, Agility, Health, Mana, avgILevel, Defense, Dodge, Block, Parry, Haste, Expertise = SearchLFGGetPartyResults(self.index, i);

			avgGroupItemLevel = avgGroupItemLevel + avgILevel;
			local online = talentPoints;
			local mClass = GetClassForClassName(className);
			local rightText;
			if (online > 0) then
				rightText = "Online";
			else
				rightText = "Offline";
			end
			local rightColor = NORMAL_FONT_COLOR;
			if (relationship) then
				if (relationship == "ignored") then
					rightColor = RED_FONT_COLOR;
					if (online > 0) then
						rightText = "Ignored";
					end
				elseif (relationship == "friend") then
					rightColor = GREEN_FONT_COLOR;
					if (online > 0) then
						rightText = "Friend";
					end
				end
			end
			local info = format("%s Level %u |c%s%s%s|r (%.0f)", name, level, ColorToString(GetClassColor(mClass)), GetSpecName(mClass, spec1, spec2, spec3), className, avgILevel);
			GameTooltip:AddDoubleLine(info, rightText, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, rightColor.r, rightColor.g, rightColor.b);
		end
		GameTooltip:AddLine(format("Group average itemLevel: %.1f", avgGroupItemLevel/(partyMembers+1)));
	end

	GameTooltip:Show();
end

TALENT_SPEC_NAMES = {
	["WARRIOR"] = { [1] = "Arms", [2] = "Fury", [3] = "Protection"},
	["PALADIN"] = { [1] = "Holy", [2] = "Protection", [3] = "Retribution"},
	["HUNTER"] = { [1] = "Beast mastery", [2] = "Marksmanship", [3] = "Survival"},
	["ROGUE"] = { [1] = "Assassination", [2] = "Combat", [3] = "Subtlety"},
	["PRIEST"] = { [1] = "Discipline", [2] = "Holy", [3] = "Shadow"},
	["DEATHKNIGHT"] = { [1] = "Blood", [2] = "Frost", [3] = "Unholy"},
	["SHAMAN"] = { [1] = "Elemental", [2] = "Enhancement", [3] = "Restoration"},
	["MAGE"] = { [1] = "Arcane", [2] = "Fire", [3] = "Frost"},
	["WARLOCK"] = { [1] = "Affliction", [2] = "Demonology", [3] = "Destruction"},
	["DRUID"] = { [1] = "Balance", [2] = "Feral Combat", [3] = "Restoration"},
};

function GetSpecName(class, spec1, spec2, spec3)
	if (not class) then return ""; end
	local m = 0;
	local idx = 0;
	if (spec1 > m) then
		m = spec1;
		idx = 1;
	end
	if (spec2 > m) then 
		m = spec2;
		idx = 2;
	end
	if (spec3 > m) then
		m = spec3;
		idx = 3;
	end
	if (idx == 0) then return ""; end
	local str = TALENT_SPEC_NAMES[class][idx] .. " ";
	return str;
end

function GetClassColor(class)
	local classColor;
	if (class) then
		classColor = RAID_CLASS_COLORS[class];
	else
		classColor = NORMAL_FONT_COLOR;
	end
	return classColor;
end

function ColorToString(color)
    return format("ff%.2x%.2x%.2x", color.r * 255, color.g * 255, color.b * 255);
end

function GetClassForClassName(className)
	if (className == "Warrior") then return "WARRIOR";
	elseif (className == "Paladin") then return "PALADIN";
	elseif (className == "Hunter") then return "HUNTER";
	elseif (className == "Rogue") then return "ROGUE";
	elseif (className == "Priest") then return "PRIEST";
	elseif (className == "Death Knight") then return "DEATHKNIGHT";
	elseif (className == "Shaman") then return "SHAMAN";
	elseif (className == "Mage") then return "MAGE";
	elseif (className == "Warlock") then return "WARLOCK";
	elseif (className == "Druid") then return "DRUID";
	end
	return 0;
end

function GetPowerForClassName(className)
	if (className == "Warrior") then return "Rage";
	elseif (className == "Paladin") then return "Mana";
	elseif (className == "Hunter") then return "Mana";
	elseif (className == "Rogue") then return "Energy";
	elseif (className == "Priest") then return "Mana";
	elseif (className == "Death Knight") then return "Runic Power";
	elseif (className == "Shaman") then return "Mana";
	elseif (className == "Mage") then return "Mana";
	elseif (className == "Warlock") then return "Mana";
	elseif (className == "Druid") then return "Mana";
	end
	return 0;
end

for i=1, NUM_LFR_LIST_BUTTONS do
	local button = _G["LFRBrowseFrameListButton"..i];
	button:SetScript("OnEnter", MyFunction);
end

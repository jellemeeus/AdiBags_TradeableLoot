--[[

The MIT License (MIT)

Copyright (c) 2022 Lucas Vienna (Avyiel), Spanky, Kevin (kevin@outroot.com)
Copyright (c) 2021 Lars Norberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
	
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]
--[[
	Many thanks to Lars Norberg, aka GoldpawForever. This is largely inspired by his
	BlizzardBags addons: https://github.com/GoldpawsStuff/BlizzardBags_BoE
	and partially based on his template: https://github.com/GoldpawsStuff/AddonTemplate
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

do -- Localization
  L["Bound"] = "Bound"
  L["Put BOE/BOA in their own sections."] = "Put BOE/BOA in their own sections."

  local locale = GetLocale()
  if locale == "frFR" then

  elseif locale == "deDE" then
    
  elseif locale == "esMX" then
    
  elseif locale == "ruRU" then
    
  elseif locale == "esES" then
    
  elseif locale == "zhTW" then
    
  elseif locale == "zhCN" then
    
  elseif locale == "koKR" then
    
  end
end

local tooltip
local function create()
  local tip, leftside = CreateFrame("GameTooltip"), {}
  for i = 1,6 do
    local L,R = tip:CreateFontString(), tip:CreateFontString()
    L:SetFontObject(GameFontNormal)
    R:SetFontObject(GameFontNormal)
    tip:AddFontStrings(L,R)
    leftside[i] = L
  end
  tip.leftside = leftside
  return tip
end

-- The filter itself

local setFilter = addon:RegisterFilter("Bound", 92, 'ABEvent-1.0')
setFilter.uiName = L['Bound']
setFilter.uiDesc = L['Put BOE/BOA in their own sections.']

function setFilter:OnInitialize()
  self.db = addon.db:RegisterNamespace('Bound', {
    profile = { enableBoE = true, enableBoA = true },
    char = {  },
  })
end

function setFilter:Update()
  self:SendMessage('AdiBags_FiltersChanged')
end

function setFilter:OnEnable()
  addon:UpdateFilters()
end

function setFilter:OnDisable()
  addon:UpdateFilters()
end

local setNames = {}

function setFilter:Filter(slotData)
  tooltip = tooltip or create()
  tooltip:SetOwner(UIParent,"ANCHOR_NONE")
  tooltip:ClearLines()

if slotData.bag == BANK_CONTAINER then
	tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
else
	tooltip:SetBagItem(slotData.bag, slotData.slot)
end

  for i = 1,6 do
    local t = tooltip.leftside[i]:GetText()
    if self.db.profile.enableBoE and t == ITEM_BIND_ON_EQUIP then
      return L["BoE"]
    elseif self.db.profile.enableBoA and (t == ITEM_ACCOUNTBOUND or t == ITEM_BIND_TO_BNETACCOUNT or t == ITEM_BNETACCOUNTBOUND) then
      return L["BoA"]
    end
  end
  tooltip:Hide()
end

function setFilter:GetOptions()
  return {
    enableBoE = {
      name = L['Enable BoE'],
      desc = L['Check this if you want a section for BoE items.'],
      type = 'toggle',
      order = 10,
    },
    enableBoA = {
      name = L['Enable BoA'],
      desc = L['Check this if you want a section for BoA items.'],
      type = 'toggle',
      order = 20,
    },
  }, addon:GetOptionHandler(self, false, function() return self:Update() end)
end

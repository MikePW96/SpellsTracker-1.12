
local frame = CreateFrame("Frame", "SpellReplayFrame", UIParent)

frame:SetWidth(220)
frame:SetHeight(40)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, -200)

local icons = {}
local times = {}

local MAX_ICONS = 5
local ICON_DURATION = 5

local i

for i = 1, MAX_ICONS do

    local tex = frame:CreateTexture(nil, "ARTWORK")

    tex:SetWidth(32)
    tex:SetHeight(32)

    tex:SetPoint("LEFT", frame, "LEFT", (i - 1) * 36, 0)

    tex:Hide()

    icons[i] = tex
    times[i] = 0
end

local function FindTexture(spell)

    local i = 1

    while true do

        local name = GetSpellName(i, BOOKTYPE_SPELL)

        if not name then
            break
        end

        if string.lower(name) == string.lower(spell) then
            return GetSpellTexture(i, BOOKTYPE_SPELL)
        end

        i = i + 1
    end

    return "Interface\\Icons\\INV_Misc_QuestionMark"
end

local function Push(texture)

    local i

    for i = MAX_ICONS, 2, -1 do

        icons[i]:SetTexture(icons[i - 1]:GetTexture())
        times[i] = times[i - 1]

        if icons[i - 1]:IsShown() then
            icons[i]:Show()
        else
            icons[i]:Hide()
        end
    end

    icons[1]:SetTexture(texture)
    icons[1]:Show()

    times[1] = GetTime()
end

local function AddSpell(spell)

    if not spell or spell == "" then
        return
    end

    local texture = FindTexture(spell)

    Push(texture)
end



-- =====================================================
-- SPELLBOOK CAST HOOK
-- Needed for SuperMacro / CastSpell(id,"spell")
-- =====================================================

local SR_OriginalCastSpell = CastSpell

CastSpell = function(id, bookType)

    if bookType == "spell" then

        local name = GetSpellName(id, bookType)

        if name then
            AddSpell(name)
        end
    end

    return SR_OriginalCastSpell(id, bookType)
end

-- =====================================================
-- DIRECT SPELLCAST HOOKS
-- This is the reliable Vanilla approach.
-- =====================================================

local SR_OriginalCastSpellByName = CastSpellByName

CastSpellByName = function(spell, onSelf)

    local clean = spell

    if string.find(clean, "%(") then
        clean = string.gsub(clean, "%s*%b()", "")
    end

    AddSpell(clean)

    return SR_OriginalCastSpellByName(spell, onSelf)
end

local SR_OriginalUseAction = UseAction

UseAction = function(slot, checkCursor, onSelf)

    local texture = GetActionTexture(slot)

    if texture then

        local i = 1

        while true do

            local name = GetSpellName(i, BOOKTYPE_SPELL)

            if not name then
                break
            end

            local tex = GetSpellTexture(i, BOOKTYPE_SPELL)

            if tex == texture then
                AddSpell(name)
                break
            end

            i = i + 1
        end
    end

    return SR_OriginalUseAction(slot, checkCursor, onSelf)
end

frame:SetScript("OnUpdate", function()

    local now = GetTime()

    local i

    for i = 1, MAX_ICONS do

        if times[i] > 0 then

            if (now - times[i]) > ICON_DURATION then

                icons[i]:Hide()
                icons[i]:SetTexture(nil)

                times[i] = 0
            end
        end
    end
end)



-- =====================================================
-- MOVE MODE
-- =====================================================

local moveBox = CreateFrame("Frame", nil, SpellReplayFrame)
moveBox:SetAllPoints(SpellReplayFrame)
moveBox:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})

moveBox:SetBackdropColor(0, 0, 0, 0.7)
moveBox:Hide()

local moveText = moveBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
moveText:SetPoint("CENTER", moveBox, "CENTER", 0, 0)
moveText:SetText("SpellsTracker Move Mode")

local moving = false

local function ToggleMove()

    moving = not moving

    if moving then

        moveBox:Show()

        SpellReplayFrame:SetMovable(true)
        SpellReplayFrame:EnableMouse(true)

        SpellReplayFrame:RegisterForDrag("LeftButton")

        SpellReplayFrame:SetScript("OnDragStart", function()
            SpellReplayFrame:StartMoving()
        end)

        SpellReplayFrame:SetScript("OnDragStop", function()
            SpellReplayFrame:StopMovingOrSizing()
        end)

        DEFAULT_CHAT_FRAME:AddMessage("SpellsTracker move mode enabled")

    else

        moveBox:Hide()

        SpellReplayFrame:StopMovingOrSizing()
        SpellReplayFrame:SetMovable(false)
        SpellReplayFrame:EnableMouse(false)

        SpellReplayFrame:SetScript("OnDragStart", nil)
        SpellReplayFrame:SetScript("OnDragStop", nil)

        DEFAULT_CHAT_FRAME:AddMessage("SpellsTracker locked in place")
    end
end

SLASH_SPELLREPLAY1 = "/st"

SlashCmdList["SPELLREPLAY"] = function()

    if frame:IsShown() then
        frame:Hide()
        DEFAULT_CHAT_FRAME:AddMessage("SpellsTracker hidden")
    else
        frame:Show()
        DEFAULT_CHAT_FRAME:AddMessage("SpellsTracker shown")
    end
end



SLASH_SPELLTRACKERMOVE1 = "/stmove"

SlashCmdList["SPELLTRACKERMOVE"] = function()

    ToggleMove()

end

DEFAULT_CHAT_FRAME:AddMessage("SpellsTracker loaded")

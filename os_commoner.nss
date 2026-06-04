// Carcerian's Custom Commoners
// Script: os_commoner by Carcerian
//
// DESCRIPTION:
// An advanced OnSpawn replacement script for Neverwinter Nights that provides
// randomized heads, randomized skin/hair/tattoo tints from explicit list pools,
// native name generation, randomized outfits, random hand props, and random shields.
// Fully customizable.
//
// AURORA TOOLSET INSTRUCTIONS:
// To override default settings for a specific NPC, open their Properties,
// navigate to the 'Variables' tab, and add any of these variables:
//
// Variable Name       | Type    | Example Value / Notes
// --------------------|---------|----------------------------------------------
// COMMONER_NO_NAME    | Integer | Set to 1 to keep original blueprint name.
// COMMONER_NO_COLORS  | Integer | Set to 1 to bypass all color tinting.
// COMMONER_SKIN       | String  | "2 5 12" (Space-separated skin index pool)
// COMMONER_HAIR       | String  | "1 4 8 16" (Space-separated hair index pool)
// COMMONER_TATTOO1    | String  | "0 10 20" (Space-separated tattoo 1 pool)
// COMMONER_TATTOO2    | String  | "5 15 25" (Space-separated tattoo 2 pool)
// COMMONER_HEADS      | String  | "1 4 12" (Space-separated head.2da row IDs)
// COMMONER_CLOTHES    | String  | "nw_cloth002 nw_cloth005" (Blueprint ResRefs)
// COMMONER_PROPS      | String  | "none nw_it_torch001" (Use "none" to skip item)
// COMMONER_SHIELDS    | String  | "none nw_it_shldsmall001" (Use "none" to skip item)
// COMMONER_PREFIX     | String  | "Sir" or "Lady"
// COMMONER_SUFFIX     | String  | "the Smith" or "of Neverwinter"

#include "nw_i0_generic"

// --- CONFIGURATION: GLOBAL HEAD STRING LISTS BY RACE & GENDER ---
const string M_HUMAN    = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32";
const string F_HUMAN    = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25";
const string M_ELF      = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18";
const string F_ELF      = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16";
const string M_HALFELF  = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32";
const string F_HALFELF  = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25";
const string M_DWARF    = "1 2 3 4 5 6 7 8 9 10 11 12 13";
const string F_DWARF    = "1 2 3 4 5 6 7 8 9 10 11 12";
const string M_GNOME    = "1 2 3 4 5 6 7 8 9 10 11 12 13";
const string F_GNOME    = "1 2 3 4 5 6 7 8 9";
const string M_HALFLING = "1 2 3 4 5 6 7 8 9 10";
const string F_HALFLING = "1 2 3 4 5 6 7 8 9 10 11";
const string M_HALFORC  = "1 2 3 4 5 6 7 8 9 10 11 12 13";
const string F_HALFORC  = "1 2 3 4 5 6 7 8 9 10 11 12";

// --- CONFIGURATION: GLOBAL DEFAULT COLOR INDEX POOLS ---
const string POOL_SKIN    = "1 2 3 4 5 6 7 8";
const string POOL_HAIR    = "1 2 3 4 5 6 7 8";
const string POOL_TATTOO1 = "1 2 3 4 5 6 7 8";
const string POOL_TATTOO2 = "1 2 3 4 5 6 7 8";

// GLOBAL CLOTHING RESREF LISTS
const string CLOTHES_MALE   = "nw_cloth001 nw_cloth002 nw_cloth003 nw_cloth005 nw_cloth027 nw_cloth017 nw_cloth015 nw_cloth021";
const string CLOTHES_FEMALE = "x2_cloth008 nw_cloth012 nw_cloth020 nw_cloth026 mcloth006 nw_cloth007 nw_cloth008 nw_cloth005";

// GLOBAL DEFAULT HAND PROPS (RIGHT HAND)
const string DEFAULT_PROPS  = "none nw_wswdg001 nw_wblcl001 nw_wblhl001 nw_wblml001 nw_wblml001 nw_wdbqs001 nw_wspsc001 x2_it_wpwhip x3_it_moonstick";

// GLOBAL DEFAULT SHIELDS (LEFT HAND)
const string DEFAULT_SHIELDS = "none none none none none none none none none nw_it_torch001 nw_ashsw001 it_iwoodshldl001 nw_ashlw001 nw_ashto001 tm_shield_griffn tm_shield_helm tm_shield_zhent";


// --- HELPER FUNCTION: GET TOTAL COUNT ---
int GetListCount(string sList)
{
    while(GetSubString(sList, 0, 1) == " ")
    {
        sList = GetSubString(sList, 1, GetStringLength(sList) - 1);
    }

    int nLen = GetStringLength(sList);
    while(nLen > 0 && GetSubString(sList, nLen - 1, 1) == " ")
    {
        sList = GetSubString(sList, 0, nLen - 1);
        nLen = GetStringLength(sList);
    }

    if(nLen == 0) return 0;

    int nCount = 1;
    int nSpace = FindSubString(sList, " ");

    while(nSpace != -1)
    {
        nCount++;
        sList = GetSubString(sList, nSpace + 1, GetStringLength(sList) - nSpace - 1);
        nSpace = FindSubString(sList, " ");
    }
    return nCount;
}

// --- HELPER FUNCTION: EXTRACT STRING BY INDEX ---
string GetStringFromList(string sList, int nIndex)
{
    string sResult = "";
    int i;

    while(GetSubString(sList, 0, 1) == " ")
    {
        sList = GetSubString(sList, 1, GetStringLength(sList) - 1);
    }

    for (i = 1; i <= nIndex; i++)
    {
        int nSpace = FindSubString(sList, " ");
        if (nSpace == -1)
        {
            sResult = sList;
            break;
        }

        sResult = GetSubString(sList, 0, nSpace);
        sList = GetSubString(sList, nSpace + 1, GetStringLength(sList) - nSpace - 1);
    }

    return sResult;
}

void main()
{
    // --- PART 1: IDENTITY RECOGNITION ---
    int nRace = GetRacialType(OBJECT_SELF);
    int nGender = GetGender(OBJECT_SELF);
    int nHeadID = 1;
    string sTargetList = "";

    // --- PART 2: HEAD LIST LOCAL OVERRIDE CHECK ---
    sTargetList = GetLocalString(OBJECT_SELF, "COMMONER_HEADS");

    if (GetStringLength(sTargetList) == 0)
    {
        if (nGender == GENDER_FEMALE)
        {
            switch(nRace)
            {
                case RACIAL_TYPE_DWARF:    sTargetList = F_DWARF;    break;
                case RACIAL_TYPE_ELF:      sTargetList = F_ELF;      break;
                case RACIAL_TYPE_HALFELF:  sTargetList = F_HALFELF;  break;
                case RACIAL_TYPE_GNOME:    sTargetList = F_GNOME;    break;
                case RACIAL_TYPE_HALFLING: sTargetList = F_HALFLING; break;
                case RACIAL_TYPE_HALFORC:  sTargetList = F_HALFORC;  break;
                default:                   sTargetList = F_HUMAN;    break;
            }
        }
        else
        {
            switch(nRace)
            {
                case RACIAL_TYPE_DWARF:    sTargetList = M_DWARF;    break;
                case RACIAL_TYPE_ELF:      sTargetList = M_ELF;      break;
                case RACIAL_TYPE_HALFELF:  sTargetList = M_HALFELF;  break;
                case RACIAL_TYPE_GNOME:    sTargetList = M_GNOME;    break;
                case RACIAL_TYPE_HALFLING: sTargetList = M_HALFLING; break;
                case RACIAL_TYPE_HALFORC:  sTargetList = M_HALFORC;  break;
                default:                   sTargetList = M_HUMAN;    break;
            }
        }
    }

    // --- PART 3: DYNAMIC RANDOM HEAD SELECTION ---
    int nMaxHeads = GetListCount(sTargetList);
    if (nMaxHeads > 0)
    {
        int nHeadRoll = Random(nMaxHeads) + 1;
        nHeadID = StringToInt(GetStringFromList(sTargetList, nHeadRoll));
        SetCreatureBodyPart(CREATURE_PART_HEAD, nHeadID, OBJECT_SELF);
    }

    // --- PART 4: COLOR CHANNELS, LIST POOLS, & INDIVIDUAL OVERRIDES ---
    int bNoColors = GetLocalInt(OBJECT_SELF, "COMMONER_NO_COLORS");

    if (!bNoColors)
    {
        string sSkinList    = GetLocalString(OBJECT_SELF, "COMMONER_SKIN");
        string sHairList    = GetLocalString(OBJECT_SELF, "COMMONER_HAIR");
        string sTattoo1List = GetLocalString(OBJECT_SELF, "COMMONER_TATTOO1");
        string sTattoo2List = GetLocalString(OBJECT_SELF, "COMMONER_TATTOO2");

        if (GetStringLength(sSkinList) == 0)    { sSkinList = POOL_SKIN; }
        if (GetStringLength(sHairList) == 0)    { sHairList = POOL_HAIR; }
        if (GetStringLength(sTattoo1List) == 0) { sTattoo1List = POOL_TATTOO1; }
        if (GetStringLength(sTattoo2List) == 0) { sTattoo2List = POOL_TATTOO2; }

        int nSkinVal = 0;
        int nSkinCount = GetListCount(sSkinList);
        if (nSkinCount > 0) { nSkinVal = StringToInt(GetStringFromList(sSkinList, Random(nSkinCount) + 1)); }

        int nHairVal = 0;
        int nHairCount = GetListCount(sHairList);
        if (nHairCount > 0) { nHairVal = StringToInt(GetStringFromList(sHairList, Random(nHairCount) + 1)); }

        int nTattoo1Val = 0;
        int nTat1Count = GetListCount(sTattoo1List);
        if (nTat1Count > 0) { nTattoo1Val = StringToInt(GetStringFromList(sTattoo1List, Random(nTat1Count) + 1)); }

        int nTattoo2Val = 0;
        int nTat2Count = GetListCount(sTattoo2List);
        if (nTat2Count > 0) { nTattoo2Val = StringToInt(GetStringFromList(sTattoo2List, Random(nTat2Count) + 1)); }

        SetColor(OBJECT_SELF, COLOR_CHANNEL_SKIN, nSkinVal);
        SetColor(OBJECT_SELF, COLOR_CHANNEL_HAIR, nHairVal);
        SetColor(OBJECT_SELF, COLOR_CHANNEL_TATTOO_1, nTattoo1Val);
        SetColor(OBJECT_SELF, COLOR_CHANNEL_TATTOO_2, nTattoo2Val);
    }

    // --- PART 5: NAME SELECTION & GENERATION ---
    int bNoRandomName = GetLocalInt(OBJECT_SELF, "COMMONER_NO_NAME");

    if (!bNoRandomName)
    {
        int nFirstType = (nGender == GENDER_FEMALE) ? 10 : 11;
        int nLastType = 0;

        if (nRace == RACIAL_TYPE_DWARF)
        {
            nLastType = 2;
            if (nGender == GENDER_FEMALE) { nFirstType = 14; }
            else { nFirstType = 15; }
        }
        else if (nRace == RACIAL_TYPE_ELF)
        {
            nLastType = 1;
            if (nGender == GENDER_FEMALE) { nFirstType = 12; }
            else { nFirstType = 13; }
        }
        else if (nRace == RACIAL_TYPE_HALFELF)
        {
            nLastType = 3;
            if (nGender == GENDER_FEMALE) { nFirstType = 16; }
            else { nFirstType = 17; }
        }
        else if (nRace == RACIAL_TYPE_GNOME)
        {
            nLastType = 4;
            if (nGender == GENDER_FEMALE) { nFirstType = 18; }
            else { nFirstType = 19; }
        }
        else if (nRace == RACIAL_TYPE_HALFLING)
        {
            nLastType = 5;
            if (nGender == GENDER_FEMALE) { nFirstType = 20; }
            else { nFirstType = 21; }
        }
        else if (nRace == RACIAL_TYPE_HALFORC)
        {
            nLastType = 6;
            if (nGender == GENDER_FEMALE) { nFirstType = 22; }
            else { nFirstType = 23; }
        }

        string sFirst = RandomName(nFirstType);
        string sLast = RandomName(nLastType);

        string sPrefix = GetLocalString(OBJECT_SELF, "COMMONER_PREFIX");
        string sSuffix = GetLocalString(OBJECT_SELF, "COMMONER_SUFFIX");

        if (GetStringLength(sPrefix) > 0) { sPrefix = sPrefix + " "; }
   	if (GetStringLength(sSuffix) > 0) { sSuffix = " " + sSuffix; }

    	string sFinalName = sPrefix + sFirst + " " + sLast + sSuffix;
    	SetName(OBJECT_SELF, sFinalName);
    }

    // --- PART 6: CLOTHING LOCAL OVERRIDE CHECK & SELECTION ---
    string sClothList = GetLocalString(OBJECT_SELF, "COMMONER_CLOTHES");

    if (GetStringLength(sClothList) == 0)
    {
        sClothList = (nGender == GENDER_FEMALE) ? CLOTHES_FEMALE : CLOTHES_MALE;
    }

    int nMaxClothes = GetListCount(sClothList);
    if (nMaxClothes > 0)
    {
        int nClothRoll = Random(nMaxClothes) + 1;
        string sTargetResRef = GetStringFromList(sClothList, nClothRoll);

        object oOutfit = CreateItemOnObject(sTargetResRef, OBJECT_SELF);
        if (GetIsObjectValid(oOutfit))
        {
            ActionEquipItem(oOutfit, INVENTORY_SLOT_CHEST);
        }
    }

    // --- PART 7: PROP LOCAL OVERRIDE CHECK & SELECTION ---
    string sPropList = GetLocalString(OBJECT_SELF, "COMMONER_PROPS");

    if (GetStringLength(sPropList) == 0)
    {
        sPropList = DEFAULT_PROPS;
    }

    int nMaxProps = GetListCount(sPropList);
    if (nMaxProps > 0)
    {
        int nPropRoll = Random(nMaxProps) + 1;
        string sPropResRef = GetStringFromList(sPropList, nPropRoll);

        if (sPropResRef != "none" && sPropResRef != "NONE")
        {
            object oProp = CreateItemOnObject(sPropResRef, OBJECT_SELF);
            if (GetIsObjectValid(oProp))
            {
                ActionEquipItem(oProp, INVENTORY_SLOT_RIGHTHAND);
            }
        }
    }

    // --- PART 8: SHIELD LOCAL OVERRIDE CHECK & SELECTION ---
    string sShieldList = GetLocalString(OBJECT_SELF, "COMMONER_SHIELDS");

    if (GetStringLength(sShieldList) == 0)
    {
        sShieldList = DEFAULT_SHIELDS;
    }

    int nMaxShields = GetListCount(sShieldList);
    if (nMaxShields > 0)
    {

        int nShieldRoll = Random(nMaxShields) + 1;
        string sShieldResRef = GetStringFromList(sShieldList, nShieldRoll);

        if (sShieldResRef != "none" && sShieldResRef != "NONE")
        {
            object oShield = CreateItemOnObject(sShieldResRef, OBJECT_SELF);
            if (GetIsObjectValid(oShield))
            {
                ActionEquipItem(oShield, INVENTORY_SLOT_LEFTHAND);
            }
        }
    }

    // --- PART 9: DEFAULT AI INITIALIZATION ---
    SetListeningPatterns();
    WalkWayPoints();
}




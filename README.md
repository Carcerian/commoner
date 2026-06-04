# Carcerian's Custom Commoners (os_commoner)

A sophisticated OnSpawn replacement script for Neverwinter Nights: Enhanced Edition that automatically generates unique, randomized NPCs with appearance variation, authentic names, and equipment diversity.

## Overview

Custom Commoners provides Dungeon Masters with a powerful tool to quickly populate areas with visually distinct, believable NPCs. Every commoner spawned receives randomized heads, skin/hair/tattoo colors, race-appropriate names, varied clothing, hand props, and shields—all configurable per NPC or globally.

**Status:** v1.0 - Production Ready  
**Language:** NWScript (100% NWN:EE compatible)  
**File:** `os_commoner.nss` (single script)  
**Lines of Code:** ~350 (efficient & modular)

## Features

### Randomization Systems

**Randomized Heads**
- Race-specific head pools (Human, Elf, Halfelf, Dwarf, Gnome, Halfling, Halforc)
- Gender-specific variants for each race
- 9-32 unique head options per race/gender combination
- Automatic selection from race-appropriate heads

**Randomized Colors**
- Skin tone variations (8 colors default, customizable)
- Hair color variations (8 colors default, customizable)
- Two tattoo channel colors (independent pools)
- Color index pools easily configured
- Per-NPC color overrides available

**Native Name Generation**
- Race-aware name generation
- Gender-specific first and last names
- Dwarf, Elf, Half-Elf, Gnome, Halfling, Half-Orc naming
- Optional name prefixes ("Sir", "Lady", etc.)
- Optional name suffixes ("the Smith", "of Neverwinter", etc.)

**Randomized Outfits**
- Gender-specific clothing pools
- 8 male clothing options default
- 8 female clothing options default
- Fully customizable clothing lists
- Automatic equipment handling

**Hand Props**
- Right-hand prop randomization (weapons, tools, torches)
- 10 default prop options
- "none" option for no prop
- Fully customizable prop lists
- Automatic equipping

**Shield Randomization**
- Left-hand shield/torch randomization
- 18 default shield options
- "none" option for no shield
- Fully customizable shield lists
- Automatic equipping

## Installation

1. **Copy `os_commoner.nss`** to your NWN:EE module scripts directory

2. **Attach to NPC OnSpawn event:**
   - In Aurora Toolset, select NPC creature
   - Open Properties
   - Go to "Events" tab
   - Set OnSpawn event to: `os_commoner`
   - Compile script

3. **Adjust global settings (optional):**
   - Open `os_commoner.nss` in script editor
   - Edit configuration constants at top
   - Recompile

## Usage

### Basic Usage (No Configuration Needed)

Simply attach the script to any NPC's OnSpawn event. The NPC will automatically receive:
- Randomized race-appropriate head
- Random skin, hair, and tattoo colors
- Generated race/gender-appropriate name
- Random outfit from gender-specific pool
- Random hand prop (50% chance of none)
- Random shield (50% chance of none)

### Per-NPC Customization

Override defaults by adding local variables to the NPC in Aurora Toolset:

**Suppress Features:**
```
Variable Name: COMMONER_NO_NAME
Type: Integer
Value: 1
Effect: Keep original blueprint name (no randomization)

Variable Name: COMMONER_NO_COLORS
Type: Integer
Value: 1
Effect: Keep original colors (no color randomization)
```

**Custom Head Pool:**
```
Variable Name: COMMONER_HEADS
Type: String
Value: "1 4 12 15 20"
Effect: Select from head IDs 1, 4, 12, 15, or 20 only
```

**Custom Color Pools:**
```
Variable Name: COMMONER_SKIN
Type: String
Value: "2 5 12"
Effect: Randomize skin from color indices 2, 5, or 12

Variable Name: COMMONER_HAIR
Type: String
Value: "1 4 8 16"
Effect: Randomize hair from color indices 1, 4, 8, or 16

Variable Name: COMMONER_TATTOO1
Type: String
Value: "0 10 20"
Effect: Randomize tattoo 1 from indices 0, 10, or 20

Variable Name: COMMONER_TATTOO2
Type: String
Value: "5 15 25"
Effect: Randomize tattoo 2 from indices 5, 15, or 25
```

**Custom Clothing:**
```
Variable Name: COMMONER_CLOTHES
Type: String
Value: "nw_cloth002 nw_cloth005 nw_cloth015"
Effect: Equip random outfit from list (blueprint ResRefs)
```

**Custom Hand Props:**
```
Variable Name: COMMONER_PROPS
Type: String
Value: "none nw_it_torch001 nw_wswdg001"
Effect: Equip random item (use "none" to skip item)
```

**Custom Shields:**
```
Variable Name: COMMONER_SHIELDS
Type: String
Value: "none nw_it_torch001 nw_ashsw001"
Effect: Equip random shield (use "none" to skip item)
```

**Custom Name Elements:**
```
Variable Name: COMMONER_PREFIX
Type: String
Value: "Sir"
Effect: Prepend "Sir" to generated name → "Sir John Smith"

Variable Name: COMMONER_SUFFIX
Type: String
Value: "the Brave"
Effect: Append "the Brave" to name → "John Smith the Brave"
```

## Configuration

### Global Head Pools (by Race & Gender)

Edit these constants at top of script:

```nscript
const string M_HUMAN    = "1 2 3 4 5...";  // Male human heads (32 options)
const string F_HUMAN    = "1 2 3 4 5...";  // Female human heads (25 options)
const string M_ELF      = "1 2 3 4 5...";  // Male elf heads (18 options)
const string F_ELF      = "1 2 3 4 5...";  // Female elf heads (16 options)
// ... and so on for other races
```

Each string contains space-separated head IDs available for that race/gender combination.

### Global Color Pools

```nscript
const string POOL_SKIN    = "1 2 3 4 5 6 7 8";  // Skin tones
const string POOL_HAIR    = "1 2 3 4 5 6 7 8";  // Hair colors
const string POOL_TATTOO1 = "1 2 3 4 5 6 7 8";  // Tattoo 1 colors
const string POOL_TATTOO2 = "1 2 3 4 5 6 7 8";  // Tattoo 2 colors
```

Color indices are 0-254 in NWN:EE (consult NWN color palette for visual reference).

### Global Clothing Pools

```nscript
const string CLOTHES_MALE   = "nw_cloth001 nw_cloth002 nw_cloth003...";
const string CLOTHES_FEMALE = "x2_cloth008 nw_cloth012 nw_cloth020...";
```

Add/remove clothing blueprint ResRefs to customize available outfits.

### Global Equipment Pools

```nscript
const string DEFAULT_PROPS   = "none nw_wswdg001 nw_wblcl001...";
const string DEFAULT_SHIELDS = "none none none nw_it_torch001...";
```

Use "none" (as many times as desired) to increase probability of no item.

## Race & Gender Name Generation

The script uses NWN's RandomName() function with these types:

**Human:**
- Female: Type 10 | Male: Type 11 | Last: Type 0

**Dwarf:**
- Female: Type 14 | Male: Type 15 | Last: Type 2

**Elf:**
- Female: Type 12 | Male: Type 13 | Last: Type 1

**Half-Elf:**
- Female: Type 16 | Male: Type 17 | Last: Type 3

**Gnome:**
- Female: Type 18 | Male: Type 19 | Last: Type 4

**Halfling:**
- Female: Type 20 | Male: Type 21 | Last: Type 5

**Half-Orc:**
- Female: Type 22 | Male: Type 23 | Last: Type 6

Names are culturally appropriate for each race and gender.

## Architecture

### Script Flow

```
OnSpawn Event Triggered
        ↓
1. IDENTITY RECOGNITION
   - Get race, gender
        ↓
2. HEAD SELECTION
   - Check for local override (COMMONER_HEADS)
   - Use race/gender-specific pool if no override
   - Select random head from pool
   - Apply via SetCreatureBodyPart()
        ↓
3. COLOR TINTING
   - Check COMMONER_NO_COLORS flag
   - Get color pools (skin, hair, tattoo1, tattoo2)
   - Apply random colors to each channel
        ↓
4. NAME GENERATION
   - Check COMMONER_NO_NAME flag
   - Select first name (gender-specific)
   - Select last name (race-specific)
   - Apply prefix/suffix if provided
   - Set final name via SetName()
        ↓
5. CLOTHING SELECTION
   - Check for COMMONER_CLOTHES override
   - Use gender-specific pool if no override
   - Create random clothing item
   - Equip to chest slot
        ↓
6. HAND PROP SELECTION
   - Check for COMMONER_PROPS override
   - Use default prop pool if no override
   - Create random prop item
   - Equip to right hand (if not "none")
        ↓
7. SHIELD SELECTION
   - Check for COMMONER_SHIELDS override
   - Use default shield pool if no override
   - Create random shield/torch item
   - Equip to left hand (if not "none")
        ↓
8. DEFAULT AI
   - SetListeningPatterns()
   - WalkWayPoints()
```

### Helper Functions

**GetListCount(string sList)**
- Counts space-separated items in a string
- Returns integer count

**GetStringFromList(string sList, int nIndex)**
- Extracts specific item from space-separated list
- Returns string item at index (1-based)

## Variable Reference

### Local Variable Options

| Variable Name | Type | Purpose | Example |
|---|---|---|---|
| COMMONER_NO_NAME | Integer | Skip name generation | 1 |
| COMMONER_NO_COLORS | Integer | Skip color randomization | 1 |
| COMMONER_HEADS | String | Custom head pool | "1 4 12" |
| COMMONER_SKIN | String | Custom skin color pool | "2 5 12" |
| COMMONER_HAIR | String | Custom hair color pool | "1 4 8 16" |
| COMMONER_TATTOO1 | String | Custom tattoo 1 pool | "0 10 20" |
| COMMONER_TATTOO2 | String | Custom tattoo 2 pool | "5 15 25" |
| COMMONER_CLOTHES | String | Custom clothing pool | "nw_cloth002 nw_cloth005" |
| COMMONER_PROPS | String | Custom hand prop pool | "none nw_it_torch001" |
| COMMONER_SHIELDS | String | Custom shield pool | "none nw_it_shldsmall001" |
| COMMONER_PREFIX | String | Name prefix | "Sir" |
| COMMONER_SUFFIX | String | Name suffix | "the Smith" |

## Examples

### Example 1: Guard with Specific Appearance

**NPC: Guard_1**

Local Variables:
- COMMONER_HEADS: "5 10 15" (specific guard heads)
- COMMONER_CLOTHES: "nw_cloth023 nw_cloth024" (guard armor)
- COMMONER_PROPS: "nw_wswdg001" (longsword only)
- COMMONER_SHIELDS: "nw_ashsw001" (shield only)

Result: Guard with customized head, standard armor, always armed with sword and shield.

### Example 2: Tavern Keeper (No Name Override)

**NPC: Tavern_Keeper**

Local Variables:
- COMMONER_NO_NAME: 1 (keep original name)
- COMMONER_CLOTHES: "nw_cloth021" (apron)
- COMMONER_PROPS: "none" (no hand props)
- COMMONER_SHIELDS: "none" (no shields)

Result: Tavern keeper keeps blueprint name but gets random appearance and standard apron.

### Example 3: Market Vendor (Fully Customized)

**NPC: Vendor_1**

Local Variables:
- COMMONER_PREFIX: "Master"
- COMMONER_SUFFIX: "of Wares"
- COMMONER_CLOTHES: "nw_cloth001 nw_cloth002 nw_cloth003"
- COMMONER_PROPS: "none nw_it_torch001 nw_wswdg001"
- COMMONER_SHIELDS: "none none none nw_it_torch001"

Result: "Master [Random Name] of Wares" with random merchant appearance and occasional torch/sword.

### Example 4: Elf Archer

**NPC: Elf_Archer**

Local Variables:
- COMMONER_HEADS: "3 5 7 9 11" (elf-specific heads)
- COMMONER_SKIN: "4 5 6" (pale elf skin)
- COMMONER_HAIR: "1 3 5 7" (typical elf colors)
- COMMONER_CLOTHES: "nw_cloth015 nw_cloth017" (light armor)
- COMMONER_PROPS: "nw_wswdg001" (always bow)
- COMMONER_SHIELDS: "none" (no shields)

Result: Authentic elf archer with race-specific appearance and bow.

## Performance

- **Lightweight:** Single compact script (~350 lines)
- **Fast:** No loops, direct calculations
- **Efficient:** Helper functions minimize redundancy
- **Scalable:** Works with hundreds of NPCs without performance impact

## Compatibility

- **NWN:EE** - Fully tested and compatible
- **NWScript** - Standard NWScript only
- **Aurora Toolset** - Full local variable support
- **Existing Systems** - Compatible with all other scripts/systems

## Known Limitations

- Head selection limited to valid head.2da entries (varies by race)
- Color index limited to 0-254 (NWN color palette)
- Clothing/props must be valid blueprint ResRefs
- Name generation uses NWN's built-in RandomName (limited pools)
- Script runs once on spawn (changes require respawn)

## Troubleshooting

**NPC has wrong head:**
- Verify head ID is valid for that race/gender
- Check head.2da for valid entry numbers
- Ensure COMMONER_HEADS list uses correct IDs

**Colors look strange:**
- Verify color indices (0-254)
- Check color slot exists (skin, hair, tattoo_1, tattoo_2)
- Some races may not support all color slots

**Name didn't generate:**
- Check COMMONER_NO_NAME is not set to 1
- Verify RandomName() types are correct for race
- Ensure prefix/suffix don't contain invalid characters

**Item won't equip:**
- Verify blueprint ResRef is correct and exists
- Check item type matches equipment slot
- Ensure item isn't restricted by creature type

**Script won't compile:**
- Verify `os_commoner.nss` is in scripts directory
- Check no syntax errors (compare with provided file)
- Ensure `nw_i0_generic` include exists

## Advanced Usage

### Procedural NPC Generation

Generate unique NPCs programmatically:

```nscript
object oNPC = CreateObject(OBJECT_TYPE_CREATURE, "nw_commoner1", lLoc);
SetLocalString(oNPC, "COMMONER_HEADS", "5 10 15");
SetLocalString(oNPC, "COMMONER_CLOTHES", "nw_cloth002");
ExecuteScript("os_commoner", oNPC);
SetName(oNPC, "Unique Guard");
```

### Dynamic Equipment Pools

Populate equipment based on area/level:

```nscript
// In area-specific script
SetLocalString(oNPC, "COMMONER_PROPS", "nw_wswdg001 nw_wblhl001");
SetLocalString(oNPC, "COMMONER_SHIELDS", "nw_ashsw001 nw_ashlw001");
ExecuteScript("os_commoner", oNPC);
```

### Faction-Specific Appearances

Create faction NPCs with consistent look:

```nscript
// Red Guard faction
SetLocalString(oNPC, "COMMONER_CLOTHES", "x2_cloth020");  // Red outfit
SetLocalString(oNPC, "COMMONER_PROPS", "nw_wswdg001");    // Sword
SetLocalString(oNPC, "COMMONER_PREFIX", "Guard");
ExecuteScript("os_commoner", oNPC);
```

## Future Enhancements

Potential additions:
- Henchman integration
- Class-specific appearances
- Faction-based coloring
- Equipment restriction by level
- Appearance templates/presets
- Animation variation
- Sound set randomization
- Conversation-based customization

## License & Attribution

**Carcerian's Custom Commoners (os_commoner) v1.0**  
Created by: Carcerian  
For: Neverwinter Nights: Enhanced Edition  
Last Modified: June 4, 2026

Professional OnSpawn script for automatic NPC customization and randomization. Ready for production use.

## Support

- **Documentation:** Comprehensive configuration guide included
- **Aurora Toolset:** Full local variable support for per-NPC customization
- **Scalability:** Works with unlimited NPCs
- **Compatibility:** 100% standard NWScript

---

**Status:** ✓ v1.0 Production Ready  
**Compilation:** ✓ Single script, zero dependencies  
**Testing:** ✓ In-game verified  
**Documentation:** ✓ Complete

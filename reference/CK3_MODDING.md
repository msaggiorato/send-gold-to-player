# CK3 Modding Cheat Sheet

Quick-reference for CK3 modding. Sourced from `reference/script_docs/` and `reference/vanilla/`.

---

## 1. Character Interactions

**File**: `common/character_interactions/<name>.txt`

### Interaction Properties

| Property | Type | Description |
|---|---|---|
| `category` | key | UI category: `interaction_category_friendly`, `_hostile`, `_vassalage`, `_diplomacy`, `_religion` |
| `icon` | string | Icon key, e.g. `icon_gold`, `icon_diplomacy` |
| `desc` | loc key | Description shown in interaction window |
| `common_interaction` | bool | Show in common interactions list |
| `interface_priority` | int | Sort order (higher = higher in list) |
| `greeting` | key | `positive`, `negative`, `neutral` |
| `notification_text` | loc key | Text shown in notification to recipient |
| `answer_accept_key` | loc key | Accept button text |
| `answer_reject_key` | loc key | Reject button text |
| `is_shown` | trigger | When interaction appears in list |
| `is_highlighted` | trigger | When interaction is highlighted |
| `highlighted_reason` | loc key | Tooltip for highlight |
| `is_valid_showing_failures_only` | trigger | Validity check (failures shown as red text) |
| `on_accept` | effect | Executed when accepted |
| `on_decline` | effect | Executed when declined |
| `on_auto_accept` | effect | Executed when auto-accepted |
| `auto_accept` | trigger/bool | When interaction skips accept/decline (`yes` = always) |
| `ai_accept` | value | AI willingness to accept (base + modifiers, >= 0 = accept) |
| `ai_potential` | trigger | Can AI initiate this? |
| `ai_will_do` | value | AI desire to initiate (base + modifiers) |
| `ai_frequency` | int | Days between AI checks |
| `ai_targets` | block | Target selection for AI |
| `ai_target_quick_trigger` | trigger | Fast pre-filter for AI targets |
| `ai_min_reply_days` | int | Min days for AI to respond |
| `ai_max_reply_days` | int | Max days for AI to respond |
| `send_option` | block | Adds a checkbox/radio option (see below) |
| `send_options_exclusive` | bool | Only one send_option can be selected |

### send_option

```
send_option = {
    flag = my_flag            # creates scope:my_flag (yes/no)
    localization = loc_key    # display text
    is_default = yes          # pre-selected
    is_valid = { ... }        # when this option is available
}
```

### Vanilla Gift Interaction (Skeleton)

```
# reference/vanilla/common/character_interactions/00_gift.txt
gift_interaction = {
    icon = icon_gold
    category = interaction_category_friendly
    common_interaction = yes
    interface_priority = 65
    greeting = positive
    notification_text = SEND_GIFT_PROPOSAL
    answer_accept_key = SEND_GIFT_ACCEPT
    answer_reject_key = SEND_GIFT_REJECT

    ai_targets = { ai_recipients = scripted_relations }
    ai_targets = { ai_recipients = liege }
    ai_targets = { ai_recipients = vassals  max = 10 }
    ai_frequency = 60

    is_shown = { NOT = { scope:recipient = scope:actor } }

    is_valid_showing_failures_only = {
        scope:actor.gold >= gift_value
    }

    auto_accept = {
        custom_description = {
            text = auto_accept_interaction_ai
            object = scope:recipient
            scope:recipient = { is_ai = yes }
        }
    }

    on_accept = {
        scope:actor = {
            send_interface_message = {
                type = event_gold_neutral
                title = gift_interaction_notification
                right_icon = scope:recipient
                pay_short_term_gold = {
                    gold = gift_value
                    target = scope:recipient
                }
            }
        }
    }

    ai_accept = {
        base = 0
        modifier = { add = 100  desc = GOLD_REASON }
    }

    ai_potential = {
        is_available_at_peace_ai_adult = yes
        short_term_gold >= gift_interaction_cutoff
    }

    ai_will_do = {
        base = 100
        modifier = {  # No double-gifts
            factor = 0
            scope:recipient = {
                has_opinion_modifier = {
                    target = scope:actor
                    modifier = gift_opinion
                }
            }
        }
    }
}
```

---

## 2. Message System

### send_interface_message / popup / toast

Three variants with different display behavior:

| Effect | Display | Default type |
|---|---|---|
| `send_interface_message` | Message feed item | `send_interface_message` |
| `send_interface_toast` | Brief toast notification | `send_interface_toast` |
| `send_interface_popup` | Modal popup | `send_interface_popup` |

**Scope**: Must be called on the **character who receives** the notification.

```
scope:recipient = {
    send_interface_message = {
        type = event_gold_neutral       # message type from common/messages/
        title = my_title_loc            # optional, overrides type default
        desc = my_desc_loc              # optional, overrides type default
        tooltip = my_tooltip_loc        # optional, overrides type default
        left_icon = scope:actor         # optional: character, artifact, or title
        right_icon = scope:the_title    # optional: character, artifact, or title

        # Effects execute AND display in the message:
        add_gold = 50
        scope:someone = { add_gold = 5 }
    }
}
```

### Template Variables (in loc strings)

Per `effects.log`:

| Variable | Contains | Source |
|---|---|---|
| `$EFFECT$` | Text description of effects (past tense) | effects.log |
| `$DESC$` | Text from the `desc` field | effects.log |
| `$DESCRIPTION$` | Full composed description output (seen in tooltip context) | _messages.info (GUI-level, not in effects.log) |

### Message Type Definition (`common/messages/`)

```
# reference/vanilla/common/messages/00_messages.txt
event_gold_neutral = {
    icon = "money"                      # texture from gfx/interface/message_icons
    title = event_message_title         # loc key
    desc = event_message_effect         # loc key (which template to use)
    style = neutral                     # good | neutral | bad
    display = feed                      # feed (default) | toast | popup
    message_filter_type = event_outcome # player filter category
    combine_into_one = yes              # optional: merge with existing msg of same type
    flag = my_flag                      # optional: custom widget handling in GUI
}
```

**`desc` templates** control what shows in the message body:

| Template Key | Shows |
|---|---|
| `event_message_effect` | Only `$EFFECT$` |
| `event_message_text` | Only `$DESC$` |
| `event_message_text_and_effect` | `$DESC$` then `$EFFECT$` |
| `event_message_effect_and_text` | `$EFFECT$` then `$DESC$` |

### Commonly Used Message Types

| Type | Icon | Style | Use For |
|---|---|---|---|
| `event_generic_good` | generic_good_effect | good | Generic positive outcome (effect only) |
| `event_generic_neutral` | generic_neutral_effect | neutral | Generic neutral outcome (effect only) |
| `event_generic_bad` | generic_bad_effect | bad | Generic negative outcome (effect only) |
| `event_generic_good_text` | generic_good_effect | good | Generic positive (desc text only) |
| `event_generic_neutral_text` | generic_neutral_effect | neutral | Generic neutral (desc text only) |
| `event_generic_bad_text` | generic_bad_effect | bad | Generic negative (desc text only) |
| `event_generic_good_with_text` | generic_good_effect | good | Generic positive (desc + effect) |
| `event_generic_neutral_with_text` | generic_neutral_effect | neutral | Generic neutral (desc + effect) |
| `event_generic_bad_with_text` | generic_bad_effect | bad | Generic negative (desc + effect) |
| `event_gold_good` | money | good | Gold gained |
| `event_gold_neutral` | money | neutral | Gold transferred |
| `event_gold_bad` | money | bad | Gold lost |
| **Toast variants** | | | |
| `event_toast_effect_good` | generic_good_effect | good | Toast: effect only |
| `event_toast_effect_neutral` | generic_neutral_effect | neutral | Toast: effect only |
| `event_toast_effect_bad` | generic_bad_effect | bad | Toast: effect only |
| `event_toast_text_good` | generic_good_effect | good | Toast: desc text only |
| `event_toast_text_neutral` | generic_neutral_effect | neutral | Toast: desc text only |
| `event_toast_text_bad` | generic_bad_effect | bad | Toast: desc text only |
| `event_toast_text_and_effect_good` | generic_good_effect | good | Toast: desc + effect |
| `event_toast_text_and_effect_neutral` | generic_neutral_effect | neutral | Toast: desc + effect |
| `event_toast_text_and_effect_bad` | generic_bad_effect | bad | Toast: desc + effect |

### Desc Chaining (Multi-Line Descriptions)

```
send_interface_message = {
    type = my_message_type
    desc = {
        desc = "My Start Line"
        desc = linebreak
        desc = "My $EFFECT$"
    }
    title = "My Cooler Title"
    tooltip = "$DESCRIPTION$"       # $DESCRIPTION$ = the full desc output
    add_gold = 50
}
# Output:
#   Title: My Cooler Title
#   Description: My Start Line \n My Add 50 Gold
#   Tooltip: My Start Line \n My Add 50 Gold
```

**Files**: `reference/vanilla/common/messages/00_messages.txt`, `01_currency_messages.txt`

---

## 3. Gold & Economy

### Effects (Character Scope)

| Effect | Description |
|---|---|
| `add_gold = X` | Add/remove gold (can be negative). Creates gold from nowhere. |
| `remove_short_term_gold = X` | Remove gold (from AI "short term" budget first, then rest) |
| `remove_long_term_gold = X` | Remove gold (from AI "long term" budget first) |
| `remove_reserved_gold = X` | Remove gold (from AI "reserved" budget first) |
| `remove_war_chest_gold = X` | Remove gold (from AI "war chest" budget first) |
| `pay_short_term_gold = { target = X gold = Y }` | Transfer gold to target (from "short term" first) |
| `pay_long_term_gold = { target = X gold = Y }` | Transfer gold to target (from "long term" first) |
| `pay_reserved_gold = { target = X gold = Y }` | Transfer gold to target (from "reserved" first) |
| `pay_war_chest_gold = { target = X gold = Y }` | Transfer gold to target (from "war chest" first) |
| `pay_short_term_income = { target = X days/months/years = Y }` | Pay income-equivalent to target (from "short term") |
| `pay_long_term_income = { target = X days/months/years = Y }` | Pay income-equivalent to target (from "long term") |
| `pay_reserved_income = { target = X days/months/years = Y }` | Pay income-equivalent to target (from "reserved") |
| `pay_war_chest_income = { target = X days/months/years = Y }` | Pay income-equivalent to target (from "war chest") |
| `add_short_term_gold = X` | Add to "short term" AI budget (overflow to short term) |
| `add_long_term_gold = X` | Add to "long term" AI budget (overflow to short term) |
| `add_reserved_gold = X` | Add to "reserved" AI budget (overflow to short term) |
| `add_war_chest_gold = X` | Add to "war chest" AI budget (overflow to short term) |
| `set_reserved_gold_maximum = X` | Set max for "reserved" budget |
| `move_budget_gold = { gold = X from = Z to = Y }` | Move between budgets |

**Budget category keys**: `budget_war_chest`, `budget_reserved`, `budget_short_term`, `budget_long_term`

### Triggers (Character Scope)

| Trigger | Operators | Description |
|---|---|---|
| `gold` | `<, <=, =, !=, >, >=` | Total character gold |
| `short_term_gold` | `<, <=, =, !=, >, >=` | AI "short term" budget amount |
| `long_term_gold` | `<, <=, =, !=, >, >=` | AI "long term" budget amount |
| `reserved_gold` | `<, <=, =, !=, >, >=` | AI "reserved" budget amount |
| `war_chest_gold` | `<, <=, =, !=, >, >=` | AI "war chest" budget amount |
| `short_term_gold_maximum` | `<, <=, =, !=, >, >=` | Max for short term (may exceed if others full) |
| `long_term_gold_maximum` | `<, <=, =, !=, >, >=` | Max for long term |
| `reserved_gold_maximum` | `<, <=, =, !=, >, >=` | Max for reserved |
| `war_chest_gold_maximum` | `<, <=, =, !=, >, >=` | Max for war chest |

### Gold Transfer Pattern

```
# Simple: remove from sender, add to recipient
scope:actor = { remove_short_term_gold = 50 }
scope:recipient = { add_gold = 50 }

# Built-in: pay effect handles both sides
scope:actor = {
    pay_short_term_gold = {
        gold = 50
        target = scope:recipient
    }
}

# With notification (effects inside execute AND display):
scope:recipient = {
    send_interface_message = {
        type = event_gold_neutral
        title = my_title
        left_icon = scope:actor
        add_gold = 50   # this effect runs AND shows in the message
    }
}
scope:actor = { remove_short_term_gold = 50 }
```

---

## 4. Scopes & Targets

### Interaction Scopes

| Scope | Description |
|---|---|
| `scope:actor` | Character initiating the interaction |
| `scope:recipient` | Character receiving the interaction |
| `scope:secondary_actor` | Optional secondary initiator |
| `scope:secondary_recipient` | Optional secondary receiver |
| `scope:<send_option_flag>` | `yes`/`no` — whether a send_option was selected |

### Scope Types

| Type | Token | Variables? | Common Usage |
|---|---|---|---|
| `character` | `char` | yes | Characters |
| `landed_title` | `lt` | yes | Titles |
| `province` | `prov` | yes | Map provinces |
| `faith` | `faith` | yes | Religious faiths |
| `culture` | `culture` | yes | Cultures |
| `dynasty` | `dyn` | yes | Dynasties |
| `dynasty_house` | `dyn_house` | yes | Cadet branches |
| `war` | `war` | yes | Wars |
| `faction` | `fac` | yes | Factions |
| `army` | `army` | yes | Armies |
| `artifact` | `artifact` | yes | Artifacts |
| `scheme` | `scheme` | yes | Schemes |
| `activity` | `act` | yes | Activities |
| `story` | `story` | yes | Story cycles |
| `secret` | `sec` | yes | Secrets |
| `struggle` | `struggle` | yes | Struggles |
| `domicile` | `domicile` | yes | Domiciles |
| `legend` | `leg` | yes | Legends |
| `none` | `none` | no | No scope (global) |
| `value` | `value` | no | Numeric value |
| `boolean` | `boolean` | no | True/false |
| `flag` | `flag` | no | Named flag |

### Common Event Targets (Saved from Code)

Key targets available in various contexts (curated subset — see `event_targets.log` for 900+ targets):

| Target | Description |
|---|---|
| `actor`, `recipient` | Interaction participants |
| `target`, `owner` | Generic target/owner |
| `child`, `mother`, `father` | Family |
| `killer`, `victim` | Death |
| `liege`, `vassal` | Feudal |
| `attacker`, `defender` | War |
| `holder`, `claimant` | Titles |
| `gold_paid`, `gold_received` | Gold amounts (in some contexts) |
| `war`, `faction` | Current war/faction |

### Saved Scope Values

```
# Save a computed value
save_scope_value_as = {
    name = gold_amount
    value = {
        value = 100
        multiply = 2
    }
}
# Use it later
add_gold = scope:gold_amount

# Save a scope (character, title, etc.)
save_scope_as = my_target
# Use it later
scope:my_target = { add_gold = 50 }
```

### Scope Navigation

```
scope:actor.gold                    # actor's gold (value)
scope:actor.culture                 # actor's culture (scope)
scope:recipient.capital_province    # recipient's capital
scope:actor.liege                   # actor's liege (can chain)
scope:actor.top_liege               # highest liege

# Conditional exists check
scope:actor.liege ?= scope:recipient    # safe comparison (no error if no liege)
exists = scope:actor.liege              # check if exists before using
```

---

## 5. Triggers Quick Reference

### Player / AI Detection

```
is_ai = yes / no
```

### Gold Checks

```
gold >= 50                  # has at least 50 total gold
gold < 0                    # is in debt
short_term_gold >= 100      # AI budget check
scope:actor.gold >= gift_value   # using script value
```

### Interaction Validity

```
# is_shown — when interaction appears
is_shown = {
    NOT = { scope:recipient = scope:actor }   # can't target self
    scope:recipient = { is_ai = no }          # only target players
}

# is_valid_showing_failures_only — red text requirements
is_valid_showing_failures_only = {
    scope:actor = { gold >= 1 }
    scope:recipient = {
        # is_busy_in_events_localised = yes   # used in vanilla but NOT in triggers.log — may be undocumented/internal
        NOT = { is_imprisoned_by = scope:actor }
    }
}
```

### Auto-Accept Patterns

```
# Always auto-accept (no accept/decline UI)
auto_accept = yes

# Auto-accept only for AI recipients
auto_accept = {
    custom_description = {
        text = auto_accept_interaction_ai
        object = scope:recipient
        scope:recipient = { is_ai = yes }
    }
}
```

### AI Accept Score

```
ai_accept = {
    base = -25                        # start negative (lean decline)
    modifier = { add = 100  desc = GOLD_REASON }
    opinion_modifier = {              # scale with opinion
        who = scope:recipient
        opinion_target = scope:actor
        multiplier = 0.5              # 0.5x opinion as accept score
    }
}
# Result >= 0 means AI accepts
```

### AI Will Do (Should AI Initiate?)

```
ai_will_do = {
    base = 100
    modifier = { factor = 0  <condition> }   # factor=0 means never
    modifier = { add = 50   <condition> }    # boost priority
    modifier = { factor = 0.1 <condition> }  # reduce by 90%
}
# base = 0 means AI never initiates
```

---

## 6. Localization

### File Format

- **Encoding**: UTF-8 with BOM (byte order mark)
- **Path**: `localization/<language>/<name>_l_<language>.yml`
- **Languages**: `english`, `french`, `german`, `spanish`, `russian`, `korean`, `simp_chinese`
- **Header**: First line must be `l_english:` (or appropriate language)

### Syntax

```yaml
l_english:
 key:0 "Display text"
 key_with_var:0 "You received [gold_amount|0] gold."
```

- `:0` = version number (use 0 for mods)
- Space before key name is required
- Quotes around value are required

### Common Template Expressions

**IMPORTANT**: In localization strings, do NOT use the `scope:` prefix. Use `[actor.GetName]`, NOT `[scope:actor.GetName]`. The `scope:` prefix is only for script code (triggers/effects).

| Expression | Result |
|---|---|
| `[actor.GetName]` | Character name with tooltip |
| `[actor.GetNameNoTooltip]` | Name without tooltip |
| `[actor.GetFirstNameNoTooltip]` | First name without tooltip |
| `[actor.GetTitledFirstName]` | "King John" |
| `[actor.GetShortUIName]` | Short UI display name |
| `[actor.GetSheFhe]` | She/He (capitalized) |
| `[actor.GetHerHis]` | Her/His |
| `[actor.GetHerHim]` | Her/Him |
| `[gold_amount\|0]` | Number with 0 decimal places |
| `[gold_amount\|2]` | Number with 2 decimal places |
| `[gold_amount\|+=]` | Number with +/- prefix |
| `#bold Text#!` | Bold text |
| `#italic Text#!` | Italic text |
| `@gold_icon!` | Inline gold icon |
| `\n` | Line break |

### Custom Localization Functions

Defined in `common/customizable_localization/`. Invoked as `[character.GetCustomFunction]` in loc strings. The function evaluates triggers to pick the right text entry.

---

## 7. Common Patterns

### Gold Transfer with Notification

```
# Actor pays, recipient gets notification
scope:actor = { remove_short_term_gold = scope:gold_amount }
scope:recipient = {
    send_interface_message = {
        type = event_generic_neutral_text
        title = my_notification_title
        desc = my_notification_desc       # loc: "[actor.GetName] sent you gold"
        left_icon = scope:actor
        add_gold = scope:gold_amount      # effect runs AND shows in message
    }
}
```

### hidden_effect

Executes effects without showing them in tooltips:

```
on_accept = {
    # Player sees this in the interaction tooltip:
    scope:recipient = { add_gold = 50 }

    # Player does NOT see this:
    hidden_effect = {
        scope:actor = { set_variable = { name = gave_gift value = yes } }
    }
}
```

### Interaction with send_options (Radio Buttons)

```
my_interaction = {
    send_option = {
        flag = option_a
        localization = option_a_text
        is_default = yes
        is_valid = { <trigger> }
    }
    send_option = {
        flag = option_b
        localization = option_b_text
        is_valid = { <trigger> }
    }
    send_options_exclusive = yes    # radio buttons (not checkboxes)

    on_accept = {
        if = {
            limit = { scope:option_a = yes }
            # do A
        }
        else_if = {
            limit = { scope:option_b = yes }
            # do B
        }
    }
}
```

### Computed Gold Amount from Options

```
save_scope_value_as = {
    name = gold_amount
    value = {
        if = {
            limit = { scope:send_10 = yes }
            add = 10
        }
        else_if = {
            limit = { scope:send_50 = yes }
            add = 50
        }
    }
}
```

### Auto-Accept for AI, Manual for Players

```
auto_accept = {
    custom_description = {
        text = auto_accept_interaction_ai
        object = scope:recipient
        scope:recipient = { is_ai = yes }
    }
}
```

### Prevent AI From Using Interaction

```
ai_potential = { always = no }
# or
ai_will_do = { base = 0 }
```

### Opinion-Based AI Accept

```
ai_accept = {
    base = -25
    opinion_modifier = {
        who = scope:recipient
        opinion_target = scope:actor
        multiplier = 0.5
    }
}
```

---

## File Reference

| What | Path |
|---|---|
| Character interactions | `common/character_interactions/` |
| Message types | `common/messages/` |
| Localization | `localization/<lang>/` |
| Script values | `common/script_values/` |
| Scripted triggers | `common/scripted_triggers/` |
| Scripted effects | `common/scripted_effects/` |
| Events | `events/` |
| On actions | `common/on_action/` |
| Custom loc | `common/customizable_localization/` |
| Effects reference | `reference/script_docs/effects.log` |
| Triggers reference | `reference/script_docs/triggers.log` |
| Event targets | `reference/script_docs/event_targets.log` |
| Scope types | `reference/script_docs/event_scopes.log` |
| Vanilla gift interaction | `reference/vanilla/common/character_interactions/00_gift.txt` |
| Vanilla message types | `reference/vanilla/common/messages/00_messages.txt` |
| Vanilla currency messages | `reference/vanilla/common/messages/01_currency_messages.txt` |

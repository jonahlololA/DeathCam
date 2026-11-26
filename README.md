# DeathCam 1.8.1

Client-side Fabric mod for Minecraft 26.2. After you die, click **Freecam** on the death screen to fly around, then press `E` to return to the respawn screen.

## Controls
- `WASD` move, `Space` / `Shift` up / down, `Ctrl` faster, mouse to look, left click to swing your fist
- `F10` open/close the DeathCam settings (while in freecam)
- `F12` open/close the **Lost items** screen (in freecam or after respawning)
- `E` return to the death screen

## Lost items
Your inventory is recorded while you are alive. When you die the items still drop as normal, but a read-only list of what you were carrying is kept until your next death or until you leave the world. Open it with the **Lost items** button on the death screen, `F12`, or the F10 menu.

## Reanimate
F10 > **Reanimate** turns the camera into a ghost body that walks on the ground (client-side only: nobody else sees it and you cannot touch blocks or chests).
- Vanilla movement: walking, sprinting, jumping, step-up, swimming (Ctrl+W swims where you look), water exit hop.
- **Crouch** with `Shift` on land: lower pose and camera, 30% speed, no sprinting, and you do not walk off ledges (vanilla safe-walk). In water `Shift` dives instead.
- A red-outlined player body with your real skin is visible in third person (`F5`), with walking, swimming, crouching and punching animations.

## Second Chance
F10 > **Second Chance** (needs Reanimate) gives you a client-side extra life with 10 hearts. The server and other players are unaffected.
- **Damage:** fall damage (distance minus 3, none in water), arrows and other harmful projectiles, melee swings from mobs/players within reach, fire/lava, drowning, starvation. 10 tick grace period after each hit.
- **Hunger** follows vanilla's FoodData rules and is drawn by vanilla's own hunger bar: sprinting costs 0.1 exhaustion per metre, swimming 0.01, jumping 0.05 (0.2 sprinting), damage 0.1; exhaustion drains saturation first, then food; no sprinting at 6 food or less; fast regeneration at full food with saturation, 1 heart every 4 seconds at 18+ food, starvation at 0 (limited by difficulty); Peaceful keeps you fed and heals.
- **Bubbles** are drawn by the mod from its own air supply (300 air, -1 per tick with your eyes underwater, +4 per tick in air, 2 damage at -20, once a second).
- Turning off Reanimate ends Second Chance. When the hearts run out it ends too.

## F10 menu
Speed slider (0-5) and type box, Reanimate, Second Chance, smooth movement, freecam HUD, view lost items, and keybind buttons for the menu key and lost-items key (click, then press a key; Esc cancels). Settings save to `.minecraft/config/deathcam.properties`; keybinds are saved by Minecraft itself and also appear under Controls.

## Build
JDK 25. `gradle wrapper --gradle-version 9.5.1` once, then `./gradlew build` (Windows: `.\gradlew.bat build`). The jar is in `build/libs`.

Client-side only: it cannot make a server send chunks you have not received.

### 1.7.1
Hunger and bubbles now show: the hotbar-hiding hook was cancelling the whole vanilla HUD block that also draws the status bars, so it now hides only the hotbar. The ghost body is re-added to the world and forced visible every tick if anything removes it or marks it invisible; crouching now only sets the shift flag when it changes.

### 1.7.2
- Second Chance shows the vanilla hotbar again (Reanimate without Second Chance still hides it).
- The info panel has a "Body:" line while reanimated (in level / invisible / removed / camera / pose) for diagnosing the ghost body not showing.
- The ghost body is never frustum-culled, the camera is re-pointed at it if anything resets it, and it borrows the real player's skin directly.

### 1.8.0 - Second Chance gear
- The XP bar is shown during Second Chance, filled with the XP you had when you died.
- Second Chance gives your dead player and the ghost body a local copy of your lost inventory: the vanilla hotbar works (keys and scroll wheel), the held item appears in your hand, and the ghost holds it in third person. Your real (empty) inventory is put back when Second Chance ends.
- Tools are purely client-side: hold left click to mine the block you look at with vanilla break times for the item in hand (crack animation, break sound and particles), right click to place block items. Nothing is sent to the server, so other players never see it and blocks can reappear when the server resends that area. Items you place are used up from the local copy only; tools do not wear out. You still cannot hurt mobs or open containers.

### 1.8.1 - Bug fixes
- A corrupt `deathcam.properties` (bad escape sequence) no longer crashes the game on startup, and a `NaN`/`Infinity` speed is ignored instead of breaking the camera.
- Pressing the menu key outside freecam no longer makes the settings menu pop open the moment you enter freecam.
- Second Chance can no longer end twice in one tick (double "extra life ran out" message) when two damage sources land together.
- If the ghost body is re-created mid-session it now gets the local gear back instead of showing empty hands.
- Removed the `noCulling` flag, which no longer exists in 26.2 and stopped the mod compiling. The ghost body is now kept from being culled by a renderer hook instead.
- **Super Death is now Second Chance** (menu label, messages and docs).
- Second Chance now draws its own hunger bar, air bubbles and hotbar (your local gear, with selection and item counts) instead of relying on vanilla's HUD, which did not show them for the ghost body. Vanilla's hotbar and hunger bar stay hidden while reanimated.
- **Ghost body fix:** creating the body copied skin properties into an immutable map, which threw and left "Body: none". That is now guarded, and any remaining spawn failure shows its reason in the yellow "Body:" line and in the log.
- **Second Chance gear** no longer depends on the body existing, and the lost-items history now covers about a second (20 ticks) instead of 3.
- Hunger icons now match the reference art: full, half-empty and empty drumsticks.
- **Ghost skin:** the body now shows all outer skin layers (jacket, sleeves, pants, hat), which a client-only player had switched off, so skins look normal.
- **Swing cooldown is back in Second Chance:** punching waits for vanilla's attack cooldown (20 / attack speed ticks, 5 for a fist), with a small recharge bar under the crosshair. Mining and placing are unaffected.
- **Swing cooldown matches vanilla:** fist 5 ticks, sword 12, pickaxe 17, shovels/most axes 20-25, hoes by tier, trident 18, mace 33; switching items restarts it, as in vanilla.
- **Water and lava buckets** can be poured in Second Chance (local only; the source does not flow). Placed, mined and poured blocks are re-applied if the server redraws the spot, so they no longer vanish.
- The yellow "Body:" debug line is gone from the info panel (a body spawn failure still shows as an on-screen message).
- Air bubbles redrawn to match the reference (outlined blue bubbles with a highlight; burst slots shown as dark circles).
- Air now depletes while you are underwater: Second Chance tracks its own air supply instead of reading the ghost body's, which did not tick down.
- **Held items in first person** no longer slide off to the side as you turn: the dead player's hand-sway reference is kept equal to its look direction while the hands are drawn.
- General fixes: mining speed underwater uses the mod's own underwater state, and leaving freecam now clears all Second Chance leftovers (air, local block edits, tracked projectiles, held-item cooldown state).

### 1.8.2
The info panel speed now shows the real distance moved per tick, so it reads 0.00 when you stand still (before, a ghost read about 0.08 because gravity velocity was counted).

### 1.9.0 - items in Super Death
Super Death runs entirely on your client, and a client cannot create entities or run server-only logic, so not every item can work. What works: placing and mining blocks, pouring water/lava buckets, and eating food (hold right click for 32 ticks; refills Super Death hunger). What cannot: boats, minecarts, spawn eggs, projectiles (bows, snowballs, ender pearls...), armor stands, item frames, potions, milk, fish/mob buckets, bone meal, shears, brushes, hoe/axe/shovel right-click actions. Trying one shows a short message explaining why. A report of every item in the game (including modded ones) is written to `config/deathcam-items.txt` the first time you enter freecam. Errors in Super Death tool code are now caught and logged instead of being able to crash the game.

### 1.9.1 - animated hotbar selector
The Super Death hotbar's selection frame now animates, in the style of the "Animated Hotbar Selector" reference: it pulses in opacity (soft inner glow) and/or size (the outline breathes outward). Choose Off / Opacity / Size / Opacity + size in the F10 menu (default: both; saved as `hotbarAnimation`).

### 1.10.0
- **Ghost items**: boats, minecarts, spawn eggs, armor stands, item frames, paintings and end crystals can't exist on the client, so right clicking with one now places a visual-only ghost copy where you aim (a glowing, unpickable item drop; boats can be "placed" on the water surface). It uses up the local copy, lives only on your screen, and disappears when Second Chance ends.
- Hotbar and XP bar restyled after the new reference picture: stone-grey frame with bevelled slots, green segmented XP bar with the level number.
- Fixed the animated hotbar selector being offset from the selected slot (it was aligned to vanilla's frame instead of the mod's own hotbar).

### 1.10.1
Melee hits in Second Chance now use vanilla damage. The client never learns other entities' real attack damage (the attribute is not synced and equipment bonuses are applied only on the server), so every hit used to be the base value. Damage is now rebuilt from the attacker's base attack damage plus the attack-damage modifiers of the item in their hand (diamond sword 7, netherite axe 10, fist 1, ...), and damage from mobs (melee and their projectiles) scales with difficulty like vanilla (Easy about half, Hard 1.5x). Not included because the client cannot see them: enchantments, potion effects, critical hits and attack cooldown.

### 1.10.2
- Switching hotbar slots no longer restarts the attack cooldown, so the reload bar no longer pops up on every swap.
- The reload bar now looks like vanilla's attack indicator (16x4, under the crosshair, outlined track with a glossy white fill).
- Hardening: per-tick code and HUD drawing are wrapped so an unexpected error is logged once and freecam is left cleanly instead of crashing the game; mixins no longer require every injection point to exist, so a renamed method in a game update disables that feature instead of crashing at launch.

### 1.10.3
Restored `tickEnvironmentalDamage` (drowning and fire/lava damage), which the 1.10.1 melee-damage edit deleted by accident and which stopped 1.10.1 and 1.10.2 from compiling.

### 1.11.0 - real crouching
The ghost body now actually crouches: the pose is set directly, so in third person (F5) you see vanilla's crouch animation and the camera drops to the crouching eye height. The physics hitbox is vanilla's 1.5 blocks while crouched, so you can crouch through 1.5-high gaps, and if you let go of Shift under a low ceiling you stay crouched until there is room to stand.

### 1.11.1
The XP bar is vanilla's own again (bar, segments and level number); the custom green bar from 1.10.0 is removed.

### 1.12.0 - client-side ghosts for every item
- Right click places a ghost copy of the item where you aim, entirely on your client (nothing is sent to the server). Boats, rafts, minecarts, armor stands, end crystals and spawn eggs show as the real thing (a boat on the water, the mob from the egg); everything else, potions included, shows as an item drop. A white glow marks them as ghosts. Punch one to pick it back up. Blocks, water/lava buckets, food and tools keep their normal use, but Shift+right click places any item as a ghost.
- An empty bucket now scoops up water or lava sources, including ones you placed yourself.

### 1.12.1
When your second chance runs out you are taken back to the death screen, now titled "You died, again." (it goes back to "You died!" once you respawn). Previously you just stayed a ghost with a short message.

### 1.12.2
The swing animation now always plays when you swing, even while the attack cooldown is recharging (before, swords and tools only animated once the reload bar was full). A swing restarts the cooldown, like in vanilla.

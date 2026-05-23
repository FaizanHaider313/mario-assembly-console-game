# Mario Assembly Console Game 🍄

A console-based Mario-style game developed completely in x86 Assembly Language using MASM, Irvine32, winmm.lib, and Visual Studio.
This project was developed for the Computer Organization & Assembly Language (COAL) course at FAST-NUCES Islamabad.

================================================================================
GAME OVERVIEW
================================================================================

A classic Super Mario Bros. implementation in x86 Assembly Language featuring
2 complete worlds with multiple scenes, enemies, power-ups, boss battles, and
a comprehensive scoring system.

================================================================================
ROLL NUMBER CUSTOMIZATION (Last Digit: 3)
================================================================================

"Speed Racer Mario" Implementation:

[X] Mario moves 25% faster than normal (2 pixels per frame with turbo)
[X] "Turbo Star" power-up (blue star) doubles Mario's speed for 10 seconds
[X] Timer display changes to BLUE when speed boost is active
[X] Mario wears GREEN shirt (odd number customization)

================================================================================
FREE CREATIVE CUSTOMIZATION
================================================================================

Moving Platform System:

- Horizontal moving platform (slides left-right between boundaries)
- Vertical moving platform (moves up-down)
- Players must time jumps correctly to land on moving platforms
- Adds dynamic challenge to level design
- Smooth animation synchronized with game frame rate

================================================================================
CONTROLS
================================================================================

W / UP ARROW : Jump
A / LEFT ARROW : Move Left
D / RIGHT ARROW : Move Right
S / DOWN ARROW : Crouch
P / ESC : Pause Game
X : Exit Game

================================================================================
GAME FEATURES
================================================================================

## CORE GAMEPLAY:

[X] 4 Complete Levels (Level 1: Scene 1 & 2, Level 2: Scene 1 & 2)
[X] Multiple Enemy Types (Goombas, Koopa Troopas, Boss Enemy)
[X] Power-up System (Turbo Star for speed boost)
[X] Physics Engine (Gravity, jumping, platform collision detection)
[X] Scoring System (Coins, enemies, boss hits)

## VISUAL ELEMENTS:

[X] Dynamic HUD (Score, coins, world/level, lives, timer)
[X] Animated Sprites (Coin rotation, cloud backgrounds, enemies)
[X] Color-coded UI (Roll number-based green Mario sprite)
[X] Multiple Platforms (Static planes, pipes, moving platforms)
[X] Flagpole System (Level completion with position-based bonuses)

## ADVANCED FEATURES:

[X] Menu System (Start, Load, Instructions, High Scores, Exit)
[X] Pause Menu (Resume or Save & Quit options)
[X] File Handling (Save/load progress, high score tracking)
[X] Boss Battle (15-hit boss with movement AI in Level 2-2)
[X] Loading Screens (Level transitions with animations)
[X] Win/Loss Screens (Game Over, Time's Up, Victory screens)

## AUDIO:

[X] Background music (background.wav in Resources folder)
Note: Game uses Windows Multimedia API for audio playback

================================================================================
LEVEL DESIGN
================================================================================

## LEVEL 1-1: Grassland Adventure

- Open starting area for learning controls
- 3 Goombas with patrol AI
- 5 collectible coins
- Multiple pipes and platforms
- Moving platforms for advanced challenges

## LEVEL 1-2: Extended Challenge

- Repositioned obstacles
- 3 Goombas + 3 Koopa Troopas
- Flagpole completion system
- Position-based bonus scoring

## LEVEL 2-1: Intermediate World

- Mixed enemy layouts
- Strategic coin placement
- Increased difficulty curve

## LEVEL 2-2: Boss Battle

- Bowser boss fight (15 HP)
- Turbo Star power-up available
- Minimal platforms for intense combat
- Victory flagpole after boss defeat

================================================================================
SCORING SYSTEM
================================================================================

ACTION POINTS

---

Collect Coin 200
Defeat Goomba 100
Defeat Koopa Troopa 200
Hit Boss 500
Defeat Boss 5000
Collect Turbo Star 500

## FLAGPOLE BONUSES:

Top Position 5000
Middle Position 2000
Bottom Position 100
Time Bonus Remaining Time x 50

================================================================================
FILE SYSTEM
================================================================================

## SAVE FILES:

savegame.txt - Current progress (name, score, level, world, lives, time)
highscores.txt - Top 3 high scores with player names

## FILE FORMAT:

PlayerName|Score|World|Level|Lives|Time

================================================================================
VISUAL DESIGN
================================================================================

## COLOR SCHEME:

Background : Light Blue sky with white clouds
Ground : Green terrain
Mario : Green shirt (roll number customization)
HUD : Black text on light blue background
Speed Boost Active : Blue timer (instead of black)
Enemies : Gray Goombas, Magenta Koopas, Red Boss
Power-ups : Blue Turbo Star

## SCREEN RESOLUTION:

120 columns x 30 rows console display
Optimized for standard Windows console

================================================================================
TECHNICAL IMPLEMENTATION
================================================================================

## ASSEMBLY TECHNIQUES USED:

- Register-based operations (no high-level constructs)
- Pure jump-based control flow (no if/while/for)
- Procedural decomposition (80+ procedures)
- Memory-efficient variable storage
- Frame-based animation system

## KEY PROCEDURES:

ApplyGravity - Physics engine
UpdateGoombas/Koopas/Boss - Enemy AI
CheckCollision - Multi-type collision detection
DrawHUD - Dynamic interface rendering
SaveGameProgress/LoadProgress - File I/O
UpdateSpeedBoost - Turbo Star timer management

================================================================================
PROJECT STRUCTURE
================================================================================

24I-0803.zip
|
+-- 24I-0803_Mario.asm Main game source code
+-- README.txt This file
+-- Resources/
| +-- background.wav Background music
+-- Screenshots/
| +-- menu.png Main menu
| +-- gameplay.png In-game screenshot
| +-- level_completion.png level 1 compete screen
+-- GameDemo.mp4 Full gameplay video

================================================================================
HOW TO RUN
================================================================================

## REQUIREMENTS:

- MASM615 (Microsoft Macro Assembler)
- Irvine32 library
- Windows OS

## SETUP:

1. Place background.wav in folder
2. Ensure Irvine32.inc and macros.inc are in include path

## PLAY:

1. Run the executable
2. Enter your name
3. Use WASD or arrow keys to play

================================================================================
ACADEMIC INTEGRITY STATEMENT
================================================================================

This project was individually developed by Syed Faizan Haider (24I-0803) for
the COAL course. All code was written from scratch using pure x86 assembly
language without copying from external sources, AI, or other students.

================================================================================
KNOWN ISSUES
================================================================================

- Background music requires background.wav in Resources folder
- Console window must support extended ASCII characters (219, 220, 223, etc.)
- Game speed depends on CPU clock (tested on modern Windows systems)

================================================================================
NOTES
================================================================================

- Game saves progress automatically when using Pause > Save & Quit
- High scores persist across game sessions
- Timer counts down from 200 seconds per level
- Lives reset to 3 when starting new game
- Turbo Star effect lasts 50 frames (~10 seconds at 5 FPS)

================================================================================
SPECIAL FEATURES HIGHLIGHT
================================================================================

1. Smart Enemy AI : Enemies reverse direction at boundaries
2. Two-Hit Koopas : Shell mode after first hit
3. Boss Battle : 15-HP Bowser with intelligent movement
4. Moving Platforms : Horizontal and vertical synchronized motion
5. Speed Boost Visual : HUD color changes during power-up
6. Flagpole Bonus : Height-based scoring algorithm
7. Pause System : Non-destructive pause with save option

================================================================================

                            Enjoy the game!

================================================================================

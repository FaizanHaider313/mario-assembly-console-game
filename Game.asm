;Syed Faizan Haider 24I-0803 CS-A
include irvine32.inc
include macros.inc
INCLUDELIB winmm.lib  ;sound
.data;--------------------------------------------------------------------
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------


ground BYTE "------------------------------------------------------------------------------------------------------------------------",0
;--------------------------------SOUND----------------------------------------------
PlaySoundA PROTO, pszSound:PTR BYTE, hmod:DWORD, dwSound:DWORD
bgMusic BYTE "Resources/slimeyfox.wav", 0    ; path variable



;------------------------------ FILE HANDLING --------------------------------
highscoreFilename BYTE "highscores.txt", 0
saveFilename BYTE "savegame.txt", 0
filename BYTE "mario_save.txt", 0
fileHandle DWORD ?
buffer BYTE 256 DUP(0)
bytesWritten DWORD ?

; High Score Data Structure (for top 3 players)
highScore1Name BYTE 20 DUP(0)
highScore1Score DWORD 0
highScore1Level BYTE 0

highScore2Name BYTE 20 DUP(0)
highScore2Score DWORD 0
highScore2Level BYTE 0

highScore3Name BYTE 20 DUP(0)
highScore3Score DWORD 0
highScore3Level BYTE 0

; Progress save data
savedPlayerName BYTE 20 DUP(0)
savedScore DWORD 0
savedLevel BYTE 0
savedWorld BYTE 0

; File messages
fileSaveMsg BYTE "Game saved successfully!",0
fileLoadMsg BYTE "Progress loaded!",0
fileErrorMsg BYTE "File error occurred!",0

;------------------------------ PAUSE MENU ----------------------------------
isPaused BYTE 0           ; 0 = not paused, 1 = paused
pauseOption BYTE 1        ; 1 = Resume, 2 = Save & Quit

pauseTitle1 db "                              ====== PAUSED ======",0
pauseMenu1 db "                              1. RESUME GAME",0
pauseMenu2 db "                              2. SAVE & QUIT",0

;------------------------------ WIN SCREEN ----------------------------------
win1 db "                    __   ______  _    _  _    _ _____ _   _ ",0dh,0ah,0
win2 db "                    \ \ / / __ \| |  | || |  | |_   _| \ | |",0dh,0ah,0
win3 db "                     \ V / |  | | |  | || |  | | | | |  \| |",0dh,0ah,0
win4 db "                      \ /| |  | | |  | || |/\| | | | | . ` |",0dh,0ah,0
win5 db "                      | || |__| | |__| ||  /\  |_| |_| |\  |",0dh,0ah,0
win6 db "                      |_| \____/ \____//_/  \_/|_____|_| \_|",0dh,0ah,0

winMsg1 db "                        Congratulations, ",0
winMsg2 db "                      You have saved the Mushroom Kingdom!",0
winMsg3 db "                            Final Score: ",0

;------------------------------ LOADING SCREENS -------------------------
loading1 db "                              ======================",0
loading2 db "                                  LOADING LEVEL ",0
loading3 db "                              ======================",0
levelComplete1 db "                              ======================",0
levelComplete2 db "                                LEVEL COMPLETE!",0
levelComplete3 db "                                   Score: ",0
levelComplete4 db "                              ======================",0


;------------------------------ MENU DATA -------------------------------
menuOption BYTE 1          ; Current selected option (1-5)
playerName BYTE 20 DUP(0) ; Store player name
nameLength BYTE 0          ; Length of entered name

; Menu ASCII Art
menuTitle1 db "   ___  ___          _        ______                    ",0dh,0ah,0
menuTitle2 db "   |  \/  |         (_)       | ___ \                   ",0dh,0ah,0
menuTitle3 db "   | .  . | __ _ _ __ _  ___  | |_/ /_ _ ___  ___       ",0dh,0ah,0
menuTitle4 db "   | |\/| |/ _` | '__| |/ _ \ | ___ \ '_/ _ \/ __|      ",0dh,0ah,0
menuTitle5 db "   | |  | | (_| | |  | | (_) || |_/ / |  (_) \__ \      ",0dh,0ah,0
menuTitle6 db "   \_|  |_/\__,_|_|  |_|\___/ \____/|_| \___/|___/      ",0dh,0ah,0

; Roll Number ASCII Art
roll1 db "  ___  _  _   ___        ___   ___   ___   ____  ",0
roll2 db " |__ \| || | |_ _|      / _ \ / _ \ / _ \ /____\ ",0
roll3 db "    ) | || |_ | | ____ | | | | (_) | | | |  __) |",0
roll4 db "   / /|__   _|| ||____|| | | |> _ <| | | | |__ < ",0
roll5 db "  / /_   | | _| |_     | |_| | (_) | |_| | ___) |",0
roll6 db " |____|  |_||____|      \___/ \___/ \___/ \____/ ",0

menu1 db "                              1. START NEW GAME",0
menu2 db "                              2. LOAD GAME",0
menu3 db "                              3. HOW TO PLAY",0
menu4 db "                              4. HIGH SCORES",0
menu5 db "                              5. EXIT",0
menuPrompt db "                         Select option (1-5): ",0
namePrompt db "                         Enter your name: ",0
pressEnter db "                      Press ENTER to continue...",0

; Manual/Instructions
manual1 db "                           ===== HOW TO PLAY =====",0
manual2 db "  ",0
manual3 db "  CONTROLS:",0
manual4 db "    W or UP    - Jump",0
manual5 db "    A or LEFT  - Move Left",0
manual6 db "    D or RIGHT - Move Right",0
manual7 db "    S or DOWN  - Crouch",0
manual8 db "    X          - Exit Game",0
manual9 db "  ",0
manual10 db "  OBJECTIVE:",0
manual11 db "    - Collect coins to increase your score (200 points each)",0
manual12 db "    - Defeat enemies by jumping on them",0
manual13 db "    - Avoid touching enemies from the side",0
manual14 db "    - Complete levels before time runs out",0
manual15 db "  ",0
manual16 db "  ENEMIES:",0
manual17 db "    G - Goomba: Defeats in 1 hit (100 points)",0
manual18 db "    K - Koopa Troopa: Requires 2 hits (200 points)",0
manual19 db "  ",0
manual20 db "  TIPS:",0
manual21 db "    - Jump on platforms and pipes to reach high places",0
manual22 db "    - Watch your time! Don't let it reach zero",0
manual23 db "    - You have 3 lives. Use them wisely!",0

; EXIT
exit1 db "                                     ______      _ _   ",0dh,0ah,0
exit2 db "                                    |  ____|    (_) |  ",0dh,0ah,0
exit3 db "                                    | |__  __  ___| |_ ",0dh,0ah,0
exit4 db "                                    |  __| \ \/ / | __|",0dh,0ah,0
exit5 db "                                    | |____ >  <| | |_ ",0dh,0ah,0
exit6 db "                                    |______/_/\_\_|\__|",0dh,0ah,0

; HIGH SCORE
high1 db "                            _    _ _       _       _____                      ",0dh,0ah,0
high2 db "                           | |  | (_)     | |     / ____|                     ",0dh,0ah,0
high3 db "                           | |__| |_  __ _| |__  | (___   ___ ___  _ __ ___  ",0dh,0ah,0
high4 db "                           |  __  | |/ _` | '_ \  \___ \ / __/ _ \| '__/ _ \ ",0dh,0ah,0
high5 db "                           | |  | | | (_| | | | | ____) | (_| (_) | | |  __/ ",0dh,0ah,0
high6 db "                           |_|  |_|_|\__, |_| |_||_____/ \___\___/|_|  \___| ",0dh,0ah,0
high7 db "                                      __/ |                                   ",0dh,0ah,0
high8 db "                                     |___/                                    ",0dh,0ah,0

;------------------------------ LEVELS ----------------------------------
isLevel1 db 0
isLevel2 db 0
;------------------------------ SCENES ----------------------------------
isLevel1Scene1 db 0
isLevel1Scene2 db 0
isLevel2Scene1 db 0
isLevel2Scene2 db 0

;----------------------------- BACKGROUND --------------------------------
score DWORD 0              ; DWORD for 6 digits
coinsCollected BYTE 0      ; Track coins collected
lives BYTE 3               ; Starting lives
currentWorld BYTE 1        ; Current world (1-8)
currentLevel BYTE 1        ; Current level (1-4)
gameTime WORD 200          ; Starting time (counts down)

;---------------------------- TIMES UP --------------------------------------
; TIMES UP!
timesup1 db "         _______ _____ __  __ ______  _____   _    _ _____  _ ",0dh,0ah,0
timesup2 db "        |__   __|_   _|  \/  |  ____|/ ____| | |  | |  __ \| |",0dh,0ah,0
timesup3 db "           | |    | | | \  / | |__  | (___   | |  | | |__) | |",0dh,0ah,0
timesup4 db "           | |    | | | |\/| |  __|  \___ \  | |  | |  ___/| |",0dh,0ah,0
timesup5 db "           | |   _| |_| |  | | |____ ____) | | |__| | |    |_|",0dh,0ah,0
timesup6 db "           |_|  |_____|_|  |_|______|_____/   \____/|_|    (_)",0dh,0ah,0

;----------------------------- GAME OVER -------------------------------------------
; GAME OVER
gameover1 db "                   _____                         ____                 ",0dh,0ah,0
gameover2 db "                  / ____|                       / __ \                ",0dh,0ah,0
gameover3 db "                 | |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __ ",0dh,0ah,0
gameover4 db "                 | | |_ |/ _` | '_ ` _ \ / _ \ | |  | \ \ / / _ \ '__|",0dh,0ah,0
gameover5 db "                 | |__| | (_| | | | | | |  __/ | |__| |\ V /  __/ |   ",0dh,0ah,0
gameover6 db "                  \_____|\__,_|_| |_| |_|\___|  \____/  \_/ \___|_|   ",0dh,0ah,0


;CLOUDS
cloud1X BYTE 10
cloud1Y BYTE 10
cloud2X BYTE 40
cloud2Y BYTE 12
cloud3X BYTE 70
cloud3Y BYTE 10
cloud4X BYTE 100
cloud4Y BYTE 12
cloudShape BYTE "  ",220,220,220,220,"  ",0
cloudShape2 BYTE " ",219,219,219,219,219,219," ",0
cloudShape3 BYTE 219,219,219,219,219,219,219,219,0


;------------------------------ READ KEYS --------------------------------
inputChar BYTE ?

;------------------------------ PLAYER -----------------------------------
xPos BYTE 0
yPos BYTE 28
Player byte "M"
jmpDirection db 0
jmpHeight db 0
onGround BYTE 1           ; 1 = on ground/platform, 0 = in air
groundLevel BYTE 28       ; default ground Y position

;------------------------------ ENEMIES ----------------------------------
; Goomba 1
goomba1X BYTE 30
goomba1Y BYTE 28
goomba1Active BYTE 1      ; 1 = alive, 0 = defeated
goomba1Direction BYTE 1   ; 1 = moving right, 0 = moving left

; Goomba 2
goomba2X BYTE 60
goomba2Y BYTE 28
goomba2Active BYTE 1
goomba2Direction BYTE 0   ; starts moving left

; Goomba 3
goomba3X BYTE 90
goomba3Y BYTE 28
goomba3Active BYTE 1
goomba3Direction BYTE 1

goombaSpeed BYTE 1        ; pixels per frame
goombaFrameCounter BYTE 0   ; goomba moves every 3 frames

;------------------------------ KOOPA TROOPA ------------------------------------
; Koopa 1
koopa1X BYTE 45
koopa1Y BYTE 28
koopa1Active BYTE 1       ; 1 = alive, 0 = defeated
koopa1Direction BYTE 1    ; 1 = moving right, 0 = moving left
koopa1Health BYTE 2       ; 2 hits to defeat, 1 = shell mode

; Koopa 2
koopa2X BYTE 75
koopa2Y BYTE 28
koopa2Active BYTE 1
koopa2Direction BYTE 0
koopa2Health BYTE 2

; Koopa 3
koopa3X BYTE 95
koopa3Y BYTE 28
koopa3Active BYTE 1
koopa3Direction BYTE 1
koopa3Health BYTE 2

koopaSpeed BYTE 1
koopaFrameCounter BYTE 0

;------------------------------ BOSS DATA -----------------------------------
bossX BYTE 60
bossY BYTE 28
bossActive BYTE 1         ; 1 = alive, 0 = defeated
bossDirection BYTE 1      ; 1 = moving right, 0 = moving left
bossHealth BYTE 15        ; Requires 15 hits
bossSpeed BYTE 1          ; Same speed as player
bossFrameCounter BYTE 0   ; Boss moves every 3 frames 


;------------------------------ PLATFORMS --------------------------------
;PLANES
plane1X BYTE 15
plane1Y BYTE 25
planeShape BYTE 223,223,223,223,223,223,223,223,223,223,223,223,223,223,223,0

;PIPES
pipe1X BYTE 40
pipe1Y BYTE 28
pipe2X BYTE 50
pipe2Y BYTE 28
pipe3X BYTE 60
pipe3Y BYTE 28
pipe4X BYTE 70
pipe4Y BYTE 28
pipeShape BYTE " ", 219, 219, " ", 0
pipeShape2 BYTE " ", 219, 219, " ", 0
pipeShape3 BYTE 223, 219, 219, 223, 0


;------------------------------ OBJECTS ----------------------------------
; Array of coins
coin1X BYTE 35
coin1Y BYTE 28
coin1Active BYTE 1      ; 1 = active, 0 = collected

coin2X BYTE 45
coin2Y BYTE 24
coin2Active BYTE 1

coin3X BYTE 55
coin3Y BYTE 28
coin3Active BYTE 1

coin4X BYTE 65
coin4Y BYTE 22
coin4Active BYTE 1

coin5X BYTE 75
coin5Y BYTE 28
coin5Active BYTE 1

coinFlag db 0

;------------------------------ TURBO STAR ----------------------------------
turboStarX BYTE 80
turboStarY BYTE 22
turboStarActive BYTE 1     
turboStarFlag BYTE 0        ; For animation  ; Countdown in frames (50 frames = 10 seconds at 5 fps)

;after colleciton
speedBoostActive BYTE 0  
speedBoostTimer WORD 0      ; Countdown in frames  



;------------------------------ MOVING PLATFORMS --------------------------------
; Moving Platform 1 (Horizontal)
movingPlat1X BYTE 25
movingPlat1Y BYTE 22
movingPlat1Direction BYTE 1   ; 1 = moving right, 0 = moving left
movingPlat1MinX BYTE 15
movingPlat1MaxX BYTE 50
movingPlat1Shape BYTE 223,223,223,223,223,223,223,223,0

; Moving Platform 2 (Vertical)
movingPlat2X BYTE 85
movingPlat2Y BYTE 24
movingPlat2Direction BYTE 1   ; 1 = moving up, 0 = moving down
movingPlat2MinY BYTE 18
movingPlat2MaxY BYTE 26
movingPlat2Shape BYTE 223,223,223,223,223,223,223,223,0

movingPlatFrameCounter BYTE 0

;------------------------------ FLAGPOLES --------------------------------
; Level 1 Scene 2 Flagpole
flagpole1X BYTE 110
flagpole1Y BYTE 29
flagpole1Active BYTE 1

; Level 2 Scene 2 Flagpole (Boss level)
flagpole2X BYTE 110
flagpole2Y BYTE 29
flagpole2Active BYTE 1

flagpoleShape BYTE 219,0        ; Vertical bar
flagShape BYTE 175,175,175,0    ; Flag at top

levelEndBonus DWORD 0           ; Bonus points for completing level

;------------------------------ GIANT POWER-UP ----------------------------------
giantPowerUpX BYTE 50
giantPowerUpY BYTE 22
giantPowerUpActive BYTE 1
giantPowerUpFlag BYTE 0        ; For animation

; After collection
isGiantMario BYTE 0            ; 0 = normal, 1 = giant
giantMarioTimer WORD 0         ; Duration in frames (80 frames = ~16 seconds)

; Giant Mario ASCII Art
giantM1 db "  __  __  ",0
giantM2 db " |  \/  | ",0
giantM3 db " | |\/| | ",0
giantM4 db " | |  | | ",0
giantM5 db " |_|  |_| ",0


;-------------------------------------------------------------------------
.code;--------------------------------------------------------------------
;-------------------------------- LEVELS ---------------------------------
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------

;func to change values for level1Scene1
setupLevel1Scene1 PROC
    ;reset time
    mov gameTime, 200
    ;player
    mov xPos, 0
    mov yPos, 28
    ;pipes
    mov pipe1X, 40
    mov pipe2X, 50
    mov pipe3X, 60
    mov pipe4X, 70
    ;planes
    mov plane1X, 15
    ;coins
    mov coin1X, 35
    mov coin2X, 45
    mov coin3X, 55
    mov coin4X, 65
    mov coin5X, 75
    mov coin1Active, 1
    mov coin2Active, 1
    mov coin3Active, 1
    mov coin4Active, 1
    mov coin5Active, 1
    ;goombas
    mov goomba1X, 30
    mov goomba2X, 60
    mov goomba3X, 90
    mov goomba1Active, 1
    mov goomba2Active, 1
    mov goomba3Active, 1
    ;clouds
    mov cloud1X, 20
    mov cloud2X, 60
    mov cloud3X, 80
    mov cloud4X, 105

    ; Update level indicators
    mov currentWorld, 1
    mov currentLevel, 1

    ret
setupLevel1Scene1 ENDP
setupLevel1Scene2 PROC
    ;player
    mov xPos, 0
    mov yPos, 28
    ;pipes
    mov pipe1X, 30
    mov pipe2X, 70
    mov pipe3X, 90
    mov pipe4X, 100
    ;planes
    mov plane1X, 80
    ;coins
    mov coin1X, 55
    mov coin2X, 60
    mov coin3X, 65
    mov coin4X, 70
    mov coin5X, 75
    mov coin1Active, 1
    mov coin2Active, 1
    mov coin3Active, 1
    mov coin4Active, 1
    mov coin5Active, 1
    ;goombas
    mov goomba1X, 10
    mov goomba2X, 20
    mov goomba3X, 30
    mov goomba1Active, 1
    mov goomba2Active, 1
    mov goomba3Active, 1
    ;koopas
    mov koopa1X, 45
    mov koopa2X, 75
    mov koopa3X, 95
    mov koopa1Active, 1
    mov koopa2Active, 1
    mov koopa3Active, 1
    mov koopa1Health, 2
    mov koopa2Health, 2
    mov koopa3Health, 2
    mov koopa1Direction, 1
    mov koopa2Direction, 0
    mov koopa3Direction, 1
    ;clouds
    mov cloud1X, 20
    mov cloud2X, 60
    mov cloud3X, 80
    mov cloud4X, 105

    ; Update level indicators
    mov currentWorld, 1
    mov currentLevel, 2

    ret
setupLevel1Scene2 ENDP
setupLevel2Scene1 PROC
    ; Similar to Level 1 but with different positions
    mov xPos, 0
    mov yPos, 28
    
    ; Pipes at different positions
    mov pipe1X, 25
    mov pipe2X, 55
    mov pipe3X, 85
    mov pipe4X, 110
    
    ; Plane
    mov plane1X, 70
    
    ; Coins
    mov coin1X, 30
    mov coin2X, 40
    mov coin3X, 50
    mov coin4X, 60
    mov coin5X, 90
    mov coin1Active, 1
    mov coin2Active, 1
    mov coin3Active, 1
    mov coin4Active, 1
    mov coin5Active, 1
    
    ; Mix of Goombas and Koopas
    mov goomba1X, 15
    mov goomba2X, 35
    mov goomba3X, 75
    mov goomba1Active, 1
    mov goomba2Active, 1
    mov goomba3Active, 1
    
    mov koopa1X, 20
    mov koopa2X, 50
    mov koopa3X, 100
    mov koopa1Active, 1
    mov koopa2Active, 1
    mov koopa3Active, 1
    mov koopa1Health, 2
    mov koopa2Health, 2
    mov koopa3Health, 2
    
    ; Clouds
    mov cloud1X, 15
    mov cloud2X, 50
    mov cloud3X, 85
    mov cloud4X, 110
    
    ; Update level indicators
    mov currentWorld, 2
    mov currentLevel, 1
    
    ret
setupLevel2Scene1 ENDP

setupLevel2Scene2 PROC
    ; player
    mov xPos, 10
    mov yPos, 28
    
    ; platforms
    mov pipe1X, 20
    mov pipe2X, 60
    mov pipe3X, 100
    mov pipe4X, 115
    
    mov plane1X, 40
    
    ; no coins
    mov coin1Active, 0
    mov coin2Active, 0
    mov coin3Active, 0
    mov coin4Active, 0
    mov coin5Active, 0

    ; turbo star
    mov turboStarX, 80
    mov turboStarY, 22
    mov turboStarActive, 1
    
    ; giant Power Up
    mov giantPowerUpX, 50
    mov giantPowerUpY, 22
    mov giantPowerUpActive, 1
    mov isGiantMario, 0
    mov giantMarioTimer, 0
    
    ; No enemies
    mov goomba1Active, 0
    mov goomba2Active, 0
    mov goomba3Active, 0
    mov koopa1Active, 0
    mov koopa2Active, 0
    mov koopa3Active, 0
    
    ; Boss
    mov bossX, 60
    mov bossY, 28
    mov bossActive, 1
    mov bossHealth, 15
    mov bossDirection, 1
    
    ; Clouds
    mov cloud1X, 10
    mov cloud2X, 40
    mov cloud3X, 70
    mov cloud4X, 100
    
    ; Update level indicators
    mov currentWorld, 2
    mov currentLevel, 2
    
    ret
setupLevel2Scene2 ENDP


;SCENE HELPERS
CheckLevel1Scene1 PROC
	
	cmp xPos, 115
	jge endIt
	ret

	endIt:
	mov isLevel1Scene1, 0
	ret
ret
CheckLevel1Scene1 ENDP
CheckLevel1Scene2 PROC
    ; Check if player touched flagpole
    mov al, 1  ; Flagpole 1
    call CheckFlagpoleCollision
    cmp al, 1
    je endLevel1Scene2
    ret
    
endLevel1Scene2:
    call ShowLevelEndBonus
    mov isLevel1Scene2, 0
    ret
CheckLevel1Scene2 ENDP
CheckLevel2Scene1 PROC
    cmp xPos, 115
    jge endLevel2Scene1
    ret
    
endLevel2Scene1:
    mov isLevel2Scene1, 0
    ret
CheckLevel2Scene1 ENDP
CheckLevel2Scene2 PROC
    ; Check if boss is defeated first
    cmp bossActive, 0
    jne notComplete
    
    ; Boss defeated, now check if player touched flagpole
    mov al, 2  ; Flagpole 2
    call CheckFlagpoleCollision
    cmp al, 1
    je endLevel2Scene2
    
notComplete:
    ret
    
endLevel2Scene2:
    ; Calculate and display bonus
    ;call ShowLevelEndBonus
    mov isLevel2Scene2, 0         ; Signal level complete
    ret
CheckLevel2Scene2 ENDP

;-------------------------------------------------------------------------
;-------------------------------- SCENES ---------------------------------
;-------------------------------------------------------------------------
Level1Scene1 PROC
	mov isLevel1Scene1, 1
    call setupLevel1Scene1
	call DrawBackground
	call DrawClouds
	call DrawPipes
	call DrawPlanes
    call DrawMovingPlatforms
	call DrawPlayer
	call DrawAllCoins
	call DrawGoombas

	mov ecx, 0  ;frame counter for timer
    push ecx   ; to avoid erros
	gameLoop1::
		mov eax, 120
        call Delay
		
		;stuff that should not be removed by player or enemies
		call JustDrawGround
        call DrawPipes
		call DrawPlanes
		
        call UpdateMovingPlatforms
        call DrawMovingPlatforms
		call ApplyGravity
		call UpdateGoombas
		call DrawGoombas
		call CoinAnimation
		call PlayerCoinCollision
		call PlayerGoombaCollision
		call DrawHUD

        pop ecx  ; to avoid errors
		; 1sec = approx 8frames of my game rn
		inc ecx
		cmp ecx, 8
		jl skipTimeUpdate
		mov ecx, 0
		call UpdateGameTime
		skipTimeUpdate:

        push ecx
		call CheckLives
		call TakeUserInput
		call CheckUserInput
		call CheckLevel1Scene1

		cmp isLevel1Scene1, 0
		je EndLevel1Scene1

        
	jmp gameLoop1
EndLevel1Scene1:
pop ecx ;clear stack
ret
Level1Scene1 ENDP

Level1Scene2 PROC
    mov isLevel1Scene2, 1
    mov flagpole1Active, 1
    call setupLevel1Scene2
    call DrawBackground
    call DrawClouds
    call DrawPipes
    call DrawPlanes
    call DrawPlayer
    call DrawAllCoins
    call DrawGoombas
    call DrawKoopas
    mov al, 1 
    call DrawFlagpole 

    mov ecx, 0  ;frame counter for timer
    push ecx   ; to avoid erros
    gameLoop2::
        mov eax, 110
        call Delay
        
        ;stuff that should not be removed by player or enemies
        call JustDrawGround
        call DrawPipes
        call DrawPlanes
        mov al, 1
        call DrawFlagpole
        
        call ApplyGravity
        call UpdateGoombas
        call DrawGoombas
        call UpdateKoopas
        call DrawKoopas
        call CoinAnimation
        call PlayerCoinCollision
        call PlayerGoombaCollision
        call PlayerKoopaCollision
        call DrawHUD

        pop ecx
        ; 1sec = approx 7frames of my game rn
        inc ecx
        cmp ecx, 7
        jl skipTimeUpdate
        mov ecx, 0
        call UpdateGameTime
        skipTimeUpdate:

        push ecx
        call CheckLives
        call TakeUserInput
        call CheckUserInput
        call CheckLevel1Scene2

		cmp isLevel1Scene2, 0
		je EndLevel1Scene2
    jmp gameLoop2
EndLevel1Scene2:
pop ecx ;clear stack
ret
Level1Scene2 ENDP

;level1
Level1 PROC
call Level1Scene1
call clrscr
call Level1Scene2
ret
Level1 ENDP

;-------------------------------------------------------------------------
;--------------------------- LEVEL 2 SCENES ------------------------------
;-------------------------------------------------------------------------
Level2Scene1 PROC
    mov isLevel2Scene1, 1
    call setupLevel2Scene1
    call DrawBackground
    call DrawClouds
    call DrawPipes
    call DrawPlanes
    call DrawPlayer
    call DrawAllCoins
    call DrawGoombas
    call DrawKoopas
    ;call DrawTurboStar
    
    mov ecx, 0
    push ecx   ; to avoid erros
    gameLoop2S1::
        ; Check for pause
        call TakeUserInput
        cmp inputChar, 'p'
        je pauseGame2S1
        cmp inputChar, 1Bh  ; ESC key
        je pauseGame2S1
        jmp continueGame2S1

        
        
    pauseGame2S1:
        mov isPaused, 1
        call DrawPauseMenu
        call HandlePauseInput
        cmp isPaused, 0
        jne GaMeOvEr  ; If not resumed, we quit
        ; Redraw everything after unpause
        call DrawBackground
        call DrawClouds
        call DrawPipes
        call DrawPlanes
        call DrawHUD
        
    continueGame2S1:
        mov eax, 105
        call Delay
        
        call JustDrawGround
        call DrawPipes
        call DrawPlanes
        
        ;call TurboStarAnimation
        ;call PlayerTurboStarCollision
        ;call UpdateSpeedBoost

        call ApplyGravity
        call UpdateGoombas
        call DrawGoombas
        call UpdateKoopas
        call DrawKoopas
        call CoinAnimation
        call PlayerCoinCollision
        call PlayerGoombaCollision
        call PlayerKoopaCollision
        call DrawHUD
        
        pop ecx
        inc ecx
        cmp ecx, 7
        jl skipTimeUpdate2S1
        mov ecx, 0
        call UpdateGameTime
        skipTimeUpdate2S1:
        
        push ecx
        call CheckLives
        call CheckUserInput
        call CheckLevel2Scene1
        
        cmp isLevel2Scene1, 0
        je EndLevel2Scene1
        
    jmp gameLoop2S1
    
EndLevel2Scene1:
    pop ecx ;clear stack
    ret
Level2Scene1 ENDP

Level2Scene2 PROC
    mov flagpole2Active, 1
    mov isLevel2Scene2, 1
    call setupLevel2Scene2
    call DrawBackground
    call DrawClouds
    call DrawPipes
    call DrawPlanes
    call DrawPlayer
    call DrawBoss
    mov al, 2
    call DrawFlagpole
    call DrawTurboStar
    call DrawGiantPowerUp  ; *** ADD THIS LINE ***
    
    ; Display boss health at top
    mov eax, red + (lightBlue * 16)
    call SetTextColor
    mov dl, 40
    mov dh, 1
    call Gotoxy
    mWrite "BOSS HEALTH: "
    movzx eax, bossHealth
    call WriteDec
    
    mov ecx, 0
    push ecx
    gameLoopBoss::
        ; Check for pause
        call TakeUserInput
        cmp inputChar, 'p'
        je pauseGameBoss
        cmp inputChar, 1Bh
        je pauseGameBoss
        jmp continueGameBoss
        
    pauseGameBoss:
        mov isPaused, 1
        call DrawPauseMenu
        call HandlePauseInput
        cmp isPaused, 0
        jne GaMeOvEr
        call DrawBackground
        call DrawClouds
        call DrawPipes
        call DrawPlanes
        call DrawHUD
        
    continueGameBoss:
        mov eax, 120
        call Delay
        
        call JustDrawGround
        call DrawPipes
        call DrawPlanes
        mov al, 2
        call DrawFlagpole
        
        call TurboStarAnimation
        call PlayerTurboStarCollision
        call UpdateSpeedBoost
        
        call GiantPowerUpAnimation        
        call PlayerGiantPowerUpCollision  
        call UpdateGiantMario             

        call ApplyGravity
        call UpdateBoss
        call DrawBoss
        call PlayerBossCollision
        call DrawHUD
        
        ; Update boss health display
        mov eax, red + (lightBlue * 16)
        call SetTextColor
        mov dl, 40
        mov dh, 1
        call Gotoxy
        mWrite "BOSS HEALTH: "
        movzx eax, bossHealth
        call WriteDec
        mWrite "  "
        
        pop ecx
        inc ecx
        cmp ecx, 8
        jl skipTimeUpdateBoss
        mov ecx, 0
        call UpdateGameTime
        skipTimeUpdateBoss:
        
        push ecx
        call CheckLives
        call CheckUserInput
        call CheckLevel2Scene2
        
        cmp isLevel2Scene2, 0
        je BossLevelComplete
        
    jmp gameLoopBoss
    
BossLevelComplete:
    pop ecx
    call ShowLevelEndBonus
    call UpdateHighScores
    call WinGame
    ret
Level2Scene2 ENDP

;level2
Level2 PROC
    call Level2Scene1
    call crlf
    call Level2Scene2
    ret
Level2 ENDP
;-------------------------------------------------------------------------
;------------------------------ BACKGROUND -------------------------------
;-------------------------------------------------------------------------
UpdateGameTime PROC
	; Decrement time every second
	cmp gameTime, 0
	je timeUp
	dec gameTime
	ret
	
	timeUp:
	; Time ran out, player dies
    call DisplayTimesUp
    mov eax, 1000
    call delay

	jmp GaMeOvEr
	ret
UpdateGameTime ENDP

DisplayTimesUp PROC
    mov eax, red + (black * 16)    ; Red text on black background
    call SetTextColor
    
    mov dl, 0
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET timesup1
    call WriteString
    
    mov dl, 0
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET timesup2
    call WriteString
    
    mov dl, 0
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET timesup3
    call WriteString
    
    mov dl, 0
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET timesup4
    call WriteString
    
    mov dl, 0
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET timesup5
    call WriteString
    
    mov dl, 0
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET timesup6
    call WriteString
    
    ret
DisplayTimesUp ENDP

DrawBackground PROC
	;draw bg color
	mov eax, black + (lightblue * 16)
	call settextcolor
	call clrscr

	; draw ground at (0,29):
	mov eax, black + (green*16)
	call settextcolor
	mov dl,0 ;x
	mov dh,29 ;y
	call Gotoxy
	mov edx,OFFSET ground
	call WriteString

ret
DrawBackground ENDP

JustDrawGround PROC
    ; draw ground at (0,29):
	mov eax, black + (green*16)
	call settextcolor
	mov dl,0 ;x
	mov dh,29 ;y
	call Gotoxy
	mov edx,OFFSET ground
	call WriteString
ret
JustDrawGround ENDP

;scores, lives etc
DrawHUD PROC
    ; Save registers
    push eax
    push edx
    
    ; Draw top black bar background
    mov eax, black + (lightblue * 16)
    call SetTextColor
    
    ; === TOP-LEFT: "SCORE" ===
    mov dl, 2
    mov dh, 1
    call Gotoxy
    mWrite "SCORE"
    
    mov dl, 2
    mov dh, 2
    call Gotoxy
    mov eax, score
    call WriteDec
    
    ; === TOP-CENTER-LEFT: Coins collected ===
    mov dl, 15
    mov dh, 1
    call Gotoxy
    mWrite "Coins: "
    
    mov dl, 22
    mov dh, 1
    call Gotoxy
    movzx eax, coinsCollected
    call WriteDec
    
    ; === TOP-CENTER: "WORLD 1-1" ===
    mov dl, 57
    mov dh, 1
    call Gotoxy
    mWrite "WORLD"
    
    mov dl, 58
    mov dh, 2
    call Gotoxy
    movzx eax, currentWorld
    call WriteDec
    mov al, '-'
    call WriteChar
    movzx eax, currentLevel
    call WriteDec
    
    ; === TOP-RIGHT: "TIME" with countdown ===
    ;Change color if speed boost is active
    cmp speedBoostActive, 1
    jne normalTimeColor
    
    ; Blue color when turbo is active
    mov eax, white + (blue * 16)
    jmp setTimeColor
    
    normalTimeColor:
    ; Normal black on light blue
    mov eax, black + (lightBlue * 16)
    
    setTimeColor:
    call SetTextColor
    
    mov dl, 95
    mov dh, 1
    call Gotoxy
    mWrite "TIME"
    
    mov dl, 95
    mov dh, 2
    call Gotoxy
    movzx eax, gameTime
    call WriteDec
    
    ; === FAR-RIGHT: Lives ===
    ; Reset to normal color for lives display
    mov eax, black + (lightBlue * 16)
    call SetTextColor
    
    mov dl, 110
    mov dh, 1
    call Gotoxy
    mWrite "LIVES"
    
    mov dl, 110
    mov dh, 2
    call Gotoxy
    mov al, 'x'
    call WriteChar
    movzx eax, lives
    call WriteDec
    
    ; Restore registers
    pop edx
    pop eax
    ret
DrawHUD ENDP

DrawClouds PROC
	mov eax, white + (lightBlue * 16)
	call SetTextColor
	
	; Draw Cloud 1
	mov dl, cloud1X
	mov dh, cloud1Y
	call Gotoxy
	mov edx, OFFSET cloudShape
	call WriteString
	
	mov dl, cloud1X
	mov dh, cloud1Y
	inc dh
	call Gotoxy
	mov edx, OFFSET cloudShape2
	call WriteString
	
	mov dl, cloud1X
	mov dh, cloud1Y
	add dh, 2
	call Gotoxy
	mov edx, OFFSET cloudShape3
	call WriteString
	
	; Draw Cloud 2
	mov dl, cloud2X
	mov dh, cloud2Y
	call Gotoxy
	mov edx, OFFSET cloudShape
	call WriteString
	
	mov dl, cloud2X
	mov dh, cloud2Y
	inc dh
	call Gotoxy
	mov edx, OFFSET cloudShape2
	call WriteString
	
	mov dl, cloud2X
	mov dh, cloud2Y
	add dh, 2
	call Gotoxy
	mov edx, OFFSET cloudShape3
	call WriteString
	
	; Draw Cloud 3
	mov dl, cloud3X
	mov dh, cloud3Y
	call Gotoxy
	mov edx, OFFSET cloudShape
	call WriteString
	
	mov dl, cloud3X
	mov dh, cloud3Y
	inc dh
	call Gotoxy
	mov edx, OFFSET cloudShape2
	call WriteString
	
	mov dl, cloud3X
	mov dh, cloud3Y
	add dh, 2
	call Gotoxy
	mov edx, OFFSET cloudShape3
	call WriteString

	; Draw Cloud 4
	mov dl, cloud4X
	mov dh, cloud4Y
	call Gotoxy
	mov edx, OFFSET cloudShape
	call WriteString
	
	mov dl, cloud4X
	mov dh, cloud4Y
	inc dh
	call Gotoxy
	mov edx, OFFSET cloudShape2
	call WriteString
	
	mov dl, cloud4X
	mov dh, cloud4Y
	add dh, 2
	call Gotoxy
	mov edx, OFFSET cloudShape3
	call WriteString
	
	ret
DrawClouds ENDP

;-------------------------------------------------------------------------
;------------------------------ READ KEYS --------------------------------
;-------------------------------------------------------------------------
TakeUserInput PROC
	call ReadKey
	mov inputChar,al
ret
TakeUserInput ENDP

CheckUserInput PROC
    ; Check for pause first
    cmp inputChar, 'p'
    je pauseGameNow
    cmp inputChar, 1Bh  ; ESC
    je pauseGameNow
    jmp continueChecking
    
pauseGameNow:
    mov isPaused, 1
    call DrawPauseMenu
    call HandlePauseInput
    cmp isPaused, 0
    jne exitGame
    ; Redraw after unpause
    call DrawBackground
    call DrawClouds
    ret

continueChecking:
    ; exit game if user types 'x':
    cmp inputChar,"x"
    je exitGame

    cmp inputChar,"w"
    je moveUp

    cmp inputChar,"s"
    je moveDown

    cmp inputChar,"a"
    je moveLeft

    cmp inputChar,"d"
    je moveRight
    jmp contin1

    moveUp:
    call StandPlayer
    cmp jmpHeight, 0
    jne contin1
    cmp onGround, 1
    jne contin1
        mov onGround, 0
        inc jmpHeight
        mov jmpDirection, 1
        call UpdatePlayer
        dec yPos
        call DrawPlayer
        jmp contin1

    moveDown:
        call CrouchPlayer
    jmp contin1

    moveLeft:
    call UpdatePlayer
    
    ; Check if turbo is active
    cmp speedBoostActive, 1
    je moveLeftFast
    
    ; Normal speed - move 1 pixel
    dec xPos
    jmp checkLeftCollision
    
    moveLeftFast:
    ; Turbo speed - move 2 pixels
    dec xPos
    dec xPos
    
    checkLeftCollision:
    call CheckLeftWallCollision
    call CheckPipeSideCollision
    call DrawPlayer
    jmp contin1

    moveRight:
    call UpdatePlayer
    
    ; *** MODIFIED: Check if turbo is active ***
    cmp speedBoostActive, 1
    je moveRightFast
    
    ; Normal speed - move 1 pixel
    inc xPos
    jmp checkRightCollision
    
    moveRightFast:
    ; Turbo speed - move 2 pixels
    inc xPos
    inc xPos
    
    checkRightCollision:
    call CheckRightWallCollision
    call CheckPipeSideCollision
    call DrawPlayer
    jmp contin1

    contin1:
    cmp jmpHeight, 0
    je c1
        cmp jmpDirection, 0
        je downn
            ;up
            call UpdatePlayer
            dec yPos
            call DrawPlayer
            inc jmpHeight

            cmp jmpHeight, 8
            jne c1
                mov jmpDirection, 0
                mov jmpHeight, 2
        downn:
            ;down
            ;mov onGround, 0
            ;call UpdatePlayer
            ;inc yPos
            call CheckGroundCollision
            ;call DrawPlayer
            dec jmpHeight
    c1:
ret
CheckUserInput ENDP

;-------------------------------------------------------------------------
;------------------------------ PLAYER -----------------------------------
;-------------------------------------------------------------------------
ApplyGravity PROC
	cmp onGround, 1
	je playerIsOnGround
		; Player is in air, apply gravity
		cmp jmpHeight, 0        ; Only fall if not jumping up
		jg playerIsOnGround
		
		call UpdatePlayer
		inc yPos                ; Fall down
		call CheckGroundCollision
		call DrawPlayer
	playerIsOnGround:
	ret
ApplyGravity ENDP

DrawPlayer PROC
    cmp isGiantMario, 1
    je drawGiant
    
    ; Normal Mario
    mov eax, Red + (lightBlue * 16)
    call settextcolor
    
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, Player
    call WriteChar
    ret
    
drawGiant:
    ; Giant Mario (5 lines tall, 10 chars wide)
    mov eax, Red + (lightBlue * 16)
    call settextcolor
    
    ; Line 1
    mov dl, xPos
    mov dh, yPos
    sub dh, 4
    call Gotoxy
    mov edx, OFFSET giantM1
    call WriteString
    
    ; Line 2
    mov dl, xPos
    mov dh, yPos
    sub dh, 3
    call Gotoxy
    mov edx, OFFSET giantM2
    call WriteString
    
    ; Line 3
    mov dl, xPos
    mov dh, yPos
    sub dh, 2
    call Gotoxy
    mov edx, OFFSET giantM3
    call WriteString
    
    ; Line 4
    mov dl, xPos
    mov dh, yPos
    sub dh, 1
    call Gotoxy
    mov edx, OFFSET giantM4
    call WriteString
    
    ; Line 5 (base)
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov edx, OFFSET giantM5
    call WriteString
    
    ret
DrawPlayer ENDP

UpdatePlayer PROC
    mov eax, lightBlue + (lightBlue * 16)
    call settextcolor
    
    cmp isGiantMario, 1
    je eraseGiant
    
    ; Erase normal Mario
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, " "
    call WriteChar
    ret
    
eraseGiant:
    ; Erase all 5 lines of giant Mario
    mov ecx, 5
    mov dh, yPos
    sub dh, 4
    
eraseGiantLoop:
    push ecx
    mov dl, xPos
    call Gotoxy
    mov edx, OFFSET giantM1  ; Use any line (same width)
    
    ; Erase 10 spaces
    mov ecx, 10
    eraseCharLoop:
        mov al, ' '
        call WriteChar
        loop eraseCharLoop
    
    inc dh
    pop ecx
    loop eraseGiantLoop
    
    ret
UpdatePlayer ENDP

CrouchPlayer PROC
	mov Player, "m"
	call DrawPlayer
ret
CrouchPlayer ENDP

StandPlayer PROC
	mov Player, "M"
ret
StandPlayer ENDP



;-------------------------------------------------------------------------
;------------------------------ ENEMIES ----------------------------------
;-------------------------------------------------------------------------
DrawGoombas PROC
	; Draw Goomba 1
	cmp goomba1Active, 1
	jne skipGoomba1
	mov dl, goomba1X
	mov dh, goomba1Y
	call DrawSingleGoomba
	skipGoomba1:
	
	; Draw Goomba 2
	cmp goomba2Active, 1
	jne skipGoomba2
	mov dl, goomba2X
	mov dh, goomba2Y
	call DrawSingleGoomba
	skipGoomba2:
	
	; Draw Goomba 3
	cmp goomba3Active, 1
	jne skipGoomba3
	mov dl, goomba3X
	mov dh, goomba3Y
	call DrawSingleGoomba
	skipGoomba3:
	
	ret
DrawGoombas ENDP

DrawSingleGoomba PROC
	; dl = X position, dh = Y position
	mov eax, Gray + (lightBlue * 16)
	call SetTextColor
	call Gotoxy
	mov al, 'G'           ; G for Goomba
	call WriteChar
	ret
DrawSingleGoomba ENDP

EraseGoomba PROC
	; dl = X position, dh = Y position
	mov eax, lightBlue + (lightBlue * 16)
	call SetTextColor
	call Gotoxy
	mov al, ' '
	call WriteChar
	ret
EraseGoomba ENDP

UpdateGoombas PROC
	; Only update goombas every 3 frames (slower movement)
	inc goombaFrameCounter
	cmp goombaFrameCounter, 3
	jl skipGoombaUpdate
	mov goombaFrameCounter, 0   ; Reset counter
	
	; Update Goomba 1
	cmp goomba1Active, 1
	jne updateGoomba2
	
	; Erase old position
	mov dl, goomba1X
	mov dh, goomba1Y
	call EraseGoomba
	
	; Move based on direction
	cmp goomba1Direction, 1
	je moveGoomba1Right
		; Move left
		dec goomba1X
		; Check if hit left boundary (x=0)
		cmp goomba1X, 0
		jg updateGoomba2
		mov goomba1Direction, 1  ; Change to right
		jmp updateGoomba2
	moveGoomba1Right:
		; Move right
		inc goomba1X
		; Check if hit right boundary (x=118)
		cmp goomba1X, 118
		jl updateGoomba2
		mov goomba1Direction, 0  ; Change to left
	
	updateGoomba2:
	; Update Goomba 2
	cmp goomba2Active, 1
	jne updateGoomba3
	
	; Erase old position
	mov dl, goomba2X
	mov dh, goomba2Y
	call EraseGoomba
	
	; Move based on direction
	cmp goomba2Direction, 1
	je moveGoomba2Right
		; Move left
		dec goomba2X
		cmp goomba2X, 0
		jg updateGoomba3
		mov goomba2Direction, 1
		jmp updateGoomba3
	moveGoomba2Right:
		; Move right
		inc goomba2X
		cmp goomba2X, 118
		jl updateGoomba3
		mov goomba2Direction, 0
	
	updateGoomba3:
	; Update Goomba 3
	cmp goomba3Active, 1
	jne doneUpdatingGoombas
	
	; Erase old position
	mov dl, goomba3X
	mov dh, goomba3Y
	call EraseGoomba
	
	; Move based on direction
	cmp goomba3Direction, 1
	je moveGoomba3Right
		; Move left
		dec goomba3X
		cmp goomba3X, 0
		jg doneUpdatingGoombas
		mov goomba3Direction, 1
		jmp doneUpdatingGoombas
	moveGoomba3Right:
		; Move right
		inc goomba3X
		cmp goomba3X, 118
		jl doneUpdatingGoombas
		mov goomba3Direction, 0
	
	doneUpdatingGoombas:
	skipGoombaUpdate:
	ret
UpdateGoombas ENDP

;-------------------------------------------------------------------------
;------------------------------ KOOPA TROOPA -----------------------------
;-------------------------------------------------------------------------
DrawKoopas PROC
    ; Draw Koopa 1
    cmp koopa1Active, 1
    jne skipKoopa1
    mov dl, koopa1X
    mov dh, koopa1Y
    movzx eax, koopa1Health
    call DrawSingleKoopa
    skipKoopa1:
    
    ; Draw Koopa 2
    cmp koopa2Active, 1
    jne skipKoopa2
    mov dl, koopa2X
    mov dh, koopa2Y
    movzx eax, koopa2Health
    call DrawSingleKoopa
    skipKoopa2:
    
    ; Draw Koopa 3
    cmp koopa3Active, 1
    jne skipKoopa3
    mov dl, koopa3X
    mov dh, koopa3Y
    movzx eax, koopa3Health
    call DrawSingleKoopa
    skipKoopa3:
    
    ret
DrawKoopas ENDP

DrawSingleKoopa PROC
    ; dl = X position, dh = Y position, eax = health
    push eax
    cmp eax, 2
    je koopaFullHealth
    ; Health = 1, draw as shell (lowercase k)
    mov eax, Magenta + (lightBlue * 16)
    call SetTextColor
    call Gotoxy
    mov al, 'k'           ; k for shell
    call WriteChar
    pop eax
    ret
    
    koopaFullHealth:
    ; Health = 2, draw as full Koopa (uppercase K)
    mov eax, Magenta + (lightBlue * 16)
    call SetTextColor
    call Gotoxy
    mov al, 'K'           ; K for Koopa
    call WriteChar
    pop eax
    ret
DrawSingleKoopa ENDP

EraseKoopa PROC
    ; dl = X position, dh = Y position
    mov eax, lightBlue + (lightBlue * 16)
    call SetTextColor
    call Gotoxy
    mov al, ' '
    call WriteChar
    ret
EraseKoopa ENDP

UpdateKoopas PROC
    ; Only update koopas every 3 frames (slower movement)
    inc koopaFrameCounter
    cmp koopaFrameCounter, 3
    jl skipKoopaUpdate
    mov koopaFrameCounter, 0   ; Reset counter
    
    ; Update Koopa 1
    cmp koopa1Active, 1
    jne updateKoopa2
    
    ; Erase old position
    mov dl, koopa1X
    mov dh, koopa1Y
    call EraseKoopa
    
    ; Move based on direction
    cmp koopa1Direction, 1
    je moveKoopa1Right
        ; Move left
        dec koopa1X
        cmp koopa1X, 0
        jg updateKoopa2
        mov koopa1Direction, 1
        jmp updateKoopa2
    moveKoopa1Right:
        ; Move right
        inc koopa1X
        cmp koopa1X, 118
        jl updateKoopa2
        mov koopa1Direction, 0
    
    updateKoopa2:
    ; Update Koopa 2
    cmp koopa2Active, 1
    jne updateKoopa3
    
    mov dl, koopa2X
    mov dh, koopa2Y
    call EraseKoopa
    
    cmp koopa2Direction, 1
    je moveKoopa2Right
        dec koopa2X
        cmp koopa2X, 0
        jg updateKoopa3
        mov koopa2Direction, 1
        jmp updateKoopa3
    moveKoopa2Right:
        inc koopa2X
        cmp koopa2X, 118
        jl updateKoopa3
        mov koopa2Direction, 0
    
    updateKoopa3:
    ; Update Koopa 3
    cmp koopa3Active, 1
    jne doneUpdatingKoopas
    
    mov dl, koopa3X
    mov dh, koopa3Y
    call EraseKoopa
    
    cmp koopa3Direction, 1
    je moveKoopa3Right
        dec koopa3X
        cmp koopa3X, 0
        jg doneUpdatingKoopas
        mov koopa3Direction, 1
        jmp doneUpdatingKoopas
    moveKoopa3Right:
        inc koopa3X
        cmp koopa3X, 118
        jl doneUpdatingKoopas
        mov koopa3Direction, 0
    
    doneUpdatingKoopas:
    skipKoopaUpdate:
    ret
UpdateKoopas ENDP

PlayerKoopaCollision PROC
    ; Check Koopa 1
    cmp koopa1Active, 1
    jne checkKoopa2Collision
    
    ; Check X collision
    mov al, xPos
    mov bl, koopa1X
    cmp al, bl
    je checkK1Y
    inc bl
    cmp al, bl
    je checkK1Y
    dec bl
    dec bl
    cmp al, bl
    je checkK1Y
    inc bl
    inc bl
    cmp al, bl
    je checkK1Y
    dec bl
    dec bl
    dec bl
    cmp al, bl
    je checkK1Y
    jmp checkKoopa2Collision
    
    checkK1Y:
    ; Check Y collision
    mov al, yPos
    mov bl, koopa1Y
    cmp al, bl
    je sameYKoopa1
    
    ; Check if player is above (jumped on)
    dec bl
    cmp al, bl
    je playerJumpedOnKoopa1
    dec bl
    cmp al, bl
    je playerJumpedOnKoopa1
    jmp checkKoopa2Collision
    
    sameYKoopa1:
        ; Side collision - player takes damage
        dec lives
        mov xPos, 5
        mov yPos, 28
        mov onGround, 1
        mov jmpHeight, 0
        mov jmpDirection, 1
        jmp checkKoopa2Collision
    
    playerJumpedOnKoopa1:
        ; Player jumped on Koopa
        dec koopa1Health
        cmp koopa1Health, 0
        jne koopa1Damaged
        ; Koopa defeated
        mov koopa1Active, 0
        add score, 200
        mov dl, koopa1X
        mov dh, koopa1Y
        call EraseKoopa
        koopa1Damaged:
        mov jmpHeight, 3
        mov jmpDirection, 1
        jmp checkKoopa2Collision

checkKoopa2Collision:
    ; Check Koopa 2
    cmp koopa2Active, 1
    jne checkKoopa3Collision
    
    mov al, xPos
    mov bl, koopa2X
    cmp al, bl
    je checkK2Y
    inc bl
    cmp al, bl
    je checkK2Y
    dec bl
    dec bl
    cmp al, bl
    je checkK2Y
    inc bl
    inc bl
    cmp al, bl
    je checkK2Y
    dec bl
    dec bl
    dec bl
    cmp al, bl
    je checkK2Y
    jmp checkKoopa3Collision
    
    checkK2Y:
    mov al, yPos
    mov bl, koopa2Y
    cmp al, bl
    je sameYKoopa2
    
    dec bl
    cmp al, bl
    je playerJumpedOnKoopa2
    dec bl
    cmp al, bl
    je playerJumpedOnKoopa2
    jmp checkKoopa3Collision
    
    sameYKoopa2:
        dec lives
        mov xPos, 5
        mov yPos, 28
        mov onGround, 1
        mov jmpHeight, 0
        mov jmpDirection, 1
        jmp checkKoopa3Collision
    
    playerJumpedOnKoopa2:
        dec koopa2Health
        cmp koopa2Health, 0
        jne koopa2Damaged
        mov koopa2Active, 0
        add score, 200
        mov dl, koopa2X
        mov dh, koopa2Y
        call EraseKoopa
        koopa2Damaged:
        mov jmpHeight, 3
        mov jmpDirection, 1
        jmp checkKoopa3Collision

checkKoopa3Collision:
    ; Check Koopa 3
    cmp koopa3Active, 1
    jne doneKoopaCollision
    
    mov al, xPos
    mov bl, koopa3X
    cmp al, bl
    je checkK3Y
    inc bl
    cmp al, bl
    je checkK3Y
    dec bl
    dec bl
    cmp al, bl
    je checkK3Y
    inc bl
    inc bl
    cmp al, bl
    je checkK3Y
    dec bl
    dec bl
    dec bl
    cmp al, bl
    je checkK3Y
    jmp doneKoopaCollision
    
    checkK3Y:
    mov al, yPos
    mov bl, koopa3Y
    cmp al, bl
    je sameYKoopa3
    
    dec bl
    cmp al, bl
    je playerJumpedOnKoopa3
    dec bl
    cmp al, bl
    je playerJumpedOnKoopa3
    jmp doneKoopaCollision
    
    sameYKoopa3:
        dec lives
        mov xPos, 5
        mov yPos, 28
        mov onGround, 1
        mov jmpHeight, 0
        mov jmpDirection, 1
        jmp doneKoopaCollision
    
    playerJumpedOnKoopa3:
        dec koopa3Health
        cmp koopa3Health, 0
        jne koopa3Damaged
        mov koopa3Active, 0
        add score, 200
        mov dl, koopa3X
        mov dh, koopa3Y
        call EraseKoopa
        koopa3Damaged:
        mov jmpHeight, 3
        mov jmpDirection, 1
    
    doneKoopaCollision:
    ret
PlayerKoopaCollision ENDP

;-------------------------------------------------------------------------
;--------------------------- BOSS ENEMY ----------------------------------
;-------------------------------------------------------------------------
DrawBoss PROC
    cmp bossActive, 1
    jne skipBoss
    
    ; Draw boss with special color
    mov eax, red + (lightBlue * 16)
    call SetTextColor
    mov dl, bossX
    mov dh, bossY
    call Gotoxy
    mov al, 'B'  ; B for Boss
    call WriteChar
    
skipBoss:
    ret
DrawBoss ENDP

EraseBoss PROC
    mov eax, lightBlue + (lightBlue * 16)
    call SetTextColor
    mov dl, bossX
    mov dh, bossY
    call Gotoxy
    mov al, ' '
    call WriteChar
    ret
EraseBoss ENDP

UpdateBoss PROC
    ; Boss moves every 3 frames
    inc bossFrameCounter
    cmp bossFrameCounter, 3
    jl skipBossUpdate
    mov bossFrameCounter, 0   ; Reset counter
    
    cmp bossActive, 1
    jne skipBossUpdate
    
    call EraseBoss
    
    ; Move based on direction
    cmp bossDirection, 1
    je moveBossRight
        ; Move left
        dec bossX
        cmp bossX, 0
        jg skipBossUpdate
        mov bossDirection, 1
        jmp skipBossUpdate
    moveBossRight:
        ; Move right
        inc bossX
        cmp bossX, 118
        jl skipBossUpdate
        mov bossDirection, 0
    
skipBossUpdate:
    ret
UpdateBoss ENDP

PlayerBossCollision PROC
    cmp bossActive, 1
    jne doneBossCollision
    
    ; Check X collision
    mov al, xPos
    mov bl, bossX
    cmp al, bl
    je checkBossY
    inc bl
    cmp al, bl
    je checkBossY
    dec bl
    dec bl
    cmp al, bl
    je checkBossY
    jmp doneBossCollision
    
checkBossY:
    ; Check Y collision
    mov al, yPos
    mov bl, bossY
    cmp al, bl
    je sameLevelBoss
    
    ; Check if player jumped on boss
    dec bl
    cmp al, bl
    je playerJumpedOnBoss
    dec bl
    cmp al, bl
    je playerJumpedOnBoss
    jmp doneBossCollision
    
sameLevelBoss:
    ; *** MODIFIED: Check if giant Mario ***
    cmp isGiantMario, 1
    je giantHitsBoss
    
    ; Normal Mario side collision - player takes damage
    dec lives
    mov xPos, 5
    mov yPos, 28
    mov onGround, 1
    mov jmpHeight, 0
    mov jmpDirection, 1
    jmp doneBossCollision
    
giantHitsBoss:
    ; Giant Mario hits boss for 5 damage
    sub bossHealth, 5
    add score, 2500  ; Big bonus for giant hit
    
    cmp bossHealth, 0
    jg bossDamaged
    
    ; Boss defeated!
    mov bossActive, 0
    add score, 5000
    call EraseBoss
    jmp doneBossCollision
    
playerJumpedOnBoss:
    ; Normal jump attack
    dec bossHealth
    add score, 500
    
    cmp bossHealth, 0
    jne bossDamaged
    
    ; Boss defeated!
    mov bossActive, 0
    add score, 5000
    call EraseBoss
    
bossDamaged:
    mov jmpHeight, 3
    mov jmpDirection, 1
    
doneBossCollision:
    ret
PlayerBossCollision ENDP

;-------------------------------------------------------------------------
;------------------------------ PLATFORMS --------------------------------
;-------------------------------------------------------------------------
;PLANES
DrawPlanes PROC
	mov eax, Red + (lightblue * 16)
	call SetTextColor

	;Draw Plane1
	mov dl, plane1X
	mov dh, plane1Y
	call Gotoxy
	mov edx, OFFSET planeShape
	call WriteString

ret
DrawPlanes ENDP

;PIPES
DrawPipes PROC
	mov eax, Green + (lightblue * 16)
	call SetTextColor
	
	; Draw Pipe 1
	mov dl, pipe1X
	mov dh, pipe1Y
	call Gotoxy
	mov edx, OFFSET pipeShape
	call WriteString
	
	mov dl, pipe1X
	mov dh, pipe1Y
	dec dh
	call Gotoxy
	mov edx, OFFSET pipeShape2
	call WriteString
	
	mov dl, pipe1X
	mov dh, pipe1Y
	sub dh, 2
	call Gotoxy
	mov edx, OFFSET pipeShape3
	call WriteString
	
	; Draw Pipe 2
	mov dl, pipe2X
	mov dh, pipe2Y
	call Gotoxy
	mov edx, OFFSET pipeShape
	call WriteString
	
	mov dl, pipe2X
	mov dh, pipe2Y
	dec dh
	call Gotoxy
	mov edx, OFFSET pipeShape2
	call WriteString
	
	mov dl, pipe2X
	mov dh, pipe2Y
	sub dh, 2
	call Gotoxy
	mov edx, OFFSET pipeShape3
	call WriteString
	
	; Draw Pipe 3
	mov dl, pipe3X
	mov dh, pipe3Y
	call Gotoxy
	mov edx, OFFSET pipeShape
	call WriteString
	
	mov dl, pipe3X
	mov dh, pipe3Y
	dec dh
	call Gotoxy
	mov edx, OFFSET pipeShape2
	call WriteString
	
	mov dl, pipe3X
	mov dh, pipe3Y
	sub dh, 2
	call Gotoxy
	mov edx, OFFSET pipeShape3
	call WriteString
	
	; Draw Pipe 4
	mov dl, pipe4X
	mov dh, pipe4Y
	call Gotoxy
	mov edx, OFFSET pipeShape
	call WriteString
	
	mov dl, pipe4X
	mov dh, pipe4Y
	dec dh
	call Gotoxy
	mov edx, OFFSET pipeShape2
	call WriteString
	
	mov dl, pipe4X
	mov dh, pipe4Y
	sub dh, 2
	call Gotoxy
	mov edx, OFFSET pipeShape3
	call WriteString
	
ret
DrawPipes ENDP

;------------------------------ MOVING PLATFORM PROCEDURES --------------------------------
DrawMovingPlatforms PROC
    mov eax, Cyan + (lightblue * 16)
    call SetTextColor
    
    ; Draw Moving Platform 1 (Horizontal)
    mov dl, movingPlat1X
    mov dh, movingPlat1Y
    call Gotoxy
    mov edx, OFFSET movingPlat1Shape
    call WriteString
    
    ; Draw Moving Platform 2 (Vertical)
    mov dl, movingPlat2X
    mov dh, movingPlat2Y
    call Gotoxy
    mov edx, OFFSET movingPlat2Shape
    call WriteString
    
    ret
DrawMovingPlatforms ENDP

EraseMovingPlatform PROC
    ; dl = X position, dh = Y position, cl = width
    mov eax, lightBlue + (lightBlue * 16)
    call SetTextColor
    call Gotoxy
    
    mov al, ' '
    movzx ecx, cl
    erasePlatLoop:
        call WriteChar
        loop erasePlatLoop
    
    ret
EraseMovingPlatform ENDP

UpdateMovingPlatforms PROC
    ; Only update every 3 frames
    inc movingPlatFrameCounter
    cmp movingPlatFrameCounter, 3
    jl skipMovingPlatUpdate
    mov movingPlatFrameCounter, 0
    
    ; Update Platform 1 (Horizontal movement)
    mov dl, movingPlat1X
    mov dh, movingPlat1Y
    mov cl, 8  ; width
    call EraseMovingPlatform
    
    cmp movingPlat1Direction, 1
    je movePlat1Right
        ; Move left
        dec movingPlat1X
        mov al, movingPlat1X
        cmp al, movingPlat1MinX
        jge updatePlat2
        mov movingPlat1Direction, 1
        jmp updatePlat2
    movePlat1Right:
        ; Move right
        inc movingPlat1X
        mov al, movingPlat1X
        cmp al, movingPlat1MaxX
        jle updatePlat2
        mov movingPlat1Direction, 0
    
    updatePlat2:
    ; Update Platform 2 (Vertical movement)
    mov dl, movingPlat2X
    mov dh, movingPlat2Y
    mov cl, 8  ; width
    call EraseMovingPlatform
    
    cmp movingPlat2Direction, 1
    je movePlat2Up
        ; Move down
        inc movingPlat2Y
        mov al, movingPlat2Y
        cmp al, movingPlat2MaxY
        jle skipMovingPlatUpdate
        mov movingPlat2Direction, 1
        jmp skipMovingPlatUpdate
    movePlat2Up:
        ; Move up
        dec movingPlat2Y
        mov al, movingPlat2Y
        cmp al, movingPlat2MinY
        jge skipMovingPlatUpdate
        mov movingPlat2Direction, 0
    
    skipMovingPlatUpdate:
    ret
UpdateMovingPlatforms ENDP

CheckMovingPlatformCollision PROC
    ; Check Moving Platform 1 (Horizontal)
    mov al, xPos
    mov bl, movingPlat1X
    cmp al, bl
    jl checkMovingPlat2
    
    add bl, 7  ; Platform width - 1
    cmp al, bl
    jg checkMovingPlat2
    
    ; Player X is within platform bounds, check Y
    mov al, yPos
    mov bl, movingPlat1Y
    dec bl
    cmp al, bl
    je onMovingPlat1
    
    inc al
    cmp al, movingPlat1Y
    je onMovingPlat1
    jmp checkMovingPlat2
    
    onMovingPlat1:
    mov al, movingPlat1Y
    dec al
    mov yPos, al
    mov onGround, 1
    mov jmpHeight, 0
    mov jmpDirection, 1
    ret
    
    checkMovingPlat2:
    ; Check Moving Platform 2 (Vertical)
    mov al, xPos
    mov bl, movingPlat2X
    cmp al, bl
    jl noMovingPlatCollision
    
    add bl, 7  ; Platform width - 1
    cmp al, bl
    jg noMovingPlatCollision
    
    ; Player X is within platform bounds, check Y
    mov al, yPos
    mov bl, movingPlat2Y
    dec bl
    cmp al, bl
    je onMovingPlat2
    
    inc al
    cmp al, movingPlat2Y
    je onMovingPlat2
    jmp noMovingPlatCollision
    
    onMovingPlat2:
    mov al, movingPlat2Y
    dec al
    mov yPos, al
    mov onGround, 1
    mov jmpHeight, 0
    mov jmpDirection, 1
    ret
    
    noMovingPlatCollision:
    ret
CheckMovingPlatformCollision ENDP

;------------------------------ FLAGPOLE PROCEDURES --------------------------------
DrawFlagpole PROC
    ; al = flagpole number (1 or 2)
    push eax
    push ebx
    push ecx
    push edx
    
    cmp al, 1
    je drawFlag1
    
    ; Draw Flagpole 2
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    
    ; Draw pole (10 units tall, starting from Y-10 to Y-1)
    mov cl, 10
    mov dh, flagpole2Y
    sub dh, cl
    inc dh  ; Start one position down from top
    
    mov bl, flagpole2Y
    dec bl  ; Stop one position above ground
    
    drawPole2Loop:
        cmp dh, bl
        jg donePole2
        
        ; Only draw if not overlapping with ground or HUD
        cmp dh, 3   ; Below HUD area
        jl skipPole2Draw
        cmp dh, 28  ; Above ground
        jge skipPole2Draw
        
        mov dl, flagpole2X
        call Gotoxy
        mov al, 219  ; Single character for pole
        call WriteChar
        
        skipPole2Draw:
        inc dh
        jmp drawPole2Loop
    
    donePole2:
    ; Draw flag at top (3 characters wide)
    mov eax, red + (lightBlue * 16)
    call SetTextColor
    mov dl, flagpole2X
    inc dl  ; Position flag next to pole
    mov dh, flagpole2Y
    sub dh, 9  ; Position at top
    
    ; Only draw if in valid area
    cmp dh, 3
    jl skipFlag2
    cmp dh, 28
    jge skipFlag2
    
    call Gotoxy
    mov al, 254  ; Flag character (solid block)
    call WriteChar
    mov al, 254
    call WriteChar
    mov al, 254
    call WriteChar
    
    skipFlag2:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
    
    drawFlag1:
    ; Draw Flagpole 1
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    
    ; Draw pole (10 units tall, starting from Y-10 to Y-1)
    mov cl, 10
    mov dh, flagpole1Y
    sub dh, cl
    inc dh  ; Start one position down from top
    
    mov bl, flagpole1Y
    dec bl  ; Stop one position above ground
    
    drawPole1Loop:
        cmp dh, bl
        jg donePole1
        
        ; Only draw if not overlapping with ground or HUD
        cmp dh, 3   ; Below HUD area
        jl skipPole1Draw
        cmp dh, 28  ; Above ground
        jge skipPole1Draw
        
        mov dl, flagpole1X
        call Gotoxy
        mov al, 219  ; Single character for pole
        call WriteChar
        
        skipPole1Draw:
        inc dh
        jmp drawPole1Loop
    
    donePole1:
    ; Draw flag at top (3 characters wide)
    mov eax, red + (lightBlue * 16)
    call SetTextColor
    mov dl, flagpole1X
    inc dl  ; Position flag next to pole
    mov dh, flagpole1Y
    sub dh, 9  ; Position at top
    
    ; Only draw if in valid area
    cmp dh, 3
    jl skipFlag1
    cmp dh, 28
    jge skipFlag1
    
    call Gotoxy
    mov al, 254  ; Flag character (solid block)
    call WriteChar
    mov al, 254
    call WriteChar
    mov al, 254
    call WriteChar
    
    skipFlag1:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawFlagpole ENDP



;-------------------------------------------------------------------------
;------------------------------ OBJECTS ----------------------------------
;-------------------------------------------------------------------------
; COINS
CoinAnimation PROC
	; update coin frame
	cmp coinFlag, 0
	je coinSideFace
		; Draw all active coins in full face
		call DrawAllCoins
		mov coinFlag, 0
		jmp coinUpdated
	coinSideFace:
		; Draw all active coins in side view
		call UpdateAllCoins
		mov coinFlag, 1
	coinUpdated:
ret
CoinAnimation ENDP

DrawAllCoins PROC
	; Draw Coin 1
	cmp coin1Active, 1
	jne skipCoin1
	mov dl, coin1X
	mov dh, coin1Y
	call DrawCoinFull
	skipCoin1:
	
	; Draw Coin 2
	cmp coin2Active, 1
	jne skipCoin2
	mov dl, coin2X
	mov dh, coin2Y
	call DrawCoinFull
	skipCoin2:
	
	; Draw Coin 3
	cmp coin3Active, 1
	jne skipCoin3
	mov dl, coin3X
	mov dh, coin3Y
	call DrawCoinFull
	skipCoin3:
	
	; Draw Coin 4
	cmp coin4Active, 1
	jne skipCoin4
	mov dl, coin4X
	mov dh, coin4Y
	call DrawCoinFull
	skipCoin4:
	
	; Draw Coin 5
	cmp coin5Active, 1
	jne skipCoin5
	mov dl, coin5X
	mov dh, coin5Y
	call DrawCoinFull
	skipCoin5:
	
	ret
DrawAllCoins ENDP

UpdateAllCoins PROC
	; Draw Coin 1
	cmp coin1Active, 1
	jne skipUpdateCoin1
	mov dl, coin1X
	mov dh, coin1Y
	call DrawCoinSide
	skipUpdateCoin1:
	
	; Draw Coin 2
	cmp coin2Active, 1
	jne skipUpdateCoin2
	mov dl, coin2X
	mov dh, coin2Y
	call DrawCoinSide
	skipUpdateCoin2:
	
	; Draw Coin 3
	cmp coin3Active, 1
	jne skipUpdateCoin3
	mov dl, coin3X
	mov dh, coin3Y
	call DrawCoinSide
	skipUpdateCoin3:
	
	; Draw Coin 4
	cmp coin4Active, 1
	jne skipUpdateCoin4
	mov dl, coin4X
	mov dh, coin4Y
	call DrawCoinSide
	skipUpdateCoin4:
	
	; Draw Coin 5
	cmp coin5Active, 1
	jne skipUpdateCoin5
	mov dl, coin5X
	mov dh, coin5Y
	call DrawCoinSide
	skipUpdateCoin5:
	
	ret
UpdateAllCoins ENDP

DrawCoinFull PROC
	; dl = X position, dh = Y position
	mov eax, yellow + (lightBlue * 16)
	call settextcolor
	call Gotoxy
	mov al, "O"
	call WriteChar
	ret
DrawCoinFull ENDP

DrawCoinSide PROC
	; dl = X position, dh = Y position
	mov eax, yellow + (lightBlue * 16)
	call settextcolor
	call Gotoxy
	mov al, "|"
	call WriteChar
	ret
DrawCoinSide ENDP

EraseCoin PROC
	; dl = X position, dh = Y position
	call Gotoxy
	mov al, " "
	call WriteChar
	ret
EraseCoin ENDP

;------------------------------ TURBO STAR ----------------------------------
DrawTurboStar PROC
    cmp turboStarActive, 1
    jne skipTurboStar
    
    mov dl, turboStarX
    mov dh, turboStarY
    call DrawStarFull
    
    skipTurboStar:
    ret
DrawTurboStar ENDP

DrawStarFull PROC
    ; dl = X position, dh = Y position
    mov eax, lightBlue + (lightBlue * 16)  ; Bright blue star
    call settextcolor
    call Gotoxy
    mov al, "+"
    call WriteChar
    ret
DrawStarFull ENDP

DrawStarSide PROC
    ; dl = X position, dh = Y position
    mov eax, blue + (lightBlue * 16)  ; Darker blue for animation
    call settextcolor
    call Gotoxy
    mov al, "x"
    call WriteChar
    ret
DrawStarSide ENDP

EraseStar PROC
    ; dl = X position, dh = Y position
    mov eax, lightBlue + (lightBlue * 16)
    call settextcolor
    call Gotoxy
    mov al, "+"
    call WriteChar
    ret
EraseStar ENDP

TurboStarAnimation PROC
    cmp turboStarActive, 0
    je skipStarAnim
    
    ; Alternate between * and +
    cmp turboStarFlag, 0
    je starSideFace
        ; Draw full star
        mov dl, turboStarX
        mov dh, turboStarY
        call DrawStarFull
        mov turboStarFlag, 0
        jmp starAnimDone
    starSideFace:
        ; Draw side view
        mov dl, turboStarX
        mov dh, turboStarY
        call DrawStarSide
        mov turboStarFlag, 1
    starAnimDone:
    
    skipStarAnim:
    ret
TurboStarAnimation ENDP

UpdateSpeedBoost PROC
    cmp speedBoostActive, 1
    jne noBoostUpdate
    
    ; Decrement timer
    dec speedBoostTimer
    cmp speedBoostTimer, 0
    jg noBoostUpdate
    
    ; Timer expired, deactivate boost
    mov speedBoostActive, 0
    
    noBoostUpdate:
    ret
UpdateSpeedBoost ENDP

;------------------------------ GIANT POWER-UP ----------------------------------
DrawGiantPowerUp PROC
    cmp giantPowerUpActive, 1
    jne skipGiantPowerUp
    
    mov dl, giantPowerUpX
    mov dh, giantPowerUpY
    call DrawPowerUpFull
    
    skipGiantPowerUp:
    ret
DrawGiantPowerUp ENDP

DrawPowerUpFull PROC
    ; dl = X position, dh = Y position
    mov eax, red + (lightBlue * 16)
    call settextcolor
    call Gotoxy
    mov al, "*"
    call WriteChar
    ret
DrawPowerUpFull ENDP

DrawPowerUpSide PROC
    ; dl = X position, dh = Y position
    mov eax, yellow + (lightBlue * 16)
    call settextcolor
    call Gotoxy
    mov al, "#"
    call WriteChar
    ret
DrawPowerUpSide ENDP

ErasePowerUp PROC
    ; dl = X position, dh = Y position
    mov eax, lightBlue + (lightBlue * 16)
    call settextcolor
    call Gotoxy
    mov al, " "
    call WriteChar
    ret
ErasePowerUp ENDP

GiantPowerUpAnimation PROC
    cmp giantPowerUpActive, 0
    je skipPowerUpAnim
    
    ; Alternate between * and #
    cmp giantPowerUpFlag, 0
    je powerUpSideFace
        ; Draw full power-up
        mov dl, giantPowerUpX
        mov dh, giantPowerUpY
        call DrawPowerUpFull
        mov giantPowerUpFlag, 0
        jmp powerUpAnimDone
    powerUpSideFace:
        ; Draw side view
        mov dl, giantPowerUpX
        mov dh, giantPowerUpY
        call DrawPowerUpSide
        mov giantPowerUpFlag, 1
    powerUpAnimDone:
    
    skipPowerUpAnim:
    ret
GiantPowerUpAnimation ENDP

UpdateGiantMario PROC
    cmp isGiantMario, 1
    jne noGiantUpdate
    
    ; Decrement timer
    dec giantMarioTimer
    cmp giantMarioTimer, 0
    jg noGiantUpdate
    
    ; clear giant
    call UpdatePlayer
    ; Timer expired, revert to normal
    mov isGiantMario, 0
    mov Player, "M"
    
    noGiantUpdate:
    ret
UpdateGiantMario ENDP

;-------------------------------------------------------------------------
;------------------------------- COLLISIONS ------------------------------
;-------------------------------------------------------------------------
PlayerCoinCollision PROC
	; Check Coin 1
	cmp coin1Active, 1
	jne checkCoin2
	mov bl, xPos
	cmp bl, coin1X
	jne checkCoin2
	mov bl, yPos
	cmp bl, coin1Y
	jne checkCoin2
	; Coin 1 collected!
	mov coin1Active, 0
	add score, 200         ; add 200 points for coin
	inc coinsCollected     
	mov dl, coin1X
	mov dh, coin1Y
	call EraseCoin
	
	checkCoin2:
	; Check Coin 2
	cmp coin2Active, 1
	jne checkCoin3
	mov bl, xPos
	cmp bl, coin2X
	jne checkCoin3
	mov bl, yPos
	cmp bl, coin2Y
	jne checkCoin3
	; Coin 2 collected!
	mov coin2Active, 0
	add score, 200         ; add 200 points
	inc coinsCollected 
	mov dl, coin2X
	mov dh, coin2Y
	call EraseCoin
	
	checkCoin3:
	; Check Coin 3
	cmp coin3Active, 1
	jne checkCoin4
	mov bl, xPos
	cmp bl, coin3X
	jne checkCoin4
	mov bl, yPos
	cmp bl, coin3Y
	jne checkCoin4
	; Coin 3 collected!
	mov coin3Active, 0
	add score, 200         ; add 200 points
	inc coinsCollected
	mov dl, coin3X
	mov dh, coin3Y
	call EraseCoin
	
	checkCoin4:
	; Check Coin 4
	cmp coin4Active, 1
	jne checkCoin5
	mov bl, xPos
	cmp bl, coin4X
	jne checkCoin5
	mov bl, yPos
	cmp bl, coin4Y
	jne checkCoin5
	; Coin 4 collected!
	mov coin4Active, 0
	add score, 200         ;add 200 points
	inc coinsCollected
	mov dl, coin4X
	mov dh, coin4Y
	call EraseCoin
	
	checkCoin5:
	; Check Coin 5
	cmp coin5Active, 1
	jne doneCheckingCoins
	mov bl, xPos
	cmp bl, coin5X
	jne doneCheckingCoins
	mov bl, yPos
	cmp bl, coin5Y
	jne doneCheckingCoins
	; Coin 5 collected!
	mov coin5Active, 0
	add score, 200         ; add 200 points
	inc coinsCollected
	mov dl, coin5X
	mov dh, coin5Y
	call EraseCoin
	
	doneCheckingCoins:
	ret
PlayerCoinCollision ENDP

PlayerTurboStarCollision PROC
    cmp turboStarActive, 1
    jne noStarCollision
    
    mov bl, xPos
    cmp bl, turboStarX
    jne noStarCollision
    mov bl, yPos
    cmp bl, turboStarY
    jne noStarCollision
    
    ; Star collected!
    mov turboStarActive, 0
    add score, 500         ; Bonus points
    mov dl, turboStarX
    mov dh, turboStarY
    call EraseStar
    
    ; Activate speed boost
    mov speedBoostActive, 1
    mov speedBoostTimer, 50  ; 10 seconds at 5 frames per second
    
    noStarCollision:
    ret
PlayerTurboStarCollision ENDP

PlayerGoombaCollision PROC
	; Check Goomba 1
	cmp goomba1Active, 1
	jne checkGoomba2Collision
	
	; Check X collision (within 2 pixels)
	mov al, xPos
	mov bl, goomba1X
	; Check if close enough horizontally
	cmp al, bl
	je checkG1Y              ; Same X
	inc bl
	cmp al, bl
	je checkG1Y              ; 1 pixel to right
	dec bl
	dec bl
	cmp al, bl
	je checkG1Y              ; 1 pixel to left
	inc bl                   ; Restore bl
	inc bl
	cmp al, bl
	je checkG1Y              ; 2 pixels to right
	dec bl
	dec bl
	dec bl
	cmp al, bl
	je checkG1Y              ; 2 pixels to left
	jmp checkGoomba2Collision
	
	checkG1Y:
	; Check Y collision
	mov al, yPos
	mov bl, goomba1Y
	cmp al, bl
	je sameYGoomba1          ; Same height - side collision
	
	; Check if player is 1 or 2 blocks above (jumped on)
	dec bl
	cmp al, bl
	je playerJumpedOnGoomba1
	dec bl
	cmp al, bl
	je playerJumpedOnGoomba1
	jmp checkGoomba2Collision
	
	sameYGoomba1:
		; Same Y level - player hit from side
		dec lives
		mov xPos, 5
		mov yPos, 28
		mov onGround, 1
		mov jmpHeight, 0
		mov jmpDirection, 1
		jmp checkGoomba2Collision
	
	playerJumpedOnGoomba1:
	; Player defeated goomba by jumping on it
	mov goomba1Active, 0
	add score, 100
	mov dl, goomba1X
	mov dh, goomba1Y
	call EraseGoomba
	mov jmpHeight, 3
	mov jmpDirection, 1
	

checkGoomba2Collision:
	; Check Goomba 2
	cmp goomba2Active, 1
	jne checkGoomba3Collision
	
	mov al, xPos
	mov bl, goomba2X
	cmp al, bl
	je checkG2Y
	inc bl
	cmp al, bl
	je checkG2Y
	dec bl
	dec bl
	cmp al, bl
	je checkG2Y
	inc bl
	inc bl
	cmp al, bl
	je checkG2Y
	dec bl
	dec bl
	dec bl
	cmp al, bl
	je checkG2Y
	jmp checkGoomba3Collision
	
	checkG2Y:
	mov al, yPos
	mov bl, goomba2Y
	cmp al, bl
	je sameYGoomba2
	
	dec bl
	cmp al, bl
	je playerJumpedOnGoomba2
	dec bl
	cmp al, bl
	je playerJumpedOnGoomba2
	jmp checkGoomba3Collision
	
	sameYGoomba2:
		dec lives
		mov xPos, 5
		mov yPos, 28
		mov onGround, 1
		mov jmpHeight, 0
		mov jmpDirection, 1
		jmp checkGoomba3Collision
	
	playerJumpedOnGoomba2:
	mov goomba2Active, 0
	add score, 100
	mov dl, goomba2X
	mov dh, goomba2Y
	call EraseGoomba
	mov jmpHeight, 3
	mov jmpDirection, 1
	

checkGoomba3Collision:
	; Check Goomba 3
	cmp goomba3Active, 1
	jne doneGoombaCollision
	
	mov al, xPos
	mov bl, goomba3X
	cmp al, bl
	je checkG3Y
	inc bl
	cmp al, bl
	je checkG3Y
	dec bl
	dec bl
	cmp al, bl
	je checkG3Y
	inc bl
	inc bl
	cmp al, bl
	je checkG3Y
	dec bl
	dec bl
	dec bl
	cmp al, bl
	je checkG3Y
	jmp doneGoombaCollision
	
	checkG3Y:
	mov al, yPos
	mov bl, goomba3Y
	cmp al, bl
	je sameYGoomba3
	
	dec bl
	cmp al, bl
	je playerJumpedOnGoomba3
	dec bl
	cmp al, bl
	je playerJumpedOnGoomba3
	jmp doneGoombaCollision
	
	sameYGoomba3:
		dec lives
		mov xPos, 5
		mov yPos, 28
		mov onGround, 1
		mov jmpHeight, 0
		mov jmpDirection, 1
		jmp doneGoombaCollision
	
	playerJumpedOnGoomba3:
	mov goomba3Active, 0
	add score, 100
	mov dl, goomba3X
	mov dh, goomba3Y
	call EraseGoomba
	mov jmpHeight, 3
	mov jmpDirection, 1
	
	doneGoombaCollision:
	ret
PlayerGoombaCollision ENDP


CheckLeftWallCollision PROC
	cmp xPos, 0
	jg notAtLeftWall
		; Player is at or past left wall
		mov xPos, 0           ; Keep player at boundary
	notAtLeftWall:
	ret
CheckLeftWallCollision ENDP

CheckRightWallCollision PROC
	cmp xPos, 118           ; Screen width - 1
	jl notAtRightWall
		; Player is at or past right wall
		mov xPos, 118         ; Keep player at boundary
	notAtRightWall:
	ret
CheckRightWallCollision ENDP

CheckGroundCollision PROC
    ; Check if player Y position is at or below ground level
    mov al, yPos
    cmp al, groundLevel
    jl playerAboveGround
        ; Player is at or below ground - place on ground
        mov al, groundLevel
        mov yPos, al
        mov onGround, 1
        mov jmpHeight, 0
        mov jmpDirection, 1
        ret
    playerAboveGround:
        ; *** MODIFIED: Giant Mario ignores platforms ***
        cmp isGiantMario, 1
        je skipPlatforms
        
        ; Normal Mario - check platforms
        call CheckPlatformCollision
        ret
        
    skipPlatforms:
        mov onGround, 0
        ret
CheckGroundCollision ENDP

CheckPlatformCollision PROC
    ; Check static Plane 1 first
    mov al, xPos
    cmp al, plane1X
    jl checkMovingPlats
    
    mov bl, plane1X
    add bl, 15
    cmp al, bl
    jg checkMovingPlats
    
    mov al, yPos
    mov bl, plane1Y
    dec bl
    cmp al, bl
    je onPlatform
    
    inc al
    cmp al, plane1Y
    je onPlatform
    jmp checkMovingPlats
    
    onPlatform:
    mov al, plane1Y
    dec al
    mov yPos, al
    mov onGround, 1
    mov jmpHeight, 0
    mov jmpDirection, 1
    ret
    
    checkMovingPlats:
    ; Check moving platforms
    ;call CheckMovingPlatformCollision
    
    ; Then check pipes
    call CheckPipeTopCollision
    ret
CheckPlatformCollision ENDP


CheckPipeTopCollision PROC
	; Check Pipe 1 top
	mov al, xPos
	mov bl, pipe1X
	cmp al, bl
	jl checkPipe2Top           ; Too far left
	add bl, 3                  ; Pipe width (4 characters: space, 219, 219, space)
	cmp al, bl
	jg checkPipe2Top           ; Too far right
	
	; Player X is within pipe bounds, check Y
	mov al, yPos
	mov bl, pipe1Y
	sub bl, 3                  ; Top of pipe (3 rows tall)
	dec bl                     ; One position above top
	cmp al, bl
	je onPipe1                 ; Player is standing on pipe
	
	inc al                     ; Check one position below
	mov bl, pipe1Y
	sub bl, 3
	cmp al, bl
	je onPipe1                 ; Player just landed on pipe
	jmp checkPipe2Top
	
	onPipe1:
	mov al, pipe1Y
	sub al, 3                  ; Place player one position above pipe top
	mov yPos, al
	mov onGround, 1
	mov jmpHeight, 0
	mov jmpDirection, 1
	ret
	
	checkPipe2Top:
	; Check Pipe 2 top
	mov al, xPos
	mov bl, pipe2X
	cmp al, bl
	jl checkPipe3Top
	add bl, 3
	cmp al, bl
	jg checkPipe3Top
	
	; Player X is within pipe bounds, check Y
	mov al, yPos
	mov bl, pipe2Y
	sub bl, 3
	dec bl
	cmp al, bl
	je onPipe2
	
	inc al
	mov bl, pipe2Y
	sub bl, 3
	cmp al, bl
	je onPipe2
	jmp checkPipe3Top
	
	onPipe2:
	mov al, pipe2Y
	sub al, 3
	mov yPos, al
	mov onGround, 1
	mov jmpHeight, 0
	mov jmpDirection, 1
	ret
	
	checkPipe3Top:
	; Check Pipe 3 top
	mov al, xPos
	mov bl, pipe3X
	cmp al, bl
	jl checkPipe4Top
	add bl, 3
	cmp al, bl
	jg checkPipe4Top
	
	; Player X is within pipe bounds, check Y
	mov al, yPos
	mov bl, pipe3Y
	sub bl, 3
	dec bl
	cmp al, bl
	je onPipe3
	
	inc al
	mov bl, pipe3Y
	sub bl, 3
	cmp al, bl
	je onPipe3
	jmp checkPipe4Top
	
	onPipe3:
	mov al, pipe3Y
	sub al, 3
	mov yPos, al
	mov onGround, 1
	mov jmpHeight, 0
	mov jmpDirection, 1
	ret
	
	checkPipe4Top:
	; Check Pipe 4 top
	mov al, xPos
	mov bl, pipe4X
	cmp al, bl
	jl noCollisionWithPipes
	add bl, 3
	cmp al, bl
	jg noCollisionWithPipes
	
	; Player X is within pipe bounds, check Y
	mov al, yPos
	mov bl, pipe4Y
	sub bl, 3
	dec bl
	cmp al, bl
	je onPipe4
	
	inc al
	mov bl, pipe4Y
	sub bl, 3
	cmp al, bl
	je onPipe4
	jmp noCollisionWithPipes
	
	onPipe4:
	mov al, pipe4Y
	sub al, 3
	mov yPos, al
	mov onGround, 1
	mov jmpHeight, 0
	mov jmpDirection, 1
	ret
	
	noCollisionWithPipes:
	; Not on any platform or pipe - mark as in air
	mov onGround, 0
	ret
CheckPipeTopCollision ENDP

CheckPipeSideCollision PROC
	; Check Pipe 1
	mov al, xPos
	cmp al, pipe1X
	jl checkPipe2Side
	mov bl, pipe1X
	add bl, 3
	cmp al, bl
	jg checkPipe2Side
	
	; Check if player Y is at pipe height
	mov al, yPos
	mov bl, pipe1Y
	sub bl, 2
	cmp al, bl
	jl checkPipe2Side
	cmp al, pipe1Y
	jg checkPipe2Side
	
	; Collision! Push player to left of pipe
	mov al, pipe1X
	dec al
	mov xPos, al
	ret
	
	checkPipe2Side:
	; Similar logic for pipes 2, 3, 4
	mov al, xPos
	cmp al, pipe2X
	jl checkPipe3Side
	mov bl, pipe2X
	add bl, 3
	cmp al, bl
	jg checkPipe3Side
	
	mov al, yPos
	mov bl, pipe2Y
	sub bl, 2
	cmp al, bl
	jl checkPipe3Side
	cmp al, pipe2Y
	jg checkPipe3Side
	
	mov al, pipe2X
	dec al
	mov xPos, al
	ret
	
	checkPipe3Side:
	mov al, xPos
	cmp al, pipe3X
	jl checkPipe4Side
	mov bl, pipe3X
	add bl, 3
	cmp al, bl
	jg checkPipe4Side
	
	mov al, yPos
	mov bl, pipe3Y
	sub bl, 2
	cmp al, bl
	jl checkPipe4Side
	cmp al, pipe3Y
	jg checkPipe4Side
	
	mov al, pipe3X
	dec al
	mov xPos, al
	ret
	
	checkPipe4Side:
	mov al, xPos
	cmp al, pipe4X
	jl doneCheckingPipeSides
	mov bl, pipe4X
	add bl, 3
	cmp al, bl
	jg doneCheckingPipeSides
	
	mov al, yPos
	mov bl, pipe4Y
	sub bl, 2
	cmp al, bl
	jl doneCheckingPipeSides
	cmp al, pipe4Y
	jg doneCheckingPipeSides
	
	mov al, pipe4X
	dec al
	mov xPos, al
	
	doneCheckingPipeSides:
	ret
CheckPipeSideCollision ENDP


CheckFlagpoleCollision PROC
    ; al = flagpole number (1 or 2)
    push ebx
    push ecx
    
    cmp al, 1
    je checkFlag1
    
    ; Check Flagpole 2
    cmp flagpole2Active, 0
    je noFlagCollision
    
    mov bl, xPos
    mov cl, flagpole2X
    cmp bl, cl
    jl noFlagCollision
    dec cl
    cmp bl, cl
    je flag2Touch
    add cl, 2
    cmp bl, cl
    je flag2Touch
    jmp noFlagCollision
    
    flag2Touch:
    ; Player touched flagpole 2!
    mov flagpole2Active, 0
    call CalculateFlagpoleBonus
    pop ecx
    pop ebx
    mov al, 1  ; Signal level complete
    ret
    
    checkFlag1:
    ; Check Flagpole 1
    cmp flagpole1Active, 0
    je noFlagCollision
    
    mov bl, xPos
    mov cl, flagpole1X
    cmp bl, cl
    jl noFlagCollision
    dec cl
    cmp bl, cl
    je flag1Touch
    add cl, 2
    cmp bl, cl
    je flag1Touch
    jmp noFlagCollision
    
    flag1Touch:
    ; Player touched flagpole 1!
    mov flagpole1Active, 0
    call CalculateFlagpoleBonus
    pop ecx
    pop ebx
    mov al, 1  ; Signal level complete
    ret
    
    noFlagCollision:
    pop ecx
    pop ebx
    mov al, 0  ; No collision
    ret
CheckFlagpoleCollision ENDP

PlayerGiantPowerUpCollision PROC
    cmp giantPowerUpActive, 1
    jne noPowerUpCollision
    
    mov bl, xPos
    cmp bl, giantPowerUpX
    jne noPowerUpCollision
    mov bl, yPos
    cmp bl, giantPowerUpY
    jne noPowerUpCollision
    
    ; Power-up collected!
    mov giantPowerUpActive, 0
    add score, 1000         ; Bonus points
    mov dl, giantPowerUpX
    mov dh, giantPowerUpY
    call ErasePowerUp
    
    ; Activate giant mode
    mov isGiantMario, 1
    mov giantMarioTimer, 80  ; ~16 seconds at 5 frames per second
    
    noPowerUpCollision:
    ret
PlayerGiantPowerUpCollision ENDP


;-------------------------------------------------------------------------
;------------------------------- MENU ------------------------------------
;-------------------------------------------------------------------------
DrawMenu PROC
    ; Set menu colors
    mov eax, yellow + (blue * 16)
    call SetTextColor
    call clrscr
    
    ; Draw Mario Bros title on the LEFT and Roll Number on the RIGHT
    ; Row 1
    mov dl, 5
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET menuTitle1
    call WriteString
    mov dl, 65
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET roll1
    call WriteString
    
    ; Row 2
    mov dl, 5
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET menuTitle2
    call WriteString
    mov dl, 65
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET roll2
    call WriteString
    
    ; Row 3
    mov dl, 5
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET menuTitle3
    call WriteString
    mov dl, 65
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET roll3
    call WriteString
    
    ; Row 4
    mov dl, 5
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET menuTitle4
    call WriteString
    mov dl, 65
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET roll4
    call WriteString
    
    ; Row 5
    mov dl, 5
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET menuTitle5
    call WriteString
    mov dl, 65
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET roll5
    call WriteString
    
    ; Row 6
    mov dl, 5
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET menuTitle6
    call WriteString
    mov dl, 65
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET roll6
    call WriteString
    
    call crlf
    call crlf
    
    ; Draw menu options
    mGotoxy 0, 12
    call DrawMenuOptions
    
    ret
DrawMenu ENDP

DrawMenuOptions PROC
    ; Option 1 - START NEW GAME
    cmp menuOption, 1
    jne checkOption2
    mov eax, black + (white * 16)
    call SetTextColor
    mGotoxy 0, 12
    mov edx, OFFSET menu1
    call WriteString
    
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mGotoxy 0, 14
    mov edx, OFFSET menu2
    call WriteString
    mGotoxy 0, 16
    mov edx, OFFSET menu3
    call WriteString
    mGotoxy 0, 18
    mov edx, OFFSET menu4
    call WriteString
    mGotoxy 0, 20
    mov edx, OFFSET menu5
    call WriteString
    jmp menuDrawn
    
checkOption2:
    cmp menuOption, 2
    jne checkOption3
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mGotoxy 0, 12
    mov edx, OFFSET menu1
    call WriteString
    
    mov eax, black + (white * 16)
    call SetTextColor
    mGotoxy 0, 14
    mov edx, OFFSET menu2
    call WriteString
    
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mGotoxy 0, 16
    mov edx, OFFSET menu3
    call WriteString
    mGotoxy 0, 18
    mov edx, OFFSET menu4
    call WriteString
    mGotoxy 0, 20
    mov edx, OFFSET menu5
    call WriteString
    jmp menuDrawn
    
checkOption3:
    cmp menuOption, 3
    jne checkOption4
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mGotoxy 0, 12
    mov edx, OFFSET menu1
    call WriteString
    mGotoxy 0, 14
    mov edx, OFFSET menu2
    call WriteString
    
    mov eax, black + (white * 16)
    call SetTextColor
    mGotoxy 0, 16
    mov edx, OFFSET menu3
    call WriteString
    
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mGotoxy 0, 18
    mov edx, OFFSET menu4
    call WriteString
    mGotoxy 0, 20
    mov edx, OFFSET menu5
    call WriteString
    jmp menuDrawn
    
checkOption4:
    cmp menuOption, 4
    jne checkOption5
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mGotoxy 0, 12
    mov edx, OFFSET menu1
    call WriteString
    mGotoxy 0, 14
    mov edx, OFFSET menu2
    call WriteString
    mGotoxy 0, 16
    mov edx, OFFSET menu3
    call WriteString
    
    mov eax, black + (white * 16)
    call SetTextColor
    mGotoxy 0, 18
    mov edx, OFFSET menu4
    call WriteString
    
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mGotoxy 0, 20
    mov edx, OFFSET menu5
    call WriteString
    jmp menuDrawn
    
checkOption5:
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mGotoxy 0, 12
    mov edx, OFFSET menu1
    call WriteString
    mGotoxy 0, 14
    mov edx, OFFSET menu2
    call WriteString
    mGotoxy 0, 16
    mov edx, OFFSET menu3
    call WriteString
    mGotoxy 0, 18
    mov edx, OFFSET menu4
    call WriteString
    
    mov eax, black + (white * 16)
    call SetTextColor
    mGotoxy 0, 20
    mov edx, OFFSET menu5
    call WriteString
    
menuDrawn:
    ret
DrawMenuOptions ENDP

MenuInput PROC
    call ReadKey
    
    cmp al, 'w'
    je moveUp
    cmp ah, 48h
    je moveUp
    
    cmp al, 's'
    je moveDown
    cmp ah, 50h
    je moveDown
    
    cmp al, 0Dh
    je selectOption
    
    jmp menuInputDone
    
moveUp:
    cmp menuOption, 1
    je menuInputDone
    dec menuOption
    call DrawMenuOptions
    jmp menuInputDone
    
moveDown:
    cmp menuOption, 5    ; Changed from 4 to 5
    je menuInputDone
    inc menuOption
    call DrawMenuOptions
    jmp menuInputDone
    
selectOption:
    ret
    
menuInputDone:
    jmp MenuInput
    
MenuInput ENDP

GetPlayerName PROC
    ; Clear screen and show name prompt
    mov eax, white + (blue * 16)
    call SetTextColor
    call clrscr
    
    mGotoxy 0, 10
    mov edx, OFFSET namePrompt
    call WriteString
    
    ; Get name input
    mov edx, OFFSET playerName
    mov ecx, 19  ; Max length (leave room for null terminator)
    call ReadString
    mov nameLength, al  ; Store length
    
    ; Show confirmation
    call crlf
    call crlf
    mGotoxy 0, 14
    mov edx, OFFSET pressEnter
    call WriteString
    call ReadChar
    
    ret
GetPlayerName ENDP

ShowManual PROC
    ; Clear screen
    mov eax, white + (magenta * 16)
    call SetTextColor
    call clrscr
    
    ; Display manual line by line
    mGotoxy 0, 2
    mov edx, OFFSET manual1
    call WriteString
    
    mGotoxy 0, 4
    mov edx, OFFSET manual3
    call WriteString
    mGotoxy 0, 5
    mov edx, OFFSET manual4
    call WriteString
    mGotoxy 0, 6
    mov edx, OFFSET manual5
    call WriteString
    mGotoxy 0, 7
    mov edx, OFFSET manual6
    call WriteString
    mGotoxy 0, 8
    mov edx, OFFSET manual7
    call WriteString
    mGotoxy 0, 9
    mov edx, OFFSET manual8
    call WriteString
    
    mGotoxy 0, 11
    mov edx, OFFSET manual10
    call WriteString
    mGotoxy 0, 12
    mov edx, OFFSET manual11
    call WriteString
    mGotoxy 0, 13
    mov edx, OFFSET manual12
    call WriteString
    mGotoxy 0, 14
    mov edx, OFFSET manual13
    call WriteString
    mGotoxy 0, 15
    mov edx, OFFSET manual14
    call WriteString
    
    mGotoxy 0, 17
    mov edx, OFFSET manual16
    call WriteString
    mGotoxy 0, 18
    mov edx, OFFSET manual17
    call WriteString
    mGotoxy 0, 19
    mov edx, OFFSET manual18
    call WriteString
    
    mGotoxy 0, 21
    mov edx, OFFSET manual20
    call WriteString
    mGotoxy 0, 22
    mov edx, OFFSET manual21
    call WriteString
    mGotoxy 0, 23
    mov edx, OFFSET manual22
    call WriteString
    mGotoxy 0, 24
    mov edx, OFFSET manual23
    call WriteString
    
    call crlf
    call crlf
    mGotoxy 0, 27
    mov edx, OFFSET pressEnter
    call WriteString
    call ReadChar
    
    ret
ShowManual ENDP

ShowHighScores PROC
    ; Clear screen
    mov eax, white + (Gray * 16)
    call SetTextColor
    call clrscr
    
    ; Display High Scores ASCII art
    mGotoxy 0, 3
    mov edx, OFFSET high1
    call WriteString
    mov edx, OFFSET high2
    call WriteString
    mov edx, OFFSET high3
    call WriteString
    mov edx, OFFSET high4
    call WriteString
    mov edx, OFFSET high5
    call WriteString
    mov edx, OFFSET high6
    call WriteString
    mov edx, OFFSET high7
    call WriteString
    mov edx, OFFSET high8
    call WriteString
    
    call crlf
    call crlf
    
    ; Display actual high scores
    mGotoxy 30, 14
    mWrite "1. "
    mov edx, OFFSET highScore1Name
    call WriteString
    mWrite " .......... "
    mov eax, highScore1Score
    call WriteDec
    
    mGotoxy 30, 16
    mWrite "2. "
    mov edx, OFFSET highScore2Name
    call WriteString
    mWrite " .......... "
    mov eax, highScore2Score
    call WriteDec
    
    mGotoxy 30, 18
    mWrite "3. "
    mov edx, OFFSET highScore3Name
    call WriteString
    mWrite " .......... "
    mov eax, highScore3Score
    call WriteDec
    
    call crlf
    call crlf
    call crlf
    mGotoxy 0, 24
    mov edx, OFFSET pressEnter
    call WriteString
    call ReadChar
    
    ret
ShowHighScores ENDP

MainMenu PROC
menuLoop:
    call DrawMenu
    call MenuInput
    
    ; Check which option was selected
    cmp menuOption, 1
    je startNewGame
    cmp menuOption, 2
    je loadGame
    cmp menuOption, 3
    je showManuall
    cmp menuOption, 4
    je highScores
    cmp menuOption, 5
    je exitMenu
    
startNewGame:
    call GetPlayerName
    ; Reset game state
    mov score, 0
    mov lives, 3
    ;mov gameTime, 120
    mov currentWorld, 1
    mov currentLevel, 1
    mov coinsCollected, 0
    ret  ; Return to start game
    
loadGame:
    call LoadGameProgress
    ret  ; Return to resume game
    
showManuall:
    call ShowManual
    jmp menuLoop
    
highScores:
    call ShowHighScores
    jmp menuLoop
    
exitMenu:
    call EndGame
    exit
    
MainMenu ENDP


;-------------------------------------------------------------------------
;------------------------------- GAMEOVER --------------------------------
;-------------------------------------------------------------------------
EndGame PROC

mov eax, white + (Cyan * 16)
call settextcolor
call clrscr

mov ecx, 20
temploop:

mGotoxy 10, 10
mov edx, OFFSET exit1
call WriteString
mov edx, OFFSET exit2
call WriteString
mov edx, OFFSET exit3
call WriteString
mov edx, OFFSET exit4
call WriteString
mov edx, OFFSET exit5
call WriteString
mov edx, OFFSET exit6
call WriteString
call crlf
call crlf
call crlf
call crlf
call crlf
loop temploop
ret
EndGame ENDP

;-------------------------------------------------------------------------
;--------------------------- PAUSE MENU ----------------------------------
;-------------------------------------------------------------------------
DrawPauseMenu PROC
    mov eax, white + (black * 16)
    call SetTextColor
    
    ; Draw semi-transparent overlay effect (just redraw with pause menu)
    mGotoxy 0, 10
    mov edx, OFFSET pauseTitle1
    call WriteString
    
    call crlf
    call crlf
    
    mGotoxy 0, 13
    call DrawPauseOptions
    
    ret
DrawPauseMenu ENDP

DrawPauseOptions PROC
    cmp pauseOption, 1
    jne checkPauseOption2
    
    ; Resume highlighted
    mov eax, black + (white * 16)
    call SetTextColor
    mGotoxy 0, 13
    mov edx, OFFSET pauseMenu1
    call WriteString
    
    mov eax, white + (black * 16)
    call SetTextColor
    mGotoxy 0, 15
    mov edx, OFFSET pauseMenu2
    call WriteString
    jmp pauseMenuDrawn
    
checkPauseOption2:
    ; Save & Quit highlighted
    mov eax, white + (black * 16)
    call SetTextColor
    mGotoxy 0, 13
    mov edx, OFFSET pauseMenu1
    call WriteString
    
    mov eax, black + (white * 16)
    call SetTextColor
    mGotoxy 0, 15
    mov edx, OFFSET pauseMenu2
    call WriteString
    
pauseMenuDrawn:
    ret
DrawPauseOptions ENDP

HandlePauseInput PROC
pauseInputLoop:
    call ReadKey
    
    ; Check for UP arrow (w)
    cmp al, 'w'
    je pauseMoveUp
    cmp ah, 48h
    je pauseMoveUp
    
    ; Check for DOWN arrow (s)
    cmp al, 's'
    je pauseMoveDown
    cmp ah, 50h
    je pauseMoveDown
    
    ; Check for ENTER
    cmp al, 0Dh
    je pauseSelect
    
    ; Check for ESC or P to resume
    cmp al, 1Bh  ; ESC
    je pauseResume
    cmp al, 'p'
    je pauseResume
    
    jmp pauseInputLoop
    
pauseMoveUp:
    cmp pauseOption, 1
    je pauseInputLoop
    dec pauseOption
    call DrawPauseOptions
    jmp pauseInputLoop
    
pauseMoveDown:
    cmp pauseOption, 2
    je pauseInputLoop
    inc pauseOption
    call DrawPauseOptions
    jmp pauseInputLoop
    
pauseSelect:
    cmp pauseOption, 1
    je pauseResume
    ; Option 2 - Save & Quit
    call SaveGameProgress
    jmp GaMeOvEr
    
pauseResume:
    mov isPaused, 0
    ret
    
HandlePauseInput ENDP

;-------------------------------------------------------------------------
;--------------------------- WIN SCREEN ----------------------------------
;-------------------------------------------------------------------------
WinGame PROC
    ; Clear screen
    mov eax, yellow + (blue * 16)
    call SetTextColor
    call clrscr
    
    ; Display win ASCII art
    mGotoxy 0, 5
    mov edx, OFFSET win1
    call WriteString
    mov edx, OFFSET win2
    call WriteString
    mov edx, OFFSET win3
    call WriteString
    mov edx, OFFSET win4
    call WriteString
    mov edx, OFFSET win5
    call WriteString
    mov edx, OFFSET win6
    call WriteString
    
    call crlf
    call crlf
    
    ; Display congratulations message with player name
    mGotoxy 0, 14
    mov edx, OFFSET winMsg1
    call WriteString
    mov edx, OFFSET playerName
    call WriteString
    mWrite "!"
    
    call crlf
    call crlf
    mGotoxy 0, 16
    mov edx, OFFSET winMsg2
    call WriteString
    
    call crlf
    call crlf
    mGotoxy 0, 18
    mov edx, OFFSET winMsg3
    call WriteString
    mov eax, score
    call WriteDec
    
    call crlf
    call crlf
    call crlf
    mGotoxy 0, 22
    mov edx, OFFSET pressEnter
    call WriteString
    call ReadChar
    
    ;Return to main menu after winner screen
    ret
WinGame ENDP

;-------------------------------------------------------------------------
;--------------------------- LOADING SCREENS -----------------------------
;-------------------------------------------------------------------------
ShowLoadingScreen PROC
    ; EAX should contain level number (1 or 2)
    push eax
    push edx
    mov eax, black + (black * 16)
    call SetTextColor
    call clrscr

    mov eax, white + (red * 16)
    call SetTextColor
    
    mGotoxy 0, 12
    mov edx, OFFSET loading1
    call WriteString
    
    call crlf
    mGotoxy 0, 13
    mov edx, OFFSET loading2
    call WriteString
    
    pop edx
    push edx
    movzx eax, currentWorld
    call WriteDec
    
    pop edx
    pop eax
    
    call crlf
    mGotoxy 0, 14
    mov edx, OFFSET loading3
    call WriteString
    
    ; Simulate loading
    mov eax, 2000
    call Delay
    
    ret
ShowLoadingScreen ENDP

ShowLevelComplete PROC
    call clrscr
    mov eax, yellow + (blue * 16)
    call SetTextColor
    
    mGotoxy 0, 10
    mov edx, OFFSET levelComplete1
    call WriteString
    
    call crlf
    mGotoxy 0, 11
    mov edx, OFFSET levelComplete2
    call WriteString
    
    call crlf
    mGotoxy 0, 12
    mov edx, OFFSET levelComplete3
    call WriteString
    mov eax, score
    call WriteDec
    
    call crlf
    mGotoxy 0, 13
    mov edx, OFFSET levelComplete4
    call WriteString
    
    call crlf
    call crlf
    call crlf
    mGotoxy 0, 17
    mov edx, OFFSET pressEnter
    call WriteString
    call ReadChar
    
    ret
ShowLevelComplete ENDP

;-------------------------------------------------------------------------
;--------------------------- FILE HANDLING -------------------------------
;-------------------------------------------------------------------------
SaveGameProgress PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Create/Open file for writing
    mov edx, OFFSET saveFilename
    call CreateOutputFile
    mov fileHandle, eax
    
    cmp eax, INVALID_HANDLE_VALUE
    je saveGameError
    
    ; Clear buffer
    mov edi, OFFSET buffer
    mov ecx, 256
    mov al, 0
    rep stosb
    
    mov edi, OFFSET buffer
    
    ; Format: NAME|SCORE|WORLD|LEVEL|LIVES|TIME
    
    ; Copy player name
    mov esi, OFFSET playerName
    copyPlayerName:
        lodsb
        cmp al, 0
        je playerNameDone
        stosb
        jmp copyPlayerName
    playerNameDone:
    
    mov al, '|'
    stosb
    
    ; Add score
    mov eax, score
    call DwordToAscii
    
    mov al, '|'
    stosb
    
    ; Add world
    movzx eax, currentWorld
    add al, '0'
    stosb
    
    mov al, '|'
    stosb
    
    ; Add level
    movzx eax, currentLevel
    add al, '0'
    stosb
    
    mov al, '|'
    stosb
    
    ; Add lives
    movzx eax, lives
    add al, '0'
    stosb
    
    mov al, '|'
    stosb
    
    ; Add time
    movzx eax, gameTime
    call DwordToAscii
    
    ; Add newline
    mov ax, 0A0Dh
    stosw
    
    ; Null terminate
    mov al, 0
    stosb
    
    ; Calculate bytes to write
    mov ecx, edi
    sub ecx, OFFSET buffer
    dec ecx  ; Don't count null
    
    ; Write to file
    mov eax, fileHandle
    mov edx, OFFSET buffer
    call WriteToFile
    
    ; Close file
    mov eax, fileHandle
    call CloseFile
    
    ; Show save message
    call clrscr
    mov eax, green + (black * 16)
    call SetTextColor
    mGotoxy 40, 12
    mov edx, OFFSET fileSaveMsg
    call WriteString
    mov eax, 1500
    call Delay
    
saveGameError:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
SaveGameProgress ENDP

LoadGameProgress PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Open file for reading
    mov edx, OFFSET saveFilename
    call OpenInputFile
    
    cmp eax, INVALID_HANDLE_VALUE
    je loadGameError
    
    mov fileHandle, eax
    
    ; Clear buffer
    mov edi, OFFSET buffer
    mov ecx, 256
    mov al, 0
    rep stosb
    
    ; Read from file
    mov eax, fileHandle
    mov edx, OFFSET buffer
    mov ecx, 255
    call ReadFromFile
    mov bytesWritten, eax
    
    ; Close file
    mov eax, fileHandle
    call CloseFile
    
    ; Check if data was read
    cmp bytesWritten, 0
    je loadGameError
    
    ; Parse: NAME|SCORE|WORLD|LEVEL|LIVES|TIME
    mov esi, OFFSET buffer
    
    ; Parse name
    mov edi, OFFSET playerName
    parseLoadName:
        lodsb
        cmp al, '|'
        je loadNameDone
        cmp al, 0
        je loadGameError
        stosb
        jmp parseLoadName
    loadNameDone:
    mov al, 0
    stosb
    
    ; Parse score
    call ParseScoreField
    mov score, eax
    
    ; Parse world
    lodsb
    sub al, '0'
    mov currentWorld, al
    inc esi  ; Skip '|'
    
    ; Parse level
    lodsb
    sub al, '0'
    mov currentLevel, al
    inc esi  ; Skip '|'
    
    ; Parse lives
    lodsb
    sub al, '0'
    mov lives, al
    inc esi  ; Skip '|'
    
    ; Parse time
    call ParseScoreField  ; Reuse this for time
    mov gameTime, ax
    
    ; Show load message
    call clrscr
    mov eax, green + (black * 16)
    call SetTextColor
    mGotoxy 40, 12
    mov edx, OFFSET fileLoadMsg
    call WriteString
    mov eax, 1500
    call Delay
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
    
loadGameError:
    ; Show error message
    call clrscr
    mov eax, red + (black * 16)
    call SetTextColor
    mGotoxy 40, 12
    mov edx, OFFSET fileErrorMsg
    call WriteString
    mov eax, 1500
    call Delay
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
LoadGameProgress ENDP

DwordToAscii PROC
    ; Converts DWORD in EAX to ASCII string at EDI
    ; Preserves all registers except EDI (moves forward)
    push eax
    push ebx
    push ecx
    push edx
    
    mov ebx, 10
    xor ecx, ecx
    
    ; Handle zero
    cmp eax, 0
    jne pushDigits
    mov al, '0'
    stosb
    jmp doneConvert
    
    pushDigits:
        cmp eax, 0
        je popDigits
        xor edx, edx
        div ebx
        add dl, '0'
        push edx
        inc ecx
        jmp pushDigits
    
    popDigits:
        cmp ecx, 0
        je doneConvert
        pop eax
        stosb
        dec ecx
        jmp popDigits
    
    doneConvert:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DwordToAscii ENDP

AsciiToDword PROC
    ; Converts ASCII string at ESI to DWORD in EAX
    ; Stops at | or newline or null
    push ebx
    push ecx
    push edx
    
    xor eax, 0
    xor ebx, 0
    mov ecx, 10
    
    convertLoop:
        mov bl, [esi]
        cmp bl, '|'
        je doneAsciiConvert
        cmp bl, 0Dh
        je doneAsciiConvert
        cmp bl, 0Ah
        je doneAsciiConvert
        cmp bl, 0
        je doneAsciiConvert
        cmp bl, '0'
        jl doneAsciiConvert
        cmp bl, '9'
        jg doneAsciiConvert
        
        mul ecx
        sub bl, '0'
        add eax, ebx
        inc esi
        jmp convertLoop
    
    doneAsciiConvert:
    pop edx
    pop ecx
    pop ebx
    ret
AsciiToDword ENDP

UpdateHighScores PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Check if current score beats any high score
    mov eax, score
    
    ; Check against 1st place
    cmp eax, highScore1Score
    jg newFirstPlace
    
    ; Check against 2nd place
    cmp eax, highScore2Score
    jg newSecondPlace
    
    ; Check against 3rd place
    cmp eax, highScore3Score
    jg newThirdPlace
    
    ; Score doesn't make top 3, but still save to file
    jmp saveAndExit
    
newFirstPlace:
    ; Shift down 2nd to 3rd
    mov esi, OFFSET highScore2Name
    mov edi, OFFSET highScore3Name
    mov ecx, 20
    rep movsb
    mov eax, highScore2Score
    mov highScore3Score, eax
    mov al, highScore2Level
    mov highScore3Level, al
    
    ; Shift down 1st to 2nd
    mov esi, OFFSET highScore1Name
    mov edi, OFFSET highScore2Name
    mov ecx, 20
    rep movsb
    mov eax, highScore1Score
    mov highScore2Score, eax
    mov al, highScore1Level
    mov highScore2Level, al
    
    ; Set new 1st place
    mov esi, OFFSET playerName
    mov edi, OFFSET highScore1Name
    mov ecx, 20
    rep movsb
    mov eax, score
    mov highScore1Score, eax
    mov al, currentLevel
    mov highScore1Level, al
    jmp saveAndExit
    
newSecondPlace:
    ; Shift down 2nd to 3rd
    mov esi, OFFSET highScore2Name
    mov edi, OFFSET highScore3Name
    mov ecx, 20
    rep movsb
    mov eax, highScore2Score
    mov highScore3Score, eax
    mov al, highScore2Level
    mov highScore3Level, al
    
    ; Set new 2nd place
    mov esi, OFFSET playerName
    mov edi, OFFSET highScore2Name
    mov ecx, 20
    rep movsb
    mov eax, score
    mov highScore2Score, eax
    mov al, currentLevel
    mov highScore2Level, al
    jmp saveAndExit
    
newThirdPlace:
    ; Set new 3rd place
    mov esi, OFFSET playerName
    mov edi, OFFSET highScore3Name
    mov ecx, 20
    rep movsb
    mov eax, score
    mov highScore3Score, eax
    mov al, currentLevel
    mov highScore3Level, al
    
saveAndExit:
    ; *** IMPORTANT: Always save to file ***
    call SaveHighScoresToFile
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
UpdateHighScores ENDP

SaveHighScoresToFile PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Create/Open file for writing
    mov edx, OFFSET highscoreFilename
    call CreateOutputFile
    mov fileHandle, eax
    
    cmp eax, INVALID_HANDLE_VALUE
    je saveHSError
    
    ; Clear buffer
    mov edi, OFFSET buffer
    mov ecx, 256
    mov al, 0
    rep stosb
    
    mov edi, OFFSET buffer
    
    ; === Write High Score 1 ===
    mov esi, OFFSET highScore1Name
    copyHS1Name:
        lodsb
        cmp al, 0
        je hs1NameDone
        stosb
        jmp copyHS1Name
    hs1NameDone:
    
    mov al, '|'
    stosb
    mov eax, highScore1Score
    call DwordToAscii
    mov al, '|'
    stosb
    movzx eax, highScore1Level
    add al, '0'
    stosb
    mov ax, 0A0Dh  ; CR+LF
    stosw
    
    ; === Write High Score 2 ===
    mov esi, OFFSET highScore2Name
    copyHS2Name:
        lodsb
        cmp al, 0
        je hs2NameDone
        stosb
        jmp copyHS2Name
    hs2NameDone:
    
    mov al, '|'
    stosb
    mov eax, highScore2Score
    call DwordToAscii
    mov al, '|'
    stosb
    movzx eax, highScore2Level
    add al, '0'
    stosb
    mov ax, 0A0Dh
    stosw
    
    ; === Write High Score 3 ===
    mov esi, OFFSET highScore3Name
    copyHS3Name:
        lodsb
        cmp al, 0
        je hs3NameDone
        stosb
        jmp copyHS3Name
    hs3NameDone:
    
    mov al, '|'
    stosb
    mov eax, highScore3Score
    call DwordToAscii
    mov al, '|'
    stosb
    movzx eax, highScore3Level
    add al, '0'
    stosb
    mov ax, 0A0Dh
    stosw
    
    ; Null terminate
    mov al, 0
    stosb
    
    ; Calculate length
    mov ecx, edi
    sub ecx, OFFSET buffer
    dec ecx  ; Don't count null terminator
    
    ; Write to file
    mov eax, fileHandle
    mov edx, OFFSET buffer
    call WriteToFile
    
    ; Close file
    mov eax, fileHandle
    call CloseFile
    
saveHSError:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
SaveHighScoresToFile ENDP

LoadHighScores PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Initialize defaults
    mov highScore1Score, 0
    mov highScore2Score, 0
    mov highScore3Score, 0
    mov highScore1Level, 1
    mov highScore2Level, 1
    mov highScore3Level, 1
    
    ; Set default names
    mov edi, OFFSET highScore1Name
    mov al, 'A'
    stosb
    stosb
    stosb
    mov al, 0
    stosb
    
    mov edi, OFFSET highScore2Name
    mov al, 'B'
    stosb
    stosb
    stosb
    mov al, 0
    stosb
    
    mov edi, OFFSET highScore3Name
    mov al, 'C'
    stosb
    stosb
    stosb
    mov al, 0
    stosb
    
    ; Try to open file
    mov edx, OFFSET highscoreFilename
    call OpenInputFile
    
    cmp eax, INVALID_HANDLE_VALUE
    je loadHSError
    
    mov fileHandle, eax
    
    ; Clear buffer
    mov edi, OFFSET buffer
    mov ecx, 256
    mov al, 0
    rep stosb
    
    ; Read from file
    mov eax, fileHandle
    mov edx, OFFSET buffer
    mov ecx, 255
    call ReadFromFile
    mov bytesWritten, eax
    
    ; Close file
    mov eax, fileHandle
    call CloseFile
    
    ; Check if any data was read
    cmp bytesWritten, 0
    je loadHSError
    
    ; Parse high scores
    mov esi, OFFSET buffer
    
    ; === Parse High Score 1 ===
    mov edi, OFFSET highScore1Name
    call ParseNameField
    call ParseScoreField
    mov highScore1Score, eax
    call ParseLevelField
    mov highScore1Level, al
    call SkipToNextLine
    
    ; === Parse High Score 2 ===
    mov edi, OFFSET highScore2Name
    call ParseNameField
    call ParseScoreField
    mov highScore2Score, eax
    call ParseLevelField
    mov highScore2Level, al
    call SkipToNextLine
    
    ; === Parse High Score 3 ===
    mov edi, OFFSET highScore3Name
    call ParseNameField
    call ParseScoreField
    mov highScore3Score, eax
    call ParseLevelField
    mov highScore3Level, al
    
loadHSError:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
LoadHighScores ENDP

; Helper: Parse name until '|'
ParseNameField PROC
    push ebx
    parseNameLoop:
        lodsb
        cmp al, '|'
        je nameFieldDone
        cmp al, 0
        je nameFieldDone
        cmp al, 0Dh
        je nameFieldDone
        stosb
        jmp parseNameLoop
    nameFieldDone:
    mov al, 0
    stosb
    pop ebx
    ret
ParseNameField ENDP

; Helper: Parse score until '|'
ParseScoreField PROC
    push ebx
    push ecx
    push edx
    
    xor eax, eax
    mov ecx, 10
    
    parseScoreLoop:
        mov bl, [esi]
        cmp bl, '|'
        je scoreFieldDone
        cmp bl, 0
        je scoreFieldDone
        cmp bl, 0Dh
        je scoreFieldDone
        cmp bl, '0'
        jl scoreFieldDone
        cmp bl, '9'
        jg scoreFieldDone
        
        mul ecx
        sub bl, '0'
        movzx edx, bl
        add eax, edx
        inc esi
        jmp parseScoreLoop
    
    scoreFieldDone:
    inc esi  ; Skip '|'
    pop edx
    pop ecx
    pop ebx
    ret
ParseScoreField ENDP

; Helper: Parse level (single digit)
ParseLevelField PROC
    lodsb
    cmp al, '0'
    jl invalidLevel
    cmp al, '9'
    jg invalidLevel
    sub al, '0'
    ret
    invalidLevel:
    mov al, 1
    ret
ParseLevelField ENDP

; Helper: Skip to next line
SkipToNextLine PROC
    push eax
    skipLoop:
        lodsb
        cmp al, 0Ah
        je lineDone
        cmp al, 0
        je lineDone
        jmp skipLoop
    lineDone:
    pop eax
    ret
SkipToNextLine ENDP

;-------------------------------------------------------------------------
;------------------------------- AUDIO -----------------------------------
;-------------------------------------------------------------------------
playBgSound PROC
    pushad 
    INVOKE PlaySoundA, OFFSET bgMusic, 0, 20009h
    popad
ret
playBgSound ENDP


;-------------------------------------------------------------------------
;------------------------------- OTHERS ----------------------------------
;-------------------------------------------------------------------------
CheckLives PROC
cmp lives, 0
jne alive
    ; player dies
    call ShowGameOver
    jmp GaMeOvEr
alive:
ret
CheckLives ENDP

ShowGameOver PROC
    mov eax, red + (black * 16)
    call SetTextColor
    call clrscr
    
    mov ecx, 20
    gameOverLoopt:
        mGotoxy 0, 10
        mov edx, OFFSET gameover1
        call WriteString
        mov edx, OFFSET gameover2
        call WriteString
        mov edx, OFFSET gameover3
        call WriteString
        mov edx, OFFSET gameover4
        call WriteString
        mov edx, OFFSET gameover5
        call WriteString
        mov edx, OFFSET gameover6
        call WriteString
        
        call crlf
        call crlf
        mGotoxy 40, 18
        mWrite "Final Score: "
        mov eax, score
        call WriteDec
        call crlf
        call crlf
    loop gameOverLoopt

        mGotoxy 40, 21
        mov edx, OFFSET pressEnter
        call WriteString
        
        
    
    call ReadChar
    ret
ShowGameOver ENDP

CalculateFlagpoleBonus PROC
    push eax
    push ebx
    
    mov levelEndBonus, 0
    
    ; Calculate position bonus based on player Y position
    mov al, yPos
    mov bl, 28  ; Ground level
    
    ; Top of flagpole (Y <= 20)
    cmp al, 20
    jg checkMiddle
    add levelEndBonus, 5000
    jmp calculateTimeBonus
    
    checkMiddle:
    ; Middle (21 <= Y <= 24)
    cmp al, 24
    jg checkBottom
    add levelEndBonus, 2000
    jmp calculateTimeBonus
    
    checkBottom:
    ; Bottom (Y >= 25)
    add levelEndBonus, 100
    
    calculateTimeBonus:
    ; Time bonus: each second × 50 points
    movzx eax, gameTime
    mov ebx, 50
    mul ebx
    add levelEndBonus, eax
    
    ; Add to total score
    mov eax, levelEndBonus
    add score, eax
    
    pop ebx
    pop eax
    ret
CalculateFlagpoleBonus ENDP

ShowLevelEndBonus PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Display bonus breakdown
    mov eax, yellow + (blue * 16)
    call SetTextColor
    
    mGotoxy 35, 10
    mWrite "LEVEL COMPLETE!"
    
    call crlf
    call crlf
    
    ; Calculate position bonus separately
    mov eax, levelEndBonus
    push eax                    ; Save total bonus
    
    ; Calculate time bonus
    movzx eax, gameTime
    mov ebx, 50
    mul ebx                     ; eax = time bonus
    
    pop ebx                     ; Get total bonus back
    push eax                    ; Save time bonus
    sub ebx, eax                ; ebx = position bonus
    
    ; Display Flagpole Bonus (position only)
    mGotoxy 35, 13
    mWrite "Flagpole Bonus: "
    mov eax, ebx
    call WriteDec
    
    ; Display Time Bonus
    call crlf
    mGotoxy 35, 14
    mWrite "Time Bonus: "
    pop eax                     ; Get time bonus back
    call WriteDec
    mWrite " ("
    movzx eax, gameTime
    call WriteDec
    mWrite " sec x 50)"
    
    ; Display Total Score
    call crlf
    call crlf
    mGotoxy 35, 16
    mWrite "Total Score: "
    mov eax, score
    call WriteDec
    
    mov eax, 3000
    call Delay
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
ShowLevelEndBonus ENDP


;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;------------------------------ MAIN() -----------------------------------
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
main PROC
     ;bg music
     call playBgSound

    ; Load high scores at start
    call LoadHighScores
    
MainGameLoop:
    ; Show menu
    call MainMenu
    
    ; Show loading screen for Level 1
    mov currentWorld, 1
    mov currentLevel, 1
    call ShowLoadingScreen
    
    ; Start Level 1
    call Level1
    
    ; Level 1 complete screen
    call ShowLevelComplete
    ;call UpdateHighScores
    
    ; Show loading screen for Level 2
    mov currentWorld, 2
    mov currentLevel, 1
    call ShowLoadingScreen
    
    ; Start Level 2
    call Level2
    ; After Level2 completes Loop back to menu

GaMeOvEr::                ;when player dies, go back to mainmenu without any scores.
    jmp MainGameLoop
    
    exitGame::
    call EndGame
    exit
main ENDP
end main
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
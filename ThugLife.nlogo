breed [cops cop]
breed [thugs thug]
breed [cash acash]

cops-own [reputation]
thugs-own [morale]
cash-own [respawntimer]

to setup
  clear-all
  reset-ticks
  create-cops initial-cops
  create-thugs initial-thug
  create-cash initial-cash

  ask patches
  [
    set pcolor 4.5
  ]

  ask cops
  [
    set shape "person police"
    set size 5
    setxy random-xcor random-ycor
    set reputation initial-reputation
  ]
  ask thugs
  [
    set shape "person thug"
    set size 5
    setxy random-xcor random-ycor
    set morale initial-morale
  ]
  ask cash
  [
    set shape "cash"
    set color green
    set size 5
    setxy random-xcor random-ycor
  ]

end

to go
  ask patches
  [
    set pcolor 4.5
  ]

  ask cops
  [
  if ticks mod 5 = 0
  [
    set reputation reputation - 5
    set label reputation
  ]
    if employ-flip?
    [
      hatch-cops 1
      [
        set reputation initial-reputation
        right random 360
        forward .6
      ]
    ]

    ifelse coin-flip? [right random 10] [left random 10]
    forward .6


     ask patches in-cone flashlight-range 40
     [
       set pcolor 9.1
     ]
    if any? thugs in-cone flashlight-range 40
    [
      set reputation (reputation + reputation-per-arrest)
      set label reputation
      ask thugs in-cone flashlight-range 40
      [
        die
      ]
    ]
    if reputation = 0
    [
      die
    ]
   ]

  ask thugs
  [
  if ticks mod 5 = 0
  [
    set morale morale - 5
    set label morale
  ]

    if recruit-flip?
    [
      hatch-thugs 1
      [
        set morale initial-morale
        right random 360
        forward .5
      ]
    ]

    ifelse coin-flip? [right random 10] [left random 10]
    forward .5

    if any? cash with [hidden? = false] in-radius 4
    [
      set morale (morale + morale-per-steal)
      set label morale
      ask cash in-radius 4
      [
        hide-turtle
        set respawntimer cash-respawn-time * 10
      ]
    ]
    if morale = 0
    [
      die
    ]

  ]

  ask cash
  [
   if respawntimer != 0
    [
    set respawntimer (respawntimer - 1)
    ]

   if respawntimer = 0
    [
    show-turtle
    ]
  ]
  tick
end

to-report coin-flip?
  report random 2 = 0
end

to-report employ-flip?
  report random-float 100 <= employ-rate
end

to-report recruit-flip?
  report random-float 100 <= recruit-rate
end
@#$#@#$#@
GRAPHICS-WINDOW
418
15
1355
953
-1
-1
6.15232
1
10
1
1
1
0
1
1
1
-75
75
-75
75
1
1
1
ticks
30.0

BUTTON
84
26
148
59
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
85
70
148
103
Go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
84
114
147
147
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
182
73
354
106
initial-thug
initial-thug
0
50
30.0
1
1
NIL
HORIZONTAL

SLIDER
182
110
354
143
initial-cops
initial-cops
0
30
10.0
1
1
NIL
HORIZONTAL

SLIDER
15
202
187
235
cash-respawn-time
cash-respawn-time
1
50
20.0
1
1
NIL
HORIZONTAL

SLIDER
11
290
183
323
employ-rate
employ-rate
0
1.5
0.3
.001
1
NIL
HORIZONTAL

SLIDER
11
333
183
366
recruit-rate
recruit-rate
0
1.5
0.85
.001
1
NIL
HORIZONTAL

SLIDER
182
36
354
69
initial-cash
initial-cash
0
500
150.0
5
1
NIL
HORIZONTAL

SLIDER
207
465
379
498
morale-per-steal
morale-per-steal
0
200
25.0
5
1
NIL
HORIZONTAL

SLIDER
207
428
379
461
reputation-per-arrest
reputation-per-arrest
0
200
25.0
5
1
NIL
HORIZONTAL

TEXTBOX
17
257
167
285
Cop Employment (birth) Rate\nThugs Recruit (birth) Rate
11
0.0
1

SLIDER
204
204
376
237
flashlight-range
flashlight-range
0
20
18.0
1
1
NIL
HORIZONTAL

SLIDER
208
335
380
368
initial-morale
initial-morale
0
500
150.0
5
1
NIL
HORIZONTAL

SLIDER
208
290
380
323
initial-reputation
initial-reputation
0
500
150.0
5
1
NIL
HORIZONTAL

TEXTBOX
226
261
376
289
Cop Initial Reputation (energy)\nThug Initial Morale (energy
11
0.0
1

TEXTBOX
28
185
178
203
Cash Respawn Time
11
0.0
1

TEXTBOX
214
189
364
207
Cop Flashlight Range
11
0.0
1

TEXTBOX
215
391
365
419
Cop Reputation Per Arrest\nThug Morale Per Steal
11
0.0
1

PLOT
0
413
200
563
Population
Time
Population
0.0
1000.0
0.0
50.0
true
false
"" ""
PENS
"default" 1.0 0 -13345367 true "" "plot count cops"
"pen-1" 1.0 0 -2674135 true "" "plot count thugs"

MONITOR
227
519
305
564
Thug Count
count thugs
17
1
11

MONITOR
219
578
291
623
Cop Count
count cops
17
1
11

@#$#@#$#@
## WHAT IS IT?

ThugLife is an ecosystem simulator that contains 3 types of agents, namely cash, thugs, and cops. The simulator is set in a bank with the lights out. The cops in the bank look around the bank to look for thugs looking to steal the money in the bank using their flashlights.

## HOW IT WORKS

###  Environment and Movement:
Cops and Thugs wander randomly around the environment similar to predators and prey in an actual ecosystem. The environment contains a set amount of cash located around the environment for thugs to steal. Cash is a finite resource that gets stolen and respawns after a set amount of time.

### Cops
Cops look for thugs to  arrest using their flashlights. Thugs caught in the cops' flashlights are arrested. Cops lose their reputation the longer they don't make an arrest so they must arrest a thug to gain more reputation. Cops are fired if they run out of reputation (The chief fires them because they aren't productive). To continue the growth of their population, each cop has the ability to employ another cop at  a fixed probability.

### Thugs
Thugs look for cash they can find in the bank and they must steal cash in order to maintain their morale. Thugs lose their morale or their will to live a life of crime if they aren't able to steal cash. They gain morale when they steal. They leave the life of crime if they run out of morale (or enthusiasm to commit crime). Thugs have a fixed probability to recruit more criminals or thugs to their cause.

## HOW TO USE IT

### Go and Start
Press the setup button to set up the environment and press the Go button to start the simulation

### Sliders
The simulation contains sliders that the user can manipulate. The user can manipulate the following:
#### initial-cash
The initial amount of cash agents in the environment.

#### initial-thug
The initial amount of thug agents in the environment.

#### initial-cops
The initial amount of cops agents in the environment.

#### cash-respawn-time
the amount of time before cash respawns.

#### flashlight-range
The range of the flashlights that cops use to arrest thugs.

#### employ-rate
The probability of cops employing another cop per tick.

#### recruit-rate
The probability of thugs recruiting another thug per tick.

#### initial-reputation
The initial reputation that cops have when they're spawned or employed.

#### initial-morale
The initial morale that thugs have when they're spawned or recruited.

#### reputation-per-arrest
The amount of reputation cops obtain when they arrest a thug

#### morale-per-steal
The amount of morale thugs obtain when they steal a stack of cash
 
## THINGS TO NOTICE
The population plot of both the cops (blue) and thugs (red)

## THINGS TO TRY
Move the sliders around to try to last longer.

Default values in the file are what the developer found to last longest so far.

@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

cash
false
0
Polygon -7500403 true true 120 240 270 165 270 105 120 165
Polygon -7500403 true true 120 165 15 135 180 90 270 105
Polygon -7500403 true true 15 135 16 205 120 240 120 165
Line -16777216 false 120 240 120 165
Line -16777216 false 120 165 15 135
Line -16777216 false 120 165 270 105
Line -16777216 false 120 180 195 150
Line -16777216 false 165 195 270 150
Line -16777216 false 165 180 270 135
Line -16777216 false 15 165 105 195
Line -16777216 false 60 165 120 180
Line -16777216 false 75 210 120 225
Polygon -16777216 false false 119 111 115 114 112 120 111 125 113 133 122 138 136 138 147 138 159 136 172 133 180 128 186 126 191 121 190 115 187 110 181 107 171 104 161 103 149 104 142 104 134 107 125 109

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

hotdog
true
0
Rectangle -6459832 true false 45 105 255 225
Rectangle -2674135 true false 60 135 240 195
Circle -2674135 true false 30 135 60
Circle -2674135 true false 210 135 60

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person police
false
0
Polygon -1 true false 124 91 150 165 178 91
Polygon -13345367 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -13345367 true false 120 90 105 90 60 195 90 210 116 158 120 195 180 195 184 158 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Rectangle -6459832 true false 123 76 176 92
Circle -6459832 true false 110 5 80
Polygon -13345367 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Rectangle -16777216 true false 109 183 124 227
Rectangle -16777216 true false 176 183 195 205
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 172 112 191 112 185 133 179 133
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24
Rectangle -16777216 true false 101 177 122 187
Rectangle -16777216 true false 179 164 183 186
Polygon -16777216 true false 225 165 210 210 231 211 243 182 283 187 289 170 227 164 224 166

person thug
false
0
Circle -16777216 true false 105 0 90
Polygon -16777216 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -6459832 true false 127 79 172 94
Polygon -16777216 true false 191 91 236 151 221 181 161 106
Polygon -16777216 true false 109 90 64 150 79 180 139 105
Circle -6459832 true false 157 19 22
Circle -6459832 true false 126 19 22
Circle -6459832 true false 141 46 22
Polygon -16777216 true false 66 130 80 174 65 184 56 157 8 163 9 143 70 136 67 137

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

plant medium
false
0
Rectangle -7500403 true true 135 165 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 165 120 120 150 90 180 120 165 165

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@

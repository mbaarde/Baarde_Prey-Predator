# Baarde_Prey-Predator

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

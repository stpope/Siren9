'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on February 23, 2022 at 12:01:33 PM'!


Smalltalk.Siren defineClass: #Score11
	superclass: #{Siren.EventGenerator}
	indexedType: #none
	private: false
	instanceVariableNames: 'start stop instrument generators postProcessors paramMap '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Score11 class methodsFor: 'instance creation'!

instr: iNum from: start to: stop
	"Answer an initialize instance of Score11"

	"TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4//8////4//'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> #(1.0 1.0 5.0); 
		add: #p6 -> (#mo -> #(5 1000 2000))) 
	eventList"

	"TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/8*4/6*3/4/'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> #(1.0 1.0 5.0); 
		add: #p6 -> (#mo -> #(5 1000 2000))) 
	eventList"

	^(self new initialize) instrument: iNum; start: start; stop: stop! !

!Siren.Score11 class methodsFor: 'examples'!

booh1
	"Score for the first section of 'Bat out of Hell' (1980-82)"
	"Score11 booh1"
	"100 timesRepeat: [Score11 booh1. (Delay forSeconds: 130) wait ]"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 120) 				"Score11 instrument block"
														"dur in sec"
		add: #p3 -> (#mx -> '15 .4 .5 , .05 .14 /			
						15 .1 .15 , .5 .4 /
						20 .5 .3 , .1 .13 /
						25 .2 .1 , .6 .6 /
						25 .5 .7 , .1 .06 /
						20 .12 .08 , .5 .5'); 
														"pitch in Hz"
		add: #p4 -> (#mx -> '20 2000 3000 , 2000 2100 /
						20 2050 2050 /
						30 2000 2100 , 2200 1600 /
						20 2400 2500 , 2800 2000 /
						30 2400 2400 , 2200 2100'); 
		add: (#p5 -> 0.1);								"ampl ratio"
		add: #p6 -> (#mx -> '100 1 1 , 1 1 / 20 1 1 , .8 1.2');	"gliss ratio"
		add: #p7 -> #(1.0 -1.0 1.0) ).						"L/R position"

	s11 du: 303.											"duty cycle sets evt dur to 3"
	s11 assign: #p6 to: #gliss:.
	s11 assign: #p7 to: #pos:.

	score := s11 eventList.								"generate the score and take an excerpt"
	score flushVoices.
	score := score excerptFrom: 0 to: 120.				"trim to the time alloted..."
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

booh3
	"Score for the first section of 'Bat out of Hell' (1980-82)"
	"Score11 booh3"
	"100 timesRepeat: [Score11 booh1. (Delay forSeconds: 130) wait ]"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 120) 				"Score11 instrument block"
																		"dur in sec"
		add: #p3 -> (#mx -> '15 .4 .5 , .05 .14 /			
						15 .1 .15 , .5 .4 /
						20 .5 .3 , .1 .13 /
						25 .2 .1 , .6 .6 /
						25 .5 .7 , .1 .06 /
						20 .12 .08 , .5 .5'); 
																		"pitch in Hz"
		add: #p4 -> (#mx -> '20 200 300 , 200 210 /
						20 205 205 /
						30 200 210 , 220 160 /
						20 240 250 , 280 200 /
						30 240 240 , 220 210'); 
		add: (#p5 -> 0.1);												"ampl ratio"
		add: #p6 -> (#mx -> '100 1 1 , 1 1 / 20 1 1 , .8 1.2') mapTo: #gliss:;	"gliss ratio"
		add: #p7 -> #(1.0 -1.0 1.0) mapTo: #pos:;							"L/R position"
		add: #p8 -> #(1.0 6.0 20.0) mapTo: #modInd:).					"modulation index"

	s11 du: 303.											"duty cycle sets evt dur to 3"
	s11 assign: #p6 .
	s11 assign: #p7 to: #pos:.

	score := s11 eventList.								"generate the score and take an excerpt"
	score flushVoices.
	score := score excerptFrom: 0 to: 120.				"trim to the time alloted..."
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

chorale1
	"Play the score for a Bach chorale on the CSL FM bell - http://scores.ccarh.org/bach/chorale/chorales.pdf #28"
	"Score11 chorale1"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 9) 				"Score11 instrument block for 9 beats"
															"dur in beats"
		add: #p3 -> (#rh -> '4/////2//'); 
															"pitch as chords"
		add: #p4 -> (#no -> 'f3:a4:c:f/f4:c5:f:a6/e4:c5:g:g/eb4:c:f:a5/d4:d:f:bb5/c4:g:e5:c/f4:c:f5:a/'); 
		add: #p5 -> #(1.0 0.25 0.3);							"ampl ratio"
		add: #p6 -> 1.0 mapTo: #gliss:;						"gliss ratio"
		add: #p7 -> #(1.0 1.0 -1.0) mapTo: #pos:;				"L/R position"
		add: #p8 -> #(1.0 4.0 8.0) mapTo: #modInd:).			"modulation index"

	s11 tempo: 100.										"speed it up"
	s11 du: 303.											"duty cycle sets evt dur to 3"

	score := s11 eventList.								"generate the score"
	score flushVoices.
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].
	score events removeLast.							"remove last note"

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

chorale2
	"Play the score for a Bach chorale on the CSL plucked string - http://scores.ccarh.org/bach/chorale/chorales.pdf #28"
	"Score11 chorale2"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 9) 				"Score11 instrument block for 9 beats"
														"dur in beats"
		add: #p3 -> (#rh -> '4/////2//'); 
														"pitch as chords"
		add: #p4 -> (#no -> 'f3:a4:c:f/f4:c5:f:a6/e4:c5:g:g/eb4:c:f:a5/d4:d:f:bb5/c4:g:e5:c/f4:c:f5:a/'); 
		add: #p5 -> #(1.0 0.85 0.95);						"ampl ratio"
		add: #p6 -> #(1.0 1.0 -1.0) mapTo: #pos:).			"L/R position"

	s11 tempo: 100.										"speed it up"
	s11 du: 303.											"duty cycle sets evt dur to 3"

	score := s11 eventList.								"generate the score"
	score flushVoices.
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 16 + 1) printString, '/pn')].
	score events removeLast.							"remove last note"

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLString.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

melody1
	"Play the score for a simple melody by Praetorius (Volta 201 from Terpsichore) on the CSL FM bell."
	"http://conquest.imslp.info/files/imglnks/usimg/f/f1/IMSLP464311-PMLP176492-PraetoriusTerpsichoreCantus.pdf" "p. 99"
	"Score11 melody1"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 32) 				"Score11 instrument block"
															"dur in beats"
		add: #p3 -> (#rh -> '4///8//4////2//1/
						4///8//4////2//1/'); 
															"pitch in note names"
		add: #p4 -> (#no -> 'c/d/e/d/e/f/e/d/c/e/f/g/
						c/d/e/d/e/f/e/d/c/e/d/c'); 
		add: #p5 -> #(1.0 0.15 0.25);							"ampl ratio"
		add: #p6 -> 1.0 mapTo: #gliss:;						"gliss ratio = 1"
		add: #p7 -> (#mo -> '32 1.0 -1.0') mapTo: #pos:;		"L/R position - pan"
		add: #p8 -> #(1.0 4.0 10.0) mapTo: #modInd:).		"modulation index = rand"

	s11 tempo: 280.										"speed it up"
	s11 du: 5.0.											"duty cycle < 100 scales evt dur by value"

	score := s11 eventList.								"generate the score"
	score flushVoices.
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].
	score events removeLast.							"remove last note"

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

melody1b
	"Play the score for a simple melody by Praetorius (Volta 201 from Terpsichore) via MIDI chan 1"
	"http://conquest.imslp.info/files/imglnks/usimg/f/f1/IMSLP464311-PMLP176492-PraetoriusTerpsichoreCantus.pdf  p. 99"
	"Score11 melody1b"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 32) 				"Score11 instrument block"
															"dur in sec"
		add: #p3 -> (#rh -> '4///8//4////2//1/
						4///8//4////2//1/'); 
															"pitch in Hz"
		add: #p4 -> (#no -> 'c/d/e/d/e/f/e/d/c/e/f/g/
						c/d/e/d/e/f/e/d/c/e/d/c'); 
		add: #p5 -> #(1.0 0.25 0.35);							"ampl ratio"
		add: #p6 -> 1.0 mapTo: #gliss:;						"gliss ratio"
		add: #p7 -> (#mo -> #(32 1.0 -1.0)) mapTo: #pos:;		"L/R position"
		add: #p8 -> #(1.0 4.0 10.0) mapTo: #modInd:).		"modulation index"

	s11 tempo: 280.										"speed it up"
	s11 du: 0.9.											"duty cycle < 100 scales evt dur by value"

	score := s11 eventList.								"generate the score and take an excerpt"
	score flushVoices.
	score events removeLast.							"remove last note (broken)"

	vox := MIDIVoice default.								"plug in the voice"
"	vox channel: 3."
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

sleepingSword1
	"Score for the first gestures of 'SleepingSword' (WIP 2021)"
	"Score11 sleepingSword1"

"Block 1: 3 clouds"
	| s11 score1 score2 vox dur1 |
	s11 := ((Score11 instr: 1 from: 0 to: 34) 								"Score11 instrument block"
																		"dur in sec"
		add: #p3 -> (#mx -> '5 0.08 0.08 , 0.1 0.12 / 5 0.1 0.1 , 0.12 0.07 / 2.0 2.0 2.0 / 
						5 0.08 0.08 , 0.1 0.12 / 5 0.1 0.1 , 0.12 0.07 / 2.0 2.0 2.0 / 
						5 0.077 0.077 , 0.1 0.12 / 5 0.1 0.1 , 0.12 0.07 
						'); 
																		"pitch in Hz"
		add: #p4 -> (#mx -> '3 1000 1000 , 960 1000 / 3 920 920 / 4 910 920 , 860 880 / 2 1000 1000 /
						3 1100 1100 , 1000 1070 / 3 930 930 / 4 900 960 , 840 910 / 2 1000 1000 /
						3 1000 1000 , 940 1000 / 3 940 940 / 4 900 940 , 890 960
						'); 
																		"ampl ratio"
		add: #p5 -> (#mx -> '4 0.03 0.05 / 6 0.05 0.1 / 2 0.00001 0.00001 /
						4 0.04 0.05 / 6 0.05 0.15  / 2 0.00001 0.00001 /
						4 0.04 0.04 / 6 0.04 0.15'
						);	
		add: #p6 -> #(1.0 0.8 1.2) mapTo: #gliss: ;							"gliss ratio"
		add: #p7 -> (#mx -> '12 -1.0 -0.3 / 
						12 -1.0 -0.1 /
						12 -0.4 0.2' 
						) mapTo: #pos: ;									"L/R position"
		add: #p8 -> #(1.0 3.0 4.0) mapTo: #modInd: ;						"modulation index"
		add: #p9 -> 1.0 mapTo: #wet: ).									"wet/dry"
	s11 du: 300.5.														"duty cycle sets evt dur to X - 300"

	score1 := s11 eventList.												"generate the score and take an excerpt"
	score1 := score1 excerptFrom: 0 to: 34.								"trim to the time alloted..."
	score1 events removeLast.											"remove last note"
	dur1 := score1 computeDuration.
	score1 flushVoices.													"flush voices and assign sequential instruments 41-57"
	score1 assignInstruments: [ :ind | ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].

"Block 2: spinning cloud"
	s11 := ((Score11 instr: 1 from: 0 to: 24) 								"Score11 instrument block"
																		"dur in sec"
		add: #p3 -> (#mx -> '5 0.08 0.08 , 0.08 0.09 / 5 0.08 0.08 , 0.06 0.06 / 2.0 2.0 2.0 / 
						2 0.06 0.075 , 0.06 0.06 / 8 0.06 0.06 / 2.0 2.0 2.0'
						); 
																		"pitch in Hz"
		add: #p4 -> (#mx -> '3 900 910 , 930 940 / 7 940 940 / 2 1000 1000 /
						7 940 940 / 3 940 940 , 930 940 / 2 1000 1000'
						); 
																		"ampl ratio"
		add: #p5 -> (#mx -> '6 0.1 0.15 / 4 0.15 0.15 /	2 0.0001 0.0001 /
						10 0.15 0.15  / 2 0.0001 0.0001'
						);	
		add: #p6 -> #(1.0 0.8 1.2) mapTo: #gliss: ;							"gliss ratio"
		add: #p7 -> (#mo -> '7 -0.1 0.1 , -0.1 0.1 / 5 -0.1 0.1 , -0.5 0.5 / 
						7 -0.5 0.5 , 0.2 0.2 / 5 0.2 0.2'
						) mapTo: #pos: ;									"L/R position"
		add: #p8 -> (#mx -> '7 3.0 4.0 , 3.0 4.0 / 5 3.0 4.0 , 2.0 3.0 / 
						7 2.0 3.0 , 2.0 2.2 / 5 2.0 2.2 , 2.0 2.0'
						) mapTo: #modInd: ;								"modulation index"
		add: #p9 -> 1.0 mapTo: #wet: ).									"wet/dry"
	s11 du: 300.5.														"duty cycle sets evt dur to X - 300"

	score2 := s11 eventList.												"generate the score and take an excerpt"
	score2 := score2 excerptFrom: 0 to: 24.								"trim to the time alloted..."
	score2 events removeLast.											"remove last note"
	score1 computeDuration.
	score2 flushVoices.													"flush voices and assign sequential instruments 41-57"
	score2 assignInstruments: [ :ind | ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].

"Post-processing"
	score1 applyBlock: [ :p | (PentatonicScale root: N re) nearestNoteTo: p asHz value] toProp: #pitch from: 12 to: 22.
	score1 applyBlock: [ :p | (BohlenPierceScale root: N mi) nearestNoteTo: p asHz value] toProp: #pitch from: 24 to: 34.
	score2 applyBlock: [ :p | (PentatonicScale root: N re) nearestNoteTo: p asHz value] toProp: #pitch.

"	score1 addAll: score2 at: dur1 + 3.0."									"concatenate event lists"
	score1 := score2.													"for testing"

"Play or inspect"
	vox := OSCVoice default.												"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score1 voice: vox.	
	InputState default shiftDown ifTrue: [^score1 inspect].					"inspect"
	score1 play															"play"! !

!Siren.Score11 class methodsFor: 'tests'!

test1
	"Open a TSV on a simple Score11 event list"
	"Score11 test1"

	TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4//8//16////32//////'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> #(1.0 1.0 5.0); 
		add: #p6 -> (#mo -> '5 1000 2000' )) 
	eventList!

test10
	"Inspect a simple Score11 event list - test rand dev"
	"Score11 test10"

	| s11 sco |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> #(1.0  0.2  0.2); 
		add: #p4 -> 440.0;
		add: #p5 -> 0.01).
"	s11 rdev: 0.03.
"	s11 rdev: #(10 0.0 0.1).
	sco := s11 eventList.
	sco scaleDurationsBy: 0.4.
	sco open!

test11: which val: val
	"Inspect a simple Score11 event list - test duty cycle settings"
	"Score11 test11: #scale val: 0.5"
	"Score11 test11: #add val: 0.5"
	"Score11 test11: #sub val: 0.1"
	"Score11 test11: #set val: 1.0"

	| s11 sco |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> #(1.0  0.5  0.5); 
		add: #p4 -> #(1.0  220  440);
		add: #p5 -> 0.01).
	which == #scale ifTrue: [s11 du: val].
	which == #add ifTrue: [s11 du: val + 100].
	which == #sub ifTrue: [s11 du: val + 200].
	which == #set ifTrue: [s11 du: val + 300].
	sco := s11 eventList.
	sco open!

test12
	"Inspect a simple Score11 event list - test chords"
	"Score11 test12"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 5) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#no -> 'c4:e:g:/d:fs:a/ef:g:bf/')).
	s11 eventList inspect!

test13
	"Inspect a simple Score11 event list - multi-segment sets"
	"Score11 test13"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#se -> '5 c5 e g / 5 d5 fs a4/')).
	s11 eventList inspect!

test14
	"Inspect/play a simple Score11 event list - test fm bell direct/reflected control"
	"Score11 test14"

	| s11 score1 vox |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '16/'); 						"start T"
		add: #p4 -> 440 Hz;
		add: #p5 -> 0.15;
		add: #p6 -> 1.0 mapTo: #gliss: ;
		add: #p7 -> 0.0 mapTo: #pos: ;
		add: #p8 -> 2.0 mapTo: #modInd: ;
		add: #p9 -> (#mo -> '10 0.0 1.0') mapTo: #wet: ).
	s11 du: 300.75.										"duty cycle sets evt dur to X - 300"

	score1 := s11 eventList.								"generate the score and take an excerpt"
	score1 := score1 excerptFrom: 0 to: 10.				"trim to the time alloted..."
	score1 events removeLast.							"remove last note"
	score1 computeDuration.
	score1 flushVoices.									"flush voices and assign sequential instruments 41-57"
	score1 assignInstruments: [ :ind | ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score1 voice: vox.	
	InputState default shiftDown ifTrue: [^score1 inspect].	"inspect"
	score1 play											"play"!

test2
	"Open a TSV on a simple Score11 event list"
	"Score11 test2"

	TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/8*4/6*3/12*6/4/'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> '10 10 100' );
		add: #p6 -> #(1.0 -1.0 1.0)) 
	eventList!

test3
	"Inspect a simple Score11 event list"
	"Score11 test3"

	 | s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/8*4/6*3/4/'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> '10 10 100' );
		add: #p6 -> #(1.0 -1.0 1.0);
		add: #p7 -> #(0.5 1 2  0.5 100 200);
		add: #p8 -> (#se -> '10 1 3 5 7 9' );
		add: #p9 -> (#mx -> '10 1 100' )
	).
	s11 assign: #p6 to: #position:.
	s11 assign: #p7 to: #attack:.
	s11 eventList inspect!

test4
	"Inspect a simple Score11 event list - test multi-segment moves"
	"Score11 test4"

	 | s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> 16); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5' ); 
		add: #p5 -> (#mo -> '7 5 100 / 3 100 5' )
	).
	s11 tempo: #(10 60 120).
	s11 eventList inspect!

test5
	"Inspect a simple Score11 event list - test dotted values"
	"Score11 test5"

	  | s11 |	
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/4./4../8'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> '7 5 100 / 3 100 5' )
	).
	s11 tempo: #(10 60 120).
	s11 eventList inspect!

test6
	"Inspect a simple Score11 event list - test rests"
	"Score11 test6"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/-4/8/-8'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> '7 5 100 / 3 100 5' )
	).
	s11 tempo: #(10 60 120).
	s11 eventList inspect!

test7
	"Inspect a simple Score11 event list - test complex movex"
	"Score11 test7"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 15) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#mx -> '5 100 120 , 2000 2400 /
						4 2050 2060 /
						6 2000 2100 , 700 1100' )).
	s11 eventList inspect!

test7b
	"Inspect a simple Score11 event list - test complex linear move with const clauses"
	"Score11 test7b"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 15) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#mo -> '5 100 120 , 2000 2000 /
						4 2050 2060 / 3 2100 /
						3 2000 2100 , 700 1100' )).
	s11 eventList inspect!

test7c
	"Inspect a simple Score11 event list - test complex movex with const clauses"
	"Score11 test7c"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 15) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#mx -> '5 100 120 , 2000 2000 /
						4 2050 2060 / 3 2100 /
						3 2000 2100 , 700 1100' )).
	s11 eventList inspect!

test8
	"Inspect a simple Score11 event list - test complex movex"
	"Score11 test8"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 8) 
		add: #p3 -> (#rh -> '32/'); 
		add: #p4 -> (#mx -> '3 140 190 , 400 440 /
						2 440 460 /
						3 400 400 , 150 250' )).
	s11 eventList inspect!

test9: which
	"Inspect a simple Score11 event list - test tempo maps"
	"Score11 test9: #accel"
	"Score11 test9: #decel"
	"Score11 test9: #both"
	"Score11 test9: #complex"

	| s11 sco |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> #(1.0  0.15  0.15); 
		add: #p4 -> 440.0;
		add: #p5 -> 0.01).
	which == #accel ifTrue: [s11 tempo: #(10 60 180)].
	which == #decel ifTrue: [s11 tempo: #(10 180 60)].
	which == #both ifTrue: [s11 tempo: #(5 60 180  5 180 60)].
	which == #complex ifTrue: [s11 tempo: #(3 60 180  2 180 60  5 120 40)].
	sco := s11 eventList.
	sco scaleDurationsBy: 0.1.
	sco open! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Score11 comment:
'chorale1
	"Play the score for a Bach chorale on the FM bell - http://scores.ccarh.org/bach/chorale/chorales.pdf #28"
	"Score11 chorale1"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 9) 				"Score11 instrument block for 9 beats"
															"dur in beats"
		add: #p3 -> (#rh -> ''4/////2//''); 
															"pitch as chords"
		add: #p4 -> (#no -> ''f3:a4:c:f/f4:c5:f:a6/e4:c5:g:g/eb4:c:f:a5/d4:d:f:bb5/c4:g:e5:c/f4:c:f5:a/''); 
		add: #p5 -> #(1.0 0.25 0.3);							"ampl ratio"
		add: #p6 -> 1.0 mapTo: #gliss:;						"gliss ratio"
		add: #p7 -> #(1.0 1.0 -1.0) mapTo: #pos:;				"L/R position"
		add: #p8 -> #(1.0 4.0 8.0) mapTo: #modInd:).			"modulation index"

	s11 tempo: 100.										"speed it up"
	s11 du: 303.											"duty cycle sets evt dur to 3"

	score := s11 eventList.								"generate the score"
	score flushVoices.
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: (''/i'', (ind - 1 \\ 16 + 41) printString, ''/pn'')].
	score events removeLast.							"remove last note"

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"'!

!Siren.Score11 methodsFor: 'initialize-release'!

initialize
	"Initialize an instance with default state."

	generators := Dictionary new.
	paramMap := Dictionary new.
	postProcessors := Dictionary new! !

!Siren.Score11 methodsFor: 'accessing'!

add: instAssoc
	"Add a generator clause to the receiver"

	generators at: instAssoc key put: instAssoc value!

add: instAssoc mapTo: prop
	"Add a generator clause to the receiver"

	generators at: instAssoc key put: instAssoc value.
	self assign: instAssoc key to: prop!

assign: param to: property
	"Add a parameter map clause to the receiver"

	paramMap at: param put: property!

du: dutyCycle
	"Add a duty cycle post-processor to the receiver"

	postProcessors at: #duty:list: put: dutyCycle!

instrument: inst
	instrument := inst!

rdev: skew
	"Set the start-time skew of the receiver"

	postProcessors at: #rdev:list: put: skew!

start: val
	start := val!

stop: val
	stop := val!

tempo: arr
	"Set the tempo curve of the receiver"

	postProcessors at: #tempo:list: put: arr! !

!Siren.Score11 methodsFor: 'playing'!

eventList
	"Answer an eventList for the receiver."

	| eList param keys |
	eList := EventList newNamed: 'Score11-I', instrument printString.	"create new event list"
	keys := generators keys copy.
	param := generators at: #p3.					"P3 is required"
	param ifNil: [self error: 'No duration data?'].
	self writeP3: param into: eList.
	keys remove: #p3.
												"Process optional parameters"
	self populate: #p4 required: false as: #pitch: into: eList.
	keys remove: #p4 ifAbsent: [nil].

	self populate: #p5 required: false as: #loudness: into: eList.
	keys remove: #p5 ifAbsent: [nil].

	keys do: [ :aK |
		(paramMap includesKey: aK)
			ifTrue: [self populate: aK required: false as: (paramMap at: aK) into: eList]
			ifFalse: [self populate: aK required: false as: (aK, ':') asSymbol into: eList]].

	postProcessors keysAndValuesDo:
		[ :key :val |
		self perform: key with: val with: eList].

	^eList! !

!Siren.Score11 methodsFor: 'private-generators'!

populate: param required: isReq as: property into: eList
	"Execute the generator for the given key and property"
	"self populate: #p4 required: false as: #pitch into: eList.
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 		-- sequential scale
		add: #p5 -> (#mo -> '10 10 100' );			-- linear move
		add: #p5 -> #(1.0 1.0 5.0);					-- rand range
		add: #p7 -> #(0.5 1 2  0.5 100 200);			-- mix of ranges
		add: #p8 -> (#se -> '10 1 3 5 7 9' );			-- set
		add: #p5 -> (#mx -> '5 4 100 / 5 100 5' )		-- multi-stage exponential move
		add: #p5 -> (#mx -> '3 100 100 , 100 96' )		-- multi-stage exponential tendancy mask move
		add: #p4 -> (#nu -> '1./.5*3/.25//-.5/1.5' )		-- numerical sequences
 	 "

	| item key val |
	item := generators at: param ifAbsent: [nil].
	(isReq and: [item isNil])
		ifTrue: [self error: 'No data for ', property, '?'].
	(isReq not and: [item isNil])
		ifTrue: [^self].
	(item isImmediate or: [item respondsToArithmetic]) ifTrue:		"handle consts"
		[^self writeConst: property from: item into: eList].
	item isAssociation ifFalse:			"handle range arrays"
		[^self writeRand: property from: item into: eList].
	key := item key.
	val := item value.
	key == #no ifTrue: [^self writeNotes: property from: val into: eList].
	key == #nu ifTrue: [^self writeNumerical: property from: val into: eList].
	key == #se ifTrue: [^self writeSet: property from: val into: eList].
	key == #mo ifTrue: [^self writeMove: property from: val into: eList].
	key == #mx ifTrue: [^self writeMoveX: property from: val into: eList].
	self error: 'Unknown Score11 term'!

writeConst: property from: val into: eList
	"Parse and process the numerical keyword to generate events"
	"aScore11 add: (#p5 -> 70); "

	| evts |
	evts := eList events.
	evts do:									"event loop"
		[ :eAss | | tN |
		tN := eAss time asSec value.
		(tN >= start and: [tN <= stop]) ifTrue:
			[eAss event perform: property with: val]]!

writeMove0: property from: array into: eList
	"Parse and process the linear move keyword to generate events"
	"aScore11 add: #p5 -> (#mo -> #(10 10 100))"
	"aScore11 add: #p6 -> (#mo -> '100 1 1 , 1 1 / 20 1 1 , .9 1.1'); "

	| evts tOffset |
	evts := eList events.
	tOffset := start.
 	array size \\ 3 = 0 ifFalse:				"use a single range, ignoring the percentage value"
		[self error: 'Wrong array size in parseRanges'].
	1 to: array size by: 3 do:				"loop through the segments"
		[ :ind | | v0 v1 vDiff t0 t1 tDiff segDur |
		segDur := array at: ind.
		v0 := array at: ind + 1.
		v1 := array at: ind + 2.
		vDiff := v1 - v0.
		t0 := tOffset.
		t1 := tOffset + segDur.
		tDiff := t1 - t0.
		evts do:							"event loop"
			[ :eAss | | tn tScale val |
			tn := eAss time asSec value.
			(tn >= tOffset and: [tn <= (tOffset + segDur)]) ifTrue:
				[tScale := (tn - t0) / tDiff.
				val := (v0 + (vDiff * tScale)) asFloat.
				eAss event perform: property with: val]].
		tOffset := tOffset + segDur]!

writeMove: property from: vString into: eList
	"Parse and process the complex linear move keyword to generate events"
	"aScore11 add: #p5 -> (#mo -> '10 10 100')"
	"	add: #p6 -> (#mo -> '100 1 1 , 1 1 / 20 1 1 , .9 1.1'); 
		add: #p4 -> (#mo -> '5 200 100  ,  2000 2100  /
						4 2050 2060  / 3 2080 /
						6 2000 2100  ,  1100 1600' ) "

	| strm evts rnd t0 t1 |
	strm := self cleanStreamFrom: vString.
"	Transcript clear.
	[strm atEnd] whileFalse:						
		[Transcript show:  '_', strm next, '_   '].
	strm := ReadStream on: (tStr tokensBasedOn: $ ).
"	evts := eList events.
	rnd := Random new.
	t0 := start.
	[strm atEnd] whileFalse:								"loop through the segments"
		[ | a0 b0 a1 b1 segDur sep interp const tDiff vDiff0 vDiff1 |
		segDur := strm next asNumber.					"read first 3 vals: dur a0 b0"
		a0 := strm next asNumber.
		b0 := strm next.
		interp := false.
		const := false.
		('/,' includes: b0 first)
			ifTrue: [const := true]						"constant clause"
			ifFalse: [b0 := b0 asNumber.
				(strm atEnd) ifFalse:
					[sep := strm next.					"read comma or slash"
					('/,' includes: sep first) ifFalse: [self error: 'Malformed movex expression'].
					(sep = ',')							"comma means read 2 more tokens"
						ifTrue: [interp := true.
							a1 := strm next asNumber.
							b1 := strm next asNumber.
							(strm atEnd)					"read trailing slash"			
								ifFalse: [sep := strm next.
									((sep = '/') or: [strm atEnd]) ifFalse: [self error: 'Malformed movex expression']]]]].
														"else 3 toks = no interpolation; const range"

		t1 := t0 + segDur.		"compute start/end ratios for expon moving range"
		tDiff := t1 - t0.
		const ifFalse:
			[vDiff0 := (b0 - a0) asFloat].
		interp ifTrue:
			[vDiff0 := (a1 - a0) asFloat.	
			vDiff1 := (b1 - b0) asFloat].
"		interp
			ifTrue:[Transcript cr; show: 'Seg: ', t0 printString, ' - ', t1 printString, ' [', a0 printString, ' - ', b0 printString, '] - [ ', 
						a1 printString, ' - ', b1 printString, '] - ', vDiff0 printString, ' : ', vDiff1 printString; cr]
			ifFalse:[Transcript cr; show: 'Seg: ', t0 printString, ' - ', t1 printString, ' [', a0 printString, ' - ', b0 printString, ']'; cr].
"
		evts do:									"event loop"
			[ :eAss | | tN tScale val v0 v1 |
			tN := eAss time asSec value.
			(tN >= t0 and: [tN <= t1]) ifTrue:
				[tScale := (tN - t0) / tDiff.
				const ifTrue: [val := a0]
					ifFalse: [interp							"false means single range for segment"
						ifFalse: [val := (a0 + (vDiff0 * tScale)) asFloat]
						ifTrue: [		"true means interpolating random ranges"
							v0 := (a0 + (vDiff0 * tScale)) asFloat.
							v1 := (b0 + (vDiff1 * tScale)) asFloat.
							val := rnd nextFrom: (v0 min: v1) to: (v0 max: v1).
"							Transcript show: tN printString, ' -  [', v0 printString, ' - ', v1 printString, '] - ', val printString, ']'; cr" ]].
				eAss event perform: property with: val]].
		t0 := t0 + segDur]!

writeMoveX2: property from: vString into: eList
	"Parse and process the complex exponential move keyword to generate events"
	"aScore11 add: #p6 -> (#mx -> '100 1 1 , 1 1 / 20 1 1 , .9 1.1'); 
		add: #p4 -> (#mx -> '5 200 100  ,  2000 2100  /
						4 2050 2060  /
						6 2000 2100  ,  1100 1600' ) "
	"Toks: _5_   _200_   _100_   _,_   _2000_   _2100_   _/_   _4_   _2050_   _2060_   _/_   _6_   _2000_   _2100_   _,_   _1100_   _1600_   "

	| tStr strm evts rnd t0 t1 const |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyReplaceAll: '	' with: ' '.
	[(tStr findString: '  ' startingAt: 1) > 0] whileTrue:
		[tStr := tStr copyReplaceAll: '  ' with: ' '].
	strm := ReadStream on: (tStr tokensBasedOn: $ ).			"split on spaces"
"	Transcript clear.
	[strm atEnd] whileFalse:						
		[Transcript show:  '_', strm next, '_   '].
	strm := ReadStream on: (tStr tokensBasedOn: $ ).
"	evts := eList events.
	rnd := Random new.
	t0 := start.
	[strm atEnd] whileFalse:								"loop through the segments"
		[ | a0 b0 a1 b1 segDur sep interp tDiff vDiff0 vDiff1 |
		segDur := strm next asNumber.					"read first 3 vals: dur a0 b0"
		a0 := strm next asNumber.
		b0 := strm next.
		interp := false.
		const := false.
		('/,' includes: b0 first)
			ifTrue: [const := true]						"constant clause"
			ifFalse: [b0 := b0 asNumber.
				(strm atEnd) ifFalse:
				[sep := strm next.						"read comma or slash"
				('/,' includes: sep first) ifFalse: [self error: 'Malformed movex expression'].
				(sep = ',')								"comma means read 2 more tokens"
					ifTrue: [interp := true.
						a1 := strm next asNumber.
						b1 := strm next asNumber.
						(strm atEnd)					"read trailing slash"			
							ifFalse: [sep := strm next.
								((sep = '/') or: [strm atEnd]) ifFalse: [self error: 'Malformed movex expression']]]]].
													"3 toks = no interpolation; const range"

		t1 := t0 + segDur.								"compute start/end ratios for expon moving range"
		tDiff := t1 - t0.
		const ifFalse:
			[vDiff0 := (b0 / a0) asFloat].
		interp ifTrue:
			[vDiff0 := (a1 / a0) asFloat.	
			vDiff1 := (b1 / b0) asFloat].
"		interp
			ifTrue:[Transcript cr; show: 'Seg: ', t0 printString, ' - ', t1 printString, ' [', a0 printString, ' - ', b0 printString, '] - [ ', 
						a1 printString, ' - ', b1 printString, '] - ', vDiff0 printString, ' : ', vDiff1 printString; cr]
			ifFalse:[Transcript cr; show: 'Seg: ', t0 printString, ' - ', t1 printString, ' [', a0 printString, ' - ', b0 printString, ']'; cr].
"
		evts do:										"event loop"
			[ :eAss | | tN tScale val v0 v1 |
			tN := eAss time asSec value.
			(tN >= t0 and: [tN <= t1]) ifTrue:
				[tScale := (tN - t0) / tDiff.
				const ifTrue: [val := a0]
					ifFalse: [interp						"false means single range for segment"
						ifFalse: [val := rnd nextFrom: (a0 min: b0) to: (a0 max: b0)]
						ifTrue: [						"true means interpolating random ranges"
							v0 := a0 asFloat * (vDiff0 raisedTo: tScale).
							v1 := b0 asFloat * (vDiff1 raisedTo: tScale).
							val := rnd nextFrom: (v0 min: v1) to: (v0 max: v1)]].
				eAss event perform: property with: val]].
		t0 := t0 + segDur]!

writeMoveX: property from: array into: eList
	"Parse and process the exponential move keyword to generate events"
	"aScore11 add: #p5 -> (#mx -> #(10 1 100))
		add: #p5 -> (#mx -> #(5 4 100   5 100 5))  ) "

	| evts tOffset |
	array isString ifTrue: [^self writeMoveX2: property from: array into: eList].
										"The rest of this is for backward compatibility; you shouldn't use arrays any more"
	evts := eList events.
	tOffset := start.
	1 to: array size by: 3 do:				"loop through the segments"
		[ :ind | | v0 v1 vDiff t0 t1 tDiff segDur |
		segDur := array at: ind.
		v0 := array at: ind + 1.
		v1 := array at: ind + 2.
		vDiff := v1 / v0.
		t0 := tOffset.
		t1 := tOffset + segDur.
		tDiff := t1 - t0.
		evts do:							"event loop"
			[ :eAss | | tn tScale val |
			tn := eAss time asSec value.
			(tn >= tOffset and: [tn <= (tOffset + segDur)]) ifTrue:
				[tScale := (tn - t0) / tDiff.
				val := v0 * (vDiff raisedTo: tScale) asFloat.
				eAss event perform: property with: val]].
		tOffset := tOffset + segDur]!

writeNotes: property from: vString into: eList
	"Parse and process the sequential keywords to generate events"
	"aScore11 add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); "
	"aScore11 add: #p4 -> (#no -> 'c4*3/a*5/'); "
	"aScore11 add: #p4 -> (#no -> 'c4:e:g:/d:fs:a/ef:g:bf'); "

	| strm ind evts tStr oct newEvents |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyWithout: $ .
	tStr := tStr copyWithout: $	.
	strm := ReadStream on: tStr.
	ind := 1.
	evts := eList events.
	oct := '3'.
	newEvents := EventList newAnonymous.
	[ind < eList events size] whileTrue:
		[ | eAss tn val cnt evt num | 
		eAss := evts at: ind.
		evt := eAss event.
		tn := eAss time asSec value.
		(tn >= start and: [tn <= (stop)]) ifTrue:
			[val := strm upTo: $/.					"read to next $/ "

			(val includes: $*)					"handle * expressions"
				ifTrue: [ | str2 | 
					str2 := ReadStream on: val.
					num := (str2 upTo: $*).
					cnt := str2 upToEnd asNumber.
					num last isDigit
						ifTrue: [oct := String with: num last.
							num := num allButLast: 1].
					cnt timesRepeat: 
						[evt perform: property with: (num, oct).
						ind := ind + 1.
						evt := (evts at: ind) event]]

				ifFalse: [(val includes: $:)			"handle : chord expressions"
					ifTrue: [ | str2 firstDone | 
						str2 := ReadStream on: val.
						firstDone := false.
						[str2 atEnd] whileFalse:
							[num := (str2 upTo: $:).
							num last isDigit
							ifTrue: [oct := String with: num last.
								num := num allButLast: 1].
							firstDone
								ifFalse: [evt perform: property with: (num, oct).
									firstDone := true.]
								ifTrue: [ | newEv |
									newEv := evt copy.
									newEv perform: property with: (num, oct).
									newEvents add: eAss start => newEv]]]
												"else just assign property"
						ifFalse: [val last isDigit
							ifTrue: [oct := String with: val last.
								val := val allButLast: 1].
							evt perform: property with: (val, oct)].
												"repeat as necessary"
		strm atEnd ifTrue: [strm := ReadStream on: vString]]].
		ind := ind + 1].
	newEvents isEmpty
		ifFalse: [eList addAll: newEvents].
	^self!

writeNumerical: property from: vString into: eList
	"Parse and process the numerical keyword to generate events"
	"aScore11 add: #p4 -> (#nu -> '1./.5*3/.25//-.5/1.5') "

	| strm ind evts |
	strm := ReadStream on: vString.
	ind := 1.
	evts := eList events.
	[ind < eList events size] whileTrue:
		[ | val cnt evt num | 
		evt := (evts at: ind) event.
		val := strm upTo: $/.					"read to next $/ "
		(val includes: $*)					"handle * expressions"
			ifTrue: [ | str2 | 
				str2 := ReadStream on: val.
				num := (str2 upTo: $*).
				cnt := str2 upToEnd asNumber.
				cnt timesRepeat: 
					[evt perform: property with: num.
					ind := ind + 1.
					evt := (evts at: ind) event]]
			ifFalse: [evt perform: property with: val].
		strm atEnd ifTrue: [strm := ReadStream on: vString].
		ind := ind + 1].
	^self!

writeP3: param into: eList	
	"Parse and process the RH keyword to generate events"
	"aScore11 add: #p3 -> (#rh -> '4/8*4/6*3/4/'); "

	| key val |
	param isAssociation ifFalse:		"handle non-rh arrays - rand sequences"
		[^self writeRandRH: param into: eList].
	key := param key.
	val := param value.
	key == #rh ifTrue: [^self writeP3RH: val into: eList].
	key == #mx ifTrue: [^self writeP3MX: val into: eList].

	self error: 'Unknown Score11 term'!

writeP3MX: vString into: eList
	"Parse and process the complex exponential move keyword to generate events"
	"aScore11 add: #p3 -> (#mx -> '100 1 1 , 1 1 / 20 1 1 , .9 1.1'); "

	| tStr strm rnd t0 t1 |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyReplaceAll: '	' with: ' '.
	[(tStr findString: '  ' startingAt: 1) > 0] whileTrue:
		[tStr := tStr copyReplaceAll: '  ' with: ' '].
	strm := ReadStream on: (tStr tokensBasedOn: $ ).				"split on spaces"
	rnd := Random new.
	t0 := start.

	[(t0 > stop) or: [strm atEnd]] whileFalse:						"loop through the segments"
		[ | a0 b0 a1 b1 segDur tN sep interp vDiff0 vDiff1 |
		segDur := strm next asNumber.							"read first 3 vals: dur a0 b0"
		a0 := strm next asNumber.
		b0 := strm next asNumber.
		(strm atEnd) ifFalse:
			[sep := strm next.									"read comma or slash"
			('/,' includes: sep first) ifFalse: [self error: 'Malformed movex expression'].
			(sep = ',')											"comma means read 2 more tokens"
				ifTrue: [interp := true.
					a1 := strm next asNumber.
					b1 := strm next asNumber.
					(strm atEnd)									"read trailing slash"			
						ifFalse: [sep := strm next.
							((sep = '/') or: [strm atEnd]) ifFalse: [self error: 'Malformed movex expression']]]
				ifFalse: [interp := false]].							"3 toks = no interpolation; const range"

		t1 := t0.													"compute start/end ratios for expon moving range"
		tN := t0 + segDur.
		vDiff0 := (a1 / a0) asFloat.	
		vDiff1 := (b1 / b0) asFloat.

		[t1 < tN] whileTrue:										"event loop"
			[ | val v0 v1 tScale |
			interp												"false means single rand range for segment"
				ifFalse: [val := rnd nextFrom: (a0 min: b0) to: (a0 max: b0)]
				ifTrue: [tScale := (t1 - t0) / segDur.
					v0 := a0 asFloat * (vDiff0 raisedTo: tScale).
					v1 := b0 asFloat * (vDiff1 raisedTo: tScale).
					val := rnd nextFrom: (v0 min: v1) to: (v0 max: v1)].
			eList add: (MusicEvent dur: val voice: instrument).
			t1 := t1 + val].
		t0 := t0 + segDur]!

writeP3RH: data into: eList	
	"Parse and process the RH keyword to generate events"
	"aScore11 add: #p3 -> (#rh -> '4/8//4//');"
	"aScore11 add: #p3 -> (#rh -> '4/8*4/6*3/4/');"
	"aScore11 add: #p3 -> (#rh -> #(4 8 8 4. 8));"
	"aScore11 add: #p3 -> (#rh -> #(4 8 -8 4 -4));"
	"aScore11 add: #p3 -> (#rh -> 16);"

	| strm num cnt tim val tStr |
	tim := start.
	data respondsToArithmetic ifTrue:			"rh number"
		[num := 4.0 / data.
		[tim > stop] whileFalse:
			[eList add: (MusicEvent dur: num voice: instrument).
			tim := tim + num].
		^self].
	data isString ifFalse:							"rh string"
		[self error: 'Mal-formed duration data?'].
	tStr := data copyWithout: Character cr.
	tStr := tStr copyWithout: $ .
	tStr := tStr copyWithout: $	.
	strm := ReadStream on: tStr.
	cnt := 0.
	[tim > stop] whileFalse:
		[val := strm upTo: $/.						"read to next $/ "
		(val includes: $*)						"handle * expressions"
			ifTrue: [ | str2 | 
				str2 := ReadStream on: val.
				num := 1.0 / (str2 upTo: $*) asNumber.
				cnt := str2 upToEnd asNumber.
				cnt timesRepeat: 
					[eList add: (MusicEvent dur: num voice: instrument).
					tim := tim + num]]	
			ifFalse: [(val includes: $.)				"handle dotted rhythmic values"
				ifTrue: [ | va2 nDots delD |
					va2 := val copyWithout: $. .
					nDots := val size - va2 size.
					num := 4.0 / val asNumber.
					delD := num / 2.0.
					nDots timesRepeat:
						[num := num + delD.
						delD := delD + (delD / 2.0)].
					eList add: (MusicEvent dur: num voice: instrument).
					tim := tim + num.
					strm atEnd ifTrue: [strm := ReadStream on: data]]
				ifFalse: [(val includes: $-)		"handle rests"
					ifTrue: [val isEmpty ifFalse: [num := -4.0 / val asNumber].
						eList add: (RestEvent dur: num).
						tim := tim + num.
						strm atEnd ifTrue: [strm := ReadStream on: data]]
					ifFalse: [val isEmpty ifFalse: [num := 4.0 / val asNumber].
						eList add: (MusicEvent dur: num voice: instrument).
						tim := tim + num.
						strm atEnd ifTrue: [strm := ReadStream on: data]]]]]!

writeRand: property from: array into: eList
	"Parse and process the random keyword to generate events"
	"aScore11 add: #p3 -> #(1.0 1.0 5.0);"
	"aScore11 add: #p3 -> #(0.5 1.0 2.0  0.5 0.25 0.5);"

	| rnd ranges |
 	rnd := Random new.
	array size == 3 ifTrue:			"use a single range, ignoring the percentage value"
		[eList eventsDo:
			[ :evt | 
			evt perform: property with: (rnd nextFrom: (array at: 2) to: (array last))].
		^self].
	ranges := self parseRanges: array.
	eList eventsDo:
		[ :evt | | val rng |
		val := rnd next.				"get a rand 0-1 to select which range we'll use"
		ranges do: [ :ass |
			ass key < val ifTrue: [rng := ass value]].
		evt perform: property with: (rnd nextFrom: rng first to: rng stop)].!

writeRandRH: array into: eList	
	"Parse and process the random RH keyword to generate events"
	"aScore11 add: #p3 -> #(1.0 1.0 5.0);"
	"aScore11 add: #p3 -> #(0.5 1.0 2.0  0.5 0.25 0.5);"

	| tim rnd |
	tim := start.
 	rnd := Random new.
	array size == 3 ifTrue:			"use a single range, ignoring the percentage value"
		[ | rng |
		rng := (array at: 2) to: (array last).
		[tim <= stop] whileTrue:
			[ | dur |
			rng size = 0
				ifTrue: [dur := rng first]
				ifFalse: [dur := rng atRandom: rnd].
			eList add: (MusicEvent dur: dur voice: instrument).
			tim := tim + dur].
		^self].!

writeSequential: property from: vString into: eList
	"Parse and process the sequential keywords to generate events"
	"aScore11 add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); "

	| strm ind evts tStr |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyWithout: $ .
	tStr := tStr copyWithout: $	.
	strm := ReadStream on: tStr.
	ind := 1.
	evts := eList events.
	[ind < eList events size] whileTrue:
		[ | eAss tn val cnt evt num | 
		eAss := evts at: ind.
		evt := eAss event.
		tn := eAss time asSec value.
		(tn >= start and: [tn <= (stop)]) ifTrue:
			[val := strm upTo: $/.					"read to next $/ "
			(val includes: $*)					"handle * expressions"
				ifTrue: [ | str2 | 
					str2 := ReadStream on: val.
					num := (str2 upTo: $*).
					cnt := str2 upToEnd asNumber.
					cnt timesRepeat: 
						[evt perform: property with: num.
						ind := ind + 1.
						evt := (evts at: ind) event]]
				ifFalse: [evt perform: property with: val].
		strm atEnd ifTrue: [strm := ReadStream on: vString]].
		ind := ind + 1].
	^self!

writeSet: property from: vString into: eList
	"Parse and process the 'set' keyword to generate events"
	"aScore11 add: #p4 -> (#se -> '20 .1 .2 .3 .4'); "
	"	add: #p8 -> (#se -> '5 c5 e g / 5 d5 fs a4'/);"

	| toks rnd segDur item strm segs t0 |
	strm := self cleanStreamFrom: vString.
	segs := OrderedCollection new.
	toks := OrderedCollection new.
	[strm atEnd] whileFalse:					"collect the segments"			
		[segDur := strm next asNumber.
		item := strm next.
		[(item = '/') or: [strm atEnd]] whileFalse:
			[toks add: item.
			item := strm next].
		segs addLast: segDur -> toks.		"start-time -> data-set"
		toks := OrderedCollection new].	
	rnd := Random new.
	t0 := 0.
	1 to: segs size do:						"step through the segments"
		[ :ind | | tN |
		tN := t0 + (segs at: ind) key.
		toks := (segs at: ind) value copy.
		eList do: 
			[ :eAss | | evt tX |
			evt := eAss event.
			tX := eAss time asSec value.
			(tX >= t0 and: [tX <= tN]) ifTrue:
				[ | val |
				val := toks atRandom: rnd.
				toks remove: val ifAbsent: [nil].
				evt perform: property with: val.
"				Transcript show: tX printString, ' - ', val printString; cr"].
		t0 := tN]]! !

!Siren.Score11 methodsFor: 'private-post-processors'!

duty: dutyCycle list: eList
	"Post-process the event list's durations."
	"000 - 099		multiply dur by dutyCycle
	  100 - 199		add dutyCycle - 100 to dur
	 200 - 299		subtract dutyCycle - 200 from dur
	 300 - 399		set dur to dutyCycle - 300
	 400 - 399		set dur to dutyCycle - 400 cycles (dur = (1/Hz) * (dutycycle - 400)"

	| dec val |
	dec := (dutyCycle / 100) truncated.
	val := dutyCycle \\ 100.
	(dec == 0) ifTrue: 			"000 - 099	multiply dur by dutyCycle"
		[eList scaleDurationsBy: val.
		^self].
	(dec == 1) ifTrue: 			"100 - 199	add dutyCycle - 100 to dur"
		[eList eventsDo: [ :ev | ev duration: (ev duration + (ev duration species value: val))].
		eList recomputeDuration.
		^self].
	(dec == 2) ifTrue: 			"200 - 299	subtract dutyCycle - 200 from dur"
		[eList eventsDo: [ :ev | ev duration: (ev duration - (ev duration species value: val))].
		eList recomputeDuration.
		^self].
	(dec == 3) ifTrue: 			"300 - 399	set dur to dutyCycle - 300"
		[eList eventsDo: [ :ev | ev duration: (ev duration species value: val)].
		eList recomputeDuration.
		^self].
	(dec >= 4) ifTrue: 			"400 - 399	set dur to dutyCycle - 400 cycles (dur = (1/Hz) * (dutycycle - 400)"
		[eList eventsDo: 
			[ :ev |  | frq |
			frq := ev pitch asHz.
			ev duration: ((1.0 / frq) * (dutyCycle - 400) sec)].
		eList recomputeDuration].!

rdev: rData list: eList
	"Post-process the event list's start-times with the random skew."
	"s11 rdev: 0.02."
	"s11 rdev: #(10 0.0 0.1)."

	| rand |
 	rand := Random new.
	rData respondsToArithmetic ifTrue:
		[eList do: 
			[ :evAss | | tX |
			tX := evAss key asSec value.
			tX := tX + ((rand next * 2 - 1.0) * rData).
			evAss start: tX].
		eList recomputeDuration.
		^self].
	rData size \\ 3 = 0 ifTrue:
		[ | dur rn0 rnN vDiff |
		dur := rData at: 1.
		rn0 := rData at: 2.
		rnN := rData at: 3.
		vDiff := rnN - rn0.
		eList events do:
			[ :evAss | | tX tScale val |
			tX := evAss key asSec value.
			tScale := tX / dur.
			val := (rn0 + (vDiff * tScale)) asFloat.
			tX := tX + ((rand next * 2 - 1.0) * val).
			evAss start: tX].
		eList recomputeDuration.
		^self]!

tempo: tData list: eList
	"Post-process the event list's start-times with the tempo curve."
	"s11 tempo: #(10 60 120)."
	"s11 tempo: 120."

	| dur t0 tN |
	tData respondsToArithmetic
		ifTrue: [ | val |
			val := 60.0 / tData.
			eList scaleStartTimesBy: val.
			eList scaleDurationsBy: val.
			eList recomputeDuration.
			^self].
	tData isString ifFalse:
		[tData size  \\ 3 = 0 ifTrue:
			[ | rOff mOff |
			rOff := 0.			"real offset"
			mOff := 0.			"mapped offset"
			1 to: tData size by: 3 do:
				[ :ind | | last |
				dur := tData at: ind.
				t0 := 60.0 / (tData at: ind + 1).
				tN := 60.0 / (tData at: ind + 2).
				last := self tempoFrom: t0 to: tN in: dur list: eList startingAt: rOff mappedTo: mOff.
				rOff := rOff + dur.
				mOff := last].
			eList recomputeDuration.
			^self]]!

tempoFrom: t0 to: tN in: dur list: eList startingAt: eStart mappedTo: mOff
	"Post-process the event list's start-times with the tempo curve."
	"s11 tempo: #(10 60 120)."

	| tDiff prevS prevO eEnd |
"	Transcript cr; show: t0 printString, ' to ', tN printString, ' in ', dur printString, 
			' startingAt ', eStart printString, ' mappedTo ', mOff printString; cr."
	tDiff := tN - t0.
	prevO := eStart.				"original start of previous note"
	prevS := mOff.				"scaled start of previous note"
	eEnd := eStart + dur.
	eList do: 
		[ :evAss | | tX val sca ioi |
		tX := evAss key asSec value.
		(tX >= eStart and: [tX <= eEnd]) ifTrue:
			[ioi := tX - prevO.
			sca := t0 + (tDiff * tX / dur).
			val := prevS + (ioi * sca).
			evAss start: val. 
"			Transcript show: tX printString, ' - ', sca printString, ' - ', val printString; cr."
			prevS := val.
			prevO := tX.
			evAss start: val]].
	^prevS! !

!Siren.Score11 methodsFor: 'private'!

cleanStreamFrom: vString
	"Clean up the string and answer a stream on it - leave spaces."

	| tStr |
	vString isString ifFalse: [tStr := vString inject: '' into:  [ :str :it | str, ' ', it printString].
		tStr := tStr copyFrom: 2 to: tStr size.
		^ReadStream on: (tStr tokensBasedOn: $ )].
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyReplaceAll: '/' with: ' / '.
	tStr := tStr copyReplaceAll: '	' with: ' '.			"tab"
	[(tStr findString: '  ' startingAt: 1) > 0] whileTrue:
		[tStr := tStr copyReplaceAll: '  ' with: ' '].
	(tStr last == $ )
		ifTrue: [tStr := tStr copyFrom: 1 to: tStr size - 1].
	^(ReadStream on: (tStr tokensBasedOn: $ ))!

compactStreamFrom: vString
	"Clean up the string and answer a stream on it."

	| tStr |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyWithout: $ .
	tStr := tStr copyWithout: $	.
	^(ReadStream on: tStr)!

parseRanges: array
	"Parse  random lists into a list of interval associations"
	"aScore11 add: #p3 -> #(0.5 1.0 2.0  0.5 0.25 0.5);"

	| ranges sum scale |
 	array size \\ 3 = 0 ifFalse:				"use a single range, ignoring the percentage value"
		[self error: 'Wrong array size in parseRanges'].
	ranges := OrderedCollection new.
	sum := 0.0.
	1 to: array size by: 3 do:
		[ :cnt | | rat lo hi |
		rat := array at: cnt.
		lo := array at: cnt + 1.
		hi := array at: cnt + 2.
		ranges addLast: (rat -> (lo to: hi)).
		sum := sum + rat].
	scale := 1.0 / sum.					"scale ranges"
	sum := 0.0. "ranges first key * scale."
	ranges do:
		[ :ass | | rat |
		rat := ass key.
		ass key: sum.
		sum := sum + (rat * scale)].
	^ranges! !


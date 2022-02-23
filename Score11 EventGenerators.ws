Score11 is a port of a Score11 instrument; see https://www.esm.rochester.edu/ears/docs/score11/index.html

Instance Variables:
	generators	<Dictionary of (prop-name -> data)>	the parameter blocks of the score11 instrument

Examples:

instrument 1 0 10;	< Instrument 1 starts at time 0 and plays for 10 beats.
	parameter 3 1; 	< Each note lasts 1 beat
end;          			< This finishes the I-block

i1 0 5;
	p3 rh 4/8*6/4;
	p4 no c4/d/e/f/g/a/b/c5;
	p5 1.0 1.0 5.0;    			< 100% of values between 1.0 and 5.0
	p6 mo 5 1000 2000;		< move from 1000 to 2000 in 5 beats
end;

Standard parameter maps -- the SCORE-11 constant parameter meanings are:

      p1 = Instrument number
      p2 = Starting time for this note (in beats) (not normally used)
      p3 = Duration for this note (in beats)
      p4 = Pitch (or frequency)
      p5 = Amplitude value (0 - 32000)

Smalltalk examples

	s11 := (Score11 instr: 1 from: 0 to: 10)
		add: #p3 -> (#rh -> '4/8*6/4');
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5');
		add: #p5 -> #(1.0 1.0 5.0);
		add: #p6 -> (#mo -> #(5 1000 2000)).
	s11 events

	"TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4//8////4//'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> #(1.0 1.0 5.0); 
		add: #p6 -> (#mo -> #(5 1000 2000))) 
	eventList"

	"TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/8*4/6*3/4/'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> #(10 10 100));
		add: #p6 -> #(1.0 -1.0 1.0)) 
	eventList"

	[ | s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/8*4/6*3/4/'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> #(10 10 100));
		add: #p6 -> #(1.0 -1.0 1.0);
		add: #p7 -> #(0.5 1 2  0.5 100 200);
		add: #p8 -> (#se -> #(10 1 3 5 7 9));
		add: #p9 -> (#mx -> #(10 1 100))
	).
	s11 assign: #p6 to: #position:.
	s11 assign: #p7 to: #attack:.
	s11 eventList inspect ]

	[ | s11 |			"test multi-segment moves"
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> 16); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> #(7 5 100  3 100 5))
	).
	s11 tempo: #(10 60 120).
	s11 eventList inspect ]

	[ | s11 |			"test dotted values"
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/4./4../8'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> #(7 5 100  3 100 5))
	).
	s11 tempo: #(10 60 120).
	s11 eventList inspect ]

	[ | s11 |			"test rests"
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/-4/8/-8'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> #(7 5 100  3 100 5))
	).
	s11 tempo: #(10 60 120).
	s11 eventList inspect ]

	[ | s11 |			"test complex movex"
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 15) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#mx -> '5 100 120 , 2000 2400 /
						4 2050 2060 /
						6 2000 2100 , 700 1100' )).
	s11 eventList inspect ]

	[ | s11 |			"test complex movex 2"
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 8) 
		add: #p3 -> (#rh -> '32/'); 
		add: #p4 -> (#mx -> '3 140 190 , 400 440 /
						2 440 460 /
						3 400 400 , 150 250' )).
	s11 eventList open ]

----

	[ | s11 |			"BOOH part 1"
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 120) 
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
"ampl ratio"
		add: (#p5 -> 0.1);
"gliss"
		add: #p6 -> (#mx -> '100 1 1 , 1 1 / 20 1 1 , .9 1.1');
"position"
		add: #p7 -> #(1.0 -1.0 1.0) ).
"	s11 du: 303."			"ToDo: Score11 duty cycle"
	s11 assign: #p6 to: #gliss:.
	s11 assign: #p7 to: #position:.
	s11 eventList  ]

Keywords requiring a parameter number:
	1. funcs (not implemented)
	2. move - move "number of beats for change" "first value" "second value"
	3. movex - movex "number of beats for change" "first value" "second value"
	4. notes - symbolic note names
	5. numbers - numerical sequences
	6. rhythms - rhythmic notations
	7. rlist
	8. rnotes
	9. sets - selection from sets

Keywords not using a parameter number:
	1. ampfac
	2. beat
	3. duty_factor
	4. end
	5. instrument (valid as 'i')
	6. parameter (valid as 'p')
	7. rdeviation
	8. rrests
	9. rseed
	10. tempo
	11. tfactor

'/,' detect: [ :c | c == $,] ifNone: [nil]
'/' = '/' 
	| evts tOffset toks strm |
	toks := vString tokensBasedOn: $ .
	strm := 
(ReadStream on: ('100 1 1 , 1 1 / 20 1 1 , .9 1.1' tokensBasedOn: $ )) next


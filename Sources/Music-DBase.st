

Smalltalk.Siren defineClass: #Track
	superclass: #{Siren.DurationEvent}
	indexedType: #none
	private: false
	instanceVariableNames: 'id name filename title artist album year labels size path kind genre comment key track modDate addDate bRate sRate persID type hasTags folder playlists '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-DBase'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Track class methodsFor: 'instance creation'!

fromLine: line
	"Create a new track from the given dictionary"
	"Siren.Track key: 235 fromDictionary: ()"
	"oid	title	artist	album	genre	comment"
	"Siren.Track fromLine: '29	In Black	Megatrax - Intervox	INX146 - Blockbuster	Promos:Drama - Epic, Orchestral, Romance - Epic/Thematic, Film	Mystic & melancholic climactic score, thoughtful & slightly sorrowful mood, orchestral instruments - Full Mix - Medium Slow - www.megatrax.com - Toll Free 888-MEGA-555' "

	| strm inst |
	strm := ReadStream on: line.
	inst := self new.
	inst hasTags: false.
	inst id: (strm upTo: Character tab).
	inst title: (strm upTo: Character tab).
	inst artist: (strm upTo: Character tab).
	inst album: (strm upTo: Character tab).
	inst genre: (strm upTo: Character tab).
	inst comment: (strm upToEnd).
	^inst!

key: k fromDictionary: dict
	"Create a new track from the given dictionary"
	"Siren.Track key: 235 fromDictionary: ()"

	| inst |
	inst := self new.
	inst hasTags: false.
	inst key: k.
	inst id: (dict at: #TrackID ifAbsent: ['']).
	inst title: (dict at: #Name ifAbsent: ['']) .
	inst artist: (dict at: #Artist ifAbsent: ['']) .
	inst album: (dict at: #Album ifAbsent: ['']) .
	inst genre: (dict at: #Genre ifAbsent: ['']) .
	inst kind: (dict at: #Kind ifAbsent: ['']) .
"	inst size: (dict at: #Size ifAbsent: ['']) ."
"	inst time: (dict at: #TotalTime ifAbsent: ['']) ."
	inst track: (dict at: #TrackNumber ifAbsent: ['']) .
"	inst modDate: (dict at: #DateModified ifAbsent: ['']) ."
"	inst addDate: (dict at: #DateAdded ifAbsent: ['']) ."
	inst bRate: (dict at: #BitRate ifAbsent: ['']) .
	inst sRate: (dict at: #SampleRate ifAbsent: ['']) .
"	inst persID: (dict at: #PersistentID ifAbsent: ['']) ."
	inst type: (dict at: #TrackType ifAbsent: ['']) .
	inst filename: (dict at: #Location ifAbsent: ['']) .
"	inst folder: (dict at: #Folder ifAbsent: [''])."
	^inst

"		<key>112482</key>
		<dict>
			<key>Track ID</key><integer>112482</integer>
			<key>Name</key><string>Last Goodbye</string>
			<key>Artist</key><string>Kenny Wayne Shepherd</string>
			<key>Album</key><string>Live On</string>
			<key>Genre</key><string>Electric Blues</string>
			<key>Kind</key><string>MPEG audio file</string>
			<key>Size</key><integer>6570106</integer>
			<key>Total Time</key><integer>273658</integer>
			<key>Track Number</key><integer>4</integer>
			<key>Date Modified</key><date>2006-01-22T19:10:54Z</date>
			<key>Date Added</key><date>2012-03-26T21:05:14Z</date>
			<key>Bit Rate</key><integer>192</integer>
			<key>Sample Rate</key><integer>44100</integer>
			<key>Persistent ID</key><string>B515ECB9FE2F7173</string>
			<key>Track Type</key><string>File</string>
			<key>Location</key><string>file://localhost/Volumes/Content/iTunes/New/Kenny%20Wayne%20Shepherd/Live%20On/Last%20Goodbye.mp3</string>
			<key>File Folder Count</key><integer>4</integer>
			<key>Library Folder Count</key><integer>1</integer>
		</dict>
"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Track methodsFor: 'comparing'!

<= other

	(self name isNil or: [other name isNil])
		ifTrue: [^self id <= other id].
	^self name <= other name! !

!Siren.Track methodsFor: 'accessing'!

addDate

	^addDate!

addDate: aValue

	addDate := aValue!

addPlaylist: pl
	"Add an item, initialize lazily"

	playlists isNil ifTrue: [playlists := Set new].
	playlists add: pl!

album

	^album!

album: aValue

	album := aValue asSymbol!

artist

	^artist!

artist: aValue

	artist := aValue asSymbol!

bRate

	^bRate!

bRate: aValue

	bRate := aValue!

comment

	^comment!

comment: aValue

	comment := aValue "asSymbol"!

filename

	^filename!

filename: aValue

	filename := aValue!

folder

	^folder!

folder: aValue

	folder := aValue!

genre

	^genre!

genre: aValue

	genre := aValue "asSymbol"!

hasTags

	^hasTags!

hasTags: aValue

	hasTags := aValue!

id

	^id!

id: aValue

	id := aValue asNumber!

isEmpty
	^true!

isTag

	^false!

key

	^key!

key: aValue

	key := aValue!

kind

	^kind!

kind: aValue

	kind := aValue!

label: aValue

	labels ifNil: [labels := OrderedCollection new].
	labels addLast: aValue asSymbol!

label: aKey put: aValue

	^self at: aKey put: aValue!

labels

	^labels!

modDate

	^modDate!

modDate: aValue

	modDate := aValue!

name

	^name!

name: aValue

	name := aValue!

persID

	^persID!

persID: aValue

	persID := aValue!

playlists
	"Answer the playlists"

	^playlists!

sRate

	^sRate!

sRate: aValue

	sRate := aValue!

size

	^size!

size: aValue

	size := aValue asNumber!

title

	^title!

title: aValue

	title := aValue!

track

	^track!

track: aValue

	track := aValue!

tracks
	^nil!

type

	^type!

type: aValue

	type := aValue asSymbol! !

!Siren.Track methodsFor: 'printing'!

printOn: aStream
	"Format and print the receiver on the argument."

	aStream nextPutAll: self title, ' -- ', self album.
"		self artist , '  --  ', self album.
"
	self labels hasItems 
"		ifFalse: [self labels do: [ :it | aStream nextPutAll: (it asString, ' - ')]]"
		ifTrue: [aStream cr.
			self labels do: [ :it | aStream nextPutAll: it printString; cr]]
		ifFalse: [aStream nextPutAll: ' -- ', self title, ' -- ', self artist , ' -- ', self album]! !

!Siren.Track methodsFor: 'parsing'!

cleanFilename
	"Take out the URL-escapes, i.e., turn %20 into space."

	| hd nm |
	nm := filename.
	nm isEmpty 
	ifTrue: [nm := 'no-name']
	ifFalse: [hd := 'file://localhost'.
		(nm copyFrom: 1 to: hd size) = hd
			ifTrue: [nm := nm copyFrom: hd size + 1 to: nm size].
		nm := URLEncoder decode: nm. " copyReplaceAll: '%20' with: ' '. "  ].
	^nm!

dropVolume: fnam
	"Strip the leading volume from the name"

	| hd nm |
	nm := fnam.
	hd := '/Volumes/Content/iTunes/'.
	((nm size > hd size) and: [(nm copyFrom: 1 to: hd size) = hd])
		ifTrue: [nm := nm copyFrom: hd size + 1 to: nm size].
	hd := '/Volumes/Content/Sound/'.
	((nm size > hd size) and: [(nm copyFrom: 1 to: hd size) = hd])
		ifTrue: [nm := nm copyFrom: hd size + 1 to: nm size].
	^nm!

escape: nam
	"Turn the non-ASCII characters into '*' in the name"

	| nst ost |
	nst := ReadStream on: nam.
	ost := WriteStream on: (String new: nst size).
	ost nextPut: $".
	[nst atEnd] whileFalse:
		[| ch |
		ch := nst next.
		ch asInteger > 128
			ifTrue: [ost nextPutAll: '"*"' ]
			ifFalse: [ost nextPut: ch]].
	ost nextPut: $".

	^ost contents!

loadTags
	"Read the ID3 tags of the track from a tags file"
	"Siren.Track someInstance loadTags"

	| nam dict strm ass |
	nam := self cleanFilename.			"de-URLize the name"
	self parseFilename: nam.				"separate out the name levels"
"Check for file"								"silent for now"
"	nam asFilename exists ifFalse:		
		[Transcript show: ' - ', (self dropVolume: nam); cr].
"
"Run tagreader file"
	nam := nam, '.tags'.					"create tag name"
	nam asFilename exists ifTrue:			"check for tag file"
		[strm := nam asFilename readStream.
		strm skipThroughAll: '-- TAG --'.	"look for tag data"
"		strm atEnd ifTrue: []."
"Read cmd output into dict"
		dict := Dictionary new.
		[strm atEnd] whileFalse:
			[ass := self parseAssociation: strm.
			ass ifNotNil: [dict at: ass key asSymbol put: ass value]].
	strm close.
"Parse dict"
	dict keys isEmpty ifFalse: [hasTags := true].
	dict associationsDo:
		[ :as2 | | k v |
		k := as2 key.
		v := as2 value.
		((#title -> [v ~= self title ifTrue: [self title: v]]),
		(#artist -> [v ~= self artist ifTrue: [self artist: v asSymbol]]),
		(#album -> [v ~= self album ifTrue: [self album: v asSymbol]]),
		(#year -> [v ~= 0 ifTrue: [self year: v asNumber]]),
		(#genre -> [v ~= self genre ifTrue: [self genre ifNotNil: [self label: self genre].
				self genre: v asSymbol]]),
		(#duration -> [self duration: v asNumber]))
			case: k]].

"Tags for /Volumes/Content/Sound/FASTLab/Folk/Bob Dylan/Blood On The Tracks/01 - Tangled Up In Blue.mp3
-- TAG --
title    Tangled Up In Blue
artist   Bob Dylan
album    Blood On The Tracks
year     1975
comment  
track    1
genre    Folk
bitrate      192
sample rate  44100
channels     2
duration     343
length       5:43
"!

loadTags0
	"Read the ID3 tags of the track"
	"Siren.Track someInstance loadTags"
	"UnixProcess cshReply: 'ls -l /etc/passwd' "
	"UnixProcess cshReply: '/usr/local/bin/tagreader /Volumes/Content/iTunes/iTunes Music/Smashing Pumpkins/Teargarden by Kaleidyscope/02 Widow Wake My Mind.mp3'" 

	| nam dict repl strm ass |
	nam := self cleanFilename.			"de-URLize the name"
	self parseFilename: nam.				"separate out the name levels"
	nam asFilename exists ifFalse:		"check for file"
		[Transcript show: ' - ', (self dropVolume: nam); cr].
"Run UNIX tagreader cmd"
	repl := UnixProcess cshReply: ('/usr/local/bin/tagreader ', (self escape: nam)).
"	Transcript show: repl; cr."
"Read cmd output into dict"
	strm := ReadStream on: repl.
	strm skipThroughAll: '-- TAG --'.
"	strm atEnd ifTrue: []."
	dict := Dictionary new.
	[strm atEnd] whileFalse:
		[ass := self parseAssociation: strm.
		ass ifNotNil: [dict at: ass key asSymbol put: ass value]].
"Parse dict"
	dict associationsDo:
		[ :as2 | | k v |
		k := as2 key.
		v := as2 value.
		((#title -> [v ~= self title ifTrue: [self title: v]]),
		(#artist -> [v ~= self artist ifTrue: [self artist: v asSymbol]]),
		(#album -> [v ~= self album ifTrue: [self album: v asSymbol]]),
		(#genre -> [v ~= self genre ifTrue: [self genre ifNotNil: [self label: self genre].
				self genre: v asSymbol]]),
		(#length -> [v ~= self album ifTrue: [ | s d | 
				s := ReadStream on: v.
				d := s upTo: $:.
				d isEmpty ifFalse: [d := d asNumber * 60].
				d := d + s upToEnd asNumber.
				self duration: d]]))
			case: k].

"******************** /Volumes/Content/iTunes/iTunes Music/Smashing Pumpkins/Teargarden by Kaleidyscope/02 Widow Wake My Mind.mp3 ********************
-- TAG --
title   - Widow Wake My Mind
artist  - Smashing Pumpkins
album   - Teargarden by Kaleidyscope
year    - 0
comment - 0
track   - 2
genre   - Alternative
-- AUDIO --
bitrate     - 192
sample rate - 44100
channels    - 2
length      - 4:27
"!

parseAssociation: strm
	"Read a line like ' genre    Alternative ' "

	 | k v |
	strm skipSeparators.
	k := (strm upTo: $ ) trimBlanks.	"first token"
	strm skipSeparators.
	v := (strm upTo: Character cr) trimBlanks.		"2nd token"
	k ifNil: [^nil].
	v ifNil: [^nil].
	v isEmpty ifTrue: [^nil].
	((v at: 1) == $") ifTrue: [v := v copyFrom: 2 to: v size].
	v isEmpty ifTrue: [^nil].
	((v at: v size) == $") ifTrue: [v := v copyFrom: 1 to: v size - 1].
	v isEmpty ifTrue: [^nil].
	^k -> v!

parseFilename: nam

	| fi sep strm |
	fi := nam.
	#('/Content/Sound/' '/Content/iTunes/') do: [ :head |
			((fi size > head size) and: [(fi copyFrom: 1 to: head size) = head])
				ifTrue: [fi := fi copyFrom: head size + 1 to: fi size]].
	strm := ReadStream on: fi.
	path := OrderedCollection new.
	sep := $/.
	[strm atEnd] whileFalse:
		[ | el |
		el := strm upTo: sep.
		el isEmpty ifFalse: [path addLast: el]]!

parseTags
	"Take the receiver's genre/content and tokenize it"
	"Track someInstance parseTags"
	"Track allInstancesDo: [ :it | it parseTags]"
	"Track allInstances detect: [ :it | it labels includes: #'Drama:News'] "

	labels := OrderedCollection new.
"	Transcript clear."
	self parseTags: self genre.
	self parseTags: self comment.
"	(labels includes: #'www.megatrax.com')
		ifTrue: [labels remove: #'www.megatrax.com'].
	(labels includes: #'Toll Free 888-MEGA-555')
		ifTrue: [labels remove: #'Toll Free 888-MEGA-555'].
"
"	Transcript show: labels printString; cr"!

parseTags0: field 
	"Take the given string and tokenize it"
	"Track someInstance parseTags: Track someInstance genre"
	"Track someInstance parseTags: Track someInstance comment"
	"DataSet defaultDataSet learnTags"

	| sep strm tok tokstr prevSep toks |
"	Transcript clear; cr; show: field; cr; cr."
	strm := ReadStream on: field.
	sep := #tok.
	prevSep := false.
"Read through the stream"
	[strm atEnd]
		whileFalse: 
			[| el |
			sep == #tok ifTrue: [tokstr := WriteStream on: String new].
			el := strm next.
			el ifNotNil: 
"Token read loop"
				[[el ~~ nil and: [el isAlphaNumeric]]
					whileTrue: 
						[tokstr nextPut: el.
						prevSep := false.
						el := strm next].
				tok := tokstr contents.
				tok isEmpty ifFalse: 
					[el ifNotNil:
"Handle separators"
						[el isSeparator
							ifFalse: [(($/ -> [sep := #slash]) ,
									($# -> [sep := #hash]) , 
									($_ -> [sep := #unders]) , 
									($. -> [sep := #dot]) , 
									($& -> [sep := #amps]) , 
									($: -> [sep := #colon]) ,
									($; -> [sep := #scolon]) , 
									($- -> [sep := #dash]) , 
									($, -> [sep := #comma])) 
								case: el otherwise: [sep := #other].
"Sep processing - some separators can be embedded..." 
								(#(dot dash unders slash amps) includes: sep) ifTrue:
										["labels addLast: sep."
										prevSep
											ifFalse: [tokstr nextPut: el.
												sep := #sep]
											ifTrue: [sep := #tok]].
"Some are ignores"
								(#("other" hash comma scolon amps comma colon) includes: sep) ifTrue: 
										["labels addLast: sep." 
										sep := #tok].
"								(#(dot dash) includes: sep) ifTrue: []."
								prevSep := false]
							ifTrue: [tokstr nextPut: el.			"store separator"
								sep := #sep.
								prevSep := true]].
"Add tok to list"
				(el isNil or: [sep == #tok])
					ifTrue: [tok last isSeparator ifTrue: [tok := tok copyFrom: 1 to: tok size - 1].
						(tok size > 1) " ifFalse: [self halt] "
							ifTrue: [toks := tok asSymbol.
								(labels includes: toks)
									ifFalse: [labels addLast: tok asSymbol].			"add 'em"
						sep := #tok]]]]].
"	Transcript show: labels printString; cr"!

parseTags: field 
	"Take the given string and tokenize it"
	"Track someInstance parseTags: Track someInstance genre"		"':SFX - General'"
	"Track someInstance parseTags: Track someInstance comment" 	"'Layered synth faller - Synth - N/A '"
	" | ti | ti := Track someInstance. ti parseTags: ti genre. ti"
	" | ti | ti := Track someInstance. ti parseTags: ti comment. ti"
	" | ti | ti := Track someInstance. ti parseTags. ti"
	"DataSet defaultDataSet learnTags"

	| pos fsize done |
"	Transcript cr; show: field; cr; cr."
"Read through the stream"
	pos := 1.
	[DataSet isSeparator: (field at: pos)]
		whileTrue: [pos := pos + 1].
	fsize := field size.
	done := false.
	[done] whileFalse: 
		[ | subs |
		subs := field copyFrom: pos to: fsize.
"		Transcript show: subs; cr."
		 DataSet tags associationsDo: 
			[ :ass | | ret |
"Do the name match"
			ret := ass value detect: [ :val | (val, '*') match: subs ignoreCase: true] ifNone: [nil].
			((ret ~~ nil) and: [ret size > 0]) ifTrue: 
				[(labels detect: [ :val | (val key == ass key) and: [val value = ret]] ifNone: [nil])
					ifNil: [labels addLast: (ass key -> ret)]]].
"skip to and over next separator"
		[(DataSet isSeparator: (field at: pos)) or: [pos = fsize]]
			whileFalse: [pos := pos + 1].
		[(DataSet isSeparator: (field at: pos)) and: [pos < fsize]]
			whileTrue: [pos := pos + 1].
		done := (pos >= fsize).
	].
"
	Transcript cr; show: labels printString; cr"! !



Smalltalk.Siren defineClass: #PlayList
	superclass: #{Siren.Track}
	indexedType: #none
	private: false
	instanceVariableNames: 'tracks parent all '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-DBase'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PlayList class methodsFor: 'instance creation'!

fromDictionary: dict with: trax
	"Create a new playlist"
	"Siren.PlayList fromDictionary: ()"
	"Siren.PlayList name: 'te' id: 1 key: 123 parent: 234 items: #() all: true"
	"DataSet someInstance loadPlayLists"

	| inst trx |
	inst := self new.
	inst name: (dict at: #Name ifAbsent: ['']) .
	inst id: (dict at: #PlaylistID ifAbsent: [0]).
	inst key: (dict at: #PlaylistPersistentID ifAbsent: ['']) asSymbol.
	inst parent: (dict at: #ParentPersistentID ifAbsent: ['']) asSymbol.
	inst all: (dict at: #AllItems ifAbsent: [true]) .
	trx := dict at: #PlaylistItems ifAbsent: [#()].
	trx do: [ :it | inst addTrack: (it at: #TrackID) with: trax].
	inst size: trx size.
	^inst

"		<dict>
			<key>Name</key><string>Emil Gilels, Eugen Jochum; Berlin Philharmonic Orchestra</string>
			<key>Playlist ID</key><integer>344239</integer>
			<key>Playlist Persistent ID</key><string>47E554C8F42B81F9</string>
			<key>Parent Persistent ID</key><string>9DCCFC04F85C8A5E</string>
			<key>All Items</key><true/>
			<key>Playlist Items</key>
			<array>
				<dict>
					<key>Track ID</key><integer>86536</integer>
				</dict>
				<dict>
					<key>Track ID</key><integer>86538</integer>
				</dict>
				<dict>
					<key>Track ID</key><integer>86540</integer>
				</dict>
			</array>
		</dict>
"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.PlayList comment:
'A PlayList corresponds to an iTunes play list

Instance Variables:

	tracks	<ClassOfVariable>	description of variable''s function
	parent	<ClassOfVariable>	description of variable''s function
	all	<ClassOfVariable>	description of variable''s function'!

!Siren.PlayList methodsFor: 'accessing'!

addList: aValue

	tracks isSequenceable
		ifTrue: [tracks := Dictionary new "
				self error: 'Adding trax & folders to the same playlist' " ].
	tracks isNil
		ifTrue: [tracks := Dictionary new].
	tracks at: aValue name put: aValue.
	aValue parent: self!

addTrack: trk

	tracks ifNil: [tracks := OrderedCollection new].
	tracks addLast: trk!

addTrack: aValue with: trax

	| trk |
	tracks ifNil: [tracks := OrderedCollection new].
	trk := trax at: aValue "printString asSymbol" ifAbsent: [nil].
	trk isNil
		ifTrue: [self halt. tracks addLast: aValue]
		ifFalse: [tracks addLast: trk]!

all

	^all!

all: aValue

	all := aValue!

allArtists
	"self allArtists"

	| co se | 
	co := OrderedCollection new. 
	self allTracksInto: co.
	se := Set new.
	co do: [ :tr | se add: tr artist].
	Transcript clear.
	co := se asSortedCollection.
	co do: [ :tr | Transcript show: tr asString; cr].
	^co!

allTracks

	^self allTracksInto: OrderedCollection new.!

allTracksInto: coll
	" | co | co := OrderedCollection new. self allTracksInto: co. co"

	tracks do:
		[ :tr |
		tr tracks isNil
			ifTrue: [coll addLast: tr]
			ifFalse: [tr allTracksInto: coll]]!

asSymbol
	"Hack"

	^nil!

at: nam

	^tracks at: nam!

id

	^id!

id: aValue

	id := aValue!

isEmpty

	^false!

key

	^key!

key: aValue

	key := aValue!

parent

	^parent!

parent: aValue

	parent := aValue!

removeListNamed: aSymbol

	tracks isSequenceable
		ifTrue: [tracks := Dictionary new "self error: 'Adding trax & folders to playlist'" ].
	tracks isNil
		ifTrue: [^nil].
	tracks removeKey: aSymbol ifAbsent: []!

size

	^size!

size: aValue

	size := aValue!

tracks

	^tracks!

tracks: aValue

	tracks := aValue! !

!Siren.PlayList methodsFor: 'printing'!

fullName
	"Full name with parents"

	self parent isNil
		ifTrue: [^self name].
	self parent size = 0
		ifTrue: [^self name].
	self parent isSymbol
		ifTrue: [^self parent asString, ' / ', self name].
	^self parent fullName, ' / ', self name!

printOn: aStream

	aStream nextPutAll: self fullName.
	self size ifNotNil: [aStream nextPutAll: '  --  ', self size printString]! !



Smalltalk.Siren defineClass: #DataSetTool
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'tree '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-DBase'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DataSetTool class methodsFor: 'interface specs'!

windowSpec
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'SndsLike Data Set' 
			#bounds: #(#{Graphics.Rectangle} 489 281 951 619 ) 
			#flags: 4 
			#menu: #menuBar 
			#toolBar: #menuBar ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.TreeViewSpec} 
					#layout: #(#{Graphics.LayoutFrame} 4 0 24 0 -4 1 -4 1 ) 
					#name: #TreeView1 
					#flags: 15 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 7700 7700 7700 ) ) 
					#model: #tree 
					#menu: #treeMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) ) ) )! !

!Siren.DataSetTool class methodsFor: 'resources'!

menuBar
	"Tools.MenuEditor new openOnClass: self andSelector: #menuBar"

	<resource: #menu>
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#rawLabel: 'file' ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'edit' ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'view' ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'tools' ) ) #(4 ) nil ) decodeAsLiteralArray!

treeMenu
	"Tools.MenuEditor new openOnClass: self andSelector: #treeMenu"

	<resource: #menu>
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#rawLabel: 'spawn' 
				#value: #spawnItem ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'inspect' 
				#value: #inspect ) ) #(2 ) nil ) decodeAsLiteralArray! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DataSetTool comment:
'DataSetTool is the GUI for looking into DataSets

Instance Variables:

	tree	<DataSet>	the root'!

!Siren.DataSetTool methodsFor: 'actions'!

inspect

	self tree selection ifNotNil: [self tree selection inspect]! !

!Siren.DataSetTool methodsFor: 'interface opening'!

childrenFor: aNode
	"tracks"

	
	aNode isEmpty ifTrue: [^#()].
	aNode tracks ifNil: [^#()].
	^aNode tracks isSequenceable
		ifTrue: [aNode tracks]
		ifFalse: [aNode tracks values asSortedCollection]!

postOpenWith: aBuilder
	super postOpenWith: aBuilder.
	self tree list:
		(TreeModel 
			on: Siren.DataSet defaultDataSet "tags" root
			displayRoot: false
			childrenWith: [ :node | self childrenFor: node]).
	self tree selectionIndexHolder
		onChangeSend: #nodeSelected to: self
"self halt."! !

!Siren.DataSetTool methodsFor: 'notifications'!

nodeSelected

	self tree selectionIndexHolder ifNil: [^self].
	self tree selection ifNil: [^self].
"	self tree selection inspect."
"	self tree selection open"! !

!Siren.DataSetTool methodsFor: 'aspects'!

childrenOf: anXMLNode
self halt.
	^[anXMLNode children reject: [:some | some isText]]
		on: Error
		do: [:ex | ex return: #()]!

tree
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^tree isNil
		ifTrue:
			[tree := MultiSelectionInTree new]
		ifFalse:
			[tree]! !



Smalltalk.Siren defineClass: #TagSetTool
	superclass: #{Siren.DataSetTool}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-DBase'!

!Siren.TagSetTool methodsFor: 'aspects'!

childrenOf: aNode

	^aNode children! !

!Siren.TagSetTool methodsFor: 'notifications'!

nodeSelected

	self tree selectionIndexHolder ifNil: [^self].
	self tree selection ifNil: [^self].
"	self tree selection inspect."
"	self tree selection open"! !

!Siren.TagSetTool methodsFor: 'interface opening'!

childrenFor: aNode
	"children"

	^aNode isCollection
		ifTrue: [aNode values]
		ifFalse: [aNode children values]!

postOpenWith: aBuilder
	super postOpenWith: aBuilder.
	self tree list:
		(TreeModel 
			on: Siren.DataSet defaultDataSet tags
			displayRoot: false
			childrenWith: [ :node | self childrenFor: node]).
	self tree selectionIndexHolder
		onChangeSend: #nodeSelected to: self
"self halt."! !



Smalltalk.Siren defineClass: #SpeciesTrainingTool
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-DBase'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SpeciesTrainingTool class methodsFor: 'token stats'!

addSrcTokens: srcFile
	"Add tokens to the discriminator match methods in the given file"
	"SpeciesTrainingTool 
		addSrcTokens: '/Content/Code/BirdsEar/BirdsEarApp_Code/Discriminators/DiscriminatorsEast2.cpp'"

	| src tok clName pos1 pos2 |
	src := (Filename named: srcFile) contentsOfEntireFile.
	pos1 := 1.
	tok := '::match(Engine *eng, Recording * rec)'.
	[pos1 > 0] whileTrue:
		[pos1 := src findString: tok startingAt: pos1.
		pos2 := pos1.
		[(src at: pos2) == $ "space"] whileFalse: [pos2 := pos2 - 1].
		clName := src copyFrom: pos2 + 1 to: pos1 - 1.
		Transcript show: clName; cr.
	]
	

"	float AmericanGoldfinchSong::match(Engine *eng, Recording * rec) {
	#if TRAIN
		TRAIN_SPECIES
	#else
		MATCH_PREAMBLE							// preamble declares conf, evts, labs, mnD & mxD

		CHECK_ELIST_SIZE(0, 20, 0.9f, false)
		CHECK_ELIST_DUR(1.625, 3.109, 0.9f, false)
		CHECK_MN_DUR(0.024, 0.025, 0.9f)
		CHECK_MX_DUR(0.191, 0.211, 0.9f)

		EVENT_LOOP_OPEN							// event loop; defines ev, lab & tag
			SIF_TAG_NIN(tag, tDUR, '456', 0.9f)
		EVENT_LOOP_CLOSE

		return conf;								// bingo!!
		MATCH_HANDLER								// catch exceptions
	#endif
"!

addSrcTokens: srcFile to: outFile
	"Add tokens to the discriminator match methods in the given file"
	"SpeciesTrainingTool 
		addSrcTokens: '/Content/Code/BirdsEar/BirdsEarApp_Code/Discriminators/DiscriminatorsEast1.cpp'
		to: '/Content/Code/BirdsEar/BirdsEarApp_Code/Discriminators/DiscriminatorsEast1b.cpp' "

	| src clName pos0 pos1 pos2 out |
	src := (Filename named: srcFile) contentsOfEntireFile.
	out := (Filename named: outFile) writeStream.
	pos0 := pos1 := 1.
" Loop looking for matching method signature"
	[pos1 > 0] whileTrue:
		[pos1 := src findString: '::match(Engine *eng, Recording * rec)' startingAt: pos1.
		(pos1 > 0) ifTrue:
			[pos2 := pos1.
			[(src at: pos2) == $ "space"] whileFalse: [pos2 := pos2 - 1].
"copy class name"
			clName := src copyFrom: pos2 + 1 to: pos1 - 1.
			Transcript show: clName; cr.
			pos1 := src findString: 'MATCH_PREAMBLE' startingAt: pos1.
			(pos1 > 0) ifTrue:
				[pos1 := src nextIndexOf: Character cr from: pos1 to: src size.
"write up through MATCH_PREAMBLE, then class token"
				out nextPutAll: (src copyFrom: pos0 to: pos1).
				out nextPutAll: ('	//-- ', clName, ' match'); cr.
				pos0 := pos1 + 1.
				pos1 := src findString: 'EVENT_LOOP_CLOSE' startingAt: pos1.
				pos1 := src nextIndexOf: Character cr from: pos1 to: src size.
				out nextPutAll: (src copyFrom: pos0 to: pos1).
				out nextPutAll: ('	//-- END'); cr.
				pos0 := pos1 + 1.
	]]].
	out close

"	float AmericanGoldfinchSong::match(Engine *eng, Recording * rec) {
	#if TRAIN
		TRAIN_SPECIES
	#else
		MATCH_PREAMBLE							// preamble declares conf, evts, labs, mnD & mxD

		CHECK_ELIST_SIZE(0, 20, 0.9f, false)
		CHECK_ELIST_DUR(1.625, 3.109, 0.9f, false)
		CHECK_MN_DUR(0.024, 0.025, 0.9f)
		CHECK_MX_DUR(0.191, 0.211, 0.9f)

		EVENT_LOOP_OPEN							// event loop; defines ev, lab & tag
			SIF_TAG_NIN(tag, tDUR, '456', 0.9f)
		EVENT_LOOP_CLOSE

		return conf;								// bingo!!
		MATCH_HANDLER								// catch exceptions
	#endif
"!

confusionStatsSummaryFor: txtFile
	"BEApp confusion stats summary - read confusion summary spreadsheet and print the 'noisiest' species"
	"SpeciesTrainingTool confusionStatsSummaryFor: '/Content/Code/BirdsEar/Doc/SpeciesConfusion_141128.txt' "

	| inF spec results confusion scoll |
	Transcript clear; cr; show: '--------------------------------------------------------------------------------------'; cr; cr.
	Transcript show: 'Summary Stats'; cr; cr.
	inF := txtFile asFilename readStream.
	results := Dictionary new.
	confusion := Dictionary new.
"Loop through file reading the song names"
	[inF atEnd] whileFalse:
		[ | lin tok num ch |
		lin := ReadStream on: (inF upTo: Character cr).
		ch := lin peek.
		((ch == nil) or: [(ch == Character cr) or: [(ch == Character tab) or: [ch == $-]]]) ifFalse:
			[tok := (lin upTo: Character tab) asSymbol.
			lin skip: 2.
			num := Number readFrom: lin.
			Transcript show: tok string, '		', num printString; cr.
			results at: tok put: num asFloat.
			confusion at: tok put: 0.0]].
	inF close.
"Print sorted summary stats"
	Transcript cr; show: '--------------------------------------------------------------------------------------'; cr.
	Transcript cr; show: 'Summary Stats Sorted'; cr; cr.
	scoll := SortedCollection new.
	results associationsDo: [ :ass | scoll add: ass].
	scoll sort: [:a :b | a value > b value].
	scoll do: [ :ass |
		(ass value > 0) ifTrue: 
			[Transcript show: ass key string, '		',  ass value asInteger printString; cr]].
	Transcript cr; show: '--------------------------------------------------------------------------------------'; cr.
	Transcript cr; show: 'Confusion Stats'; cr; cr.
	inF := txtFile asFilename readStream.
"Loop through the file accumulating confusing species"
	spec := ''.
	[inF atEnd] whileFalse:
		[ | lin tok num val ch |
		lin := ReadStream on: (inF upTo: Character cr).
		val := 1.0.
		ch := lin peek.
		((ch == nil) or: [(ch == Character cr) or: [ch == $-]]) ifFalse:
		[(ch == Character tab)
			ifFalse:
				[spec := (lin upTo: Character tab) asSymbol.
				val := results at: spec.
				val == 0.0 ifTrue: [val := 1.0]]
			ifTrue: [lin skip: 1.
				tok := (lin upTo: Character tab) asSymbol.
				tok == spec ifFalse:
					[num := Number readFrom: lin.
"					Transcript show: spec printString, '		',  tok printString, '		', num printString; cr."
					(confusion includesKey: tok) ifTrue:
						[confusion at: tok put: ((confusion at: tok) + (num / (val)))]]]]].
"Copy results to a sorted collection, reverse sort and print"
	scoll := SortedCollection new.
	confusion associationsDo: [ :ass | scoll add: ass].
	scoll sort: [:a :b | a value > b value].
	scoll do: [ :ass |
		(ass value > 0) ifTrue: 
			[Transcript show: ass key string, '		',  ass value asInteger printString; cr]].
	inF close.
	Transcript cr" ; show: 'Found ', confusion size printString, ' items'; cr."!

copyPlayList: srcFile
	"Copy and rename MP3 files"
	"copyPlayList: srcFile"

	| src tok clName pos1 pos2 |
	src := (Filename named: srcFile) contentsOfEntireFile.
	pos1 := 1.
	tok := '::match(Engine *eng, Recording * rec)'.
	[pos1 > 0] whileTrue:
		[pos1 := src findString: tok startingAt: pos1.
		pos2 := pos1.
		[(src at: pos2) == $ "space"] whileFalse: [pos2 := pos2 - 1].
		clName := src copyFrom: pos2 + 1 to: pos1 - 1.
		Transcript show: clName; cr.
	]
	

"


"!

copyPlayList: srcFile in: folder
	"Copy and rename MP3 files"
	"SpeciesTrainingTool copyPlayList: 'list.txt' in: '/Content/Sound/Sampler CDs/Sumer2014/' "

	| list srcName destName count pref pos |
	list := (Filename named: folder, srcFile) readStream.
	count := 1.
	Transcript clear.
	[list atEnd] whileFalse:
		[srcName := list upTo: Character cr.
		pos := srcName lastIndexOf: $/.
		count < 10
			ifTrue: [pref := '0', count printString]
			ifFalse: [pref := count printString].
		destName := folder, pref, ' - ', (srcName copyFrom: pos + 1 to: srcName size).
"		Transcript show: 'Copy ', srcName; crtab; show: ' to ', destName; cr."
		[(Filename named: srcName) copyTo: destName]
			on: Error
			do: [Transcript show: 'Error copying ', srcName; crtab; show: ' to ', destName; cr.].
		count := count + 1.
	]!

copySelectionFrom: topFolder in: inFolders to: outFolder
	"Copy a random sample of the old files to the new folder"
	"SpeciesTrainingTool copySelectionFrom: '/Users/stp/Business/BirdsEar/Analysis4/' 
		in: #('AMECRO' 'AMEGOL L flight call long' 'AMEGOL flight call short' 'AMEGOL song' 'AMEROB high call' 'AMEROB regular call' 
			'AMEROB song' 'BALORI songs' 'BAROWL full call' 'BLCACH harsh call' 'BLCACH song' 'BLUJAY main call' 'BLUJAY short shriek' 
			'BRHCOW high slur' 'BRHENU calls' 'BROTHR songs' 'CARCHI harsh' 'CARCHI song only' 'CARWRE call' 'CARWRE songs' 
			'CEDWAX' 'CHISPA song' 'COMGRA' 'COMYEL' 'COOHAW' 'DAEJUN trill' 'DAEJUN tu tu' 'DOWWOO call' 'DOWWOO whinny' 
			'EASOWL Whinny Files' 'EASPHO 2' 'EASTOW drink only' 'EASTOW drink tea' 'EAWOPE' 'EUCDOV songs' 'EURSTA scold' 
			'EUSTAR general call' 'FISCRO ts' 'GRACAT call' 'GRACAT song' 'GRCFLY clear only' 'GRCFLY wheep only' 'GRHOOW main song' 
			'HAIWOO' 'HOUFIN' 'HOUSPA' 'HOUWRE ts' 'INDBUN song' 'KILDEE strip' 'MOUDOV' 'NORCAR' 'NORFLI LONG CALLS' 
			'NORFLI SHORT EUW CALL' 'NORMOC files to use' 'ORCORI songs' 'PILWOO main calls' 'PURFIN songs ID Criteria' 
			'REBEWO CHACK CALLS' 'REBEWO CHURR' 'REBRNU calls' 'REEVIR songs' 'RESHAW' 'REWBLA oklee' 'ROBGRO songs' 
			'ROCPIG call seq' 'ROCPIG single calls' 'SCATAN songs' 'SONSPA' 'SUMTAN songs' 'TUFTIT harsh call' 'TUFTIT peter song' 
			'VEERY songs' 'WARVIR SONGS' 'WHBRNU' 'WHPOWI call' 'WHTHSP SONG analyze' 'WOOTHR songs' 'YELWAR')
		to: '/Users/stp/Business/BirdsEar/Analysis4/3b_Selections' "

	|  num outF inFolder inFiles fi rnd oFiles |
	num := 5.
	outF := outFolder asFilename.
	outF exists ifFalse: [ ^nil ].
	rnd := Random new.
	Transcript clear.
	inFolders do: [ :di |
		Transcript show: di; cr.
		inFolder := (topFolder, di) asFilename.
		inFiles := inFolder directoryContents.
		inFiles := inFiles select: [ :it | '*.wav' match: it].
		oFiles := OrderedCollection new.
		1 to: num do: [ : ind |
			fi := inFiles atRandom: rnd.
			[(topFolder, di, '/', fi) asFilename isDirectory] whileTrue: [fi := inFiles atRandom: rnd].
			[oFiles includes: fi] whileTrue: [fi := inFiles atRandom: rnd].
			(topFolder, di, '/', fi) asFilename copyTo: (outFolder, '/', di, '_', ind printString, '.wav').
			oFiles addLast: fi.
		]
	]!

cvsTranslate: inFile toXML: dir
	"Take the metadata spreadsheet and copy it to the XML folders"
	"SpeciesTrainingTool 
		cvsTranslate: '/Users/stp/Business/BirdsEar/Analysis4/0_Metadata/SpecDataEast.tsv'
		toXML: '/Content/Code/BirdsEar/BirdsEarApp_Code/Data/XML/' "

	| src list lin snam tnam fnam xml desc crTab |
	Transcript clear.
	src := (Filename named: inFile) readStream.
"Skip first line"
	lin := src skipThrough: Character cr.
"loop through lines creating the XML files"
	[src atEnd] whileFalse:
		[lin := src upTo: Character cr.
		lin isEmpty ifFalse:
			[list := lin asSequenceableCollection: $	 "tab" .
			(list size < 22) ifTrue:
				[22 - list size timesRepeat: [list addLast: '']].
			snam := list first.								"spec name"
			tnam := snam copyReplaceAll: ' ' with: '_'.		"token name"
			fnam := tnam copyReplaceAll: '''' with: ''.		"file name"
"			Transcript show: fnam; cr."
"Create and write XML file"
			fnam := dir, fnam, '.xml'.
			xml := (Filename named: fnam) writeStream.
			Transcript show: 'Writing ', fnam; cr.
"add CRs to description"
"			crTab := '.', (String with: Character cr), '    '. "
			crTab := '.', (String with: Character cr with: Character cr).
			desc := (list at: 3) copyReplaceAll: '.    ' with: crTab.
			desc := desc copyReplaceAll: '.   ' with: crTab.
			desc := desc copyReplaceAll: '.  ' with: crTab.
			xml nextPutAll: ('<?xml version="1.0" encoding="UTF-8" ?>
<BE_SPECIES>
	<Name>', snam, '</Name>
	<LatinName>', (list at: 2), '</LatinName>

	<MinimumLatitude>-90</MinimumLatitude>
	<MaximumLatitude>90</MaximumLatitude>

	<MinimumLongitude>-180</MinimumLongitude>
	<MaximumLongitude>180</MaximumLongitude>

	<MinimumDay>0</MinimumDay>
	<MaximumDay>365</MaximumDay>

	<MinimumTime>0</MinimumTime>
	<MaximumTime>2400</MaximumTime>

	<MinimumDuration>0.01</MinimumDuration>
	<MaximumDuration>10.0</MaximumDuration>

	<WP_URL>http://en.wikipedia.org/wiki/', tnam, '</WP_URL>
	<IB_URL>', (list at: 4), '</IB_URL>

	<Picture1>', (list at: 5), '</Picture1>
	<Picture2>', (list at: 6), '</Picture2>
	<Picture3>', (list at: 7), '</Picture3>
	<Picture4>', (list at: 8), '</Picture4>
	<Song1>', (list at: 9), '</Song1>
	<Song1Title>', (list at: 10), '</Song1Title>
	<Song2>', (list at: 11), '</Song2>
	<Song2Title>', (list at: 12), '</Song2Title>
	<Song3>', (list at: 13), '</Song3>
	<Song3Title>', (list at: 14), '</Song3Title>
	<Song4>', (list at: 15), '</Song4>
	<Song4Title>', (list at: 16), '</Song4Title>
	<Song5>', (list at: 17), '</Song5>
	<Song5Title>', (list at: 18), '</Song5Title>
	<Song6>', (list at: 19), '</Song6>
	<Song6Title>', (list at: 20), '</Song6Title>
	<Song7>', (list at: 21), '</Song7>
	<Song7Title>', (list at: 22), '</Song7Title>

	<Description>', desc, '
</Description>

</BE_SPECIES>'); cr.
				xml close]].
	src close

"Fields

Common Name
Latin Name
Description
AllAboutBirds Link
Picture 1 Name
Picture 2 Name
Picture 3 Name
Picture 4 Name
Song 1
Song 1 Title
Song 2
Song 2 Title
Song 3
Song 3 Title
Song 4
Song 4 Title
Song 5
Song 5 Title
Song 6
Song 6 Title
Song 7
Song 7 Title
"!

eventStatsFor: toks
	"BEApp event list stats"

	| cnt stats nams num |
	nams := #(nEvts Dur mnDur mxDur ).
	stats := Array new: 4.
	num := toks size / 4.
	cnt := 1.
	Transcript clear; cr; show: 'Processing ', num printString, ' lines; '; cr.
"Init arrays"
	1 to: 4 do: [ :ind |
		stats at: ind put: (Array new: num)].
"copy data to matrix"
	1 to: num do: [ :ind |
		1 to: 4 do: [ :in2 | (stats at: in2) at: ind put: (toks at: cnt). 
			cnt := cnt + 1]].
"Calc min/max"
	1 to: 4 do: [ :ind |  | mn mx sm va av dv |
		mx := -1000000.
		mn := 1000000.
		sm := 0.
		dv := 0.
		1 to: num do: [ :in2 |
			va := (stats at: ind) at: in2.
			(va > mx) ifTrue: [mx := va].
			(va < mn) ifTrue: [mn := va].
			sm := sm + va].
		av := (sm / num) asFloat.
		dv := 0.
		1 to: num do: [ :in2 |
			va := (stats at: ind) at: in2.
			dv := dv + (va - av) squared].
		dv := dv / num.
		Transcript tab; show: (nams at: ind) printString, '		', 
				mn printString, '	-	', 
				mx printString, '		a ', 
				av printString, '	d ', 
				dv asFloat printString, '		s0 ', 
				((av - dv) max: 0) printString, '	s1 ', 
				(av + dv) asFloat printString; cr]!

removeDupFiles0: oldFolder with: newFolder
	"Remove files in old from new"
	"SpeciesTrainingTool removeDupFiles: '/Content/Code/new/birdsearappPreEx164' with: '/Content/Code/new/birdsearapp499'  "

	| inFiles outFiles cmpBlok iFil oFil inDir outDir |
	inFiles := oldFolder asFilename directoryContents.
	outFiles := newFolder asFilename directoryContents.

	cmpBlok := [ :old1 :new1 | | newF | 
			newF := new1 asFilename. 
			(newF exists) ifTrue: 
				[Transcript show: 'Remove ',  new1 printString; cr.
			"	newF delete]"].

	inFiles do: [ :fNam | 
		iFil := fNam asFilename.
		oFil := outFiles detect: [ :ea | ea = fNam] ifNone: [nil].
		oFil ifNotNil: 
			[iFil isDirectory
				ifTrue: [ | iFi2 oFi2 |
					inDir := iFil directoryContents.
					outDir := oFil asFilename directoryContents.
				"		iFi2 := iFil constructSafe:  "
						inFiles do: [ :fNa2 | 
						iFil := fNa2 asFilename. ]]
				ifFalse: [


					]
	
		]]]!

removeDupFiles: oldFolder with: newFolder
	"Remove files in old from new"
	"SpeciesTrainingTool removeDupFiles: '/Content/Code/new/birdsearappPreEx164' with: '/Content/Code/new/birdsearapp499'  "

	| inFiles outFiles cmpBlok iFil oFil inFolder outFolder |
	inFolder := oldFolder asFilename.
	outFolder := newFolder asFilename.
	outFolder exists ifFalse: [ ^nil ].
	inFiles := inFolder directoryContents.
	outFiles := outFolder directoryContents.
"	Transcript show: 'removeDupFiles: ', oldFolder, ' with: ', newFolder; cr."

	cmpBlok := [ :old1 :new1 | | newF | 
			newF := new1 asFilename. 
			(newF exists) ifTrue: 
				[Transcript show: 'Remove ',  new1 printString; cr.
				newF delete  ]].

	(inFiles select: [ :fn | fn ~= '.svn']) do: [ :fNam | 
		iFil := oldFolder asFilename construct: fNam.
		oFil := outFiles select: [ :ea | ea = fNam].
		oFil isNil
			ifTrue: [Transcript show: '	Not found: ',  fNam printString; cr.] 
			ifFalse: [oFil := newFolder asFilename construct: fNam.
				iFil exists ifTrue: [iFil isDirectory
					ifTrue: [SpeciesTrainingTool removeDupFiles: (iFil asString) with: (oFil asString) ]
					ifFalse: [cmpBlok value: (iFil asString) value: (oFil asString)]]]]!

tokenStatsFor: toks
	"BEApp Token list stats"
	"SpeciesTrainingTool tokenStatsFor: #( 547835 557735 357875 555835 ) "

	| nams sums val |
	nams := #(Dur Pitch BWidth Gliss Harm Ampl ).
	sums := Array new: 10.
	Transcript clear; cr; show: 'Processing ',  toks size printString, ' tokens; ',
						toks first printString size printString, ' labels.'; cr.
	1 to: toks first printString size do: [ :ind |
		1 to: 10 do: [ :in2 | sums at: in2 put: 0].
		toks do: [ :to |
			val := (to printString at: ind) asInteger - $0 asInteger.
"			Transcript show: ' ',  val printString."
			sums at: val put: ((sums at: val) + 1)].
		Transcript show: 'Res for ', (nams at: ind) printString; cr.
		1 to: 10  do: [ :in2 | ((sums at: in2) > 0) 
			ifTrue: [Transcript tab; show: in2 printString, ' = ', (sums at: in2) printString; cr]]]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!




Smalltalk.Siren defineClass: #Tag
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'name tracks parents children siblings '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-DBase'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Tag class methodsFor: 'instance creation'!

name: nam track: tr
	"Create and return a new Tag"

	| inst |
	inst := self new initialize.
	inst name: nam.
	tr ifNotNil: [inst tracks addFirst: tr].
	^inst! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Tag comment:
'A Tag represents a metadata label used in a song data set. It has its name and references to the songs that use it.

Instance Variables:

	name		<Symbol>	my name
	parent		<Tag>	my parent tag
	children	<OrderedCollection of Tags>	child tags
	tracks		<OrderedCollection of Tracks>	the songs that use this tag'!

!Siren.Tag methodsFor: 'accessing'!

addChild: aTag

	children at: aTag name put: aTag!

addParent: aTag

	parents at: aTag name put: aTag!

addSibling: aTag

	siblings at: aTag name put: aTag!

children

	^children!

isTag

	^true!

name

	^name!

name: aValue

	name := aValue!

parents

	^parents!

siblings

	^siblings!

tracks

	tracks ifNil: [tracks := OrderedCollection new].
	^tracks!

tracks: aValue

	tracks := aValue! !

!Siren.Tag methodsFor: 'printing'!

printOn: aStream
	"Format and print the receiver on the argument."

	aStream nextPutAll: name value, ' - ', self tracks size printString, ' tracks'.! !

!Siren.Tag methodsFor: 'initialize-release'!

initialize
	"Setup instance"

	parents := IdentityDictionary new.
	children := IdentityDictionary new.
	siblings := IdentityDictionary new.!

reinitialize
	"Setup instance"

	parents := IdentityDictionary new.
	children := IdentityDictionary new.
	siblings := IdentityDictionary new.! !



Smalltalk.Siren defineClass: #DataSet
	superclass: #{Siren.AbstractEvent}
	indexedType: #none
	private: false
	instanceVariableNames: 'tracks albums playlists root artists tree date majVersion minVersion appVersion folder persID features tags name '
	classInstanceVariableNames: 'SongDataSet Tags '
	imports: ''
	category: 'Music-DBase'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DataSet class methodsFor: 'examples'!

example1
	"Load an iTunes XML data set"
	"DataSet example1"
	"DataSet flushDataSet"

	| db |
	db := DataSet new: '/Volumes/Content/iTunes/Library120412b.xml'.
	Transcript cr.
"	Transcript show: db printString; cr."
	db inspect.

"| lis |
lis := self tree elements last.
Transcript cr; show: lis tag; cr.
Transcript cr; show: lis elements size printString; cr.
lis elements do: [ :el |
Transcript cr; show: el  size printString]
"
"	Transcript show: db tracks size printString; cr.
	Transcript show: db albums size printString; cr.
	Transcript show: db playlists size printString; cr.
	Transcript show: db tree type.

	db tree elements do:
		[ :el |
		Transcript show: el size printString; cr.
		el size > 0 ifTrue: [el elements do: 
			[ :el2 |
			Transcript show: el2 size printString; cr]]].
"!

example2
	"Load and process a MegaTrax data set"
	"DataSet example2"
	"DataSet defaultDataSet"
"	TagSetTool open "

	DataSet flushDataSet.
	DataSet new: '/Volumes/Content/Code/SndsLike/DataSets/MTrax/msongs-strings.txt'.

	DataSet defaultDataSet learnTags: true.
	"DataSet defaultDataSet learnTags: false"

	DataSet defaultDataSet flushTags.
	DataSet defaultDataSet splitTags.
	DataSet defaultDataSet printTags: 600.! !

!Siren.DataSet class methodsFor: 'class var accessing'!

defaultDataSet
	"DataSet defaultDataSet"
	"DataSetTool open"

	SongDataSet ifNil: [self new: self defaultDataSetName].
	^SongDataSet!

defaultDataSetName
	"Answer an iTunes XML file"

	^'/Volumes/Content/iTunes/Library120412b.xml'!

flushDataSet
	"DataSet flushDataSet"

	SongDataSet ifNotNil: [SongDataSet release].
	SongDataSet := nil!

isSeparator: char
	"Check for AlphaNumeric or dash or dot"

	char isAlphaNumeric ifTrue: [^false].
	(#($. $-) includes: char) ifTrue: [^false].
	^true!

tags
	"DataSet tags"
	"Tags := nil"

	Tags ifNil: [Tags := self loadFiles: 'attributes.xml'].
	^Tags! !

!Siren.DataSet class methodsFor: 'xml import'!

loadFiles: fname 
	"Load the MegaTrax attributes files into a dict of identity sets"
	"DataSet loadFiles: 'attributes.xml'"

	| tree list dir taglist |
	dir := '/Volumes/Content/Code/SndsLike/DataSets/MTrax/XML/'.
	tree := XML.XMLParser processDocumentInFilename: dir , fname beforeScanDo: [:parser | parser validate: false].
	list := tree children first elements select: [:el | el isBlankText not].
	list := list collect: [:el | (el attributes at: 2) value].
	taglist := Dictionary new.
	list do: [ :fn | self loadList: fn in: dir to: taglist].
	^taglist!

loadList: fname in: dir to: taglist
	"Load a MegaTrax list files into an identity set"
	"DataSet loadFiles: 'attributes.xml'"

	| streem list tok it |
	tok := 'node label="'.
"	list := IdentitySet new."
	list := OrderedCollection new.
"Open file"
	streem := (dir , fname) asFilename readStream.
	[streem atEnd] whileFalse: 					"read file"
		[streem throughAll: tok.					"skip to token"
		it := streem upTo: $".						"read to $"
"		Transcript show: it; cr."
		list add: it "asLowercase asSymbol"].		"save lower-case symbol"
	streem close.
"Add to dict"
	taglist at: (fname copyFrom: 1 to: fname size - 4) asSymbol put: list! !

!Siren.DataSet class methodsFor: 'instance creation'!

new
	^super new initialize!

new: aFile
	"Load a data set"
	"DataSet new: '/Volumes/Content/iTunes/Library120412.xml' "
	"DataSet new: '/Volumes/Content/Code/SndsLike/DataSets/MTrax/msongs-strings.txt' "
	"DataSet someInstance"
	"DataSet flushDataSet"

	| inst dsname |
	SongDataSet ifNotNil: [SongDataSet release. SongDataSet := nil].
	inst := self new.
	('*.xml' match: aFile) 
		ifTrue: [inst read: aFile]
		ifFalse: [inst readStrings: aFile].
	dsname := Dialog request: 'Please edit data set name' initialAnswer: aFile.
	dsname isEmpty ifFalse: [inst name: dsname].
	SongDataSet := inst.
	^inst! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DataSet comment:
'DataSet is a holder of tracks, tags, and other metadata

Instance Variables:

	tracks		<OrderedCollection of Tracks>	the track list
	albums		<ClassOfVariable>	description of variable''s function
	playlists	<ClassOfVariable>
	root		<>
	artists		<>
	tree		<>
	date		<>
	majVersion		<>
	minVersion		<>
	appVersion	<>
	folder		<>
	persID		<>
	features	<>
	tags		<OrderedCollection of Trags>	the tag list'!

!Siren.DataSet methodsFor: 'accessing'!

addAlbum: alb

	albums add: alb!

addPlaylist: pls

	playlists add: pls!

addTrack: trk

	tracks add: trk!

albums

	^albums!

albums: aValue

	albums := aValue!

appVersion

	^appVersion!

appVersion: aValue

	appVersion := aValue!

artists

	^artists!

date

	^date!

date: aValue

	date := aValue!

features

	^features!

features: aValue

	features := aValue!

folder

	^folder!

folder: aValue

	folder := aValue!

majVersion

	^majVersion!

majVersion: aValue

	majVersion := aValue!

minVersion

	^minVersion!

minVersion: aValue

	minVersion := aValue!

persID

	^persID!

persID: aValue

	persID := aValue!

playlists

	^playlists!

playlists: aValue

	playlists := aValue!

root

	^root isNil
		ifTrue: [self]
		ifFalse: [root]!

tags

	tags ifNil: [tags := IdentityDictionary new].
	^tags!

tracks

	^tracks!

tracks: aValue

	tracks := aValue!

tree

	^tree! !

!Siren.DataSet methodsFor: 'initialize-release'!

free
	"Setup instance"

	tracks := nil.
	playlists := nil.
	albums := nil.
	artists := nil.
	tree := nil.!

initialize
	"Setup instance"

	super initialize.
	name := #none.
	tracks := Dictionary new.
	playlists := Dictionary new.
	albums := Dictionary new.! !

!Siren.DataSet methodsFor: 'printing'!

printElement0: el on: aStream
	"Format and print the receiver on the argument."

	el hasSubNodes
		ifFalse: [^aStream tab; nextPutAll: el class printString, ' ', el printString; cr].
	aStream tab; nextPutAll: ' - ', el elements size printString.
	el elements size > 0 
		ifTrue: ["self halt"
			1 to: (el elements size min: 24) do: 
				[ :el2 | self printElement: el2 on: aStream]]
"	tree tag type printOn: aStream. aStream cr."!

printElement: el on: aStream
	"Format and print the receiver on the argument."

	el hasSubNodes
		ifFalse: [^aStream tab; nextPutAll: el class printString, ' ', el printString; cr].
	aStream tab; nextPutAll: ' - ', el elements size printString.
	1 to: (el elements size min: 24) do: 
				[ :in | self printElement: (el elements at: in) on: aStream]
"	tree tag type printOn: aStream. aStream cr."!

printElement: el on: aStream depth: dep
	"Format and print the receiver on the argument."

	| op |
	dep > 3 ifTrue: [^self].
	dep timesRepeat: [aStream tab].
	el hasSubNodes
		ifFalse: [aStream nextPutAll: el class printString, ' ', el printString; cr. ^self].
	el isValue
		ifTrue: [ op := el value]
		ifFalse: [op := el elements].
	aStream nextPutAll: ' - ', op size printString.
	1 to: (op size min: 24) do: 
				[ :in | self printElement: (op at: in) on: aStream depth: dep + 1]
"	tree tag type printOn: aStream. aStream cr."!

printOn0: aStream
	"Format and print the receiver on the argument."

	super printOn: aStream.
	self tracks size printOn: aStream. aStream cr.
	self albums size printOn: aStream. aStream cr.
	self playlists size printOn: aStream. aStream cr.
	tree elements size printOn: aStream. aStream cr.
	tree elements do:
		[ :el |
		el hasSubNodes
			ifTrue: [el size printOn: aStream. 
				aStream nextPutAll: ' - ', el elements size printString; cr.
				el elements size > 0 ifTrue: ["self halt"
						el elements do: 
						[ :el3 | el3 hasSubNodes
							ifTrue: [aStream nextPutAll: ' : ', el3 elements size printString; cr]]]]
			ifFalse: [el size printOn: aStream. 
				aStream cr]].
"	tree tag type printOn: aStream. aStream cr."!

printOn: aStream
	"Format and print the receiver on the argument."

	super printOn: aStream.
	aStream nextPutAll: tracks size printString, ' tracks'; cr.
	aStream nextPutAll: playlists size printString, ' playlists'; cr.

"	self tracks size printOn: aStream. aStream cr.
	self albums size printOn: aStream. aStream cr.
	self playlists size printOn: aStream. aStream cr.
	tree elements size printOn: aStream. aStream cr.
	self printElement: tree on: aStream depth: 1
"! !

!Siren.DataSet methodsFor: 'cleaning'!

fileNotFound
	"Create a per-artist genre histogram"
	"DataSet someInstance fileNotFound"

	| tok tSiz count |
	Transcript clear.
	tok := 'file://localhost*'.
	tSiz := tok size.
	count := 1.
	tracks valuesDo: 
		[ :trk | | nam fnam dString rs byteA ws |
		count := count + 1.
		((count mod: 1000) = 0)
			ifTrue: [Transcript show: count printString; cr].
		nam := trk filename.
		(tok match: nam) ifTrue:
			[nam := nam copyFrom: tSiz to: nam size].
"		nam := nam copyReplaceAll: '%20' with: ' '."
		rs := nam readStream.
		byteA := ByteArray new: nam size.
		ws := byteA writeStream.
		[rs atEnd] whileFalse:
			[ | ch | 
			ch := rs next.
			ch = $%
				ifTrue:   [ws nextPut: (Number readIntegerFrom: (rs next: 2) readStream radix: 16)]
				ifFalse:  [ws nextPut: ch asInteger]].
		dString := byteA asStringEncoding: #'UTF-8'.
		nam := (CompositionStream on: dString readStream) contents.
		('http*' match: nam) 
			ifFalse: [fnam := Filename named: nam.
				(fnam exists) ifFalse:
					[Transcript show: nam; cr]]].
	Transcript cr; show: 'done.'; cr.!

genreHistogram
	"Create a per-artist genre histogram"
	"DataSet someInstance genreHistogram"
	"PlayList allInstances do: [ :in | in properties ifNotNil: [in properties removeKey: #tag ifAbsent: []]]"

	| tags |
	Transcript show: 'Generate per-artist genre histograms'; cr.
	(root at: #Artists) tracks associationsDo: 
		[ :ass | 
		ass value tracks associationsDo: 
			[ :as2 |  | nam art |
			nam := as2 key.
			Transcript show: nam; cr.
			art := as2 value.
			tags := Bag new.
			tags addAll: ((tracks select: [ :trk | trk artist == nam]) 
								collect: [ :trk2 | trk2 genre]).
			tags removeAllOccurrencesOf: #'' ifAbsent: [].
			art at: #tags put: tags]].
	Transcript cr; show: 'done.'; cr.!

notInPlaylists
	"Create a per-artist genre histogram"
	"DataSet someInstance notInPlaylists"
	"PlayList allInstances do: [ :in | in properties ifNotNil: [in properties removeKey: #tag ifAbsent: []]]"

	| tgs |
	Transcript show: 'Generate per-artist genre histograms'; cr.
	(root at: #Artists) tracks associationsDo: 
		[ :ass | 
		ass value tracks associationsDo: 
			[ :as2 |  | nam art |
			nam := as2 key.
			Transcript show: nam; cr.
			art := as2 value.
			tgs := Bag new.
			tgs addAll: ((tracks select: [ :trk | trk artist == nam]) 
								collect: [ :trk2 | trk2 genre]).
			tgs removeAllOccurrencesOf: #'' ifAbsent: [].
			art at: #tags put: tgs]].
	Transcript cr; show: 'done.'; cr.!

parseNames
	"Create an hierarchical list of names"
	"DataSet someInstance parseNames"

	Transcript show: 'Generate name tree'; cr.
	(root at: #Artists) tracks associationsDo: 		"A-Z list"
		[ :ass |
		ass value tracks associationsDo: 			"all artists"
			[ :as2 |  | nam strList types |
			nam := as2 key.
			Transcript show: nam; cr.
			strList := nam asString subStrings.
			as2 value at: #names put: strList.
			types := self parseTokens: strList.
			as2 value at: #types put: types.]].
	Transcript cr; show: 'done.'; cr.!

parseTokens: strList
	"Parse a list of strings into a list of token types"
	" i.e., #(The Jesus & Mary Chain) -> #(#article #name #conj #name #name)"

	| types dic |
	types := OrderedCollection new: strList size.
	dic := ((#article -> #(the an a ein eine u une)),
		 (#conj -> #(with including featuring feat and &)),
		  (#prep -> #(of )),	
		  (#punct -> #(. , / -))).
	strList do: [ :tok | | ty |
		ty := #name.
		dic associationsDo: [ :ass |
			(ass value includes: tok asSymbol) ifTrue: [ty := ass key]].
		types addLast: ty].
	^types! !

!Siren.DataSet methodsFor: 'parsing XML'!

addList: li to: di
	"Add the given list to the dictionary"
	"self addList: (playlists select: [ :it | it parent size == 0]) to: root."
	
	li associationsDo:
		[ :ass | | v chl |
		v := ass value.
		di addList: v.
		chl := playlists select: [ :it | it parent asSymbol = v key].
		chl isEmpty ifFalse:
			[Transcript show: '	Found ', chl size printString, ' under ', v name; cr].
		self addList: chl to: v].		"recurse"
	li size > 0 ifTrue: [di size: li size]!

groupAlbums
	"Parse the dictionary into an album list"
	"DataSet someInstance groupAlbums"

	| top |
	Transcript show: 'Group albums ', tracks size printString; cr.
"Get top-level nodes"
	top := Set new.
	top addAll: (tracks collect: [ :it | it album]).
	albums := Dictionary new.
	top do: [ :it | | li trx |
		it isEmpty ifFalse:
			[li := PlayList new name: it.
			trx := tracks select: [ :it2 | it2 album = it].
			trx isEmpty ifTrue: [self halt].
			trx do: [ :tr |
				li addTrack: tr].
			albums at: it asSymbol put: li]].
"	albums inspect"!

groupArtists
	"Parse the dictionary into an artist list"
	"DataSet someInstance groupArtists"
	"DataSet someInstance artists"
	"(DataSet someInstance playlists do: [ :it | it key: it key asString asSymbol])"
	"(DataSet someInstance playlists select: [ :it | it key == #'36556BEED87BEBA9' ])"

	| top albs ar |
	Transcript show: 'Group artists ', tracks size printString; cr.
"Get top-level nodes"
	top := Set new.
	top addAll: (tracks collect: [ :it | it artist]).
	artists := PlayList new name: 'Artists'.
	artists parent: root.
	top do: [ :art | | li trx |
		art isEmpty ifFalse:
			[li := PlayList new name: art.
			artists addList: li.
			trx := tracks select: [ :it2 | it2 artist == art].
			trx isEmpty ifTrue: [self halt].
			albs := Set new.
			albs addAll: (trx collect: [ :it | it album]).
			albs do: [ :al | | alb atrx |
				alb := PlayList new name: al.
				li addTrack: alb.
				atrx := trx select: [ :it2 | it2 album == al].
				atrx do: [ :atr |
					alb addTrack: atr]]]].
	artists size: artists tracks size.

	root removeListNamed: #Artists.
	ar := PlayList new name: #Artists.
	root addList: ar.
	65 to: 90 do:
		[ :in | | ch li li2 |
		ch := in asCharacter.
		Transcript show: '	Artists ', (String with: ch); cr.
		li := PlayList new name: ch asSymbol.
		li2 := artists tracks select: [ :pl | pl name first == ch].
		li2 values do: [ :it | li addList: it].
		ar addList: li.
		ar size: ar tracks size].
	artists := nil.!

groupPlayLists
	"Parse the dictionary into a play list"
	"DataSet someInstance groupPlayLists"
	"DataSet someInstance playlists"
	"DataSet someInstance root"
	"(DataSet someInstance playlists select: [ :it | '*Master*' match: it name]) "
	"(DataSet someInstance playlists select: [ :it | it parent = '']) "
	"(DataSet someInstance playlists select: [ :it | it size == 0]) size collect: [ :it | Transcript show: it name; cr]"
	"(DataSet someInstance playlists do: [ :it | it key: it key asString asSymbol])"
	"(DataSet someInstance playlists select: [ :it | it key == #'36556BEED87BEBA9' ])"

	| top genres |
	Transcript show: 'Group lists ', playlists size printString; cr.
"Get top-level nodes"
	top := playlists select: [ :it | it parent size == 0].
	root := PlayList new name: #Root.
	root id: 0.
	root key: 0.
	genres := PlayList new name: #Genres.
	root addList: genres.
	self addList: top to: genres.
"	root inspect"!

loadPlayLists
	"Parse the dictionary into a play list"
	"DataSet someInstance loadPlayLists"
	"DataSet someInstance playlists"
	"| ds di | di := Dictionary new.
	ds := DataSet someInstance.
	ds playlists associationsDo: [ :ass | di at: ass value key asSymbol put: ass value].
	ds playlists: di"

	| ind  lis |
	lis := tree at: #Playlists.
	Transcript show: 'Load lists ', lis size printString; cr.
	playlists := Dictionary new.
	ind := 1.
	lis do:
		[ :item | | plist |
		plist := PlayList fromDictionary: item with: tracks.
		playlists at: plist key asSymbol put: plist.
		tracks do: [ :trk | trk addPlaylist: plist].
		ind := ind + 1.
		(ind \\ 1000 == 0) ifTrue: [Transcript show: ind printString; cr]].!

loadTracks
	"Parse the dictionary into a track list"
	"DataSet someInstance loadTracks"
	"DataSet someInstance tracks"

	| trx ind  |
	trx := tree at: #Tracks.
	Transcript show: 'Load trax ', trx size printString; cr.
	ind := 1.
	trx associationsDo:
		[ :ass | | ke trk |
		ke := ass key.
		trk := Track key: ke fromDictionary: ass value.
		trk loadTags.			"read the file"
		tracks at: ke asString asNumber put: trk.
		ind := ind + 1.
		(ind \\ 1000 == 0) ifTrue: [Transcript show: ind printString; cr]].!

parseElement: el depth: dep index: indx
	"Load XML elements into a data set"
	"DataSet example1"

	| k v dict oc ind |
"Handle empty elements"
	el isText ifTrue:
		[(el text trimSeparators isEmpty) ifTrue: [^nil].
		^el text asSymbol].
"Handle dictionaries"
	el tag type = 'dict'
		ifTrue: [ind := indx.
			dict := Dictionary new.
			el elements do: [ :it | | ty |
				(it isText and: [it text trimSeparators isEmpty]) ifFalse: [
					ty := it tag type asSymbol .
					((#key -> [k := it elements first text]),
						(#integer -> [v := it elements first text asNumber]),
						(#string -> [it elements isEmpty ifTrue: [v := ''] ifFalse: [v := it elements first text]]),
						(#date -> [v := it elements first text]),
						(#data -> [v := it elements first text]),
						(#true -> [v := true]),
						(#false -> [v := false]),
						(#dict -> [v := self parseElement: it depth: dep + 1 index: ind.		"recurse"
								ind := ind + 1.
								(ind \\ 1000 == 0) ifTrue: [Transcript tab; 
										show: dep printString, '  ', ind printString, '  ', 
									k printString; cr]]),
						(#array -> [v := self parseElement: it depth: dep + 1 index: ind.		"recurse"
								ind := ind + 1.
								(ind \\ 1000 == 0) ifTrue: [Transcript tab; 
										show: dep printString, '  ', ind printString, '  ', 
									k printString; cr]]))
					case: ty
					otherwise: [Transcript show: it tag type; cr.
								self halt].
					(k notNil) & (v notNil)
						ifTrue: [ | k2 |
							k2 := (k copyReplaceAll: ' ' with: '') asSymbol.
							dict at: k2 put: v.
						"	k2 == #TrackID
								ifTrue: [Transcript tab; show: dep printString, '  ', ind printString, '  ', 
									k printString, ' -> ', v printString; cr]. "
							k := nil.  v := nil]]].
			^dict].
	el hasSubNodes ifFalse: [^el].
"Handle arrays"
	el elements size > 1
		ifTrue: [oc := OrderedCollection new.
			ind := indx.
			el elements do: 
				[ :el2 | | item |
				item := self parseElement: el2 depth: dep + 1 index: ind.			"recurse"
				item ifNotNil: [oc addLast: item.
					ind := ind + 1.
					(ind \\ 1000 == 0) ifTrue: [Transcript tab; 
						show: dep printString, '  ', ind printString, '  '; cr]]].
			^oc]!

read: aFilename
	"Load a data set"
	"DataSet new read: '/Volumes/Content/iTunes/Library120412a.xml' "
	"DataSet example1"
	"DataSet someInstance tracks first"

	Transcript cr; cr; show: 'Read DataSet ', aFilename; cr.
	tree := XML.XMLParser processDocumentInFilename: aFilename
					beforeScanDo: [:parser | parser validate: false].

	Transcript show: 'Parse DataSet'; cr.
	tree := self parseElement: tree root depth: 1 index: 1.
	tree := tree first.
	Transcript show: (tree at: #Tracks) size printString, ' tracks'; cr.
	Transcript show: (tree at: #Playlists) size printString, ' playlists'; cr.

	self loadTracks.
	self loadPlayLists.
	self groupPlayLists.
	self groupArtists.
	self groupAlbums.
	tree := nil.
	name := aFilename.
	Transcript cr; show: 'Done'; cr.!

readStrings: aFilename
	"Load a data set"
	"DataSet new read: '/Volumes/Content/iTunes/Library120412a.xml' "

	| fil trk|
	Transcript cr; cr; show: 'Read DataSet ', aFilename; cr.
"	trx := tree at: #Tracks."
	fil := aFilename asFilename readStream.
	fil upTo: Character cr.						"skip forst line"
	[fil atEnd] whileFalse:
		[trk := Track fromLine: (fil upTo: Character cr).
		tracks at: trk id put: trk.].
	Transcript show: tracks size printString, ' tracks'; cr.
	name := aFilename.
	Transcript cr; show: 'Done'; cr.! !

!Siren.DataSet methodsFor: 'megatrax'!

addRelationsFor: tok to: tag
	"Find related tags and add parent/child relationships"
	"DataSet defaultDataSet splitTags"
	"DataSet defaultDataSet flushTags"

	| other |
"	Transcript show: tok, ' : ', tag name string; cr. "
	(self tags includesKey: tok)
		ifTrue:  [other := self tags at: tok.
			(tag == other) ifTrue: [^self].
			other addChild: tag.
			tag addParent: other.
"			Transcript show: tok, ' : ', other name string; cr" ]
		ifFalse: [other := Tag name: tok track: nil.
			tags at: tok put: other.
			other addChild: tag.
			tag addParent: other.
"			Transcript show: tok, ' : ', tag name string; cr" ]!

buildTagsTree
	"Load the tags of the data set; re-load tags if reParse is true"
	"DataSet defaultDataSet learnTags: false"
	"DataSet defaultDataSet tags"
	" | ta | 
	ta := DataSet defaultDataSet tags.
	Transcript clear.
	1 to: 600 do: [ :ind | Transcript show: (ta at: ind) printString; cr]"

	| tags2 cnt |
	Transcript clear.
	Transcript show: 'Processing DataSet ', name; cr.
"Collect labels"
	Transcript show: 'Loading tags'; cr.
	self tags do: 
		[ :ta | | t2 |
			t2 := tags detect: [ :tag | tag name == true	
								]
					ifNone: [nil].
	]!

filterDegenerate
	"Drop the vacuous tags"
	"DataSet defaultDataSet filterDegenerate"

	| tags1 tags2 |
	tags1 := tags values.
	tags1 removeAllSuchThat: 
		[ :it | (((it tracks isEmpty) and: [it parents values isEmpty]) and: [it children values size == 1])].
	tags2 := IdentityDictionary new.
	tags1 do: [ :it | tags2 at: it name put: it].
	Transcript crtab; show: tags size printString, ' tags'; cr.
	tags := tags2.
	Transcript tab; show: tags size printString, ' tags'; cr.!

filterNumbers
	"Drop the really short tokens and number-first tags"
	"Transcript cr; tab; show: DataSet defaultDataSet tags size printString, ' tags'; cr.
	DataSet defaultDataSet filterNumbers.
	Transcript tab; show: DataSet defaultDataSet tags size printString, ' tags'; cr. "
	"29896 to 29271"

	| tags2 |
	tags2 := IdentityDictionary new.
"Loop over tags"
	self tags values do: 
		[ :ta | | toks tk1 |
		(ta name size > 2) ifTrue:
"Scanner on tag"
			[toks := Scanner new breakIntoTokens: ta name.
			tk1 := toks first string.
			(tk1 asNumber == 0) ifTrue:			"starts with a number: ignore"
				[tags2 at: ta name put: ta]]].
	tags := tags2.!

fixAbbreviations
	"Find truncated tags"
	"DataSet defaultDataSet fixAbbreviations"

	| tagL srch coll |
"Loop over tags looking for matches"
	tagL := self tags values.
	tagL do: 
		[ :ta |
		(ta name size > 4) ifTrue:
			[srch := ta name string, '*'.
			coll := tagL select: [ :item | srch match: item name string].
			(coll size > 1)
				ifTrue: [Transcript cr; show: ta name string; crtab.
					coll do:
						[ :ma |
						ma size ~= ta name size
							ifTrue: [Transcript show: ma name string; tab]].
					self halt
					]]]!

flushTags
	"Reset the family dictionaries"
	"DataSet defaultDataSet flushTags"

	self tags values do: 
		[ :ta | ta reinitialize]!

isAlphaNumeric: char
	"Check for AlphaNumeric or dash or dot"

	char isAlphaNumeric ifTrue: [^true].
	(#($. $-) includes: char) ifTrue: [^true].
	^false!

isSeparator: char
	"Check for AlphaNumeric or dash or dot"

	char isAlphaNumeric ifTrue: [^false].
	(#($. $-) includes: char) ifTrue: [^false].
	^true!

learnTags: reParse
	"Load the tags of the data set; re-load tags if reParse is true"
	"DataSet defaultDataSet learnTags: false"
	"DataSet defaultDataSet tags"
	"DataSet defaultDataSet printTags: 600"

	| tags2 cnt "tagVs" |
	Transcript clear.
	Transcript show: 'Processing DataSet ', name; cr.
"Parse tracks; empty tag list"
	reParse ifTrue: [Transcript show: 'Parsing strings'; cr.
		self tracks do: [ :tr | tr parseTags]].
	tags := IdentityDictionary new.			"create tags dict"
"Collect labels"
	Transcript show: 'Loading tags'; cr.
	self tracks do: 
		[ :tr | tr labels do: 
			[ :lab | | ta |
"Case-insensitive compare"
			ta := tags at: lab ifAbsent: [nil].				"simple match here, clean up later"
			ta isNil
				ifTrue: [tags at: lab put: (Tag name: lab track: tr)]
				ifFalse: [ta tracks add: tr]]].
"Merge duplicates case insensitive"
	Transcript show: 'Culling'; cr.
	tags2 := IdentityDictionary new.
	cnt := 0.
	tags values do: [ :ts | | ta |
		ta := tags values select: [ :tx | ts name value match: tx name value ignoreCase: true].		"match tag names"
		(ta size = 1)
			ifTrue: [tags2 at: ta first put: ts]
			ifFalse: [ | t1 tn |
				t1 := ta first.
"				Transcript show: t1 name string, ' - '."
				(t1 == ts) ifTrue: 
					[tags2 at: t1 name put: t1.
					2 to: ta size do: [ :ind |
						tn := ta at: ind.
"						Transcript show: tn name string, ' - '."
						t1 tracks addAll: tn tracks].
"				Transcript cr"
				cnt := cnt + 1]]].
	Transcript tab; show: cnt printString, ' duplicates'; cr.
	Transcript tab; show: tags2 size printString, ' tags'; cr.
"Filter numbers and dead tags"
	Transcript show: 'Filtering'; cr.
	tags := tags2.
	self filterNumbers.
	Transcript tab; show: tags size printString, ' tags'; cr.
"Sort labels by frequency & Dump the top 300 to the Transcript"
"	Transcript show: 'Sorting'; cr.
	tagVs := tags values asSortedCollection: [ :a :b | a tracks size > b tracks size]. 
	1 to: 300 do: [ :ind | Transcript show: (tagVs at: ind) printString; cr].
"	Transcript cr; show: 'Done'; cr.!

printTags: howMany
	"Dump some tags to the Transcript"
	"DataSet defaultDataSet printTags: 600"

	| tagVs | 
	Transcript clear.
	tagVs := DataSet defaultDataSet tags values asSortedCollection: [ :a :b | a tracks size > b tracks size]. 
	1 to: 600 do: [ :ind | Transcript show: (tagVs at: ind) printString; cr]!

scanTokens: toks in: tag
	"Scan the token list in the tag"
	"DataSet defaultDataSet splitTags"

	| punct tk1 tk2 ind |
"Ignore 1-token tags"
	(toks size == 1)
		ifTrue: [^self].
"2 tokens: check len of 2"
	(toks size == 2)
		ifTrue: [tk1 := toks first string asSymbol.
			tk2 := (toks at: 2) string asSymbol.
"			(tk1 size < 3) ifTrue: [self halt]."			"handle too-short 1st tag"
			(tk2 size < 3)			"drop too-short 2nd tag"
					ifTrue: [tag name: tk1]
					 ifFalse: [self addRelationsFor: tk1 to: tag.
							self addRelationsFor: tk2 to: tag].
			^self].
"3 or more tokens"
	punct := 0.		"find longest list of words with no punct"
	ind := 1.
	[(punct == 0) and: [ind <= toks size]] whileTrue: 
		[ | tz |
		tz := (toks at: ind) string.
		((tz size == 1) and: [self isSeparator: tz first]) ifTrue: [punct := ind].
		ind := ind + 1].
"if no punct, add all words"
		(punct == 0) 
			ifTrue: [self scanWords: toks from: 1 to: toks size in: tag]
"Process the head"
			ifFalse: [self scanWords: toks from: 1 to: punct - 1 in: tag.
"Scan the tail"
					(punct == toks size) 
						ifFalse: [self scanTokens: (toks copyFrom: punct + 1 to: toks size) in: tag]]!

scanWords: tagList from: startI to: stopI in:tag
	"Scan a set of tag tokens"

"Loop over tags"
	startI to: stopI do: 
		[ :ind | | tok |
		tok := ''.
		startI to: ind do: 
			[ :in2 | | item |
			item := tagList at: in2.
			tok := tok, item.
			self addRelationsFor: tok asSymbol to: tag.
			(item size > 1)
				ifTrue: [tok := tok, ' ']]]!

splitTags
	"Loop over the tags scanning them and building the parent/child tree"
	"DataSet defaultDataSet splitTags"
	"29778 to 94906 tags"

	self flushTags.
	Transcript tab; show: tags size printString, ' tags'; cr.
"Loop over tags"
	self tags values do: 
		[ :ta | | toks |
"Scanner on tag"
		toks := Scanner new scanTokens: ta name.
		toks := toks collect: [ :item | item isSymbol ifTrue: [item] ifFalse: [item printString]].
		self scanTokens: toks in: ta].
	Transcript tab; show: tags size printString, ' tags'; cr! !

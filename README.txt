Siren 9.0 README File

This is the Siren 9.0 Music/Sound Package for Visualworks Smalltalk

The project home page is,
	http://FASTLabInc.com/Siren

To get the whole release, grab,
	http://FASTLabInc.com/Siren/Siren_9.0.zip

The best in-depth doc (book chapter) is in,
	http://FASTLabInc.com/Siren/SirenBookChapter.pdf

The read the demo code workbook, go to,
	http://FASTLabInc.com/Siren/Siren7.5_Workbook.html
	http://FASTLabInc.com/Siren/Siren7.5_Workbook.pdf

The current source code is in the Cincom public Store repository

What's Siren?

Siren is a software library for music and sound composition, processing, performance, and analysis; it is a collection of about 250 classes written in Smalltalk-80. Siren uses the Smoke music description language supports streaming I/O via OpenSoundControl (OSC), MIDI, and multi-channel audio ports. This version (7.5) works on VisualWorks Smalltalk 7.5, which is available for free for non-commercial use, see http://www.cincom.com/smalltalk.

Siren is a programming framework and tool kit; the intended audience is Smalltalk developers, or users willing to learn Smalltalk in order to write their own applications. The built-in applications are meant as demonstrations of the use of the libraries, rather than as end-user applications. Siren is not a specific MIDI sequencer, nor a score notation editor, through both of these applications would be easy to implement with the Siren framework.

There are several elements to Siren:
	the Smoke music representation language
		(music magnitudes, events, event lists, generators, functions, and sounds);
	voices, schedulers and I/O drivers
		(real-time and file-based voices, sound, score, and MIDI I/O);
	user interface components for musical applications
		(UI framework, tools, and widgets); and
	several built-in applications
		(editors and browsers for Smoke objects).
	external interfaces to real-time I/O and co-processing libraries
		(DLLCC and SWIG external models of dynamic C++ libraries)

See the references for more detailed descriptions and copious code examples.

If you're new to reading Smalltalk, see the language intro
	http://FASTLabInc.com/Siren/Doc/Reading_ST80.txt

To make full use of the Smalltalk code, there are several external packages that use DLLCC C/C++ glue code to access the LibSndFile, PortAudio, PortMIDI, FFTW and OSC libraries; the SWIG-based I/O Interfaces to both CSL (C++ signal synthesis/processing library) and Loris (analysis/resynthesis tool using bandwidth-enhanced partials) provide their own Smalltalk models that mirror the C++ class structure of these packages.

To install these, download and install the required packages, then look in the DLLCC folder and run the makefile there for each target library. The links for these are,
	libsndfile - http://www.zip.com.au/~erikd/libsndfile
	portmidi - http://www-2.cs.cmu.edu/~music/portmusic
	portaudio - http://www.portaudio.com
	fftw - http://www.fftw.org

The experimental SWIG interfaces are in the folders SWIG_Loris and SWIG_CSL; to use them, you need,
	Loris - http://sourceforge.net/projects/loris
and/or
	CSL - http://FASTLabInc.com/CSL

To build Siren, you start with a 7.5 VisualWorks Smalltalk virtual image and load the following packages from the release file set,
	Store/PostgreSQL
	BOSS
	DLLCC
	Advanced Tools
	HTTP
	XMLTools
	ComposedTextEditor

Then, in a Store browser, on the Cincom public repository, load SmaCC* and SWIG before loading the Siren package.

----

Building a Siren Image in VisualWorks 9.0

To load Siren into a VisualWorks 9.0 virtual image, follow these steps.

Start VW 9.0
	Load your favorite parcels (AT tools, DB, etc.)
	Siren requires the following packages:
		Store/PostgreSQL, DLLCC, BOSS, OldBrowsers (from vw 8.0)
	Load Siren9.0.pcl
	It should automatically do the next 2 steps, see the Transcript.
	File in the MusicConstants.st file
 		['Siren_9.0/MusicConstants.st' asFilename fileIn]

	Now use the Page/load_all menu item to load the workbook contents from the BOSS file Siren_9.0/Workbook9.0.bos
		[ListWorkBook open]

By-hand init (see these methods for site tuning)
	Siren.SoundFile initialize
	Siren.SirenUtility initialize (or SirenUtility initializeSirenSTP)

Load optional L&F hacks (in Siren9.0/PostBuild)
	Left-hand scroll bars - left-scroll-bar.st
	Custom colors - WidgetPolicy class-initializeDefaultGenericColors.st

See the appropriate Workbook pages for the following subsystems

	SirenUtility initialize. SirenSession initialize

Load and test the DLLCC External Interfaces (see the C makefiles and interface class defs)
	LibSndFile - [LibSndFileInterface example1: 'unbelichtet.aiff']
	PortMIDI - [PortMidiInterface testMIDI]
	FFTW - [FFTWInterface example]
	PortAudio - [PortAudioInterface example1]

Test the OSC I/O (assumes some OSC client)
	OSCVoice midiScaleExample

Load and test the SWIG Interfaces
	CSL 
		Siren.CSL.CSL initializeModule
		CSLGraph testSimpleGraph
	Loris
		Siren.Loris.Loris initializeModule
		Siren.Loris.Loris version
		See examples in LorisSound

Set up a new changelist and make a snapshot...

To use the DLLCC-based external interfaces for MIDI and Audio IO and accelerated FFT, copy the files in DLLCC/Libs into /usr/local/lib (on a Mac).

--------------

For more info, see the Doc directory and on-line workbook and reference manuals.

Stephen Travis Pope -- stp@create.uscb.edu -- May 2007 - May 2020

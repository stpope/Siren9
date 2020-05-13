# What is Siren?

The Siren system is a general-purpose software framework for music and sound composition, processing, performance, and analysis; it is a collection of about 350 classes written in Smalltalk-80 (40 kLOC or so). This version of Siren (9.0) works on VisualWorks Smalltalk (available for free for non-commercial use) and supports streaming I/O via OpenSoundControl (OSC), MIDI, and multi-channel audio ports. The Siren release is available via the web from the URL http://FASTLabInc.com/Siren. Note that you need a Smalltalk virtual machine and run-time to use Siren; you can down-load the free (non-commercial) system from Cincom at http://www.cincom.com/smalltalk or http://smalltalk.cincom.com/downloads/index.ssp

Siren is a programming framework and tool kit; the intended audience is Smalltalk developers, or users willing to learn Smalltalk in order to write their own applications. The built-in applications are meant as demonstrations of the use of the libraries, rather than as end-user applications. Siren is not a MIDI sequencer, nor a score notation editor, through both of these applications would be easy to implement with the Siren framework.

![Siren utility](https://github.com/stpope/Siren9/blob/master/gifs-new/SirenUtility.gif)

## There are several elements to Siren:

* the Smoke music representation language
		(music magnitudes, events, event lists, generators, functions, and sounds);
    
* voices, schedulers and I/O drivers
		(real-time and file-based voices, sound, score file, OSC, and MIDI I/O);
    
* user interface components for musical applications
		(UI framework, tools, and widgets);
    
* several built-in applications 
		(editors and browsers for Smoke objects); and
    
* external library interfaces for streaming I/O and DSP math
		(sound/MIDI I/O, fast FFT, CSL & Loris sound analysis/resynthesis packages )
    
![Siren components](https://github.com/stpope/Siren9/blob/master/gifs-new/SirenOverview1Page-small.gif)

Each of these components is described below in its own section of this document.

If you can read a bit of Smalltalk and want a quick tour before proceeding, read the condensed "Standard Siren Demo" that's at the end of this outline.

## Where's More Documentation?

Siren and its predecessors and components (ARA, DoubleTalk, HyperScore ToolKit, and MODE) are documented in several extended book chapters and articles:

* "Squeak: Open Personal Computing and Multimedia" (Mark Guzdial and Kim Rose, eds, Prentice-Hall, 2002);
    
* "Musical Signal Processing" (C. Roads, S. T. Pope, G. DePoli, and A. Piccialli, eds. Swets & Zeitlinger, 1997);
    
* "The Interim DynaPiano" in "Computer Music Journal" 16:3, Fall, 1992 (also on the CMJ Web site);
    
* "The Well-Tempered Object: Musical Applications of Object-Oriented Software Technology" (S. T. Pope, ed. MIT Press, 1991);
    
* Proceedings of the 1986, 1987, 1989, 1991, 1992, 1994, 1996, 1997, 2003 International Computer Music Conferences (ICMCs); 

* The MODE- and Smoke-related documents (including the above references) in the directory ftp://FASTLabInc.com/Siren/Doc or as PDF files on the page http://HeavenEverywhere.com/stp/publs.html.

The official Siren home page is http://FASTLabInc.com/Siren.

Here are the on-line Docs: The best in-depth doc (book chapter) is in,

http://FASTLabInc.com/Siren/Doc/SirenBookChapter.pdf

The read the demo code workbook (this text), go to,

http://FASTLabInc.com/Siren/Siren7.5.Workbook.html
  
	http://FASTLabInc.com/Siren/Siren7.5.Workbook.pdf

If you like to read manuals, take a look at,

http://FASTLabInc.com/Siren/Manual

Watch the detailed Siren demo at,

https://vimeo.com/120751122

![Siren transport](https://github.com/stpope/Siren9/blob/master/gifs-new/SirenTransportMenus.jpg)

## History

Siren and its predecessors stem from music systems that I've developed in the process of composing and realizing my music. Of the early ancestors, the MShell (1980-83) was the score processing shell used for "4" (1980-82); ARA (1982-4) was an outgrowth of the Lisp system used for "Bat out of Hell" (1983); the DoubleTalk system (1984-7) was based on the Smalltalk-80-based Petri net editing system used for "Requiem Aeternam dona Eis" (1986); the HyperScore ToolKit's various versions (1986-90) were used (among others) for "Day" (1988), and the MODE (1990-96) was developed to realize "Kombination XI" (1990) and "Paragraph 31: All Gates are Open" (1993).

Siren-on-Squeak (1996-2002) was a simple re-implementation of the MODE in the Squeak version of Smalltalk; it added the representations and tools I needed for "Four Magic Sentences" (1998-2000). Siren 7.4 added tools from the realizations of "Eternal Dream" (2002) and "Leur Songe de la Paix" (2003). The newest release incorporates new code from "Jerusalem's Secrets" and "Ora penso invece che il mondo..." (2005-6). In each of these cases, some amount of effort was spent--after the completion of the composition--to make the tools more general-purpose. 

![Siren utility](https://github.com/stpope/Siren9/blob/master/gifs-new/spectrum2.gif)

## Portability

The Smalltalk portion of Siren is 100% cross-platform, and the DLLCC external interfaces to sound file, MIDI, and sound streaming I/O use cross-platform libraries. There are a few places (Sound play command and aubio interfaces) that assume UNIX shell commands can be run form within Smalltalk; I'm not certain hiow these port to Windows.

The core of Siren is not dependent on the dialect of Smalltalk, and in fact, runs well in Squeak. The bulk of the interactive tools and GUIs are based on my own display list graphics framework, and are thus also portable. The actual integrated applications and GUIs in Siren 7.5 use VisualWorks-specific application model classes, though.

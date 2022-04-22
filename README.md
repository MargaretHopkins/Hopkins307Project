# Hopkins project report, MUMT 307

## Project goals
The goal of this project was to create a simple model for the additive synthesis of flugelhorn notes based on a group of sample notes, using linear interpolation. The model can be used either with input of a recording of a single note played on the trumpet, or a MIDI note number. In the case of the first note, the output is an additively synthesized note based on the flugelhorn model at the same pitch as the trumpet note, while in the second case, the output is an additively synthesized note at the specified MIDI pitch. 

## Background
The flugelhorn and trumpet are both brass instruments in the key of B flat, both made of 1.48m of metal pipe. Note that, as the flugelhorn and trumpet are instruments in B flat, the note names will refer by default to notes in this key, though the concert pitch note names will sometimes be included for clarity. Though the two instruments are nearly identical in playing technique, they have distinct tones. The trumpet is often described as having a more bright, brilliant tone than the mellower-sounding flugelhorn (Forsyth 1949, 165). The main physical difference between the flugelhorn and the trumpet is the conicality of the pipes. While both are cylindro-conical, i.e., combining cylindrical and conical sections, the flugelhorn is more conical than the trumpet. Benade (1990, 411) notes that conical instruments have fewer upper resonances than cylindrical instruments. This agrees with descriptions of the more conical flugelhorn as having a "darker" sound than the flugelhorn, as a "dark" tone is often associated with a lower spectral centroid (Schubert and Wolfe, 2006). 

## Methodology
The methods used in this project involved three main steps. First, the resonances of the recorded trumpet and flugelhorn notes were analyzed using an FFT and compared with one another, with particular interest given to the relative amplitudes of all partials above the fundamental frequency of each note. This analysis was then used to create a simple model for the resonance of the flugelhorn, using linear interpolation to predict amplitude ratios for notes between the sample notes. Finally, this model was used to generate an additively synthesized flugelhorn note given either a recorded trumpet note or a MIDI note number. 

The audio recordings used in this file were recorded on a Yamaha 8335s Xeno series B flat trumpet and a Couesnon flugelhorn. Seven notes were recorded for each instrument using a built-in MacBook Pro microphone, in a G major arpeggio starting from the lowest G on the instrument (F3 concert) to the G two octaves above (F5 concert). In the analysis section, an FFT was taken for each recorded note. For example, Figure 1 shows an FFT for a G4 on the trumpet and the flugelhorn. This analysis confirmed that for each note, the flugelhorn and the trumpet had a similarly structured spectrum, with peaks corresponding to the fundamental frequency and its overtones. The fundamental frequencies for each note were close to one another, with slight variation due to tuning discrepancies, and each had a series of overtones above. The locations of the first seven peaks were recorded for the lowest five notes, and the first six peaks for the highest two. The locations of these peaks were confirmed to correspond to the overtones of the notes by both viewing the locations of the peaks on the FFT graph to make sure they line up with visible peaks, and by calculating the frequency ratios between the overtones and confirming that they are very close to the whole number ratios 1 through 7. 

![image](https://user-images.githubusercontent.com/63251494/164791695-dfe976b9-64f3-4b79-a487-f394b677b46a.png)
Figure 1: FFT of a G4 (F4 concert) on trumpet and flugelhorn

After the peaks of all overtones were located, the relative strengths of the overtones across all partials for each note were compared. This comparison was chosen because the differences between trumpet and flugelhorn sounds are often described as a smaller amount of higher harmonics in the flugelhorn spectrum. Since we want to create a model that will interpolate the shape of the flugelhorn spectrum for various notes, we plot the ratio of the amplitude to the amplitude of the fundamental for a given harmonic over the f0 value for each of the recorded notes. For example, Figure 2 shows the relative strengths of the second harmonics over all of the f0 values. The f0 values are converted from frequencies to MIDI note numbers so that the pitch is on a linear scale for the interpolation. We can see in Figure 2 that for the second harmonic, the amplitude ratio is higher in the trumpet than for the flugelhorn for low- and high-range f0's, but that for the G4, the second harmonic is stronger in the flugelhorn than in the trumpet, though both instruments have a stronger second harmonic for this particular note than for the others. 

![image](https://user-images.githubusercontent.com/63251494/164791824-cc8770e1-f095-4b31-9e77-c8b3f78032ec.png)
Figure 2: Second harmonic amplitude ratios for trumpet and flugelhorn

By comparison, we can see in Figure 3 that the trumpet has consistently higher amplitude ratios for the fifth harmonic than the flugelhorn, supporting the hypothesis that the trumpet has stronger harmonic content in its higher overtones. Plots for all harmonics are available in the Matlab files, labeled "ar[harmonic number].fig".

![image](https://user-images.githubusercontent.com/63251494/164791890-23ce7afe-8aa5-4efe-9c93-91c339968794.png)
Figure 3: Fifth harmonic amplitude ratios for trumpet and flugelhorn

We can linearly interpolate between these values for any note in between the measured notes. In the case of the plot above, this means that we take the point along the line between two values that corresponds to our desired MIDI note number and use that value as the amplitude ratio for the second partial of that note. We can use the measured points to linearly interpolate the amplitude ratios of the seven (or six, for notes over the trumpet's B4, concert A4) partials above a given note. 

In the last step, we use these linearly interpolated values to additively synthesize a single note at either the pitch of the input note or at the input MIDI note. The sine wave frequency and amplitude of the fundamental are taken directly from the FFT of the input file, or the frequency is taken from the MIDI note number and the amplitude is set to a default of 0.03. For each partial above that, a sinusoid is sampled at a whole number multiples of the fundamental, *nf0*, where *n* is an integer between 2 and 7. The sinusoids are summed up for all seven (or six) partials, as in the equation in Figure 4, where the *a_i*'s are the amplitudes for each partial, *a_0* is the fundamental frequency amplitude, and *f_0* is the fundamental frequency. 

![image](https://user-images.githubusercontent.com/63251494/164767837-0d246574-fad6-4640-902a-34ac990098c2.png)
Figure 4: Equation for additive synthesis using flugelhorn model


## Results
The results are best assessed by listening to the synthesized flugelhorn tones. See the section ["Notes on the Matlab Files"](https://github.com/MargaretHopkins/Hopkins307Project#notes-on-the-matlab-files) for instructions on generating tones using the Matlab scripts. When compared with an additive synthesized tone that uses the measured trumpet parameters, the flugelhorn sound is audibly different from the trumpet sound, and could be reliably identified as a flugelhorn sound by informally surveyed trumpet players. When asked to describe the difference between the two tones, the listeners described the synthesized flugelhorn sound as "mellower" and "darker" than the trumpet sound, with "less overtones." With this simple model, we are able to create synthesized tones that sound like a flugelhorn, and transform trumpet recordings into flugelhorn sounds. 

## Limitations and future work
One of the largest limitations of this model is that the feature that detects the pitch of the input file requires the parameters to be tuned carefully and verified to ensure that the correct fundamental is chosen. The parameters used in these Matlab files are tuned to work on any of the recorded sounds included, but to use other files, it may be necessary to tune the peak detection parameters. If a more robust fundamental frequency detector were used, we could use the input file feature on more trumpet note files, or even files of any other pitched instrument, to transform them into a synthesized flugelhorn sound. 

Another limitation of this model is the limited range over which the model interpolates. While the notes G3 through G5 are the most common notes played by the flugelhorn, it is not uncommon for players to leave this range, particularly to play higher notes. With the current model, inputting a note outside this range results in a blank audio file, but with additional sampling outside this range it could be expanded. Due to tuning differences, even the lowest G and highest G trumpet audio files result in blank files, so the model actually works between low G sharp and high F sharp. 

This model can only be used to synthesize a single note at a time. It could be used to synthesize many notes in a row, or adapted for use in real-time using the MIDI note input technique. It would be more difficult to use it to transform a trumpet recording into a synthesized flugelhorn recording, as it would need to be split into frames and/or onset detection would need to be used to determine where new notes begin. 

The recordings used were recorded on a single B flat trumpet and a single flugelhorn, by one player, using an average-quality microphone. To create a more reliable model, many recordings could be taken with a high-quality microphone in a well-soundproofed room, by multiple players and using multiple different instruments, and combined to create a model that is more characteristic of the instrument and less influenced by the qualities of the particular performer, room, and instrument. Different methods of interpolation could also be explored, which may provide a more accurate model than the linear interpolation used. 

As the envelope was not the main focus of this project, the envelope used was a simple linear envelope estimated from a single recording of a trumpet note. To create a more realistic-sounding synthesis, different types of envelopes could be explored, different envelope parameters could be used for the different harmonics, and envelope differences between flugelhorn and trumpet could be assessed for their influence on the timbre of the instruments. 

## Notes on the Matlab files
The files included with this project include all of the amplitude ratio and FFT figures used to get data, a spreadsheet of all the parameters found through the FFT analysis, and functions to generate a note using the flugelhorn and trumpet models, from a trumpet audio file source or given a MIDI number. To generate a synthesized flugelhorn note, you can use either of the commands:

soundsc(flugelSound("tptG4.wav"), 44100)

soundsc(flugelSound(76), 44100)

Choosing option 1 for trumpet note input for the first example, or option 2 for the MIDI note input when prompted, changing the file name or MIDI note number as desired. Similarly, to generate a synthesized trumpet ntoe for comparison, you can use one of the commands:

soundsc(trumpetSound("tptG4.wav"), 44100)

soundsc(trumpetSound(76), 44100)

with the appropriate input type options chosen when prompted. 

## References
Benade, Arthur. 1990. *Fundamentals of Musical Acoustics: Second, Revised Edition*. New York: Dover Publications, Inc.

Forsyth, Cecil. 1949. *Orchestration, Second Edition*. New York: The Macmillan Company. 

Schubert, Emery and Joe Wolfe. 2006. "Does Timbral Brightness Scale with Frequency and Spectral Centroid?" *Acta Acustics united with Acustica* 92, no. 5: 820–825. 

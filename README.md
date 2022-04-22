# Hopkins project report, MUMT 307

## Project goals
The goal of this project was to create a simple model for the additive synthesis of flugelhorn notes based on a group of sample notes, using linear interpolation. The model can be used either with input of a recording of a single note played on the trumpet, or a MIDI note number. In the case of the first note, the output is an additively synthesized note based on the flugelhorn model at the same pitch as the trumpet note, while in the second case, the output is an additively synthesized note at the specified MIDI pitch. 

## Background
The flugelhorn and trumpet are both brass instruments in the key of B flat, both made of 1.48m of metal pipe. Though the two instruments are nearly identical in playing technique, they have distinct tones. The trumpet is often described as having a more bright, brilliant tone than the mellower-sounding flugelhorn (Forsyth 165). The main physical difference between the flugelhorn and the trumpet is the conicality of the pipes. While both are cylindro-conical, i.e., combining cylindrical and conical sections, the flugelhorn is more conical than the trumpet. **talk about pg 411 in Benade for cylindrical/conical distinction**

## Methodology
The methods used in this project involved three main steps. First, the resonances of the recorded trumpet and flugelhorn notes were analyzed using an FFT and compared with one another, with particular interest given to the relative amplitudes of all partials above the fundamental frequency of each note. This analysis was then used to create a simple model for the resonance of the flugelhorn, using linear interpolation to predict amplitude ratios for notes between the sample notes. Finally, this model was used to generate an additively synthesized flugelhorn note given either a recorded trumpet note or a MIDI note number. 

The audio recordings used in this file were recorded on a Yamaha 8335s Xeno series B flat trumpet and a Couesnon flugelhorn. Seven notes were recorded for each instrument using a built-in MacBook Pro microphone, in a G major arpeggio starting from the lowest G on the instrument (F3 concert) to the G two octaves above (F5 concert). In the analysis section, an FFT was taken for each recorded note. **show an example** This analysis confirmed that for each note, the flugelhorn and the trumpet had a similarly structured spectrum, with peaks corresponding to the fundamental frequency and its overtones. The fundamental frequencies for each note were close to one another, with slight variation due to tuning discrepancies, and each had a series of overtones above. The locations of the first seven peaks were recorded for the lowest five notes, and the first six peaks for the highest two. The locations of these peaks were confirmed to correspond to the overtones of the notes by both viewing the locations of the peaks on the FFT graph to make sure they line up with visible peaks, and by calculating the frequency ratios between the overtones and confirming that they are very close to the whole number ratios 1 through 7. 

After the peaks of all overtones were located, the relative strengths of the overtones across all partials for each note were compared. This comparison was chosen because the differences between trumpet and flugelhorn sounds are often described as a smaller amount of higher harmonics in the flugelhorn spectrum. Since we want to create a model that will interpolate the shape of the flugelhorn spectrum for various notes, we plot the ratio of the amplitude to the amplitude of the fundamental for a given harmonic over the f0 value for each of the recorded notes. For example, the plot below shows the relative strengths of the second harmonics over all of the f0 values. The f0 values are converted from frequencies to MIDI ntoe numbers so that the pitch is on a linear scale for the interpolation. We can see that... **put in a figure for 2nd harmonic and discuss the strengths**

We can linearly interpolate between these values for any note in between the measured notes. In the case of the plot above, this means that we take the point along the line between two values that corresponds to our desired MIDI note number and use that value as the amplitude ratio for the second partial of that note. We can use the measured points to linearly interpolate the amplitude ratios of the seven (or six, for notes over the trumpet's B4, concert A4) partials above a given note. 

In the last step, we use these linearly interpolated values to additively synthesize a single note at either the pitch of the input note or at the input MIDI note. The sine wave frequency and amplitude of the fundamental are taken directly from the FFT of the input file, or the frequency is taken from the MIDI note number and the amplitude is set to a default of 0.03. For each partial above that, a sine wave is sampled at a whole number multiples of the fundamental, *nf0*, where *n* is an integer between 2 and 7. 

## Results
How does it sound?

## Difficulties/discussion


## Notes on the Matlab files
How to get started/use the matlab files

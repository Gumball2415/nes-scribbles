plot.py "vid out scanline 1.bin"
plot.py "vid out scanline 2.bin"
plot.py "vid out scanline 3.bin"

ffmpeg -framerate 2 -i "vid out scanline %%1d.bin.png" -filter_complex "split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" "composite_waveform_example.gif"
"composite_waveform_example.gif"

pause
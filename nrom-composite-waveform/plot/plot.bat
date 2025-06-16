plot.py "scanline 1.bin"
plot.py "scanline 2.bin"
plot.py "scanline 3.bin"

ffmpeg -framerate 2 -i "scanline %%1d.bin.png" -filter_complex "split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" "composite_waveform_example.gif" -y
"composite_waveform_example.gif"

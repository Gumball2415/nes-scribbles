# Each NES scribble has more or less the same structure
# because it uses the same template makefile with minor
# modifications.

for dir in */; do
	cd "$dir";
	make all
	cd ..
	mkdir -p distribute && cp -a "$dir"output distribute/"$dir"
done
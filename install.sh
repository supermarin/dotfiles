IGNORED_FILES=(. .. .git .gitignore)

for file in .*
do
    if [[ "${IGNORED_FILES[@]}" =~ "${file} " || "${IGNORED_FILES[${#IGNORED_FILES[@]}-1]}" == "${file}" ]]; then
        # whatever you want to do when arr contains value
        echo "should not link $file"
    else
	link_from=$(pwd)/$file
	link_to=~/$file
	ln -s $link_from $link_to
    fi
done


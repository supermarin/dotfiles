function xopen
    open (find . -name '*.xcworkspace' -maxdepth 1) 2> /dev/null
    if [ !$status ]
        open (find . -name '*.xcodeproj' -maxdepth 1) 2> /dev/null
    end
    if [ !$status ]
        echo "No .xcworkspace or .xcodeproj found in the working directory."
    end
end


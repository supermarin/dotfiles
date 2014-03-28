function xopen
    open (find . -name '*.xcworkspace' -maxdepth 1) 2> /dev/null
    if [ $status -ne 0 ]
        open (find . -name '*.xcodeproj' -maxdepth 1) 2> /dev/null

        if [ $status -ne 0 ]
            echo "No .xcworkspace or .xcodeproj found in the working directory."
        end
    end
end


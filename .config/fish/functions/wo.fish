# Search through my code directories and quickly open project folder
# wo = workon
function wo
    set -l code_dir ~/code
    cd (find $code_dir -type d -maxdepth 3 | grep -i $argv | grep -Ev Pods --max-count=1)
end


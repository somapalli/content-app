#!/bin/bash

# Function to analyze a single repository
analyze_repo() {
    local repo_path="$1"
    local repo_name=$(basename "$repo_path")
    
    echo "Analyzing repository: $repo_name"
    echo "----------------------------------------"
    
    # Get total number of commits
    total_commits=$(git -C "$repo_path" rev-list --count HEAD)
    echo "Total commits: $total_commits"
    
    # Get commit statistics per user
    echo -e "\nCommit statistics per user:"
    echo "----------------------------------------"
    git -C "$repo_path" log --format='%an' | sort | uniq -c | sort -nr | while read count author; do
        echo "Author: $author"
        echo "Number of commits: $count"
        
        # Get lines added/deleted per author
        echo "Lines changed:"
        git -C "$repo_path" log --author="$author" --numstat --pretty=format:"" | awk '
            BEGIN {add=0; del=0}
            /^[0-9]/ {add+=$1; del+=$2}
            END {printf "  Added: %d\n  Deleted: %d\n", add, del}'
        echo "----------------------------------------"
    done
    
    # Get commit dates
    echo -e "\nCommit dates:"
    echo "----------------------------------------"
    git -C "$repo_path" log --format='%an - %ad' --date=short | sort -r | head -n 5
    echo "----------------------------------------"
    echo -e "\n"
}

# Main script
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory_containing_repos>"
    exit 1
fi

REPO_DIR="$1"

# Check if directory exists
if [ ! -d "$REPO_DIR" ]; then
    echo "Error: Directory $REPO_DIR does not exist"
    exit 1
fi

# Loop through all directories in the specified path
for dir in "$REPO_DIR"/*/; do
    if [ -d "$dir" ] && [ -d "$dir/.git" ]; then
        analyze_repo "$dir"
    fi
done 
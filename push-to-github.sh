#!/bin/bash

# GitHub Upload Script for SpeedMeter

echo "🚀 SpeedMeter - GitHub Upload Helper"
echo ""
echo "This script will help you push your code to GitHub."
echo ""

# Check if git remote exists
if git remote get-url origin > /dev/null 2>&1; then
    echo "✅ Remote 'origin' already configured:"
    git remote get-url origin
    echo ""
    read -p "Do you want to push to this remote? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted."
        exit 1
    fi
else
    echo "⚠️  No remote repository configured."
    echo ""
    echo "Please create a repository on GitHub first, then enter the details:"
    echo ""
    read -p "Enter your GitHub username: " github_username
    read -p "Enter repository name (default: SpeedMeter): " repo_name
    repo_name=${repo_name:-SpeedMeter}
    
    echo ""
    echo "Choose connection method:"
    echo "1) HTTPS (recommended for most users)"
    echo "2) SSH (if you have SSH keys set up)"
    read -p "Enter choice (1 or 2): " -n 1 connection_type
    echo ""
    echo ""
    
    if [ "$connection_type" = "1" ]; then
        remote_url="https://github.com/${github_username}/${repo_name}.git"
    else
        remote_url="git@github.com:${github_username}/${repo_name}.git"
    fi
    
    echo "Adding remote: $remote_url"
    git remote add origin "$remote_url"
    
    if [ $? -ne 0 ]; then
        echo "❌ Failed to add remote. Please check the URL and try again."
        exit 1
    fi
    
    echo "✅ Remote added successfully!"
    echo ""
fi

# Ensure we're on main branch
echo "📋 Checking branch..."
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "Renaming branch to 'main'..."
    git branch -M main
fi

# Show what will be pushed
echo ""
echo "📦 Commits to be pushed:"
git log --oneline --graph origin/main..HEAD 2>/dev/null || git log --oneline --graph
echo ""

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo ""
    echo "🎉 Your repository is now live at:"
    git remote get-url origin | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//'
    echo ""
    echo "Next steps:"
    echo "  1. Visit your repository on GitHub"
    echo "  2. Add topics: macos, swift, swiftui, network-monitoring"
    echo "  3. Consider adding screenshots to README"
    echo "  4. Create a release tag: git tag v1.0.0 && git push --tags"
else
    echo ""
    echo "❌ Push failed. Common issues:"
    echo "  - Repository doesn't exist on GitHub (create it first)"
    echo "  - Authentication failed (use personal access token, not password)"
    echo "  - SSH key not configured (use HTTPS instead)"
    echo ""
    echo "For help, see: GITHUB_UPLOAD.md"
fi

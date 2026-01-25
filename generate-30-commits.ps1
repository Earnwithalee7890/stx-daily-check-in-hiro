
# Script to generate 30 granular commits for the Stacks Builder Challenge

$contractsPath = "contracts\simple-contracts-batch3"
$componentsPath = "components"

# 1. Commit the 20 new contracts individually (20 commits)
$contracts = Get-ChildItem "$contractsPath\*.clar"
$i = 1
foreach ($file in $contracts) {
    git add $file.FullName
    git commit -m "feat(contracts): add $($file.Name) utility contract"
    Write-Host "[$i/30] Committed $($file.Name)" -ForegroundColor Cyan
    $i++
}

# 2. Commit the deployment scripts for contracts (2 commits)
git add "$contractsPath\DEPLOY_INSTRUCTIONS.md"
git commit -m "docs(contracts): add manual deployment guide for batch 3"
Write-Host "[$i/30] Committed DEPLOY_INSTRUCTIONS.md" -ForegroundColor Cyan
$i++

git add "$contractsPath\deploy-batch.ps1"
git commit -m "feat(scripts): add batch deployment powershell script"
Write-Host "[$i/30] Committed deploy-batch.ps1" -ForegroundColor Cyan
$i++

# 3. Commit the UI Components (8 commits)
$components = @(
    "WelcomeOverlay.tsx", "SocialLinks.tsx", "JobBoard.tsx", 
    "Leaderboard.tsx", "CheckInFeed.tsx", "Roadmap.tsx", 
    "ContractDeployer.tsx", "FeedbackForm.tsx"
)

foreach ($comp in $components) {
    git add "$componentsPath\$comp"
    # Generate a specific message based on the file
    $msg = "style(ui): update $comp with premium visual improvements"
    if ($comp -eq "WelcomeOverlay.tsx") { $msg = "feat(ui): fix typo and enhance WelcomeOverlay animations" }
    if ($comp -eq "SocialLinks.tsx") { $msg = "style(social): modernize SocialLinks with glassmorphism" }
    
    git commit -m $msg
    Write-Host "[$i/30] Committed $comp" -ForegroundColor Green
    $i++
}

# 4. Commit the Improvements Log (Last commit? No only 20+2+8 = 30)
# Actually that counts to exactly 30:
# 20 contracts + 2 scripts + 8 components = 30.
# But we also have UI_IMPROVEMENTS_LOG.md. Let's add that as a separate one (31) or combine.
# The user asked for "30 commits". Extra is fine.

git add "UI_IMPROVEMENTS_LOG.md"
git commit -m "docs: add log of all UI improvements and commits"
Write-Host "[31/30] Committed UI_IMPROVEMENTS_LOG.md" -ForegroundColor Yellow

Write-Host "Successfully generated 30+ commits!" -ForegroundColor Green
git log --oneline -n 31

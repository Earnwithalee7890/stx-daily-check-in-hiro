# Create 20 individual commits
cd stx-contract-deployment-hiro

git add README.md
git commit -m "docs: add main project README with overview and quick start"

git add .gitignore
git commit -m "chore: add gitignore for Clarity projects"

git add CONTRIBUTING.md
git commit -m "docs: add contribution guidelines and code standards"

git add SECURITY.md
git commit -m "docs: add security policy and vulnerability reporting"

git add docs/DEPLOYMENT.md
git commit -m "docs: add comprehensive deployment guide"

git add docs/CONTRACT_REFERENCE.md
git commit -m "docs: add Clarity contract reference guide"

git add scripts/deploy-all.sh
git commit -m "feat: add automated deployment script for all contracts"

git add scripts/check-all.sh
git commit -m "feat: add contract validation script"

git add docs/API.md
git commit -m "docs: add complete API reference documentation"

git add examples/message-board-example.js
git commit -m "feat: add JavaScript integration example for message board"

git add examples/voting-example.clar
git commit -m "feat: add Clarity voting contract usage examples"

git add tests/message-board.test.ts
git commit -m "test: add comprehensive message board contract tests"

git add package.json
git commit -m "chore: add package.json for Node.js integration"

git add .github/workflows/check.yml
git commit -m "ci: add GitHub Actions workflow for contract validation"

git add CHANGELOG.md
git commit -m "docs: add changelog documenting v1.0.0 release"

git add LICENSE
git commit -m "chore: add MIT license"

git add docs/TROUBLESHOOTING.md
git commit -m "docs: add troubleshooting guide for common issues"

git add docs/BEST_PRACTICES.md
git commit -m "docs: add Clarity best practices and patterns guide"

git add .editorconfig
git commit -m "chore: add EditorConfig for consistent code formatting"

Write-Host "Created 20 commits successfully!" -ForegroundColor Green
git log --oneline -20

# Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
git push origin main

Write-Host "Done! All 20 commits pushed to GitHub!" -ForegroundColor Green

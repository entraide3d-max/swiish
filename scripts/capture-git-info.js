#!/usr/bin/env node
/**
 * Capture Git information at build time
 * This script detects the current git branch and writes it to src/version.json
 * It's automatically run before build/start to ensure the app knows which branch it's on
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const outputPath = path.join(__dirname, '..', 'src', 'active-branch.json');

function getGitBranch() {
  // 1. Try to get the branch name from git first (if .git folder is present)
  try {
    const branch = execSync('git rev-parse --abbrev-ref HEAD', {
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'pipe']
    }).trim();
    
    // If we got a valid branch (not HEAD), return it
    if (branch && branch !== 'HEAD') {
      return branch;
    }
  } catch (error) {
    // Git failed or not a repo, continue to fallback
  }

  // 2. Fallback to environment variable (useful for CI/Docker where .git might be missing)
  if (process.env.GIT_BRANCH) {
    return process.env.GIT_BRANCH;
  }

  return null;
}

function main() {
  const branch = getGitBranch();
  
  const versionInfo = {
    branch: branch,
    capturedAt: new Date().toISOString()
  };
  
  fs.writeFileSync(outputPath, JSON.stringify(versionInfo, null, 2));
  console.log(`Git info captured: branch=${branch || 'unknown'}`);
}

main();

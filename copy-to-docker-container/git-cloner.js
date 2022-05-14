const { execSync } = require('child_process');

const {
  GIT_REPO_URL: gitRepoUrl,
  GIT_USERNAME: gitUsername,
  GIT_EMAIL: gitEmail
} = process.env;

const gitRepoSsh = 'git@github.com:'
  + gitRepoUrl.split('github.com/')[1];

clone();

function clone() {
  log('\nUsing Git credentials from host:');
  log('hr');
  log('username:', gitUsername);
  log('email:', gitEmail);
  log('repository:', gitRepoSsh);
  log('hr');

  try {
    exec(`git config --global user.name "${gitUsername}"`);
    exec(`git config --global user.name "${gitEmail}"`);
    exec(`git clone ${gitRepoSsh} cl`);
  }
  catch (error) {
    log('\nFAILED TO CLONE:\n');
    log(error + '');
    log('hr');
    log('NOTE:');
    log('You need to add the following SSH-key to your GitHub account:');
    log('\nXXXYYYZZZZ');
    log('hr');
  }
}

function exec(...args) {
  execSync(...args, { stdio: 'pipe' });
}

function log(...args) {
  args[0] = args[0] === 'hr' ? '_'.repeat(70) + '\n' : args[0];
  console.log(...args);
}
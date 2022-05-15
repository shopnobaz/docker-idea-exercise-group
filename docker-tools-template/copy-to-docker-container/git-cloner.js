const fs = require('fs');
const { execSync } = require('child_process');

const {
  GIT_REPO_NAME: gitRepoName,
  GIT_BRANCH_NAME: gitBranchName,
  GIT_REPO_URL: gitRepoUrl,
  GIT_USERNAME: gitUsername,
  GIT_EMAIL: gitEmail,
  HOST_REPO_PATH: hostRepoPathAlmost
} = process.env;

const hostRepoPath = hostRepoPathAlmost
  .replaceAll('\\\\', '/').split('/docker-tools')[0];

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
    exec([
      // copy ssh-key to .ssh folder
      'cp -r ssh-key /root/.ssh',
      // set correct chmod for ssh-key files
      'chmod -R 400 /root/.ssh',
      // start ssh agent
      'eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519',
      // set git username and email
      `git config --global user.name "${gitUsername}"`,
      `git config --global user.email "${gitEmail}"`,
      // add github.com to known host (this avoids question before clone)
      'ssh-keyscan github.com >> /root/.ssh/known_hosts',
      // clone
      `git clone ${gitRepoSsh} cloned-repo`
    ].join(' && '));
  }

  catch (error) {
    log('\nFAILED TO CLONE:\n');
    log(error + '');
    log('hr');
    log('NOTE:');
    log('I am a Docker container and I have copied your global');
    log('git username and email from the host - your machine.')
    log('So if you have set those ok the one thing missing is a')
    log('SSH key...')
    log('');
    log('You need to add this SSH-key to your GitHub account:');
    log('\n' + fs.readFileSync('./ssh-key/id_ed25519.pub', 'utf-8'));
    log('hr');
    process.exit();
  }

  // Cloned successfully
  checkoutAllBranches();
}

function checkoutAllBranches() {
  // Get all branch names
  let branches = execSync(
    'cd cloned-repo && git branch -av',
    { encoding: 'utf8' }
  ).toString()
    .split('\n')
    .map(x => x.replace('* ', '*').trim())
    .map(x => x.split(' ')[0])
    .filter(x => x.indexOf('remotes/origin') === 0 && x !== 'remotes/origin/HEAD')
    .map(x => x.replace('remotes/origin/', ''));

  log('Found the following remote branches:\n');
  log(branches.join('\n'));
  log('hr');
  log('Checking out all of them to a Docker volume:\n');
  log(`${gitRepoName}-storage`);

  // Copy the cloned repo folder once for each branch
  try {
    exec([
      'mkdir /storage/branches',
      ...branches
        .map(branch => `cp -r cloned-repo /storage/branches/${branch}`)
    ].join(' && '));
  } catch (e) {
    log('\nError during copying of cloned repo');
    log(e + '');
  }

  // Checkout every branch (in its corresponding folder)
  try {
    branches.forEach(branch => {
      exec([
        `cd /storage/branches/${branch}`,
        `git checkout ${branch}`
      ].join(' && '))
    });
  }
  catch (e) {
    log('\nError during checkout of branches');
    log(e + '');
  }

  buildComposeFile(branches);

  log('hr');
  log('All done from git-cloner...\n');
}

function buildComposeFile(branches) {
  let port = 4500;
  let yml = ['version: "3.8"', '', 'services:'];
  for (let branch of branches) {
    if (fs.existsSync(`/storage/branches/${branch}/Dockerfile`)) {
      let bind = gitBranchName === branch
      let name = gitRepoName + '-' + (
        bind ? `bind-mounted-${branch}` : branch
      );
      let workingDir = bind ? `/hostRepo` : `/storage/branches/${branch}`;
      yml = [
        ...yml,
        `  ${branch}:`,
        `    container_name: ${name}`,
        `    build: /storage/branches/${branch}`,
        `    working_dir: ${workingDir}`,
        `    ports:`,
        `      - "${port}:${port}"`,
        `    volumes:`,
        `      - ${gitRepoName}-storage:/storage`,
        ...(bind ? [
          `      - type: bind`,
          `        source: ${hostRepoPath}`,
          `        target: /hostRepo`
        ] : []),
        `    environment:`,
        `       PORT: ${port}`
      ];
      port++;
    }
  }
  yml = [
    ...yml,
    '',
    'volumes:',
    `  ${gitRepoName}-storage:`,
    `    external: true`
  ];
  yml = yml.join('\n');
  log('hr');
  log('BUILDING docker-compose.yml:\n');
  log(yml);
  fs.writeFileSync('/storage/branches/docker-compose.yml', yml, 'utf-8');
}

function exec(...args) {
  // Silent execution
  execSync(...args, { stdio: 'pipe' });
}

function log(...args) {
  // Log things to the terminal/console
  args[0] = args[0] === 'hr' ? '_'.repeat(70) + '\n' : args[0];
  console.log(...args);
}
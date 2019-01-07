#!/usr/bin/env node

/* eslint-env node */
/* eslint-disable no-console */

let exitStatus = 0;

const {node: expectedNodeVersion, npm: expectedNpmVersion} = require('../package.json').engines;
const actualNodeVersion = process.versions.node;
const actualNpmVersion = require('child_process').execSync('npm -v').toString().replace(/\n/, '');

console.info(`Node.js ${actualNodeVersion}`);
console.info(`NPM ${actualNpmVersion}`);
console.info('');

if (expectedNodeVersion !== actualNodeVersion) {
  console.error(`You are using Node.js ${actualNodeVersion} but the required version specified in package.json is ${expectedNodeVersion}`);
  exitStatus = 1;
}

if (expectedNpmVersion !== actualNpmVersion) {
  console.error(`You are using NPM ${actualNpmVersion} but the required version specified in package.json is ${expectedNpmVersion}`);
  exitStatus = 1;
}

console.info('');

process.exit(exitStatus);

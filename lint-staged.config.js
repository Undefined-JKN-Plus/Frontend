module.exports = {
  '*.{ts,tsx}': [() => 'npm run types:staged', 'npm run lint:check', 'npm run format:staged']
};

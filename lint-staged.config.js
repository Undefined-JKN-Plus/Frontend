module.exports = {
  '*.{ts,tsx}': [() => 'npm run types:staged', 'npm run lint:staged', 'npm run format:staged']
};

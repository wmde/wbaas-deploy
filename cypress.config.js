const { defineConfig } = require("cypress");

module.exports = defineConfig({
  env: {
    URL_PLATFORM_UI: 'https://wikibase.cloud',
    URL_TEST_WIKI:   'https://test-hackathon-2024.wikibase.cloud',
  },
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});

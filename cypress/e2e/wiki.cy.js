describe('Login to wiki works', () => {
  it('passes', () => {
    cy.visit(Cypress.env('URL_TEST_WIKI'))
    cy.get('#pt-login a').click()

    cy.get('#wpName1').type(Cypress.env('TEST_WIKI_USERNAME'))
    cy.get('#wpPassword1').type(Cypress.env('TEST_WIKI_PASSWORD'))
    cy.get('#wpLoginAttempt').click()

    cy.get('#pt-userpage').contains(Cypress.env('TEST_WIKI_USERNAME'))
  })
})

// TODO create item after login
// cy.visit(Cypress.env('URL_TEST_WIKI') + '/wiki/Special:NewItem')

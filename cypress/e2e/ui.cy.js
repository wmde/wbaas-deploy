describe('Discovery page works', () => {
  it('passes', () => {
    cy.visit(Cypress.env('URL_PLATFORM_UI') + '/discovery')
    cy.get('.details.col').should('not.be.empty')
  })
})

describe('User can login', () => {
  it('passes', () => {
    cy.visit(Cypress.env('URL_PLATFORM_UI'))
    cy.get('#nav-login').click()
    cy.url().should('include', '/login')

    cy.get('#inputEmail').type(Cypress.env('TEST_USER'))
    cy.get('#inputPassword').type(Cypress.env('TEST_PASSWORD'))

    cy.get('form').submit()

    cy.contains(Cypress.env('TEST_USER'))
  })
})


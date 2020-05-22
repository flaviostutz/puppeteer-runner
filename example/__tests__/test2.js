const timeout = process.env.JEST_TEST_TIMEOUT

describe(
  'uol.com.br',
  () => {
    let page
    beforeAll(async () => {
      page = await global.__BROWSER__.newPage()
      await page.goto(process.env.UOL_URL)
      await page.waitFor(2000)
      await page.waitForSelector('#usuario')
    }, timeout)

    afterAll(async () => {
      await page.close()
    })

    it('should load without error', async () => {
      let text = await page.evaluate(() => document.body.textContent)
      expect(text).toContain('uol')
      await page.screenshot({ path: "/app/screenshots/uol.jpg" })
    })

  },
  timeout
)

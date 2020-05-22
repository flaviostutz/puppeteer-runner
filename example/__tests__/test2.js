const timeout = 5000

describe(
  'uol.com.br',
  () => {
    let page
    beforeAll(async () => {
      page = await global.__BROWSER__.newPage()
      await page.goto(process.env.UOL_URL)
    }, timeout)

    afterAll(async () => {
      await page.close()
    })

    it('should load without error', async () => {
      let text = await page.evaluate(() => document.body.textContent)
      expect(text).toContain('uol')
      await page.screenshot({ path: "/app/example/screenshots/uol.jpg" })
    })

  },
  timeout
)

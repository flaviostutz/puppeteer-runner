const timeout = 5000

describe(
  'Google',
  () => {
    
    let page
    beforeAll(async () => {
      page = await global.__BROWSER__.newPage()
      await page.setViewport( { 'width' : 1024, 'height' : 768 } );
      await page.goto('https://google.com')
    }, timeout)

    afterAll(async () => {
      await page.close()
    })

    it('should load without error', async () => {
      let text = await page.evaluate(() => document.body.textContent)
      expect(text).toContain('google')
    })

    it('search "test"', async () => {
      // console.log("Typing")
      await page.waitForSelector('input[name=q]')
      await page.type('[name=q]', 'test');
      // let text2 = await page.evaluate(() => document.body.textContent)
      // console.log(text2)
      await page.screenshot({ path: "/app/example/screenshots/1.jpg" })
      // console.log("Clicking")
      await page.waitForSelector('input[name=btnK]')
      await page.hover('input[name=btnK]');
      await page.click('input[name=btnK]')
      // console.log("Evaluating")
      await page.waitForSelector('#result-stats')
      await page.screenshot({ path: "/app/example/screenshots/2.jpg" })
      let text = await page.evaluate(() => document.body.textContent)
      expect(text).toContain('Mais')
    })

  },
  timeout
)

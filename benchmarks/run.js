const puppeteer = require('puppeteer');

if (process.argv.length != 3) {
  console.error("Expected one HTML file name as an argument");
}

const file = process.argv[2];

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  const start = new Date();
  page.once('load', () => {
    const end = new Date();
    const diff = end - start;
    console.log(diff);
  });
  await page.goto('http://localhost:8000/' + file, {timeout: 3000000});

  await browser.close();
})();

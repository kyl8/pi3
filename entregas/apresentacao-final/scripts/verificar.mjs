import {chromium} from 'playwright';
import {resolve} from 'node:path';
import {pathToFileURL} from 'node:url';
import assert from 'node:assert/strict';
import {lerSlides} from './ler-slides.mjs';

const {slides}=await lerSlides();
const browser=await chromium.launch({executablePath:process.env.CHROME_PATH||(process.platform==='win32'?'C:/Program Files/Google/Chrome/Application/chrome.exe':undefined)});
try{
 const page=await browser.newPage({viewport:{width:1280,height:800},reducedMotion:'reduce'});
 const requests=[],errors=[];
 page.on('pageerror',e=>errors.push(e.message));
 await page.route(/^https?:/,route=>{requests.push(route.request().url());return route.abort();});
 await page.goto(pathToFileURL(resolve('apresentacao-pi3-appa.html')).href);
 await page.evaluate(()=>document.fonts.ready);
 for(const [i,s] of slides.entries()){
  await page.waitForFunction(n=>document.querySelector('.slide')?.getAttribute('data-slide-index')===String(n),i);
  assert.equal(await page.locator('.slide h1,.slide h2').count(),1);
  const fit=await page.locator('.slide-content').evaluate(e=>{
   const b=e.getBoundingClientRect();
   return [...e.children].every(child=>{const r=child.getBoundingClientRect();return r.top>=b.top-2&&r.bottom<=b.bottom+2&&r.right<=b.right+2;});
  });
  assert(fit,'Conteúdo fora do quadro no slide '+(i+1));
  if(s.kind==='grade'){
   await page.getByRole('button',{name:'λ = 0,7',exact:true}).click();
   await page.waitForFunction(()=>document.querySelector('.pi-metrics')?.textContent?.includes('0,289'));
   assert((await page.locator('.pi-order').textContent()).includes('d95'));
  }
  if(i<slides.length-1) await page.keyboard.press('ArrowRight');
 }
 await page.keyboard.press('m'); assert(await page.getByRole('complementary',{name:'Índice de slides'}).isVisible());
 await page.keyboard.press('Escape');
 await page.keyboard.press('n'); assert(await page.getByRole('complementary',{name:'Notas do apresentador'}).isVisible());
 await page.setViewportSize({width:390,height:844});
 assert(await page.locator('.mobile-reading').isVisible());
 assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));
 assert.deepEqual(errors,[]);
 assert.deepEqual(requests,[]);
 console.log('PI III: slides, interação MMR, navegação, celular e offline OK.');
}finally{await browser.close();}

import {readFile, writeFile, mkdir} from 'node:fs/promises';
import {minify} from 'terser';
import JavaScriptObfuscator from 'javascript-obfuscator';
const source = await readFile(new URL('../src/index.html', import.meta.url), 'utf8');
const match = source.match(/<script>([\s\S]*?)<\/script>/i);
if (!match) throw new Error('Expected one inline application script');
const result = await minify(match[1], {compress:{passes:2}, mangle:true, format:{comments:false}});
if (!result.code) throw new Error('JavaScript minification failed');
const obfuscated = JavaScriptObfuscator.obfuscate(result.code, {
  compact:true, controlFlowFlattening:false, deadCodeInjection:false,
  stringArray:true, stringArrayThreshold:0.35, rotateStringArray:true,
  selfDefending:false, renameGlobals:false, identifierNamesGenerator:'hexadecimal'
}).getObfuscatedCode();
const html = source.replace(match[0], '<script src="./assets/nebula.engine.js"></script>')
  .replace(/<!--([\s\S]*?)-->/g,'').replace(/>\s+</g,'><');
await mkdir(new URL('../dist/assets/', import.meta.url),{recursive:true});
await writeFile(new URL('../dist/index.html', import.meta.url),html);
await writeFile(new URL('../dist/assets/nebula.engine.js', import.meta.url),obfuscated);
console.log('Built packaged frontend; minified and obfuscated JS');

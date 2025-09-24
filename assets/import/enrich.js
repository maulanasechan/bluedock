// enrich.js
const fs = require("fs");

function normalizeTitle(s) {
  return (s || "")
    .toLowerCase()
    .replace(/[’'\-.,_/]+/g, " ")
    .trim();
}

function buildSearchKeywords(title, minPrefixLen = 2, maxPrefixLen = 20) {
  const normalized = normalizeTitle(title);
  const words = normalized.split(/\s+/).filter(Boolean);
  const set = new Set();
  for (const w of words) {
    set.add(w); // full word: "jacket"
    const end = Math.min(w.length, maxPrefixLen);
    for (let i = minPrefixLen; i <= end; i++) {
      set.add(w.substring(0, i)); // "ja","jac","jack",...
    }
  }
  return Array.from(set);
}

if (process.argv.length < 4) {
  console.error("Usage: node enrich.js <input.json> <output.json>");
  process.exit(1);
}

const [inputPath, outputPath] = process.argv.slice(2);
const raw = fs.readFileSync(inputPath, "utf8");
const json = JSON.parse(raw);

// Struktur node-firestore-import-export:
// { "__collections__": { "Products": { "<docId>": { ... } } } }
const products = json?.__collections__?.Products || {};

for (const [docId, doc] of Object.entries(products)) {
  const title = doc.title || "";
  doc.title_lower = title.toLowerCase();
  doc.search_keywords = buildSearchKeywords(title);
  // optional: versi index (buat idempotensi)
  doc.keywordsVersion = 1;
}

// Tulis file baru
fs.writeFileSync(outputPath, JSON.stringify(json, null, 2), "utf8");
console.log(`Enriched → ${outputPath}`);

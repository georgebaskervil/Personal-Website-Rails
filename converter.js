const { convert } = require("@ruslanuz/sass-convert");
const fs = require("node:fs");
const path = require("node:path");

const stylesDir = path.join(__dirname, "app/stylesheets");

fs.readdir(stylesDir, (error, files) => {
  if (error) {
    console.error(`Error reading directory ${stylesDir}:`, error);
    return;
  }

  for (const file of files) {
    if (path.extname(file) === ".scss") {
      const filePath = path.join(stylesDir, file);
      convert(filePath, { syntax: "sass" })
        .then(() => console.log(`Converted ${file}`))
        .catch((error_) => console.error(`Error converting ${file}:`, error_));
    }
  }
});

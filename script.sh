#!/bin/bash

# Project name
PROJECT_NAME=$0

# Check if the project name was provided
if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: $0 <project-name>"
  exit 1
fi

# Create the project directory and navigate into it
mkdir $PROJECT_NAME
cd $PROJECT_NAME || exit

# Initialize a Node.js project
npm init -y

# Install Express, dotenv, and other necessary packages
npm install express dotenv

# Install TypeScript and its dependencies
npm install --save-dev typescript @types/node @types/express ts-node-dev

# Create the .editorconfig file
echo "root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true" > .editorconfig

# Install and configure Prettier
npm install --save-dev prettier
echo "{
  \"semi\": false,
  \"singleQuote\": true,
  \"tabWidth\": 2,
  \"trailingComma\": \"es5\",
  \"printWidth\": 80
}" > .prettierrc

# Install and configure ESLint
npm install --save-dev eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
npx eslint --init

# Create the tsconfig.json file
echo "{
  \"compilerOptions\": {
    \"target\": \"es6\",
    \"module\": \"commonjs\",
    \"outDir\": \"./dist\",
    \"rootDir\": \"./src\",
    \"strict\": true,
    \"esModuleInterop\": true,
    \"skipLibCheck\": true,
    \"forceConsistentCasingInFileNames\": true
  },
  \"include\": [\"src\"],
  \"exclude\": [\"node_modules\"]
}" > tsconfig.json

# Create the project structure and files
mkdir src
echo "import express from 'express'
import dotenv from 'dotenv'

dotenv.config()

const app = express()
const port = process.env.PORT || 3000

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(\`Server is running on port \${port}\`)
})" > src/index.ts

# Create the .env file
echo "PORT=3000" > .env

# Configure the package.json scripts
npx json -I -f package.json -e 'this.scripts={ "start": "node dist/index.js", "build": "tsc", "dev": "ts-node-dev src/index.ts", "lint": "eslint . --ext .ts" }'

# Initialize git and make the first commit
git init
echo "node_modules
dist" > .gitignore
git add .
git commit -m "Initial commit"

echo "Node.js project with Express, dotenv, EditorConfig, Prettier, ESLint, and TypeScript successfully configured!"

npm run dev

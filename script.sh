#!/bin/bash

# Nome do projeto
PROJECT_NAME=$1

# Verifica se o nome do projeto foi fornecido
if [ -z "$PROJECT_NAME" ]; then
  echo "Uso: $(basename "$0") <nome-do-projeto>"
  exit 1
fi

# Cria a pasta do projeto e navega até ela
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit

# Inicializa um projeto Node.js
npm init -y

# Instala o Express, dotenv e outros pacotes necessários
npm install express dotenv

# Instala o TypeScript e suas dependências
npm install --save-dev typescript @types/node @types/express ts-node-dev

# Cria o arquivo .editorconfig
echo "root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true" > .editorconfig

# Instala o Prettier e configura
npm install --save-dev prettier
echo "{
  \"semi\": false,
  \"singleQuote\": true,
  \"tabWidth\": 2,
  \"trailingComma\": \"es5\",
  \"printWidth\": 80
}" > .prettierrc

# Instala o ESLint e configura
npm install --save-dev eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
npx eslint --init

# Cria o arquivo tsconfig.json
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

# Cria a estrutura de pastas e arquivos do projeto
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

# Cria o arquivo .env
echo "PORT=3000" > .env

# Configura os scripts do package.json
npx json -I -f package.json -e 'this.scripts={ "start": "node dist/index.js", "build": "tsc", "dev": "ts-node-dev src/index.ts", "lint": "eslint . --ext .ts" }'

# Inicializa o git e faz o primeiro commit
git init
echo "node_modules
dist" > .gitignore
git add .
git commit -m "Initial commit"

echo "Projeto Node.js com Express, dotenv, EditorConfig, Prettier, ESLint e TypeScript configurado com sucesso!"

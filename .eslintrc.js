// {
//   "root": true,
//   "parser": "@typescript-eslint/parser",
//   "parserOptions": {
//     "project": "tsconfig.json",
//     "sourceType": "module"
//   },
//   "env": {
//     "node": true,
//     "jest": true
//   },
//   "plugins": ["@typescript-eslint"],
//   "extends": [
//     "plugin:@typescript-eslint/eslint-recommended",
//     "plugin:@typescript-eslint/recommended"
//   ],
//   "rules": {
//     "quotes": ["error", "single"],
//     "indent": [
//       "error",
//       2,
//       {
//         "MemberExpression": 1
//       }
//     ],
//     "@typescript-eslint/typedef": [
//       "error",
//       {
//         "memberVariableDeclaration": true,
//         "propertyDeclaration": true,
//         "variableDeclaration": true,
//         "variableDeclarationIgnoreFunction": true,
//         "arrowParameter": false
//       }
//     ],
//     "@typescript-eslint/no-empty-interface": "off",
//     "@typescript-eslint/no-inferrable-types": "off",
//     "@typescript-eslint/semi": ["error", "always"]
//   }
// }
module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    tsconfigRootDir: __dirname,
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint/eslint-plugin'],
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended',
  ],
  root: true,
  env: {
    node: true,
    jest: true,
  },
  ignorePatterns: ['.eslintrc.js'],
  rules: {
    quotes: ['error', 'single'],
    '@typescript-eslint/typedef': [
      'error',
      {
        memberVariableDeclaration: true,
        propertyDeclaration: true,
        variableDeclarationIgnoreFunction: true,
        arrowParameter: false,
      },
    ],
    '@typescript-eslint/no-empty-interface': 'off',
    '@typescript-eslint/no-inferrable-types': 'off',
    '@typescript-eslint/semi': ['error', 'always'],
    '@typescript-eslint/interface-name-prefix': 'off',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'off',
  },
};

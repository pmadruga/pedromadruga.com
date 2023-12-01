[![Netlify Status](https://api.netlify.com/api/v1/badges/890c3122-d11b-44fa-a95a-be8de5632911/deploy-status)](https://app.netlify.com/sites/silly-noyce-919da2/deploys)

## Development

```
hugo serve -D
```

## Update papermod

```
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive # needed when you reclone your repo (submodules may not get cloned automatically)
```

```
git submodule update --remote --merge
```

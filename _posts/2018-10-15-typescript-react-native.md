---
layout: post
title: ' Converting to TypeScript with React Native in 5 minutes'
description: 'Enabling typescript on a React Native codebase.'
thumb_image: 'https://images.unsplash.com/photo-1536743899248-cefb610916d6?ixlib=rb-0.3.5&s=c556a9cc1008101cac2efdf3558f2738&auto=format&fit=crop&w=1618&q=80'
tags: [development]
---

![](https://images.unsplash.com/photo-1536743899248-cefb610916d6?ixlib=rb-0.3.5&s=c556a9cc1008101cac2efdf3558f2738&auto=format&fit=crop&w=1618&q=80)

This tutorial is heavily inspired by the one in [React Native's blog](https://facebook.github.io/react-native/blog/2018/05/07/using-typescript-with-react-native). The goal here is to have a minimal setup to get us up and running with TypeScript, so some things have been excluded and others were included for TS to run.



#### 1. Start by installing dependencies:

{% highlight html %}
yarn add -dev typescript react-native-typescript-transformer @types/react @types/react-native
 {% endhighlight %}



#### 2. Create a typescript configuration:

{% highlight html %}
yarn tsc --init --pretty --jsx react
 {% endhighlight %}

which will create a `tsconfig.json` file at the root of your project.



#### 3. Make changes in `tsconfig.json`:

Search for `allowSyntheticDefaultImports`, and enable it by setting it to true.

Now, let's change our `outDir` to `outputs`. This enables to have our transpiled files in a folder instead of having them next to the non-transpiled ones.

Now, and just for the sake of getting started quickly on an errorless state, we want to skip the type checking on default library declaration files by adding `"skipLibCheck": true`.

So, our tsconfig.json should include

{% highlight html %}
{
  "compilerOptions": {
	  // ...
	  "skipLibCheck": true,
	  "outDir": "outputs",
	  "allowSyntheticDefaultImports": true
	  }
}
 {% endhighlight %}

#### 4. Configure the React Native Script Transformer.

Let's create the file that holds these settings, by doing `touch rn-cli.config.js`, opening it and adding:

{% highlight html %}
module.exports = {
  getTransformModulePath() {
    return require.resolve('react-native-typescript-transformer');
  },
  getSourceExts() {
    return ['ts', 'tsx'];
  },
};
 {% endhighlight %}

#### 5. That's it!

Run `tsc -w` in the terminal and everything should be working!

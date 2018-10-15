---
layout: post
title: "Create and showcase your own React UI library using Webpack 4"
description: "When working in a company with multiple projects, you might want to have design
guidelines to ensure consistency throughout. What if you could have a showcase
for your styled components and still be able to use those components in other
projects, with something as easy as a installing a npm package?"
thumb_image: "https://cdn-images-1.medium.com/max/1600/0*SdbWagCZ6YyyY2vJ."
tags: [development]
---

![](https://cdn-images-1.medium.com/max/1600/0*SdbWagCZ6YyyY2vJ.)


This tutorial shows how can one build a library of reusable components, showcase
them and be able to easily import in other projects, using both
[Webpack](https://webpack.js.org/) 4 and [Parcel
bundler](https://github.com/parcel-bundler/parcel). Webpack will be responsible
for handling the bundling of the library of components. Parcel bundler will
handle the bundling of the show case of the components.

For this example, you will build a simple documentation showcase and a button as
a shared component. All code is on
[https://github.com/pmadruga/myUI](https://github.com/pmadruga/myUI)

#### What you’ll be building

* A library of UI components that can be used on other projects
* A showcase for all the components of that library

Let’s get started. 🎉

### Folder Structure

Let’s start by creating a folder structure. Firstly, let’s create a standard
folder structure. The `lib` folder will contain the reusable React components
and `docs` will contain the showcase for those components as well as any other
documentation needed (such as the API for the components, for example).

At this point, the folder structure looks like this:
{% highlight html %}

    src/
    |- docs
     |-index.html
     |-index.js
    |- lib
     |- index.js
     |- Button/
     |- index.js
    dist/
    webpack.config.js
    package.json

  {% endhighlight %}



### Dependencies

This is everything you’ll need:

{% highlight html %}
    // For showcasing our docs
    yarn add react react-dom

    // For bundling our library and docs
    yarn add webpack parcel-bundler webpack-cli webpack-node-externals "babel-loader@^8.0.0-beta" @babel/core @babel/preset-env webpack-node-externals -D
  {% endhighlight %}

### lib/: react components library

Our library of React reusable components. When bundled (into `/dist/lib`) you’ll
be able to consume them in another project by quickly installing this as a npm
package, which could be public (where it’s possible to use the npm registry) or
private (where gemfury could be used, for example). The `index.js` at the root
of the `lib` folder will be responsible to export all the components of the
library. For this case, you’ll be exporting a simple button only.

So our `lib/index.js` contains all the exported components by the library,
(which will be a simple button for this case), so it will contain

  {% highlight html %}
    export { Button };
  {% endhighlight %}

And in `lib/Button/index.js` , you’ll create and export a simple button. You
could also have styling and it would still be bundled into one file.

  {% highlight javascript %}

    import React from 'react';
    const Button = ({ text }) => <button>{text}</button>;
    export { Button };  

  {% endhighlight %}

### docs/: documenting and showcasing the components

The `docs`folder will showcase our library’s components as well as any other
documentation needed (such as the API for the components, for example). It is
just a small React application inside our main application. When bundled (into
/dist/docs) it can easy be uploaded anywhere. Using the github pages would be a
good cenario.

Now, you’ll create both and `index.js` and `index.html`, where the first one
includes a component from the `lib` folder.

So, the `index.js` will contain

  {% highlight javascript %}

    import React from 'react';
    import ReactDOM from 'react-dom';
    import { Button } from '../lib/Button';

    const App = () => (
      <div>
        <h1>My UI</h1>
        <h2>Button</h2>
        <p>Here's an example of button.</p>
        <Button text="Click me!" />
      </div>
    );

    ReactDOM.render(<App />, document.getElementById('root'));
  {% endhighlight %}

Nothing too fancy and the main gist is that it’s possible to see that there is a
Button being imported from the library of components.

### Webpack.config.js

As mentioned, webpack is responsible to bundle the components library (and not
the documentation). Let’s take a look at its configuration. The most important
value here is the `libraryTarget: ‘commonJS'` which allows individual exporting
of components.

  {% highlight javascript %}

    module.exports = {
      entry: path.resolve(__dirname, 'src/lib/index.js'),
      output: {
        path: path.resolve(__dirname, './build/lib'),
        filename: 'index.js',
        library: '',
        libraryTarget: 'commonjs'
      },
      externals: [nodeExternals()],
      module: {
        rules: [
          {
            test: /\.js$/,
            exclude: /(node_modules|bower_components)/,
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env', '@babel/react']
            }
          },
          {
            test: /\.css$/,
            use: ['style-loader', 'css-loader']
          }
        ]
      }
    };

  {% endhighlight %}

### Package.json

The most important thing of the package.json is the “main”. After uploading the
library to a registry (wether its npm or gemfury or other), this signals which
file will be served as the entry point. The `./dist/lib/index.js` contains all
the code bundled from `lib` .

  {% highlight javascript %}
    {

      "name": "myui",

      "version": "0.0.1",

      "description": "Bootstrapping a UI component library",

      "main": "./dist/lib/index.js",

      "scripts": {

      "start": "./node_modules/.bin/parcel src/docs/index.html",

      "build": "./node_modules/.bin/webpack --mode=production",

      "build:docs": "./node_modules/.bin/parcel build src/docs/index.js -d dist/docs/"

    },

      "author": "Pedro Madruga",

      "license": "MIT",

      "dependencies": {

        "react": "^16.2.0",

        "react-dom": "^16.2.0"

    },

      "peerDependencies": {

        "react": "^16.2.0",

        "react-dom": "^16.2.0"

    },

       "devDependencies": {

       "@babel/core": "^7.0.0-beta.42",

       "@babel/preset-env": "^7.0.0-beta.42",

       "@babel/preset-react": "^7.0.0-beta.42",

       "babel-core": "6",

       "babel-loader": "^8.0.0-beta",

       "parcel-bundler": "^1.6.2",

       "webpack": "^4.1.1",

       "webpack-cli": "^2.0.12",

       "webpack-node-externals": "^1.6.0"

     }

    }

  {% endhighlight %}

### Importing from another project

**Assuming your project is published somewhere** (wether npm or gemfury), it
will be easy as:

{% highlight html %}

  `yarn add myUI`

{% endhighlight %}

and then in your file:

{% highlight javascript %}

`import { Button } from ‘myUI’`

{% endhighlight %}

That’s it! Remember to check the repository for this example in
[https://github.com/pmadruga/myUI](https://github.com/pmadruga/myUI)

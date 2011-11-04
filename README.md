# RequireJS + jQuery

This project shows how [jQuery](http://jquery.com) can be used with
[RequireJS](http://requirejs.org). It includes a sample project that you can use
as a template to get started.

See the [Use with jQuery](http://requirejs.org/docs/jquery.html) page on the
RequireJS site for more background on the sample project. The RequireJS site
also has a link to
[download this sample project](http://requirejs.org/docs/download.html#samplejquery).

The sample project uses a require-jquery.js file which is just a simple
combination of RequireJS and jQuery.

This project will be kept relatively up to date with the latest jQuery and
RequireJS files as they are released.

## Alternate Integrations

With RequireJS, scripts can load in a different order than the order they are specified.
This can cause problems for jQuery plugins that assume jQuery is already loaded.
Using the combined RequireJS + jQUery file makes sure jQuery is in the page before
any jQuery plugins load.

However, there are many use cases where it would be ideal to load jQuery with
RequireJS, particularly if jQuery is being loaded from a Content Delivery
Network (CDN).

Here are some alternate ways to use RequireJS and jQuery together in a way that
recognizes jQuery plugin constraints.

### Wrap all scripts with define()

Ideally, all the scripts you use would wrap themselves in a define() call so
that RequireJS can understand what dependencies need to be loaded before defining
the script's functionality.

For scripts that just need jQuery, you can wrap the code in a wrapper like
this:

```javascript
    define(['jquery'], function ($) {
        //Script contents go here.
    });
```

For more information on using define() to declare the codes as Asynchronous
Module Definition (AMD) modules, see the
[RequireJS API page](http://requirejs.org/docs/api.html).

If you do not control the code in question, you can ask the code's author if
they could optionally call define() in their code. As of jQuery 1.7, jQuery
itself optionally calls define() if it is available. The
[umdjs project](https://github.com/umdjs/umd) has some resources and examples
to help code authors update their code to this pattern.

### Use order plugin

The [order plugin](http://requirejs.org/docs/api.html#order) can be used to load
scripts in the order they are specified:

```javascript
    require(['order!jquery', 'order!pluginOne.jquery'], function () {
    });
```

While this works, it does not give the same modular, encapsulated benefits when
using define()-wrapped code.

### Use priority config

You can use the [priority config option](https://requirejs.org/docs/api.html#config-priority)
to load jQuery before any other script is loaded. However, there are some
implications when using the
[RequireJS optimizer](http://requirejs.org/docs/optimization.html).
See **Optimization Considerations** below.

First, an explanation on what to change in the sample project:

#### app.html

* Change the script tag to load just **require.js** ([download it](http://requirejs.org/docs/download.html#requirejs) from the RequireJS site) instead of require-jquery.js
* Remove the data-main attribute
* Load the main.js file with a require() call in the HTML file.
* Specify a [priority configuration option](http://requirejs.org/docs/api.html#config). This tells RequireJS to download jQuery before tracing any other script dependencies:

```html

    <title>jQuery+RequireJS Sample Page</title>
    <script src="scripts/require.js"></script>
    <script>
    require({
        baseUrl: 'scripts',
        priority: ['jquery']
    }, ['main']);
    </script>
```

The above example assumes that you downloaded jQuery and placed it in the project
as **webapp/scripts/jquery.js**. If you wanted to load jQuery from a CDN, like Google's you
could do this:

```html
    <title>jQuery+RequireJS Sample Page</title>
    <script src="scripts/require.js"></script>
    <script>
    require({
        baseUrl: 'scripts',
        paths: {
            jquery: 'https://ajax.googleapis.com/ajax/libs/jquery/1.6.0/jquery.min'
        },
        priority: ['jquery']
    }, ['main']);
    </script>
```

However, you will want to download a local copy of jQuery and place it in the
project at **webapp/scripts/jquery.js** so it can be used with the optimizer.

#### Optimization Considerations

With jQuery loaded externally, before main.js is loaded, jQuery now needs to be
excluded from the built file the optimizer generates.

**First**, make sure you have a jquery.js file in the the **webapp/scripts**
directory. It can be a blank file, but should exist. The optimizer cannot
fetch files from the network, so it needs a local file to satisfy the "jquery"
dependency.

Then change the app.build.js file to the following:

```javascript
    ({
        appDir: "../",
        baseUrl: "scripts",
        dir: "../../webapp-build",
        //Comment out the optimize line if you want
        //the code minified by UglifyJS
        optimize: "none",

        modules: [
            {
                name: "main",
                exclude: ["jquery"]
            }
        ]
    })
```

This will bundle all the scripts into the built main.js file, except for jQuery.

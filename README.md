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

## Better integrations

With RequireJS, scripts can load in a different order than the order they are specified.
This can cause problems for jQuery plugins that assume jQuery is already loaded.
Using the combined RequireJS + jQUery file makes sure jQuery is in the page before
any jQuery plugins load.

However, the ideal use of jQuery with RequireJS is to load it as a module, since
it registers as an AMD module.

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

### Use shim config

In RequireJS 2.0, there is a
[shim config option](http://requirejs.org/docs/api.html#config-shim) that
allows specifying the dependencies for a script without having to modify the
script. For simple jQuery plugins, it is enough to just specify an array that
mentions jQuery for the shim value:

```javascript
requirejs.config({
    shim: {
        'plugin.one': ['jquery'],
        'plugin.two': ['jquery']
    }
});
```

Be sure to read
[the build notes for shim](http://requirejs.org/docs/api.html#config-shim).
In particular, if using "shim" config you must build in jquery.js into your
built file.

### Use step plugin

Using the shim config is the recommended way to use non-module code with
RequireJS and jQuery. However, there are some situations in which the
**step plugin** may be useful. See the
[step plugin README](https://github.com/requirejs/step) for more information.

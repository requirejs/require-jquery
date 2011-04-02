# RequireJS + jQuery

This project shows how [jQuery](http://jquery.com) can be used with [RequireJS](http://requirejs.org). It includes a sample project that you can use as a template to get started.

See the [Use with jQuery](http://requirejs.org/docs/jquery.html) page on the RequireJS site for more background on the sample project. The RequireJS site also has a link to [download this sample project](http://requirejs.org/docs/download.html#samplejquery).

The sample project uses a require-jquery.js file which is a combination of three files:

* RequireJS, version 0.24.0
* jQuery, version 1.5.2
* [post.js](require-jquery/blob/master/parts/post.js), which just registers jQuery as a module.

This project will be kept relatively up to date with the latest jQuery and RequireJS files as they are released.

## Alternate Integration

If you do not want to bundle RequireJS with jQuery, you can load jQuery separately, not as part of the same file as RequireJS, but it has some implications when using the [RequireJS optimizer](http://requirejs.org/docs/optimization.html). See **Optimization Considerations** below.

First, an explanation on what to change in the sample project:

### app.html

Change the script tag to load just **require.js** ([download it](http://requirejs.org/docs/download.html#requirejs) from the RequireJS site) instead of require-jquery.js.

### main.js

Change main.js to use the [priority configuration option](http://requirejs.org/docs/api.html#config). This tells RequireJS to download jQuery before tracing any other script dependencies:

    //Configure RequireJS
    require({
        //Load jQuery before any other scripts, since jQuery plugins normally
        //assume jQuery is already loaded in the page.
        priority: ['jquery']
    });

    //Load scripts.
    require(['jquery', 'jquery.alpha', 'jquery.beta'], function($) {
        //the jquery.alpha.js and jquery.beta.js plugins have been loaded.
        $(function() {
            $('body').alpha().beta();
        });
    });


### Optimization Considerations

Since jQuery plugins do not explicitly specify jQuery as a script dependency via the RequireJS define() call, and they expect jQuery to already be in the page, there can be a problem when you try to use the RequireJS optimizer with the setup above.

If you exclude jQuery from the optimized main.js file, then the plugins will be included in main.js, but they will try to use jQuery before the priority configuration has had a chance to load jQuery.

There are two options to fix this:

#### 1) Include jQuery in the optimized file.

* Download the version of jQuery you are using, and put it in the **webapp/scripts** directory, and call it **jquery.js**. Then change the app.build.js file to the following:

    ({
        appDir: "../",
        baseUrl: "scripts",
        dir: "../../webapp-build",
        //Comment out the optimize line if you want
        //the code minified by UglifyJS
        optimize: "none",

        modules: [
            {
                name: "main"
            }
        ]
    })

#### 2) wrap the jQuery plugins in a define call.

Instead of including jQuery in the optimized main.js, you can modify the contents of each file that implicitly depends on jQuery with the following (assuming it does not already have a define() call in the file):

    define(['jquery'], function (jQuery) {
        //Some plugins use jQuery, some may just use $,
        //so create an alias for $ just in case. You can
        //leave this out if the plugin clearly uses "jQuery"
        //instead of "$".
        var $ = jQuery;

        //The rest of the file contents go here.

    });

For the optimizer: create an empty file called **blank.js** and put it in the webapp/scripts directory. Then change app.build.js to the following:

    ({
        appDir: "../",
        baseUrl: "scripts",
        dir: "../../webapp-build",
        //Comment out the optimize line if you want
        //the code minified by UglifyJS
        optimize: "none",

        paths: {
            "jquery": "blank"
        },

        modules: [
            {
                //If you have multiple pages in your app, you may
                //want jQuery cached separately from the optimized
                //main module. In that case, uncomment the exclude
                //directive below.
                exclude: ["jquery"],
                name: "main"
            }
        ]
    })

By wrapping each of the jQuery plugins that implicitly rely on jQuery in a define() call, you can be sure they will not execute until jQuery is loaded via the priority configuration.

**NOTE**: If a plugin tries to define a global variable (does not attach the functionality to jQuery.fn), wrapping the code in a define() call may cause errors if the plugin expects you to call one of the global variables it creates.

You can work around this problem by declaring the variable outside the define call. So, for example, if the plugin looks like this when it is wrapped:

    define(['jquery'], function (jQuery) {
        var $ = jQuery;

        //The plugin wanted to make globalFoo a global,
        //but this will not work with the define wrapping:
        var globalFoo = "something";
        ...
    });

Put the var declaration outside the define function and remove the "var" from the internal assignment:

    var globalFoo;
    define(['jquery'], function (jQuery) {
        var $ = jQuery;

        //Just assign now, remove the declaration.
        globalFoo = "something";
        ...
    });

# RequireJS + jQuery

This project shows how jQuery can be used with RequireJS. It includes a sample project that you can use as a template to get started.

See the [Use with jQuery](http://requirejs.org/docs/jquery.html) page on the RequireJS site for more background on the sample project.

The sample project uses a require-jquery.js file which is a combination of three files:

* RequireJS, version 0.24.0
* jQuery, version 1.5.1
* [post.js](tree/master/parts/post.js), which just registers jQuery as a module.

This project will be kept relatively up to date with the latest jQuery and RequireJS files as they are released.

## Alternate Integration

If you do not want to bundle RequireJS with jQuery, you can load jQuery separately, not as part of the same file as RequireJS, but it has some implications when using the RequireJS optimizer. See **Optimization Considerations** below. First, an explanation on what to change in the sample project:

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

**NOTE**: some jQuery plugin files may try to declare global variables. Most well-written plugins try to avoid creating global variables, but if the plugin does do try, wrapping the code in a define() call may cause errors if the plugin expects you to call one of the global variables it creates.

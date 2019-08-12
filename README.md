# Tuesmon documentation source #

[![Kaleidos Project](http://kaleidos.net/static/img/badge.png)](https://github.com/kaleidos "Kaleidos Project")
[![Managed with Tuesmon.com](https://img.shields.io/badge/managed%20with-TUESMON.io-709f14.svg)](https://manage.tuesmon.com/project/tuesmon/ "Managed with Tuesmon.com")

> *Status:* _Still a work in progress_

Web: http://tuesmoncom.github.io/tuesmon-doc/dist/

### Setup initial environment (for developers)

Install requirements: Ruby / `asciidoctor` + `pygments.rb` (installed via. `bundler` using the provided `Gemfile`)

You can install Ruby through the apt package manager, pacman, rbenv, or rvm.

Confirm that `Gemfile` is in the base `tuesmon-doc` directory, and then perform the installation from that directory:

    $ cd tuesmon-doc
    $ export PATH=$(ruby -e "print Gem.user_dir")"/bin:$PATH"
    $ export GEM_HOME=$(ruby -e 'print Gem.user_dir')
    $ gem install bundler
    $ bundle
    $ asciidoctor -v // should return Asciidoctor 1.5.1 ...

### (Optional) Regenerating curls and json responses

Tuesmon doc includes a django app that helps us generate the curl commands and
the json responses from the api. To use it, you have to activate your
tuesmon-back virtualenv, and install the `generate_api_documents`.

    $ workon tuesmon
    $ cd generate_api_documents_app
    $ pip install -e .

Now add it to your tuesmon settings installed apps; Modify in tuesmon-back your
`settings/local.py` and include the line:

```python
INSTALLED_APPS += ["generate_api_documents"]
```

For generating api examples you need to disable `DEBUG` option in your settings
as well as enable the following importers:

```python
IMPORTERS["github"]
IMPORTERS["trello"]
IMPORTERS["jira"]
IMPORTERS["asana"] 
```
If you copied local.py.example, uncommenting the importers code should be enough.

Now regenerate the tuesmon-back database with the sample data:

    $ cd tuesmon-back
    $ workon tuesmon
    $ bash regenerate.sh
    $ python manage.py runserver

And finally, in a new terminal, run the `generate_api_examples`
 django command:

    $ cd tuesmon-back
    $ workon tuesmon
    $ python manage.py generate_api_examples

If you get some error, check your settings and regenerate the database again.

After that, you have to copy the content generated in the output directory to
the api/generated/ directory in tuesmon-doc:

    $ mv output/* ../tuesmon-doc/api/generated/

Now you can rebuild your documentation running `make`:

    $ make

### (Optional) Setup live preview in browser

> _Prerequisite: Initial environment above must be setup and working_

#### Overview

This step is optional but highly recommended in order to ease the process of editing AsciiDoc files, by rendering the HTML from the source `.adoc` file as soon as any modifications are saved - allowing for instant preview in the browser.

The following instructions are based on:
* The Asciidoctor page: [Editing AsciiDoc with Live Preview][1]
* The Guard README: [Guard: README.md][5]

#### Installation

If the `bundler` install completed successfully, all of the gems will already be in place (including both Guard and the shell file monitor).

For notifications to work properly:
> You have to install the libnotify-bin package with your favorite package manager
>
> -- [Guard: System notifications - Libnotify][6]

For example, on a Debian-based system:

    $ sudo apt-get install libnotify-bin

Or in Arch

    $ yaourt -S libnotify

#### Ensure Guard is working

> It's important that you always run Guard through Bundler to avoid errors.
>
> -- [Guard: README.md][5]

Confirm that `Guardfile` is in the base `tuesmon-doc` directory and then start Guard from that directory:

    $ cd tuesmon-doc
    $ bundle exec guard

* Open `index.adoc` in a text editor, make a minor modification and then save the file
* If Guard is working properly, `dist/index.html` will be created/updated automatically
* If `libnotify` is configured correctly, a notification will be shown confirming that `index.adoc` has been found and rendered accordingly

#### Configure live preview in the browser

> _Note: The [Asciidoctor page][1] suggests using LiveReload with the `guard-livereload` gem but this package is [no longer compatible with LiveReload 2][2]_

Simply use a browser that has auto-reload built-in or install a relevant browser add-on.

Examples include:

* [Web][3] web browser (formerly Epiphany web browser) - has built-in auto-reload functionality
* Firefox + [Auto Reload][4] add-on
* _[Please add other working configurations here]_

#### Test live preview

* Open `dist/index.html` in the browser
* As before, save a modification to `index.adoc`
* Once Guard has rendered the new copy of `dist/index.html`, the browser will auto-reload the page

#### Working with live preview

Some tips/notes about working with live preview:

* Position the text editor and web browser windows side-by-side (or on different screens!), save changes and see the result in the browser almost immediately
* Changes to any of the `.adoc` files within the `api/` directory or its sub-dirs will render `dist/api.html` - since many `.adoc` files are combined to render the single HTML file, there is a slight lag in the live preview as the conversion process completes
* Otherwise, there is a 1:1 relationship between the `.adoc` file and its rendered `.html` file - changes to these are displayed almost instantaneously


[1]: http://asciidoctor.org/docs/editing-asciidoc-with-live-preview/
[2]: http://feedback.livereload.com/knowledgebase/articles/86181-failed-to-start-port-occupied
[3]: https://wiki.gnome.org/Apps/Web
[4]: https://addons.mozilla.org/en-US/firefox/addon/auto-reload/
[5]: https://github.com/guard/guard#guard
[6]: https://github.com/guard/guard/wiki/System-notifications#libnotify

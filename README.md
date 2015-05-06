# TRails Application Generator
## Application Generation command

```bash
$ rails new <project-name> --skip-turbolinks -T -G -d=<db-name> -m path/to/bin/trails.rb
```

* -T : will skip Tests
* -G : will skip .gitignore
* -d : to specify a database driver

## Example

```bash
$ rails new blog --skip-turbolinks -T -G -d=mysql -m trails/bin/trails.rb
```

## This template does the following

* remove comments from `uncomment.yml` files
* replace `application.js` with `application.coffee`
* convert `application.html` layout to HAML
* replaces `.gitignore` with a better template
* add RSpec
* add factory girl
* add staging environment
* add basic folders
	* exceptions
	* validators
  * services
* add Database Cleaner gem
* add devise gem
* add branches listed in `branches.yml`
* use HAML as default template
* stop development from sending emails

## Development

template main file is executed in the context of a rails application generator
the following methods are available for you in `self` and could be used through
modules using `ctx` parameter.

http://www.rubydoc.info/github/erikhuda/thor/master/Thor/Actions.html
http://guides.rubyonrails.org/rails_application_templates.html

### Configs

you can create a new config YAML file in `config` directory, file content will be parsed and assigned to global constant corresponding to the config file name (eg. `config/branches.yml` will be available through `BRANCHES`)

### Snippets
you can add template files to `snippets` directory, it will be available
in `SNIPPETS` hash globally with the file name as key, eg(`snippets/application.rb` will be available through `SNIPPETS[:application]`), you can use it as template files, or content holders of any kind (ruby code, template files, JS files, CSS files...etc).

### Modules
group related logic in single class with a class method called `call(context)`, we will pass the current application generator object to
it in case you needed any method in it (`gem`, `create_file`, `remove_file`, ...).

then add module name to `config/modules.yml` in the appropriate section.

### Testing your code

you can use `template.rb` as to execute the project.

### Compiling

you can use `compile.rb` to compile all snippets, modules, configs in a single file `bin/trails.rb`.

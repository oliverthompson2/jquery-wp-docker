# jquery-wp-docker

This repo has the necessary setup for running [jquery-wp-content](https://github.com/jquery/jquery-wp-content) in [WordPress](https://wordpress.com/) locally using [Docker](https://www.docker.com/).

## Usage

1. Clone this repo and its submodules

```sh
git clone --recursive git@github.com:jquery/jquery-wp-docker.git
```

2. Copy the wp-config-sample.php file to wp-config.php

```sh
cp wp-config-sample.php wp-config.php
```

3. Edit the wp-config.php file and set unique keys and salts using https://api.wordpress.org/secret-key/1.1/salt/. Do NOT change the `DB_` defines.

```php
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
// etc.
```

4. Copy .env.example to .env and edit the file to define database credentials

```sh
MYSQL_DATABASE=your_database_name
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_USER=your_database_user_name
MYSQL_PASSWORD=your_database_password
```

5. Optionally, add local SSL certs to the `ssl` directory. If you don't have any, you can generate them using [mkcert](https://github.com/FiloSottile/mkcert). Run the following:

```sh
mkcert -install
``` 

Then, in the `ssl` directory, run:

```sh
mkcert jquery.com *.jquery.com jqueryui.com *.jqueryui.com jquerymobile.com *.jquerymobile.com jquery.org *.jquery.org
```

6. Run `docker compose up --build` to start the containers

That's it! You should now be able to access the site at http://local.jquery.com, or https://local.jquery.com if you created certs.


## Notes

You do not need to configure your `/etc/hosts` file for `local.*` because `jquery.com`'s DNS handles this for you. However, if you plan to work offline, you can use the following rules:

```
127.0.0.1 local.jquery.com local.api.jquery.com local.blog.jquery.com local.releases.jquery.com local.learn.jquery.com local.plugins.jquery.com
127.0.0.1 local.jqueryui.com local.api.jqueryui.com local.blog.jqueryui.com
127.0.0.1 local.jquerymobile.com local.api.jquerymobile.com local.blog.jquerymobile.com
127.0.0.1 local.jquery.org local.brand.jquery.org local.contribute.jquery.org local.events.jquery.org local.meetings.jquery.org
127.0.0.1 local.sizzlejs.com
```

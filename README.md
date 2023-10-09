# jquery-wp-docker

This repo has the necessary setup for running [jquery-wp-content](https://github.com/jquery/jquery-wp-content) in [WordPress](https://wordpress.com/) locally using [Docker](https://www.docker.com/).

## Getting started

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

4. Run `docker compose up --build` to start the containers.

5. Import the database from a production WordPress instance.

```sh
# You need SSH admin access to this production server
ssh wp-05.ops.jquery.net
sudo -u tarsnap mysqldump --databases `sudo -u tarsnap mysql -B -N -e "SHOW DATABASES LIKE 'wordpress_%'"` > wordpress.sql
```

Then, on your local machine, run:

```sh
# Copy the SQL dump from your home directory on the server (as created by the previous command)
scp wp-05.ops.jquery.net:~/wordpress.sql .
# Docker root database password must match your .env file
# NOTE: There must be no space between -p and the password!
docker exec -i jquerydb mysql -u root -proot < wordpress.sql
```

6. Visit http://local.api.jquery.com:9412.

## Updating

To update your setup after pulling down changes, run:

```
docker compose down
docker compose up --build -d
```

## Troubleshooting

### Ports

If you already use port 9412 on your host, you can create a `.env` file in this directory and set the following environment variable with a port number of your own choosing:

```
JQUERY_WP_HTTP_PORT=8080
```

Note that the MySQL port (JQUERY_WP_MYSQL_PORT=9414) is only exposed for debugging purposes, e.g. to allow you to connect to it from a GUI or some other tool. The webserver container connects to the MySQL container directly and does not use this port.

### DNS

You do not need to configure your `/etc/hosts` file to define `local.jquery.com`, because we have defined these domains in the production DNS for jquery.com as alias for localhost. However, if you plan to work offline, you can add the following rules:

```
127.0.0.1 local.jquery.com
127.0.0.1 local.api.jquery.com
127.0.0.1 local.blog.jquery.com
127.0.0.1 local.learn.jquery.com
127.0.0.1 local.releases.jquery.com

127.0.0.1 local.jqueryui.com
127.0.0.1 local.api.jqueryui.com
127.0.0.1 local.blog.jqueryui.com

127.0.0.1 local.jquerymobile.com
127.0.0.1 local.api.jquerymobile.com
127.0.0.1 local.blog.jquerymobile.com

127.0.0.1 local.jquery.org
127.0.0.1 local.brand.jquery.org
127.0.0.1 local.contribute.jquery.org
127.0.0.1 local.meetings.jquery.org
```

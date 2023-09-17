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
cp .env.example .env
```

5. Optionally, add local SSL certs to the `ssl` directory.

   * If you don't have any, you can generate them using [mkcert](https://github.com/FiloSottile/mkcert).
     Run the following:

     ```sh
     mkcert -install
     ```

   * Then, in the `ssl` directory, run:
     ```sh
     mkcert \
     local.jquery.com \
     local.api.jquery.com \
     local.blog.jquery.com \
     local.learn.jquery.com \
     local.releases.jquery.com \
     local.jqueryui.com \
     local.api.jqueryui.com \
     local.blog.jqueryui.com \
     local.jquerymobile.com \
     local.api.jquerymobile.com \
     local.blog.jquerymobile.com \
     local.jquery.org \
     local.brand.jquery.org \
     local.contribute.jquery.org \
     local.meetings.jquery.org
     ```
     Wildcards don't work for multi-level subdomains. Add each site to the list of domains.

   * Rename the created certs to `cert.pem` and `cert-key.pem`.

6. Run `docker compose up --build` to start the containers.

7. Import the database from a production WordPress instance.

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

8. Visit http://local.jquery.com, or https://local.jquery.com if you created certs.

## Notes

You do not need to configure your `/etc/hosts` file for `local.*` because `jquery.com`'s DNS handles this for you. However, if you plan to work offline, you can use the following rules:

```
127.0.0.1 local.jquery.com local.api.jquery.com local.blog.jquery.com local.releases.jquery.com local.learn.jquery.com local.plugins.jquery.com
127.0.0.1 local.jqueryui.com local.api.jqueryui.com local.blog.jqueryui.com
127.0.0.1 local.jquerymobile.com local.api.jquerymobile.com local.blog.jquerymobile.com
127.0.0.1 local.jquery.org local.brand.jquery.org local.contribute.jquery.org local.events.jquery.org local.meetings.jquery.org
```

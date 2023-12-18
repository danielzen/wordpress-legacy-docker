# WordPress Legacy Environment Docker Setup

## Introduction

bran, emulating the configuration used by Dreamhost in the past. The setup includes WordPress 
version 4.3.32, PHP 5.6, MySQL 5.6, and Apache. In particular, I chose a version of MySQL old enough that, by default, allowed for ZERO dates from my old database exports.

### Warning
This older version of WordPress probably has security issues. And this is only for resurrecting 
an old site, not for hosting it!

This project aims to assist in resurrecting, maintaining, and archiving old WordPress websites that were originally hosted in an environment similar to Dreamhost's historical specifications. Once I was able to upgrade the site sufficiently, I used the [Simply Static](https://fr.wordpress.org/plugins/simply-static/) plugin to export the WordPress site as a static site

The database is stored in a Docker Volume accessible by PhpMyAdmin. This is a variation on a common docker-compose file, although I did expose port 3306 locally incase you wanted to more easily use a tool such as MySQLWorkbench. You will need to import your MySQL database, and make the approprate URL changes. I had old [Duplicator](https://wordpress.org/plugins/duplicator/) installer scripts that I created back in the day that took care of this for me. Your mileage may vary.

## Requirements

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Quick Start

1. Clone this repository:

    ```bash
    git clone https://github.com/danielzen/wordpress-legacy-docker.git
    ```

2. Navigate to the project directory:

    ```bash
    cd wordpress-legacy-docker
    ```

3. Build and start the containers:

   ```bash
   docker build -t wp-legacy:4.3.32-php5.6-apache .
   docker-compose up -d
   ```
   The `Dockerfile` is a custom container that creates wp-legacy environment with: 
   * Wordpress 4.3.2
   * PHP 5.6
   * served with Apache

   I needed to do my own custom build to get the exact configuration I wanted. Note that the
   `docker-entrypoint.sh` used is just an old version of [this file](https://github
   .com/docker-library/wordpress/blob/master/docker-entrypoint.sh)

   The `docker-compose.yml` brings up the following: 
    * The `wp-legacy` container you just built above (published on port 80)
    * MySQL 5.6 (published on port 3306)
      * db_data volume for mysql files
    * PHPMyAdmin (published on port 8008)

4. Access PhpMyAdmin

	Open [http://localhost:8008](http://localhost:8008)

	```
   WORDPRESS_DB_USER: wordpress
   WORDPRESS_DB_PASSWORD: wordpress
   WORDPRESS_DB_NAME: wordpress
   MYSQL_ROOT_PASSWORD: password
   ```
  * Import your old database here
  * Make sure to modify your domain name to `localhost` or `127.0.0.1`, etc.
  * html files are hosted, in the `wp-legacy` container, at `/var/www/html` 

4. Access WordPress in your browser:

	Put a copy of your old Wordpress installation in the `./html` folder.

    Open [http://localhost](http://localhost) in your preferred web browser.

With a little luck, you can get your old WordPress site up and running again. This isn't a guide, just a re-usable environment.

## Configuration

### WordPress, PHP, MySQL Versions

The version can be adjusted by modifying the services in the `docker-compose.yml` file. Update 
the `image` lines to your desired version to simulate upgrading PHP:

```yaml
wordpress:
  image: wordpress:php7.4-apache
```

If you are on a newer Mac with M silicon, you might want to substitue the amd64 MySQL version ofr the biarms version. There is a comment there ready for substitution with the standard version.

#### Good luck

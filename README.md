# Introduction

This is a fork of the PHP geocoding example from the [Mapbox API](https://www.mapbox.com/developers/api/). This is not an officially supported project.

I have rapidly restructured it to be PSR-4 compatible, work with PHP7, and be required and autoloaded using Composer.

The PHP driver currently supports geocoding, reverse geocoding, and permanent geocoding APIs.  This is great because I need geocoding.  If there is interest in this project, more could follow.

# PHP Specifics
##Dependencies
* PHP >= 7.0 is required.
* The php-curl module is required.
* The composer PSR-4 default autoloader will be user

# Getting Started
## Get a Mapbox Token
[Register with Mapbox](https://www.mapbox.com/studio/signup/) for free access to most Mapbox services.  Go to the [API Token page](https://www.mapbox.com/studio/account/tokens/) to get or create an API token.

## Using the Driver
Require the file 'Mapbox.php, and instantiate a <tt>mapbox</tt> object with the token as parameter'

```php    
	//setup - require your composer autoloader
	require_once('vendor/composer/autoload.php');

	// instantiate a Mapbox class with your token
	$mapbox = new Mapbox("<yourMapboxToken>");
```
The driver creates an authenticated handle to Mapbox and configures class loading on instantiation, so be sure to always instantiate a Mapbox object first.

## Geocode Example

(Remember, first create a Mapbox object as we've done above.)
```php
  //geocode
  $address = "149 9th St, San Francisco, CA 94103";
  $res = $mapbox->geocode($address);
  //view results for debugging
  print_r($res->getData());
```

You can add the `types` and `proximity` parameters:
```php
	//types
	$types = array('region','place');
	$res = $mapbox->geocode($address, $types);
```
or

```php
	//proximity
	$proximity = array('longitude'=>-122,'latitude'=>37);
	$res = $mapbox->geocode($address, "", $proximity);
```
## Reverse Geocode Example

```php
	//reverse geocode
	$longitude = -122;
	$latitude = 37;
	$res = $mapbox->reverseGeocode($longitude, $latitude);
   	//view results for debugging
	print_r($res->getData());
```

You can use the `types` parameter with reverse geocoding too, effectively giving you a form of point-in-polygon of different geography types:
```php
	//types
	$types = array('postcode');
	$res = $mapbox->reverseGeocode($longitude, $latitude, $types);
```
Pro Tip: longitude always comes before latitude in parameter order, except when it doesn't.

Permanent Geocoding requires specific authentication from Mapbox, so it's a different method:

```php
    	//permanent geocode
    	$address = "149 9th St, San Francisco, CA 94103";
    	$res = $mapbox->geocodePermanent($address);
    	//view results for debugging
	print_r($res->getData());
```

Unnecessary Reminder: we use <tt>print_r()</tt> in these examples so you can review the output visually.  Obviously, but worth a reminder nonetheless, you do not want to use <tt>print_r()</tt> in production.  

## Working with Results

The response object is an iterator, so you can iterate on it directly:

```php
	//iterate
	foreach ($res as $key => $value){
		//do something with each result
		print_r($value);
	}
```
You can also just get the results as an array:

```php
	$results = $res->getData();
	print_r($results);
```

## Debugging and Metadata

A boatload of tools are available in the driver to help you understand your request, and what the server is (or is not) returning.  Putting the mapbox object in debug mode will dump a ton of metadata to stdout on each query:

```php
	$mapbox->debug();
```

and a wealth of other metadata is available via the response object outside debug mode:

```php
	//was the request successful?
	$success = $res->success();

	//get result count
	$count = $res->getCount();

	//get http status code: 200, 404, etc.
	$code = $res->getCode();

	//get server headers (including rate-limit information)
	$headers = $res->getHeaders();

	//get request metadata
	$request - $res->getInfo();

	//get attribution
	$attribution - $res->getAttribution();

```

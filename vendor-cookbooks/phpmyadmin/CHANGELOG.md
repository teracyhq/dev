# CHANGELOG for phpmyadmin

This file is used to list changes made in each version of phpmyadmin.

## 1.0.7

* Version bump
* Include important PHP dependencies before running the default recipe

## 1.0.6

* Blowfish secret fix
* PMA version bump

## 1.0.5

* PMA major version bump in the 4.x series
* Fixed mirror string

## 1.0.4

* PMA version bump
* Fix for node save in order to run on chef-solo runs (credit: Ivan Tanev)
* Updated the upload directory permissions with more secure ones
* Othe small fixes here and there

## 1.0.2

* PMA version bump
* Updated some default attributes

## 1.0.1

* Updated blowfish hash creation method
* Added the pmadb LWRP for creating the PMA's databases to each needed node
* Updated LWRP idempotency
* Added new attributes

## 1.0.0:

* Initial release of phpmyadmin

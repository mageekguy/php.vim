php.vim
=======
# Vim syntax file for PHP

Yet another PHP syntax file for [VIM](http://www.vim.org).  
It's a light syntax file because there is:

* No support for PHP native functions
* No support for PHP native classes
* No support for PHP native interfaces
* No support for PHP native constants
* No support for PHP short tags, ie `<?` and `?>`

In order to use it, just put it in your `.vim/syntax` directory.  
It can be used only with [VIM](http://www.vim.org) ≥ 7.

## Features

* Support PHP 5.4 syntax
* Support annotations in comment block
* Fold functions, classes, interfaces, methods
* Fold comment block
* Fold try and catch block.
* Fold namespace importation if the `use` statement is used as a block, ie:

``` PHP
use
   foo\bar,
	atoum
;
```

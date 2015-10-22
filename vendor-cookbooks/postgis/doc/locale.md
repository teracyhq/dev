### Locale

It should be noted that it is best setup the locale so that
the encoding is the desired database encoding prior to including
the recipe. Typically this is set via a snippet such as;

    node.override['locale']['lang'] = 'en_AU.UTF-8'
    include_recipe 'locale::default'

    include_recipe 'postgis::default'

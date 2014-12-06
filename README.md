# Chef Cookbook to install ImageMagick (and perlmagick)

# Usage

in your `Berksfile`
```
cookbook 'imagemagick', github: 'DQNEO/cookbook-imagemagick
```

and run
```
berks vendor cookbooks
```

# Attributes

|name|default value|
|---|---|---|
|['imagemagick']['prefix']|/opt/ImageMagick|
|['imagemagick']['version']| 6.8.6-10 |
|['imagemagick']['with-perl']| /opt/perl/bin/perl |
|['imagemagick']['config_options']| --enable-shared --disable-openmp --disable-opencl --without-x |


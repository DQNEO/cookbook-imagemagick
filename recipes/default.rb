# -*- coding: utf-8 -*-
# install ImageMagick
# originally from ftp://ftp.kddlabs.co.jp/graphics/ImageMagick/

include_recipe "build-essential"

basename = "ImageMagick-#{node['imagemagick']['version']}"
tarball_filename = basename + ".tar.gz"
tarball_filepath = Chef::Config['file_cache_path'] + '/' + tarball_filename

# we need libpng to read logo file
%w{libjpeg-turbo libjpeg-turbo-devel libpng-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file tarball_filename do
  # destination
  path Chef::Config['file_cache_path'] + "/" + tarball_filename
end

bash "tar xfz ImageMagick" do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
    tar xfz #{tarball_filename}
  EOH

  not_if "test -e #{Chef::Config['file_cache_path']}/#{basename}"
end

# make and install
# (also make and install PerlMagick)
bash "make and install ImageMagick" do
  cwd Chef::Config['file_cache_path'] + "/" + basename
  flags '-e'
  code <<-EOH
    ./configure --prefix=#{node['imagemagick']['prefix']} --with-perl=#{node['imagemagick']['with-perl']} #{node['imagemagick']['config_options']}
    make
    make install
  EOH

  not_if "test -x #{node['imagemagick']['prefix']}/bin/convert"
end

# make symlinks
%w{montage animate composite convert identify mogrify}.each do |cmdname|
  link "/usr/local/bin/#{cmdname}" do
    to "#{node['imagemagick']['prefix']}/bin/#{cmdname}"
  end
end

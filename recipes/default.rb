# -*- coding: utf-8 -*-
# install ImageMagick
basename = "ImageMagick-#{node['imagemagick']['version']}"
tarball_filename = basename + ".tar.gz"
tarball_filepath = Chef::Config['file_cache_path'] + '/' + tarball_filename

# we need libpng to read log file
%w{libjpeg-turbo libjpeg-turbo-devel libpng-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file tarball_filename do
  # destination
  path Chef::Config['file_cache_path'] + "/" + tarball_filename
end

execute "tar xfz ImageMagick" do
  cwd Chef::Config['file_cache_path']
  command <<-EOH
    tar xfz #{tarball_filename}
  EOH

  creates Chef::Config['file_cache_path'] + "/" + basename
  action :run
end

# make and install
# (also make and install PerlMagick)
execute "make ImageMagick" do
  cwd Chef::Config['file_cache_path'] + "/" + basename

  command <<-EOH
    ./configure --prefix=#{node['imagemagick']['prefix']} --with-perl=#{node['imagemagick']['with-perl']} --enable-shared --disable-opencl --without-x
    make
    make install
  EOH

  creates "#{node['imagemagick']['prefix']}/bin/convert"

  action :run
end

# make symlinks
%w{montage animate composite convert identify mogrify}.each do |cmdname|
  link "/usr/local/bin/#{cmdname}" do
    to "#{node['imagemagick']['prefix']}/bin/#{cmdname}"
  end
end

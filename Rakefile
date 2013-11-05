task :default do
  build_dir = 'build'
  FileUtils.mkdir_p(build_dir)
  vendor = ['jquery', 'ie9-prototype-name', 'handlebars', 'md5', 'moment', 'mousetrap', 'autolink', 'autoresize', 'autocomplete']
  vendor = vendor.map { |v| "vendor/#{v}.js" }.join(' ')
  `cat #{vendor} > #{File.join(build_dir, 'vendor.tmp.js')}`

  tmp_vendor_file = File.join(build_dir, 'vendor.tmp.js')
  tmp_helpers_file = File.join(build_dir, 'helpers.tmp.js')
  tmp_swipe_file = File.join(build_dir, 'swipe.tmp.js')

  lib_files = ['framework', 'view_object', 'router', 'layout', 'view', 'page', 'dialog', 'store', 'tabbed_view']
  lib_files = lib_files.map { |v| "lib/#{v}.coffee" }.join(' ')

  system "coffee --compile --join #{tmp_helpers_file} helpers/*.coffee"
  system "coffee --compile --join #{tmp_swipe_file} #{lib_files}"

  `cat #{tmp_vendor_file} #{tmp_helpers_file} #{tmp_swipe_file} > #{File.join(build_dir, 'swipe.js')}`
  FileUtils.rm(tmp_vendor_file)
  FileUtils.rm(tmp_helpers_file)
  FileUtils.rm(tmp_swipe_file)
end
require 'coffee-script'
Dir.glob('**/*.coffee') do |coffee_file_path|
  coffee_src = File.read coffee_file_path
  js_src = CoffeeScript.compile coffee_src, bare: true
  File.open(coffee_file_path.gsub('.coffee', '.js'), 'w') do |file|
    file.write js_src
  end
end
require "jekyll"

#After the site is written, the necessary files this plugin's generateed code needs are also written
Jekyll::Hooks.register :site, :post_write do |site|
  debug_logging = site&.config&.dig("jdvp_back_to_top", "debug_logging") || false

  # Copy required CSS file
  css = File.expand_path("../../assets/jdvp-back-to-top.css", __FILE__)
  FileUtils.mkdir_p("#{site.in_dest_dir("assets/")}")
  css_location = site.in_dest_dir("assets/jdvp-back-to-top.css")
  if (debug_logging)
    puts "Copying jdvp-back-to-top CSS to #{css_location}"
  end
  FileUtils.cp(css, "#{css_location}")

  # Copy required JS file
  js = File.expand_path("../../assets/jdvp-back-to-top.js", __FILE__)
  js_location = site.in_dest_dir("assets/jdvp-back-to-top.js")
  if (debug_logging)
    puts "Copying jdvp-back-to-top JavaScript to #{js_location}"
  end
  FileUtils.cp(js, "#{js_location}")

  # Determine which pages will get the widget
  page_file_pattern = site&.config&.dig("jdvp_back_to_top", "file_pattern") || "**/*.html"

  # Generate the actual HTML for pages that will have the widget
  default_options = "{id:\"jdvp-back-to-top\",backgroundColor:\"#FFF\",textColor:\"#000\",innerHTML:\'<svg style=\"margin: 0px;\"><path d=\"M4 12l1.41 1.41L11 7.83V20h2V7.83l5.58 5.59L20 12l-8-8-8 8z\"/></svg>\',cornerOffset:20}"
  back_to_top_options = site&.config&.dig("jdvp_back_to_top", "options") || default_options
  resource_string = "<link rel=\"stylesheet\" href=\"#{site.baseurl}/assets/jdvp-back-to-top.css\"/>" +
    "<script src=\"#{site.baseurl}/assets/jdvp-back-to-top.js\"></script>" + 
    "<script>addBackToTop(#{back_to_top_options});</script>"

  # For every html file in the generated site
  site_directory = "#{site.in_dest_dir("/")}"
  Dir.glob(page_file_pattern, base: site_directory).each do |file_name|
    file_plus_path = "#{site_directory}#{file_name}"

    if (debug_logging)
      puts "Adding jdvp-back-to-top widget to #{file_plus_path}"
    end

    # If the file has a body, append to the body
    if (File.foreach(file_plus_path).grep(/<\/body>/).any?)
      File.write(file_plus_path, File.open(file_plus_path, &:read).sub("</body>","#{resource_string}</body>"))
    # If no body exists for some reason, try to just append at the end of the html tag
    elsif (File.foreach(file_plus_path).grep(/<\/html>/).any?)
      File.write(file_plus_path, File.open(file_plus_path, &:read).sub("</html>","#{resource_string}</html>"))
    end
  end
end
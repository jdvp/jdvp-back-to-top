Gem::Specification.new do |spec|
  spec.name          = "jdvp-back-to-top"
  spec.summary       = "Simple gem used to add a back-to-top widget to my site"
  spec.version       = "1.0.0"
  spec.authors       = ["JD Porterfield"]
  spec.email         = "jd.porterfield@alumni.rice.edu"
  spec.homepage      = "https://github.com/jdvp/jdvp-back-to-top"
  spec.licenses      = ["MIT"]

  spec.files         = [
    "lib/jdvp-back-to-top.rb", 
    "assets/jdvp-back-to-top.css",
    "assets/jdvp-back-to-top.js"
  ]

  spec.required_ruby_version = ">= 2.6.0"
  spec.add_development_dependency "jekyll", ">= 4.2", "< 5.0"
end
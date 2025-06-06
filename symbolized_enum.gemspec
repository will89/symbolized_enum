# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'symbolized_enum/version'

Gem::Specification.new do |spec|
  spec.name          = 'symbolized_enum'
  spec.version       = SymbolizedEnum::VERSION
  spec.authors       = ['Will Leonard']
  spec.email         = ['wleonard@salsify.com']

  spec.summary       = 'Symbolized enum for activerecord'
  spec.homepage      = 'https://github.com/will89/symbolized_enum'
  spec.license       = 'MIT'

  spec.metadata      = {
    'homepage_uri' => 'https://github.com/will89/symbolized_enum',
    'changelog_uri' => 'https://github.com/will89/symbolized_enum/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/will89/symbolized_enum/',
    'bug_tracker_uri' => 'https://github.com/will89/symbolized_enum/issues'
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.1'

  spec.add_dependency 'activerecord', '>= 7.0', '< 8.1'
  spec.add_dependency 'activerecord-type-symbol', '~> 0.7.0'
  spec.add_dependency 'activesupport', '>= 7.0', '< 8.1'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'bundler', '>= 1.3.0'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'with_model'
end

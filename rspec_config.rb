if defined?(RSpec)
  RSpec.configure do |config|
    # Filter all gems from backtrace
    config.filter_gems_from_backtrace
    
    # Additionally filter asdf paths
    config.backtrace_exclusion_patterns << /\.asdf\/installs/
    
    # But always show application code
    config.backtrace_inclusion_patterns = [
      /#{Regexp.escape(Dir.pwd)}\//  # Your project directory
    ]
  end
end
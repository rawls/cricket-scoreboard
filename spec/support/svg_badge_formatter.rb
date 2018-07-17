require 'pathname'
# Generates an SVG format test coverage badge for the README.md
class SvgBadgeFormatter
  # Badge colours
  GREEN  = '#97CA00'.freeze
  ORANGE = '#dfb317'.freeze
  RED    = '#e05d44'.freeze

  OUTFILE = Pathname.new(__FILE__).realpath.parent.parent.parent + 'resources' + 'coverage.svg'

  # Generates the SVG and writes it to the OUTFILE
  def format(result)
    coverage = result.source_files.covered_percent.round(0)
    File.write(OUTFILE, svg(coverage))
    puts "Generated badge to #{OUTFILE}"
  rescue StandardError
    puts "Failed to generate badge to #{OUTFILE}"
  end

  private

  def svg(coverage)
    <<-SVG
      <svg xmlns="http://www.w3.org/2000/svg" width="99" height="20">
        <linearGradient id="a" x2="0" y2="100%">
          <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
          <stop offset="1" stop-opacity=".1"/>
        </linearGradient>
        <rect rx="3" width="99" height="20" fill="#555"/>
        <rect rx="3" x="63" width="36" height="20" fill="#{colour(coverage)}"/>
        <path fill="#97CA00" d="M63 0h4v20h-4z"/>
        <rect rx="3" width="99" height="20" fill="url(#a)"/>
        <g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11">
          <text x="32.5" y="15" fill="#010101" fill-opacity=".3">coverage</text>
          <text x="32.5" y="14">coverage</text>
          <text x="80" y="15" fill="#010101" fill-opacity=".3">#{coverage}%</text>
          <text x="80" y="14">#{coverage}%</text>
        </g>
      </svg>
    SVG
  end

  def colour(coverage)
    case coverage
    when 0..59   then RED
    when 60..89  then ORANGE
    when 90..100 then GREEN
    end
  end
end

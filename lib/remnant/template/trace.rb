# -*- coding: utf-8 -*-
class Remnant
  class Template
    class Trace
      def start(template_name)
        rendering = Remnant::Template::Rendering.new(template_name)
        rendering.start_time = Time.now
        @current.add(rendering)
        @current = rendering
      end

      def finished(template_name)
        @current.end_time = Time.now
        @current = @current.parent
      end

      def initialize
        @current = root
      end

      def total_time
        root.child_time
      end

      def root
        @root ||= Remnant::Template::Rendering.new('root')
      end

      def log(logger, rendering, depth = 0)
        rendering.results.map do |key, result|

          #
          line = Remnant.color
          line += "#{'   ' * depth}#{depth != 0 ? '└ ' : ''}"
          line += "#{result['time'].to_i}ms (#{result['exclusive'].to_i}ms)"
          line += Remnant.color(true)
          line += ' ' * ((line.size >= 50 ? 10 : 50 - line.size) - (depth == 0 ? 2 : 0))
          line += "#{key}"

          logger.info line

          rendering.children.map do |child|
            log(logger, child, depth + 1)
          end
        end
      end
    end
  end
end

module ActiveRecord
  module Acts
    module DimensionedGallery
      module CygonRectanglePacker
        class Point
          
          @X
          @Y

          def initialize(x,y)
            @X = x
            @Y = y
          end

          def ==(point)
            return @X == point.X && @Y == point.Y
          end

          def X
            return @X
          end

          def Y
            return @Y
          end

          def X=(x)
            @X = x
          end
          
          def Y=(y)
            @Y = y
          end
          
        end
      end
    end
  end
end
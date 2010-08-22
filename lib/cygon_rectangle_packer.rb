module ActiveRecord
  module Acts
    module DimensionedGallery
      module CygonRectanglePacker
        class Packer
          @heightSlices
          @packingAreaWidth
          @packingAreaHeight

          def initialize(packingAreaWidth, packingAreaHeight)
            @packingAreaWidth = packingAreaWidth
            @packingAreaHeight = packingAreaHeight
            @heightSlices = Array.new
            @heightSlices << Point.new(0,0)
          end

          def TryPack(rectangleWidth, rectangleHeight)
            if (rectangleWidth > @packingAreaWidth) || (rectangleHeight > @packingAreaHeight)
              return nil
            end

            placement = tryFindBestPlacement(rectangleWidth, rectangleHeight)

            if placement
              integrateRectangle(placement.X, rectangleWidth, placement.Y + rectangleHeight)
            end

            return placement
          end

          private
            def tryFindBestPlacement(rectangleWidth, rectangleHeight)
              bestSliceIndex = -1
              bestSliceY = 0
              bestScore = @packingAreaHeight
              leftSliceIndex = 0

              #@heightSlices.sort! {|x,y| x.X <=> y.X}
              rightSliceIndex = @heightSlices.bsearch_lower_boundary {|x| x.X <=> rectangleWidth}

              while rightSliceIndex <= @heightSlices.length
                highest = @heightSlices[leftSliceIndex].Y
                (leftSliceIndex + 1).upto(rightSliceIndex - 1) do |index|
                  if @heightSlices[index].Y > highest
                    highest = @heightSlices[index].Y
                  end
                end

                if (highest + rectangleHeight) <= @packingAreaHeight
                  score = highest

                  if score < bestScore
                    bestSliceIndex = leftSliceIndex
                    bestSliceY = highest
                    bestScore = score
                  end
                end

                leftSliceIndex += 1
                if leftSliceIndex >= @heightSlices.length
                  break
                end

                rre = @heightSlices[leftSliceIndex].X + rectangleWidth
                rre.upto(@heightSlices.length) do |rightRectangleEnd|
                  if rightSliceIndex == @heightSlices.length
                    rightSliceStart = @packingAreaWidth
                  else
                    rightSliceStart = @heightSlices[rightSliceIndex].X
                  end

                  if rightSliceStart > rightRectangleEnd
                    break
                  end
                end

                if rightSliceIndex > @heightSlices.length
                  break
                end
              end

              if bestSliceIndex == -1
                return nil
              else
                return Point.new(@heightSlices[bestSliceIndex].X, bestSliceY)
              end
            end

            def integrateRectangle(left, width, bottom)
              #@heightSlices.sort! {|x,y| x.X <=> y.X}
              startSlice = @heightSlices.bsearch_first {|x| x.X <=> left}

              if !startSlice
                raise "Slice starts within another slice"
              end

              firstSliceOriginalHeight = @heightSlices[startSlice].Y
              @heightSlices[startSlice] = Point.new(left, bottom)

              right = left + width
              startSlice += 1

              if startSlice >= @heightSlices.length

                if right < @packingAreaWidth
                  @heightSlices << Point.new(right, firstSliceOriginalHeight)
                end
              else
                point_right = Point.new(right, 0)
                #@heightSlices.sort! {|x,y| x.X <=> y.X}
                endSlice = @heightSlices.bsearch_lower_boundary(startSlice..@heightSlices.length - startSlice) {|x| x.X <=> point_right.X}

                if @heightSlices[endSlice] == point_right
                  @heightSlices.slice!(startSlice..(endSlice - startSlice))
                else
                  if endSlice == startSlice
                    returnHeight = firstSliceOriginalHeight
                  else
                    returnHeight = @heightSlices[endSlice - 1].Y
                  end

                  @heightSlices.slice!(startSlice..(endSlice - startSlice))
                  if right < @packingAreaWidth
                    @heightSlices.insert(startSlice, Point.new(right, returnHeight))
                  end
                end
              end
            end
        end
      end
    end
  end
end
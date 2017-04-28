require "stumpy_core"
class StumpyCore::Canvas
  def paste(canvas : Canvas, x, y, color : RGBA)
      (0...canvas.width).each do |cx|
        (0...canvas.height).each do |cy|
          current = safe_get(x + cx, y + cy)
          unless current.nil?
            self[x + cx, y + cy] = canvas[cx, cy].multiply(color).over(current)
          end
        end
      end
  end

  def paste_flip(canvas : Canvas, x, y)
    (0...canvas.width).each do |cx|
      (0...canvas.height).each do |cy|
        current = safe_get(x + cx, y + cy)
        unless current.nil?
          icx = canvas.width - cx - 1
          self[x + cx, y + cy] = canvas[icx, cy].over(current)
        end
      end
    end
  end

  def paste_flip(canvas : Canvas, x, y, color : RGBA)
    (0...canvas.width).each do |cx|
      (0...canvas.height).each do |cy|
        current = safe_get(x + cx, y + cy)
        unless current.nil?
          icx = canvas.width - cx - 1
          self[x + cx, y + cy] = canvas[icx, cy].multiply(color).over(current)
        end
      end
    end
  end
end
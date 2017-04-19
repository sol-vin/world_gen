require "stumpy_core"
class StumpyCore::Canvas
  def paste_and_tint(canvas : Canvas, x, y, color : RGBA)
      (0...canvas.width).each do |cx|
        (0...canvas.height).each do |cy|
          current = safe_get(x + cx, y + cy)
          unless current.nil?
            self[x + cx, y + cy] = canvas[cx, cy].multiply(color).over(current)
          end
        end
      end
  end
end
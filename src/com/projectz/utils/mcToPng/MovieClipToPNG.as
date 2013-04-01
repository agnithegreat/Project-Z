/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 30.03.13
 * Time: 2:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.mcToPng {
import com.adobe.images.PNGEncoder;

import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.geom.Matrix;
import flash.geom.Rectangle;

public class MovieClipToPNG {

    public static function exportPNGSequence($name: String, $mc: MovieClip, $scale: Number = 1):Vector.<PNG> {
        $mc.scaleX = $mc.scaleY = $scale;

        var len: int = $mc.totalFrames;
        var rect: Rectangle = new Rectangle();
        for (var i:int = 1; i <= len; i++) {
            $mc.gotoAndStop(i);
            var tempBounds: Rectangle = $mc.getBounds($mc);
            rect = rect.union(tempBounds);
        }

        var pngs: Vector.<PNG> = new <PNG>[];
        var count: int = 0;
        var state: String = "";
        $mc.gotoAndStop(1);
        for (i = 1; i < len; i++) {
            if ($mc.currentFrameLabel && state != $mc.currentFrameLabel) {
                state = $mc.currentFrameLabel;
                count = 0;
            }
            var bd: BitmapData = new BitmapData(rect.width, rect.height);
            bd.draw($mc, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));

            var png: PNG = new PNG();
            png.name = $name + "-" + state + "_" + (100 + (++count));
            png.data = PNGEncoder.encode(bd);
            pngs.push(png);

            $mc.nextFrame();
        }

        return pngs;
    }
}
}
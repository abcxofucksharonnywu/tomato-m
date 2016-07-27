package org.apache.cordova.scan;

import android.content.Context;
import android.hardware.Camera;
import android.util.AttributeSet;

import me.dm7.barcodescanner.zxing.ZXingScannerView;

/**
 * Created by SHARON on 16/7/27.
 */

public class ScanView extends ZXingScannerView {
    public ScanView(Context context) {
        super(context);
    }

    public ScanView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }

    @Override
    public void setupCameraPreview(Camera camera) {
        super.setupCameraPreview(camera);
        getChildAt(1).setVisibility(INVISIBLE);
    }
}

package org.apache.cordova.scan;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.ImageView;

import com.abcxo.tomato.R;
import com.google.zxing.Result;

import me.dm7.barcodescanner.zxing.ZXingScannerView;

public class ScanActivity extends Activity implements ZXingScannerView.ResultHandler {
    public static final String TAG = "ScanActivity";
    private ScanView mScannerView;

    @Override
    public void onCreate(Bundle state) {
        super.onCreate(state);
        setContentView(R.layout.activity_scan);                // Set the scanner view as the content view
        mScannerView = (ScanView) findViewById(R.id.v_scan);
        findViewById(R.id.iv_close).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        final ImageView iv_scan = (ImageView) findViewById(R.id.iv_scan);
        iv_scan.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                    iv_scan.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                } else {
                    iv_scan.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                }
                iv_scan.getLayoutParams().height = iv_scan.getMeasuredWidth();
            }
        });

    }

    @Override
    public void onResume() {
        super.onResume();
        mScannerView.setResultHandler(this); // Register ourselves as a handler for scan results.
        mScannerView.startCamera();          // Start camera on resume


    }

    @Override
    public void onPause() {
        super.onPause();
        mScannerView.stopCamera();           // Stop camera on pause

    }

    @Override
    public void handleResult(Result rawResult) {
        // Do something with the result here
        Log.v(TAG, rawResult.getText()); // Prints scan results
        Log.v(TAG, rawResult.getBarcodeFormat().toString()); // Prints the scan format (qrcode, pdf417 etc.)

        // If you would like to resume scanning, call this method below:
//        mScannerView.resumeCameraPreview(this);
        Intent intent = new Intent();
        intent.putExtra("content", rawResult.getText());
        setResult(RESULT_OK, intent);
        finish();
    }


}
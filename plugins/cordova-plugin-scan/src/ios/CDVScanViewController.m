
//
//  CDVScanViewController.m
//  tomato
//
//  Created by shadow on 16/3/11.
//
//

#import "CDVScanViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface CDVScanViewController () <AVCaptureMetadataOutputObjectsDelegate> //用于处理采集信息的代理
@property (strong, nonatomic) AVCaptureSession* scanSession; //输入输出的中间桥梁
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* scanLayer; //输入输出的中间桥梁
@end
@implementation CDVScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"識別二維碼";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"關閉" style:UIBarButtonItemStylePlain target:self action:@selector(handleClose:)];

    // Do any additional setup after loading the view, typically from a nib.
    //获取摄像设备
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput* output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    //初始化链接对象
    self.scanSession = [[AVCaptureSession alloc] init];
    //高质量采集率
    [self.scanSession setSessionPreset:AVCaptureSessionPresetHigh];

    [self.scanSession addInput:input];
    [self.scanSession addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[ AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode93Code ];

    self.scanLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.scanSession];
    self.scanLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.scanLayer atIndex:0];
    //开始捕获
    [self.scanSession startRunning];
}

-(void)handleClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scanLayer.frame = self.view.layer.bounds;
}
- (void)viewWillAppear:(BOOL)animated
{
    if (!self.scanSession.isRunning) {
        [self.scanSession startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.scanSession.isRunning) {
        [self.scanSession stopRunning];
    }
}

- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputMetadataObjects:(NSArray*)metadataObjects fromConnection:(AVCaptureConnection*)connection
{
    [self.scanSession stopRunning];
    if (metadataObjects.count > 0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject* metadataObject = [metadataObjects objectAtIndex:0];
        //输出扫描字符串
        NSString *str = metadataObject.stringValue;
        NSLog(@"%@",str);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"scan" object:self userInfo:@{@"content":str}];
                [self handleClose:NULL];
        });
        
        
    }
}

@end


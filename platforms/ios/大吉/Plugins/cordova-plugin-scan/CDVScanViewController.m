
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
@property (strong, nonatomic) UIImageView* imageView; //输入输出的中间桥梁
@property (strong, nonatomic) UILabel* label; //输入输出的中间桥梁
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* scanLayer; //输入输出的中间桥梁
@end
@implementation CDVScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"識別二維碼";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Close"] style:UIBarButtonItemStylePlain target:self action:@selector(handleClose:)];

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
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Scan"]];
    [self.view addSubview:self.imageView];
    
    self.label = [[UILabel alloc] init];
    self.label.text = @"請將二維碼放入框內，將自動識別";
    self.label.backgroundColor = [UIColor colorWithRed:253/255.f green:28/255.f blue:122/255.f alpha:1];
    self.label.textColor =[UIColor whiteColor];
    self.label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:self.label];
}

-(void)handleClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scanLayer.frame = self.view.layer.bounds;
    CGFloat width = self.view.frame.size.width;
    CGFloat imageViewWidth =width-60;
    self.imageView.frame=CGRectMake(30, (self.view.frame.size.height-imageViewWidth)/2-60, imageViewWidth, imageViewWidth);
    [self.label sizeToFit];
    self.label.frame = CGRectMake((width-self.label.frame.size.width-30)/2, CGRectGetMaxY(self.imageView.frame)+30, self.label.frame.size.width+30, self.label.frame.size.height+10);
    
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


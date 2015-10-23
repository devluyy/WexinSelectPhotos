//
//  EMImageCropView.m
//  PictureSelector
//
//  Created by Lyy on 15/8/21.
//  Copyright (c) 2015年 Lyy. All rights reserved.
//

#import "EMImageCropView.h"


#define k64Height          (64.f)

@interface EMImageCropView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic) CGFloat cropSquareSide;

@end

@implementation EMImageCropView

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize cropRect = _cropRect;
@synthesize originalImage = _originalImage;
@synthesize cropSquareSide = _cropSquareSide;


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return self.scrollView;
}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        self.scrollView.layer.masksToBounds = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [[self scrollView] addSubview:_imageView];
    }
    return _imageView;
}

- (void)originalImage:(UIImage *)originalImage cropSquareSide:(CGFloat)cropSquareSide
{
    [self setOriginalImage:originalImage];
    if (originalImage) {
        [self setCropSquareSide:cropSquareSide];
    }
}
-(void)setOriginalImage:(UIImage *)originalImage
{
    if (originalImage != _originalImage) {
        _originalImage = nil;
        _originalImage = originalImage;
    }
    [[self imageView] setImage:_originalImage];
}

-(void)setCropSquareSide:(CGFloat)cropSquareSide
{
    
    _cropSquareSide = cropSquareSide;
    
    [self.scrollView setFrame:CGRectMake(self.center.x-_cropSquareSide/2, self.center.y-_cropSquareSide/2 - k64Height, _cropSquareSide, _cropSquareSide + k64Height)];
    
    CGFloat selfViewW = CGRectGetWidth(self.frame);
    CGFloat imageW = _originalImage.size.width;
    CGFloat imageH = _originalImage.size.height;
    
    CGFloat imageViewW = 0;
    CGFloat imageViewH = 0;
    if (self.originalImage.size.width<=self.originalImage.size.height) {
        imageViewW = selfViewW;
        imageViewH = imageH*selfViewW/imageW;
    }else{
        imageViewW = imageW*self.cropSquareSide/imageH;
        imageViewH = self.cropSquareSide;
    }
    
    float minimumScale = self.cropSquareSide/MIN(imageViewW, imageViewH);
    self.scrollView.minimumZoomScale = minimumScale;
    self.scrollView.maximumZoomScale = minimumScale+2;

    
    [self.imageView setFrame:CGRectMake(0,0, imageViewW, imageViewH)];
    
    [self.scrollView setContentSize:self.imageView.frame.size];
    [self.scrollView addSubview:self.imageView];
    
    
    CGFloat offsetX = ABS((imageViewW- self.cropSquareSide)/2);
    CGFloat offsetY = ABS((imageViewH- self.cropSquareSide)/2);
    
    [_scrollView setContentOffset:CGPointMake(offsetX, offsetY) animated:YES];
    
    self.maskOpacity = self.maskOpacity?self.maskOpacity:0.7f;
    self.maskColor = self.maskColor?self.maskColor:[UIColor blackColor];
    [self overlayMask];

}

-(void)setMaskColor:(UIColor *)maskColor
{
    _maskColor = maskColor;
    [self setNeedsLayout];
}

-(void)setMaskOpacity:(CGFloat)maskOpacity
{
    _maskOpacity = maskOpacity;
    [self setNeedsLayout];
}

- (void)overlayMask
{
    CALayer *maskLayer = [CALayer new];
    maskLayer.frame = self.frame;
    maskLayer.backgroundColor = self.maskColor.CGColor;
    maskLayer.opacity = self.maskOpacity;
    [self.layer addSublayer:maskLayer];
    
    CAShapeLayer *arcLayer = [[CAShapeLayer alloc] init];
    arcLayer.frame = maskLayer.frame;
    
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithRect:arcLayer.frame];
    
    _cropSquareSide = self.cropSquareSide<self.frame.size.width?self.cropSquareSide:self.frame.size.width;
    
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.cropSquareSide/2 startAngle:0.0f endAngle:M_PI*2 clockwise:YES];
    
    [shapePath appendPath:arcPath];
    
    arcLayer.path = shapePath.CGPath;
    arcLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.mask = arcLayer;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.cropSquareSide/2 startAngle:0.0f endAngle:M_PI*2 clockwise:YES].CGPath;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor whiteColor].CGColor;
    circle.lineWidth = 0;
    
    // Add to parent layer
    [self.layer addSublayer:circle];
}


-(UIImage *)cropImage
{
    CGFloat zoomScale = [self scrollView].zoomScale;
    CGFloat offsetX = [self scrollView].contentOffset.x;
    CGFloat offsetY = [self scrollView].contentOffset.y;
    CGRect cropRect = CGRectMake(offsetX/zoomScale, offsetY/zoomScale+k64Height, _cropSquareSide/zoomScale, _cropSquareSide/zoomScale);
    
    UIImage* bigImage= [self latestImage];
    
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, cropRect);
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, cropRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

- (UIImage *)latestImage {
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, YES, 1);  //NO，YES 控制是否透明
    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

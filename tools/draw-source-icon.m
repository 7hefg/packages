// Original circular arc-reactor-inspired source artwork. No external image assets.
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <CommonCrypto/CommonDigest.h>
#import <math.h>

static void fill(CGContextRef c, CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    CGContextSetRGBFillColor(c,r,g,b,a);
}
static void stroke(CGContextRef c, CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    CGContextSetRGBStrokeColor(c,r,g,b,a);
}
static CGRect disc(CGFloat r) { return CGRectMake(128-r,128-r,2*r,2*r); }
static CGPoint polar(CGFloat radius, CGFloat a) {
    return CGPointMake(128+radius*cos(a),128+radius*sin(a));
}
static void ring(CGContextRef c, CGFloat radius, CGFloat width, CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    stroke(c,r,g,b,a); CGContextSetLineWidth(c,width); CGContextStrokeEllipseInRect(c,disc(radius));
}
static void radial(CGContextRef c, CGFloat radius, const CGFloat *colors, const CGFloat *locations, size_t count) {
    CGColorSpaceRef cs=CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient=CGGradientCreateWithColorComponents(cs,colors,locations,count);
    CGContextDrawRadialGradient(c,gradient,CGPointMake(119,141),0,CGPointMake(128,128),radius,kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient); CGColorSpaceRelease(cs);
}
static void wedge(CGContextRef c, CGFloat inner, CGFloat outer, CGFloat a, CGFloat width) {
    CGContextBeginPath(c);
    CGContextAddArc(c,128,128,outer,a-width/2,a+width/2,0);
    CGPoint p=polar(inner,a+width/2); CGContextAddLineToPoint(c,p.x,p.y);
    CGContextAddArc(c,128,128,inner,a+width/2,a-width/2,1);
    CGContextClosePath(c); CGContextDrawPath(c,kCGPathFillStroke);
}
static void glow(CGContextRef c, CGFloat radius, CGFloat width) {
    ring(c,radius,width+18,.00,.55,1,.035);
    ring(c,radius,width+10,.05,.70,1,.12);
    ring(c,radius,width+4,.16,.83,1,.6);
    ring(c,radius,width,.70,.96,1,1);
    ring(c,radius,MAX(1,width-2),.94,1,1,1);
}
static void draw(CGContextRef c) {
    CGFloat bg[]={.055,.095,.15,1, .018,.028,.05,1}; CGFloat ends[]={0,1};
    radial(c,185,bg,ends,2);
    // Recessed metal mounting plate with faint machining marks.
    fill(c,.015,.024,.04,1); CGContextFillEllipseInRect(c,disc(112));
    ring(c,111,2,.22,.29,.34,1);
    CGFloat bezel[]={.32,.39,.44,1, .095,.13,.17,1, .035,.05,.07,1}; CGFloat stops[]={0,.62,1};
    CGContextSaveGState(c); CGContextAddEllipseInRect(c,disc(106)); CGContextClip(c);
    radial(c,110,bezel,stops,3); CGContextRestoreGState(c);
    for(int i=0;i<6;i++) ring(c,100+i,0.45,.56,.66,.72,.18);
    ring(c,98,2,.015,.025,.04,1);
    fill(c,.018,.045,.065,1); CGContextFillEllipseInRect(c,disc(96));
    glow(c,91,4);
    // Twelve radial electromagnetic cartridges, each wound with copper bands.
    for(int i=0;i<12;i++) {
        CGFloat a=(i*30+15)*M_PI/180;
        fill(c,.15,.22,.27,1); stroke(c,.46,.58,.62,1); CGContextSetLineWidth(c,.8);
        wedge(c,66,86,a,.32);
        fill(c,.48,.29,.15,1); stroke(c,.80,.58,.30,1); CGContextSetLineWidth(c,.4);
        wedge(c,69,83,a,.22);
        for(int j=0;j<6;j++) {
            CGFloat ra=70.0+j*2.1;
            stroke(c,.95,.70,.40,.80); CGContextSetLineWidth(c,.7);
            CGContextBeginPath(c); CGContextAddArc(c,128,128,ra,a-.10,a+.10,0); CGContextStrokePath(c);
        }
        // Cool highlights separate each cartridge even at small sizes.
        CGPoint p=polar(66,a-.17), q=polar(86,a-.17);
        stroke(c,.29,.77,.88,.8); CGContextSetLineWidth(c,1);
        CGContextMoveToPoint(c,p.x,p.y); CGContextAddLineToPoint(c,q.x,q.y); CGContextStrokePath(c);
    }
    ring(c,64,3,.22,.35,.42,1);
    glow(c,59,5);
    fill(c,.016,.06,.10,1); CGContextFillEllipseInRect(c,disc(53));
    ring(c,50,1,.25,.54,.64,1);
    // Fine radial energy vanes around a bright, simple central core.
    for(int i=0;i<36;i++) {
        CGFloat a=i*M_PI/18;
        CGPoint p=polar(38,a),q=polar(48,a);
        stroke(c,.29,.75,.87,.55); CGContextSetLineWidth(c,.65);
        CGContextMoveToPoint(c,p.x,p.y); CGContextAddLineToPoint(c,q.x,q.y); CGContextStrokePath(c);
    }
    CGFloat core[]={.98,1,1,1, .72,.97,1,1, .22,.73,.96,1}; CGFloat coreStops[]={0,.62,1};
    CGContextSaveGState(c); CGContextAddEllipseInRect(c,disc(39)); CGContextClip(c);
    radial(c,42,core,coreStops,3); CGContextRestoreGState(c);
    glow(c,38,2);
    // Three dark titanium braces, stopping short of the core.
    for(int i=0;i<3;i++) {
        CGFloat a=(90+i*120)*M_PI/180;
        fill(c,.07,.13,.17,1); stroke(c,.37,.54,.60,1); CGContextSetLineWidth(c,.7);
        wedge(c,43,63,a,.10);
        CGPoint p=polar(52,a); fill(c,.80,.95,.98,1);
        CGContextFillEllipseInRect(c,CGRectMake(p.x-1.2,p.y-1.2,2.4,2.4));
    }
    // Four recessed screws in the outer bezel.
    for(int i=0;i<4;i++) {
        CGFloat a=(45+i*90)*M_PI/180; CGPoint p=polar(102,a);
        fill(c,.025,.045,.06,1); CGContextFillEllipseInRect(c,CGRectMake(p.x-3,p.y-3,6,6));
        stroke(c,.51,.63,.69,1); CGContextSetLineWidth(c,.8);
        CGContextMoveToPoint(c,p.x-1.5,p.y-.7); CGContextAddLineToPoint(c,p.x+1.5,p.y+.7); CGContextStrokePath(c);
    }
}
int main(int argc,const char *argv[]) {
    @autoreleasepool {
        if(argc!=2) { fprintf(stderr,"Usage: draw-source-icon OUTPUT.png\n"); return 64; }
        const size_t size=768, outputSize=192;
        CGColorSpaceRef cs=CGColorSpaceCreateDeviceRGB();
        CGContextRef large=CGBitmapContextCreate(NULL,size,size,8,size*4,cs,kCGImageAlphaPremultipliedLast);
        if(!large) return 1;
        CGContextScaleCTM(large,3,3); CGContextSetAllowsAntialiasing(large,true); draw(large);
        CGImageRef rendered=CGBitmapContextCreateImage(large);
        CGContextRef small=CGBitmapContextCreate(NULL,outputSize,outputSize,8,outputSize*4,cs,kCGImageAlphaPremultipliedLast);
        if(!small || !rendered) return 1;
        CGContextSetInterpolationQuality(small,kCGInterpolationHigh);
        CGContextDrawImage(small,CGRectMake(0,0,outputSize,outputSize),rendered);
        CGImageRef image=CGBitmapContextCreateImage(small);
        NSURL *url=[NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[1]]];
        CGImageDestinationRef dest=CGImageDestinationCreateWithURL((__bridge CFURLRef)url,CFSTR("public.png"),1,NULL);
        if(!dest) return 1;
        CGImageDestinationAddImage(dest,image,NULL);
        bool ok=CGImageDestinationFinalize(dest); CFRelease(dest);
        CGImageRelease(image); CGContextRelease(small); CGImageRelease(rendered); CGContextRelease(large); CGColorSpaceRelease(cs);
        if(!ok) return 1;
        NSData *data=[NSData dataWithContentsOfURL:url];
        CGImageSourceRef check=CGImageSourceCreateWithData((__bridge CFDataRef)data,NULL);
        CGImageRef decoded=check?CGImageSourceCreateImageAtIndex(check,0,NULL):NULL;
        if(!decoded || !CFEqual(CGImageSourceGetType(check),CFSTR("public.png")) || CGImageGetWidth(decoded)!=outputSize || CGImageGetHeight(decoded)!=outputSize || data.length>100000) return 1;
        unsigned char hash[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256(data.bytes,(CC_LONG)data.length,hash);
        printf("PNG verified: %zux%zu, %lu bytes, SHA256 ",CGImageGetWidth(decoded),CGImageGetHeight(decoded),(unsigned long)data.length);
        for(int i=0;i<CC_SHA256_DIGEST_LENGTH;i++) printf("%02x",hash[i]); printf("\n");
        CGImageRelease(decoded); CFRelease(check); return 0;
    }
}

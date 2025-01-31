#include <opencv2/opencv.hpp>
#include <chrono>

#ifdef __ANDROID__

#include <android/log.h>

#endif

using namespace cv;
using namespace std;

extern "C"
{

    void platform_log(const char *fmt, ...)
    {
        va_list args;
        va_start(args, fmt);
#ifdef __ANDROID__
        __android_log_vprint(ANDROID_LOG_VERBOSE, "FFI Logger: ", fmt, args);
#else
        vprintf(fmt, args);
#endif
        va_end(args);
    }

    __attribute__((visibility("default"))) __attribute__((used))
    const char *
    getOpenCVVersion()
    {
        return CV_VERSION;
    }

    __attribute__((visibility("default"))) __attribute__((used)) void convertImageToGrayImage(char *inputImagePath, char *outputPath)
    {
        platform_log("PATH %s: ", inputImagePath);
        cv::Mat img = cv::imread(inputImagePath);
        platform_log("Length: %d", img.rows);
        cv::Mat graymat;
        cvtColor(img, graymat, cv::COLOR_BGR2GRAY);
        platform_log("Output Path: %s", outputPath);
        cv::imwrite(outputPath, graymat);
        platform_log("Gray Image Length: %d", graymat.rows);
        platform_log("Image writed again ");
    }

    __attribute__((visibility("default"))) __attribute__((used)) void applyGaussianBlur(char *inputImagePath, char *outputPath, int kernelSize)
    {
        platform_log("Applying Gaussian Blur to %s", inputImagePath);
        Mat img = imread(inputImagePath);
        Mat blurred;
        GaussianBlur(img, blurred, Size(kernelSize, kernelSize), 0);
        imwrite(outputPath, blurred);
        platform_log("Blur applied and saved to %s", outputPath);
    }

    __attribute__((visibility("default"))) __attribute__((used)) void applySharpen(char *inputImagePath, char *outputPath)
    {
        platform_log("Sharpening image %s", inputImagePath);
        Mat img = imread(inputImagePath);
        Mat sharpened;
        Mat kernel = (Mat_<float>(3, 3) << -1, -1, -1,
                      -1, 9, -1,
                      -1, -1, -1);
        filter2D(img, sharpened, -1, kernel);
        imwrite(outputPath, sharpened);
        platform_log("Sharpening completed and saved to %s", outputPath);
    }

    __attribute__((visibility("default"))) __attribute__((used)) void detectEdges(char *inputImagePath, char *outputPath)
    {
        platform_log("Detecting edges in %s", inputImagePath);
        Mat img = imread(inputImagePath);
        Mat edges;
        Mat gray;
        cvtColor(img, gray, COLOR_BGR2GRAY);
        Canny(gray, edges, 100, 200);
        imwrite(outputPath, edges);
        platform_log("Edge detection completed and saved to %s", outputPath);
    }

    __attribute__((visibility("default"))) __attribute__((used)) void applyMedianBlur(char *inputImagePath, char *outputPath, int kernelSize)
    {
        platform_log("Applying Median Blur to %s", inputImagePath);
        Mat img = imread(inputImagePath);
        Mat blurred;
        medianBlur(img, blurred, kernelSize);
        imwrite(outputPath, blurred);
        platform_log("Median blur applied and saved to %s", outputPath);
    }

    __attribute__((visibility("default"))) __attribute__((used)) void applySobelEdge(char *inputImagePath, char *outputPath)
    {
        platform_log("Applying Sobel edge detection to %s", inputImagePath);
        Mat img = imread(inputImagePath);
        Mat gray, grad_x, grad_y, abs_grad_x, abs_grad_y, grad;
        cvtColor(img, gray, COLOR_BGR2GRAY);
        Sobel(gray, grad_x, CV_16S, 1, 0);
        Sobel(gray, grad_y, CV_16S, 0, 1);
        convertScaleAbs(grad_x, abs_grad_x);
        convertScaleAbs(grad_y, abs_grad_y);
        addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad);
        imwrite(outputPath, grad);
        platform_log("Sobel edge detection completed and saved to %s", outputPath);
    }
}

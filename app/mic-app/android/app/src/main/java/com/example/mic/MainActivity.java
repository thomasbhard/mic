package com.example.mic;

import android.content.res.AssetFileDescriptor;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;
import org.tensorflow.lite.Interpreter;


import java.io.FileInputStream;
import java.io.IOException;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "prediction";
  MappedByteBuffer endToEndModel = null;
  Interpreter endToEndInterpreter = null;

  MappedByteBuffer domainFeatureModel = null;
  Interpreter domainFeatureInterpreter = null;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    try{
      endToEndModel = loadModelFile("m1578220494_first=rel_batTrues12.tflite");
      endToEndInterpreter = new Interpreter(endToEndModel);

      domainFeatureModel = loadModelFile("m1577748110_first=_p512s5_f2048_strelu_p0.tflite");
      domainFeatureInterpreter = new Interpreter(domainFeatureModel);
    }catch (IOException e){
      System.out.println("Error loading model" + e.getMessage());
    }

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall call, Result result) {


        if (call.method.equals("ENDTOEND")) {
          double [] input_vec = call.argument("input");
          double [] labels;

          float [][] input = new float[1][2048];
          float [][] output = new float[1][10];

          input[0] = doubleToFloatArray(input_vec);

          if(endToEndInterpreter != null){
            endToEndInterpreter.run(input, output);


            labels = floatToDoubleArray(output[0]);
            result.success(labels);
          }
          else{
            result.error("UNAVAILABLE", "Interpreter not loaded", null);
          }
        }
        else if(call.method.equals("DOMAINFEATURES")){
          MFCC mfcc = new MFCC(2048, 44100, 13);
          double [] input_vec = call.argument("input");
          long startTime = System.nanoTime();
          double [] mfccFeatures = mfcc.process(doubleToFloatArray(input_vec));
          double [] labels;

          DescriptiveStatistics stat = new DescriptiveStatistics(input_vec);

          double mean = stat.getMean();
          double median = stat.getPercentile(50);
          double stdDeviation = stat.getStandardDeviation();
          double q25 = stat.getPercentile(25);
          double q75 = stat.getPercentile(75);
          double iqr = q75 - q25;
          double skewness = stat.getSkewness();
          double kurtosis = stat.getKurtosis();

          double [] features = new double [21];

          for(int i=0; i<mfccFeatures.length; i++)
            features[i] = mfccFeatures[i];

          features[13] = mean;
          features[14] = median;
          features[15] = stdDeviation;
          features[16] = q25;
          features[17] = q75;
          features[18] = iqr;
          features[19] = skewness;
          features[20] = kurtosis;

          long endTime = System.nanoTime();
          long time = endTime - startTime;

          String timeStr = time + "";


          Log.d("featureExtractionTime", timeStr);

          float [][] input = new float[1][21];
          float [][] output = new float[1][10];

          input[0] = doubleToFloatArray(features);

          if(domainFeatureInterpreter != null){
            domainFeatureInterpreter.run(input, output);


            labels = floatToDoubleArray(output[0]);
            result.success(labels);
          }
          else{
            result.error("UNAVAILABLE", "Interpreter not loaded", null);
          }
        }


      }

    });
  }

  private MappedByteBuffer loadModelFile(String MODEL_FILE) throws IOException {
    AssetFileDescriptor fileDescriptor = getAssets().openFd(MODEL_FILE);
    FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
    FileChannel fileChannel = inputStream.getChannel();
    long startOffset = fileDescriptor.getStartOffset();
    long declaredLength = fileDescriptor.getDeclaredLength();
    return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
  }

  private double [] floatToDoubleArray(float [] floatArray){
    if(floatArray == null){
      return null;
    }
    double [] doubleArray = new double[floatArray.length];
    for(int i=0; i < floatArray.length; i++){
      doubleArray[i] = floatArray[i];
    }
    return doubleArray;
  }

  private float [] doubleToFloatArray(double [] doubleArray){
    if(doubleArray == null){
      return null;
    }
    float [] floatArray = new float[doubleArray.length];
    for(int i=0; i < doubleArray.length; i++){
      floatArray[i] = (float) doubleArray[i];
    }
    return floatArray;
  }
}

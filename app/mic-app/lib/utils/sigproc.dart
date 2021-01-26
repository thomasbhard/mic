import 'dart:math';
import 'dart:typed_data';

Float64List intToFloat64List(List<int> x){
  Float64List xFloat = Float64List(x.length);
  for(var i=0; i< x.length; i++){
    xFloat[i] = x[i]/32768;
  }
  return xFloat;
}


double getLevel(Float64List x){
  double level = 0;
  for(var i=0; i < x.length; i++){
    level += x[i]*x[i];
  }
  level /= 44100;
  level = sqrt(level);
  return level;
}

Float64List normalize(Float64List x){
  double maxValue = x.reduce(max);
  if(maxValue == 0.0){
    return x;
  }

  Float64List normalized = Float64List(x.length);
  for(var i=0; i < x.length; i++){
    normalized[i] = x[i] / maxValue;
  }

  return normalized;
}